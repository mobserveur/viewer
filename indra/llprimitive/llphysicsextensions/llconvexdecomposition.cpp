/**
* @file   llconvexdecomposition.cpp
* @author falcon@lindenlab.com
* @brief  A Havok implementation of LLConvexDecomposition interface
*
* $LicenseInfo:firstyear=2011&license=lgpl$
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

#if !defined(LL_CONVEX_DECOMP_STUB)
#	include "LLConvexDecompositionImpl.h"
#else
#	include "LLConvexDecompositionStubImpl.h"
#endif

#include "llconvexdecomposition.h"


/*static */bool LLConvexDecomposition::s_isInitialized = false;

/*static*/bool LLConvexDecomposition::isFunctional()
{
#if !defined(LL_CONVEX_DECOMP_STUB)
	return true;
#else
	return false;
#endif
}

#if !defined(LL_CONVEX_DECOMP_STUB) && defined(HK_COMPILER_CLANG)
 //have to specialize before use so that generalized one not auto gen-d
HK_SINGLETON_SPECIALIZATION_DECL(LLConvexDecompositionImpl);
#endif

/*static*/LLConvexDecomposition* LLConvexDecomposition::getInstance()
{
	if ( !s_isInitialized )
	{
		return NULL;
	}
	else
	{
#if !defined(LL_CONVEX_DECOMP_STUB)
		return &hkSingleton<LLConvexDecompositionImpl>::getInstance();
#else
		return LLConvexDecompositionImpl::getInstance();
#endif
	}
}

/*static */LLCDResult LLConvexDecomposition::initSystem()
{
	LLCDResult result = LLConvexDecompositionImpl::initSystem();
	if ( result == LLCD_OK )
	{
		s_isInitialized = true;
	}
	return result;
}

/*static */LLCDResult LLConvexDecomposition::initThread()
{
	return LLConvexDecompositionImpl::initThread();
}

/*static */LLCDResult LLConvexDecomposition::quitThread()
{
	return LLConvexDecompositionImpl::quitThread();
}

/*static */LLCDResult LLConvexDecomposition::quitSystem()
{
	return LLConvexDecompositionImpl::quitSystem();
}


