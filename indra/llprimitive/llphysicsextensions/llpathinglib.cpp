/**
* @file   llpathinglib.cpp
* @author prep@lindenlab.com
* @brief  LLPathingLib core creation methods
*
* $LicenseInfo:firstyear=2012&license=lgpl$
* Second Life Viewer Source Code
* Copyright (C) 2011, Linden Research, Inc.
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

#if defined(_WINDOWS)
#	include "windowsincludes.h"
#endif

#ifndef NULL
#define NULL 0
#endif


#if !defined(LL_PATHING_LIB_STUB)
#	include "LLPathingLibImpl.h"
#else
#	include "LLPathingLibStubImpl.h"
#endif

#include "llpathinglib.h"

//disable the undefined symbol optimization
//#pragma warning (disable : 4221)

//=============================================================================

/*static */bool LLPathingLib::s_isInitialized = false;

//=============================================================================


/*static*/bool LLPathingLib::isFunctional()
{
#if !defined(LL_PATHING_LIB_STUB)
	return true;
#else
	return false;
#endif
}

#if !defined(LL_PATHING_LIB_STUB) && defined(HK_COMPILER_CLANG)
 //have to specialize before use so that generalized one not auto gen-d
HK_SINGLETON_SPECIALIZATION_DECL(LLPathingLibImpl);
#endif

/*static*/LLPathingLib* LLPathingLib::getInstance()
{
	if ( !s_isInitialized )
	{
		return NULL;
	}
	else
	{
#if !defined(LL_PATHING_LIB_STUB)
		return &hkSingleton<LLPathingLibImpl>::getInstance();
#else
		return LLPathingLibImpl::getInstance();
#endif
	}
}

//=============================================================================

/*static */LLPathingLib::LLPLResult LLPathingLib::initSystem()
{
	if ( LLPathingLibImpl::initSystem() == LLPL_OK )
	{
		s_isInitialized = true;
		return LLPL_OK;
	}
	return LLPL_UNKOWN_ERROR;
}
//=============================================================================
/*static */LLPathingLib::LLPLResult LLPathingLib::quitSystem()
{
	LLPLResult quitResult = LLPL_UNKOWN_ERROR;

	if (s_isInitialized)
	{
		quitResult = LLPathingLibImpl::quitSystem();
		s_isInitialized = false;
	}

	return quitResult;
}
//=============================================================================

