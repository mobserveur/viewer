/** 
 * @file llglstates.h
 * @brief LLGL states definitions
 *
 * $LicenseInfo:firstyear=2001&license=viewerlgpl$
 * Second Life Viewer Source Code
 * Copyright (C) 2010, Linden Research, Inc.
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

//THIS HEADER SHOULD ONLY BE INCLUDED FROM llgl.h
#ifndef LL_LLGLSTATES_H
#define LL_LLGLSTATES_H

#include "llimagegl.h"

//----------------------------------------------------------------------------

class LLGLDepthTest
{
	// Enabled by default
public:
	LLGLDepthTest(GLboolean depth_enabled, GLboolean write_enabled = GL_TRUE, GLenum depth_func = GL_LEQUAL);
	
	~LLGLDepthTest();
	
	void checkState();

	GLboolean mPrevDepthEnabled;
	GLenum mPrevDepthFunc;
	GLboolean mPrevWriteEnabled;
private:
	static GLboolean sDepthEnabled; // defaults to GL_FALSE
	static GLenum sDepthFunc; // defaults to GL_LESS
	static GLboolean sWriteEnabled; // defaults to GL_TRUE
};

//----------------------------------------------------------------------------

class LLGLSDefault
{
protected:
#if GL_VERSION_1_1
	LLGLEnable mColorMaterial;
#endif
	LLGLDisable
#if GL_VERSION_1_1
		mAlphaTest,
#endif
		mBlend, mCullFace, mDither
#if GL_VERSION_1_1
		, mFog,
		mLineSmooth, mLineStipple, mNormalize, mPolygonSmooth
#if GL_VERSION_1_3
		,
		mGLMultisample
#endif // GL_VERSION_1_3
#endif // GL_VERSION_1_1
			;
public:
	LLGLSDefault()
		:
		// Enable
#if GL_VERSION_1_1
		mColorMaterial(GL_COLOR_MATERIAL),
		// Disable
		mAlphaTest(GL_ALPHA_TEST),
#endif
		mBlend(GL_BLEND), 
		mCullFace(GL_CULL_FACE),
		mDither(GL_DITHER)
#if GL_VERSION_1_1
		,
		mFog(GL_FOG), 
		mLineSmooth(GL_LINE_SMOOTH),
		mLineStipple(GL_LINE_STIPPLE),
		mNormalize(GL_NORMALIZE),
		mPolygonSmooth(GL_POLYGON_SMOOTH)
#if GL_VERSION_1_3
		,
		mGLMultisample(GL_MULTISAMPLE)
#endif // GL_VERSION_1_3
#endif // GL_VERSION_1_1
	{ }
};

class LLGLSObjectSelect
{ 
protected:
	LLGLDisable mBlend
#if GL_VERSION_1_1
		, mFog, mAlphaTest
#endif
		;
	LLGLEnable mCullFace;
public:
	LLGLSObjectSelect()
		: mBlend(GL_BLEND),
#if GL_VERSION_1_1
		  mFog(GL_FOG),
		  mAlphaTest(GL_ALPHA_TEST),
#endif
		  mCullFace(GL_CULL_FACE)
	{ }
};

#if GL_VERSION_1_1
class LLGLSObjectSelectAlpha
{
protected:
	LLGLEnable mAlphaTest;
public:
	LLGLSObjectSelectAlpha()
		: mAlphaTest(GL_ALPHA_TEST)
	{}
};
#endif

//----------------------------------------------------------------------------

class LLGLSUIDefault
{ 
protected:
	LLGLEnable mBlend
#if GL_VERSION_1_1
		, mAlphaTest
#endif
		;
	LLGLDisable mCullFace;
	LLGLDepthTest mDepthTest;
public:
	LLGLSUIDefault() 
		: mBlend(GL_BLEND),
#if GL_VERSION_1_1
		  mAlphaTest(GL_ALPHA_TEST),
#endif
		  mCullFace(GL_CULL_FACE),
		  mDepthTest(GL_FALSE, GL_TRUE, GL_LEQUAL)
	{}
};

#if GL_VERSION_1_1
class LLGLSNoAlphaTest // : public LLGLSUIDefault
{
protected:
	LLGLDisable mAlphaTest;
public:
	LLGLSNoAlphaTest()
		: mAlphaTest(GL_ALPHA_TEST)
	{}
};

//----------------------------------------------------------------------------

class LLGLSFog
{
protected:
	LLGLEnable mFog;
public:
	LLGLSFog()
		: mFog(GL_FOG)
	{}
};

class LLGLSNoFog
{
protected:
	LLGLDisable mFog;
public:
	LLGLSNoFog()
		: mFog(GL_FOG)
	{}
};
#endif

//----------------------------------------------------------------------------

class LLGLSPipeline
{ 
protected:
	LLGLEnable mCullFace;
	LLGLDepthTest mDepthTest;
public:
	LLGLSPipeline()
		: mCullFace(GL_CULL_FACE),
		  mDepthTest(GL_TRUE, GL_TRUE, GL_LEQUAL)
	{ }		
};

class LLGLSPipelineAlpha // : public LLGLSPipeline
{ 
protected:
	LLGLEnable mBlend
#if GL_VERSION_1_1
		, mAlphaTest
#endif
		;
public:
	LLGLSPipelineAlpha()
		: mBlend(GL_BLEND)
#if GL_VERSION_1_1
		  ,
		  mAlphaTest(GL_ALPHA_TEST)
#endif
	{ }
};

#if GL_VERSION_1_1
class LLGLSPipelineEmbossBump
{
protected:
	LLGLDisable mFog;
public:
	LLGLSPipelineEmbossBump()
		: mFog(GL_FOG)
	{ }
};
#endif

class LLGLSPipelineSelection
{ 
protected:
	LLGLDisable mCullFace;
public:
	LLGLSPipelineSelection()
		: mCullFace(GL_CULL_FACE)
	{}
};

#if GL_VERSION_1_1
class LLGLSPipelineAvatar
{
protected:
	LLGLEnable mNormalize;
public:
	LLGLSPipelineAvatar()
		: mNormalize(GL_NORMALIZE)
	{}
};
#endif

class LLGLSPipelineSkyBox
{ 
protected:
#if GL_VERSION_1_1
	LLGLDisable mAlphaTest;
#endif
    LLGLDisable mCullFace;
    LLGLSquashToFarClip mSquashClip;
public:
	LLGLSPipelineSkyBox();
   ~LLGLSPipelineSkyBox();
};

class LLGLSPipelineDepthTestSkyBox : public LLGLSPipelineSkyBox
{ 
public:
	LLGLSPipelineDepthTestSkyBox(bool depth_test, bool depth_write);

    LLGLDepthTest mDepth;
};

class LLGLSPipelineBlendSkyBox : public LLGLSPipelineDepthTestSkyBox 
{ 
public:
	LLGLSPipelineBlendSkyBox(bool depth_test, bool depth_write);
    LLGLEnable mBlend;    
};

class LLGLSTracker
{
protected:
	LLGLEnable mCullFace, mBlend
#if GL_VERSION_1_1
		, mAlphaTest
#endif
		;
public:
	LLGLSTracker() :
		mCullFace(GL_CULL_FACE),
		mBlend(GL_BLEND)
#if GL_VERSION_1_1
		,
		mAlphaTest(GL_ALPHA_TEST)
#endif
		
	{ }
};

//----------------------------------------------------------------------------

#if GL_VERSION_1_1
class LLGLSSpecular
{
public:
	F32 mShininess;
	LLGLSSpecular(const LLColor4& color, F32 shininess)
	{
		mShininess = shininess;
		if (mShininess > 0.0f)
		{
			glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, color.mV);
			S32 shiny = (S32)(shininess*128.f);
			shiny = llclamp(shiny,0,128);
			glMateriali(GL_FRONT_AND_BACK, GL_SHININESS, shiny);
		}
	}
	~LLGLSSpecular()
	{
		if (mShininess > 0.f)
		{
			glMaterialfv(GL_FRONT_AND_BACK, GL_SPECULAR, LLColor4(0.f,0.f,0.f,0.f).mV);
			glMateriali(GL_FRONT_AND_BACK, GL_SHININESS, 0);
		}
	}
};
#endif

//----------------------------------------------------------------------------

#endif
