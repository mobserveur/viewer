/**
 * @file llreflectionmapmanager.cpp
 * @brief LLReflectionMapManager class implementation
 *
 * $LicenseInfo:firstyear=2022&license=viewerlgpl$
 * Second Life Viewer Source Code
 * Copyright (C) 2022, Linden Research, Inc.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation;
 * version 2.1 of the License only.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 * Linden Research, Inc., 945 Battery Street, San Francisco, CA  94111  USA
 * $/LicenseInfo$
 */

#include "llviewerprecompiledheaders.h"

#include "llreflectionmapmanager.h"
#include "llviewercamera.h"
#include "llspatialpartition.h"
#include "llviewerregion.h"
#include "pipeline.h"
#include "llviewershadermgr.h"

extern BOOL gCubeSnapshot;
extern BOOL gTeleportDisplay;

//#pragma optimize("", off)

LLReflectionMapManager::LLReflectionMapManager()
{
    for (int i = 0; i < LL_REFLECTION_PROBE_COUNT; ++i)
    {
        mCubeFree[i] = true;
    }
}

struct CompareReflectionMapDistance
{

};


struct CompareProbeDistance
{
    bool operator()(const LLPointer<LLReflectionMap>& lhs, const LLPointer<LLReflectionMap>& rhs)
    {
        return lhs->mDistance < rhs->mDistance;
    }
};

// helper class to seed octree with probes
void LLReflectionMapManager::update()
{
    if (!LLPipeline::sRenderDeferred || gTeleportDisplay)
    {
        return;
    }

    LL_PROFILE_ZONE_SCOPED_CATEGORY_DISPLAY;
    llassert(!gCubeSnapshot); // assert a snapshot is not in progress
    if (LLAppViewer::instance()->logoutRequestSent())
    {
        return;
    }

    // =============== TODO -- move to an init function  =================

    if (mTexture.isNull())
    {
        mTexture = new LLCubeMapArray();
        mTexture->allocate(LL_REFLECTION_PROBE_RESOLUTION, 3, LL_REFLECTION_PROBE_COUNT);
    }

    if (!mRenderTarget.isComplete())
    {
        U32 color_fmt = GL_RGBA;
        const bool use_depth_buffer = true;
        const bool use_stencil_buffer = true;
        U32 targetRes = LL_REFLECTION_PROBE_RESOLUTION * 4; // super sample
        mRenderTarget.allocate(targetRes, targetRes, color_fmt, use_depth_buffer, use_stencil_buffer, LLTexUnit::TT_RECT_TEXTURE);
    }

    if (mMipChain.empty())
    {
        U32 res = LL_REFLECTION_PROBE_RESOLUTION*2;
        U32 count = log2((F32)res) + 0.5f;
        
        mMipChain.resize(count);
        for (int i = 0; i < count; ++i)
        {
            mMipChain[i].allocate(res, res, GL_RGB, false, false, LLTexUnit::TT_RECT_TEXTURE);
            res /= 2;
        }
    }

    // =============== TODO -- move to an init function  =================

    // naively drop probes every 16m as we move the camera around for now
    // later, use LLSpatialPartition to manage probes
    const F32 PROBE_SPACING = 16.f;
    const U32 MAX_PROBES = 8;

    LLVector4a camera_pos;
    camera_pos.load3(LLViewerCamera::instance().getOrigin().mV);

    // process kill list
    for (int i = 0; i < mProbes.size(); )
    {
        auto& iter = std::find(mKillList.begin(), mKillList.end(), mProbes[i]);
        if (iter != mKillList.end())
        {
            deleteProbe(i);
            mProbes.erase(mProbes.begin() + i);
            mKillList.erase(iter);
        }
        else
        {
            ++i;
        }
    }

    mKillList.clear();
    
    // process create list
    for (auto& probe : mCreateList)
    {
        mProbes.push_back(probe);
    }

    mCreateList.clear();

    const F32 UPDATE_INTERVAL = 10.f;  //update no more than once every 5 seconds

    bool did_update = false;

    if (mUpdatingProbe != nullptr)
    {
        did_update = true;
        doProbeUpdate();
    }

    for (int i = 0; i < mProbes.size(); ++i)
    {
        LLReflectionMap* probe = mProbes[i];
        if (probe->getNumRefs() == 1)
        { // no references held outside manager, delete this probe
            deleteProbe(i);
            --i;
            continue;
        }
        
        probe->mProbeIndex = i;

        LLVector4a d;
        
        if (probe->shouldUpdate() && !did_update && i < LL_REFLECTION_PROBE_COUNT)
        {
            if (probe->mCubeIndex == -1)
            {
                probe->mCubeArray = mTexture;
                probe->mCubeIndex = allocateCubeIndex();
            }

            did_update = true; // only update one probe per frame
            probe->autoAdjustOrigin();

            mUpdatingProbe = probe;
            doProbeUpdate();
            probe->mDirty = false;
        }

        d.setSub(camera_pos, probe->mOrigin);
        probe->mDistance = d.getLength3().getF32()-probe->mRadius;
    }

    // update distance to camera for all probes
    std::sort(mProbes.begin(), mProbes.end(), CompareProbeDistance());
}

