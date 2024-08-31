# -*- cmake -*-
find_program(GIT git)

macro( checkout_deps_repository DEPSREPO DEPSDIR DEPSTAG)
  execute_process(
	  COMMAND ${GIT} "clone" ${DEPSREPO} ${DEPSDIR}
	  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/../..
  )
  execute_process(
	  COMMAND ${GIT} "checkout" ${DEPSTAG}
	  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/../../${DEPSDIR}
  )
  execute_process(
	  COMMAND ${GIT} "pull"
	  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/../../${DEPSDIR}
  )
endmacro( checkout_deps_repository )
