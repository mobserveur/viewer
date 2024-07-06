/**
* @file mpvfloatertuning.cpp
* @brief Controller for viewer tuning
* @author observeur@megapahit.net
*
* $LicenseInfo:firstyear=2014&license=viewerlgpl$
* Second Life Viewer Source Code
* Copyright (C) 2014, Linden Research, Inc.
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

#include "mpvfloatertuning.h"
#include "llsliderctrl.h"
#include "llcheckboxctrl.h"
#include "llcombobox.h"
#include "llviewercontrol.h"
#include "llsdserialize.h"

#include "../llrender/llvertexbuffer.cpp"

MPVFloaterTuning::MPVFloaterTuning(const LLSD& key) : LLFloater(key)
{
}

void MPVFloaterTuning::syncFromPreferenceSetting(void *user_data)
{
    MPVFloaterTuning *self = static_cast<MPVFloaterTuning*>(user_data);

    U32 fps = gSavedSettings.getU32("MaxFPS");
    LLSliderCtrl* fpsSliderCtrl = self->getChild<LLSliderCtrl>("fpsSlider");
    fpsSliderCtrl->setValue(fps,FALSE);

    U32 optBuf = gSavedSettings.getU32("MPVBufferOptiMode");
    LLComboBox * optBufCtrl = self->getChild<LLComboBox>("MPVBuffModeComboBox");
    optBufCtrl->setCurrentByIndex(optBuf);

    LL_INFOS() << "syncFromPreferenceSetting optBuf=" << optBuf << LL_ENDL;
}

BOOL MPVFloaterTuning::postBuild()
{
    LLSliderCtrl* fpsSliderCtrl = getChild<LLSliderCtrl>("fpsSlider");
    fpsSliderCtrl->setMinValue(0);
    fpsSliderCtrl->setMaxValue(165);
    fpsSliderCtrl->setSliderMouseUpCallback(boost::bind(&MPVFloaterTuning::onFinalCommit,this));

    LLComboBox* optBufCtrl = getChild<LLComboBox>("MPVBuffModeComboBox");
    optBufCtrl->setCommitCallback(boost::bind(&MPVFloaterTuning::onFinalCommit,this));

    syncFromPreferenceSetting(this);

    return TRUE;
}

// Do send-to-the-server work when slider drag completes, or new
// value entered as text.
void MPVFloaterTuning::onFinalCommit()
{
    LLSliderCtrl* fpsSliderCtrl = getChild<LLSliderCtrl>("fpsSlider");
    U32 fps = (U32)fpsSliderCtrl->getValueF32();
    gSavedSettings.setU32("MaxFPS",fps);

    LLComboBox* optBufCtrl = getChild<LLComboBox>("MPVBuffModeComboBox");
    S16 optBuf = optBufCtrl->getCurrentIndex();
    gSavedSettings.setU32("MPVBufferOptiMode",optBuf);

    LLVertexBuffer::sMappingMode = optBuf;
}

void MPVFloaterTuning::onClose(bool app_quitting)
{
}