void LLReflectionMapManager::addProbe(const LLVector3& pos)
{
    //LLReflectionMap* probe = new LLReflectionMap();
    //probe->update(pos, 1024);
    //mProbes.push_back(probe);
}

LLReflectionMap* LLReflectionMapManager::addProbe(LLSpatialGroup* group)
{
    LLReflectionMap* probe = new LLReflectionMap();
    probe->mGroup = group;
    probe->mOrigin = group->getOctreeNode()->getCenter();
    probe->mDirty = true;

    if (gCubeSnapshot)
    { //snapshot is in progress, mProbes is being iterated over, defer insertion until next update
        mCreateList.push_back(probe);
    }
    else
    {
        mProbes.push_back(probe);
    }

    return probe;
}

void LLReflectionMapManager::getReflectionMaps(std::vector<LLReflectionMap*>& maps)
{
    LL_PROFILE_ZONE_SCOPED_CATEGORY_DISPLAY;

    U32 count = 0;
    U32 lastIdx = 0;
    for (U32 i = 0; count < maps.size() && i < mProbes.size(); ++i)
    {
        mProbes[i]->mLastBindTime = gFrameTimeSeconds; // something wants to use this probe, indicate it's been requested
        if (mProbes[i]->mCubeIndex != -1)
        {
            mProbes[i]->mProbeIndex = count;
            maps[count++] = mProbes[i];
        }
        else
        {
            mProbes[i]->mProbeIndex = -1;
        }
        lastIdx = i;
    }

    // set remaining probe indices to -1
    for (U32 i = lastIdx+1; i < mProbes.size(); ++i)
    {
        mProbes[i]->mProbeIndex = -1;
    }

    // null terminate list
    if (count < maps.size())
    {
        maps[count] = nullptr;
    }
}

LLReflectionMap* LLReflectionMapManager::registerSpatialGroup(LLSpatialGroup* group)
{
    if (group->getSpatialPartition()->mPartitionType == LLViewerRegion::PARTITION_VOLUME)
    {
        OctreeNode* node = group->getOctreeNode();
        F32 size = node->getSize().getF32ptr()[0];
        if (size >= 7.f && size <= 17.f)
        {
            return addProbe(group);
        }
    }
    
    if (group->getSpatialPartition()->mPartitionType == LLViewerRegion::PARTITION_TERRAIN)
    {
        OctreeNode* node = group->getOctreeNode();
        F32 size = node->getSize().getF32ptr()[0];
        if (size >= 15.f && size <= 17.f)
        {
            return addProbe(group);
        }
    }

    return nullptr;
}

S32 LLReflectionMapManager::allocateCubeIndex()
{
    for (int i = 0; i < LL_REFLECTION_PROBE_COUNT; ++i)
    {
        if (mCubeFree[i])
        {
            mCubeFree[i] = false;
            return i;
        }
    }

    // no cubemaps free, steal one from the back of the probe list
    for (int i = mProbes.size() - 1; i >= LL_REFLECTION_PROBE_COUNT; --i)
    {
        if (mProbes[i]->mCubeIndex != -1)
        {
            S32 ret = mProbes[i]->mCubeIndex;
            mProbes[i]->mCubeIndex = -1;
            return ret;
        }
    }

    llassert(false); // should never fail to allocate, something is probably wrong with mCubeFree
    return -1;
}

