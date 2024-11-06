/**
* @file mpfloatertuning.cpp
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

#include "mpfloatertuning.h"
#include "llsliderctrl.h"
#include "lltextbox.h"
#include "llcheckboxctrl.h"
#include "llcombobox.h"
#include "llviewercontrol.h"
#include "llsdserialize.h"

MPFloaterTuning::MPFloaterTuning(const LLSD& key) : LLFloater(key)
{
}

void MPFloaterTuning::syncFromPreferenceSetting(void *user_data)
{
    MPFloaterTuning *self = static_cast<MPFloaterTuning*>(user_data);

    U32 fps = gSavedSettings.getU32("MaxFPS");
    if(fps==0) fps=132;

    LLSliderCtrl* fpsSliderCtrl = self->getChild<LLSliderCtrl>("fpsSlider");
    fpsSliderCtrl->setValue(fps,FALSE);

    LLTextBox* fpsText = self->getChild<LLTextBox>("fpsText");
    if(fps>120) fpsText->setValue("no limit");
    else fpsText->setValue(std::to_string(fps)+" fps");
}

bool MPFloaterTuning::postBuild()
{
    LLSliderCtrl* fpsSliderCtrl = getChild<LLSliderCtrl>("fpsSlider");
    fpsSliderCtrl->setMinValue(12);
    fpsSliderCtrl->setMaxValue(132);
    fpsSliderCtrl->setSliderMouseUpCallback(boost::bind(&MPFloaterTuning::onFinalCommit,this));

    LLTextBox* fpsText = getChild<LLTextBox>("fpsText");
    fpsText->setValue("");

    syncFromPreferenceSetting(this);

    return TRUE;
}

// Do send-to-the-server work when slider drag completes, or new
// value entered as text.
void MPFloaterTuning::onFinalCommit()
{
    LLSliderCtrl* fpsSliderCtrl = getChild<LLSliderCtrl>("fpsSlider");
    U32 fps = (U32)fpsSliderCtrl->getValueF32();
    gSavedSettings.setU32("MaxFPS",fps);

    LLTextBox* fpsText = getChild<LLTextBox>("fpsText");
    if(fps>120) fpsText->setValue("no limit");
    else fpsText->setValue(std::to_string(fps)+" fps");
}

void MPFloaterTuning::onClose(bool app_quitting)
{
}