void LLReflectionMapManager::deleteProbe(U32 i)
{
    LL_PROFILE_ZONE_SCOPED_CATEGORY_DISPLAY;
    LLReflectionMap* probe = mProbes[i];

    if (probe->mCubeIndex != -1)
    { // mark the cube index used by this probe as being free
        mCubeFree[probe->mCubeIndex] = true;
    }
    if (mUpdatingProbe == probe)
    {
        mUpdatingProbe = nullptr;
        mUpdatingFace = 0;
    }

    // remove from any Neighbors lists
    for (auto& other : probe->mNeighbors)
    {
        auto& iter = std::find(other->mNeighbors.begin(), other->mNeighbors.end(), probe);
        llassert(iter != other->mNeighbors.end());
        other->mNeighbors.erase(iter);
    }

    mProbes.erase(mProbes.begin() + i);
}


void LLReflectionMapManager::doProbeUpdate()
{
    LL_PROFILE_ZONE_SCOPED_CATEGORY_DISPLAY;
    llassert(mUpdatingProbe != nullptr);

    mRenderTarget.bindTarget();
    mUpdatingProbe->update(mRenderTarget.getWidth(), mUpdatingFace);
    mRenderTarget.flush();

    // generate mipmaps
    {
        LLGLDepthTest depth(GL_FALSE, GL_FALSE);
        LLGLDisable cull(GL_CULL_FACE);

        gReflectionMipProgram.bind();
        gGL.matrixMode(gGL.MM_MODELVIEW);
        gGL.pushMatrix();
        gGL.loadIdentity();

        gGL.matrixMode(gGL.MM_PROJECTION);
        gGL.pushMatrix();
        gGL.loadIdentity();

        gGL.flush();
        U32 res = LL_REFLECTION_PROBE_RESOLUTION*4;

        S32 mips = log2((F32) LL_REFLECTION_PROBE_RESOLUTION)+0.5f;

        for (int i = 0; i < mMipChain.size(); ++i)
        {
            mMipChain[i].bindTarget();

            if (i == 0)
            {
                gGL.getTexUnit(0)->bind(&mRenderTarget);
            }
            else
            {
                gGL.getTexUnit(0)->bind(&(mMipChain[i - 1]));
            }

            gGL.begin(gGL.QUADS);
            
            gGL.texCoord2f(0, 0);
            gGL.vertex2f(-1, -1);
            
            gGL.texCoord2f(res, 0);
            gGL.vertex2f(1, -1);

            gGL.texCoord2f(res, res);
            gGL.vertex2f(1, 1);

            gGL.texCoord2f(0, res);
            gGL.vertex2f(-1, 1);
            gGL.end();
            gGL.flush();

            res /= 2;

            S32 mip = i - (mMipChain.size() - mips);

            if (mip >= 0)
            {
                mTexture->bind(0);
                glCopyTexSubImage3D(GL_TEXTURE_CUBE_MAP_ARRAY, mip, 0, 0, mUpdatingProbe->mCubeIndex * 6 + mUpdatingFace, 0, 0, res, res);
                mTexture->unbind();
            }
            mMipChain[i].flush();
        }

        gGL.popMatrix();
        gGL.matrixMode(gGL.MM_MODELVIEW);
        gGL.popMatrix();

        gReflectionMipProgram.unbind();
    }
    
    if (++mUpdatingFace == 6)
    {
        updateNeighbors(mUpdatingProbe);
        mUpdatingProbe = nullptr;
        mUpdatingFace = 0;
    }
}

void LLReflectionMapManager::rebuild()
{
    for (auto& probe : mProbes)
    {
        probe->mLastUpdateTime = 0.f;
    }
}

void LLReflectionMapManager::shift(const LLVector4a& offset)
{
    for (auto& probe : mProbes)
    {
        probe->mOrigin.add(offset);
    }
}

void LLReflectionMapManager::updateNeighbors(LLReflectionMap* probe)
{
    LL_PROFILE_ZONE_SCOPED_CATEGORY_DISPLAY;

    //remove from existing neighbors
    {
        LL_PROFILE_ZONE_NAMED_CATEGORY_DISPLAY("rmmun - clear");
    
        for (auto& other : probe->mNeighbors)
        {
            auto& iter = std::find(other->mNeighbors.begin(), other->mNeighbors.end(), probe);
            llassert(iter != other->mNeighbors.end()); // <--- bug davep if this ever happens, something broke badly
            other->mNeighbors.erase(iter);
        }

        probe->mNeighbors.clear();
    }

    // search for new neighbors
    {
        LL_PROFILE_ZONE_NAMED_CATEGORY_DISPLAY("rmmun - search");
        for (auto& other : mProbes)
        {
            if (other != probe)
            {
                if (probe->intersects(other))
                {
                    probe->mNeighbors.push_back(other);
                    other->mNeighbors.push_back(probe);
                }
            }
        }
    }
}

void LLReflectionMapManager::setUniforms()
{
    LL_PROFILE_ZONE_SCOPED_CATEGORY_DISPLAY;

    // structure for packing uniform buffer object
    // see class2/deferred/softenLightF.glsl
    struct ReflectionProbeData
    {
        LLVector4 refSphere[LL_REFLECTION_PROBE_COUNT]; //origin and radius of refmaps in clip space
        GLint refIndex[LL_REFLECTION_PROBE_COUNT][4];
        GLint refNeighbor[4096];
        GLint refmapCount;
    };

    mReflectionMaps.resize(LL_REFLECTION_PROBE_COUNT);
    getReflectionMaps(mReflectionMaps);

    ReflectionProbeData rpd;

    // load modelview matrix into matrix 4a
    LLMatrix4a modelview;
    modelview.loadu(gGLModelView);
    LLVector4a oa; // scratch space for transformed origin

    S32 count = 0;
    U32 nc = 0; // neighbor "cursor" - index into refNeighbor to start writing the next probe's list of neighbors

    for (auto* refmap : mReflectionMaps)
    {
        if (refmap == nullptr)
        {
            break;
        }

        llassert(refmap->mProbeIndex == count);
        llassert(mReflectionMaps[refmap->mProbeIndex] == refmap);

        llassert(refmap->mCubeIndex >= 0); // should always be  true, if not, getReflectionMaps is bugged

        {
            //LL_PROFILE_ZONE_NAMED_CATEGORY_DISPLAY("rmmsu - refSphere");

            modelview.affineTransform(refmap->mOrigin, oa);
            rpd.refSphere[count].set(oa.getF32ptr());
            rpd.refSphere[count].mV[3] = refmap->mRadius;
        }

        rpd.refIndex[count][0] = refmap->mCubeIndex;
        llassert(nc % 4 == 0);
        rpd.refIndex[count][1] = nc / 4;

        S32 ni = nc; // neighbor ("index") - index into refNeighbor to write indices for current reflection probe's neighbors
        {
            //LL_PROFILE_ZONE_NAMED_CATEGORY_DISPLAY("rmmsu - refNeighbors");
            //pack neghbor list
            for (auto& neighbor : refmap->mNeighbors)
            {
                if (ni >= 4096)
                { // out of space
                    break;
                }
                
                GLint idx = neighbor->mProbeIndex;
                if (idx == -1)
                {
                    continue;
                }

                // this neighbor may be sampled
                rpd.refNeighbor[ni++] = idx;
            }
        }
        
        if (nc == ni)
        {
            //no neighbors, tag as empty
            rpd.refIndex[count][1] = -1;
        }
        else
        {
            rpd.refIndex[count][2] = ni - nc;

            // move the cursor forward
            nc = ni;
            if (nc % 4 != 0)
            { // jump to next power of 4 for compatibility with ivec4
                nc += 4 - (nc % 4);
            }
        }
        
        
        count++;
    }

    rpd.refmapCount = count;

    //copy rpd into uniform buffer object
    if (mUBO == 0)
    {
        glGenBuffersARB(1, &mUBO);
    }

    {
        LL_PROFILE_ZONE_NAMED_CATEGORY_DISPLAY("rmmsu - update buffer");
        glBindBufferARB(GL_UNIFORM_BUFFER, mUBO);
        glBufferDataARB(GL_UNIFORM_BUFFER, sizeof(ReflectionProbeData), &rpd, GL_STREAM_DRAW);
        glBindBufferARB(GL_UNIFORM_BUFFER, 0);
    }

    glBindBufferBase(GL_UNIFORM_BUFFER, 1, mUBO);
}