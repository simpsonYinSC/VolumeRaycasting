MACRO(GENERATE_SUBDIRS result curdir bindir)
  FILE(GLOB children RELATIVE ${curdir} ${curdir}/*)
  SET(names "")
  SET(names2 "")
  SET(path2 "")
  FOREACH(child ${children})
    IF(IS_DIRECTORY ${curdir}/${child})
		IF (NOT ${child} MATCHES "\\..*")
			if(EXISTS ${curdir}/${child}/CMakeLists.txt)
				string(REPLACE " " "_" child ${child})
				SET(names ${names} ${child})
				message("BUILD FOR '${child}' GENERATED")
			endif()
		ENDIF()
    ENDIF()
    FILE(GLOB children2 ${curdir}/${child}/*)
     FOREACH(child2 ${children2})
       IF(IS_DIRECTORY ${child2})
    	IF (NOT ${child2} MATCHES "\\..*")
    	if(EXISTS ${child2}/CMakeLists.txt)
    		string(REPLACE "${curdir}/${child}/" "" child2 ${child2})
    				SET(names2 ${names2} ${child2})
    				SET(path2 ${path2} "${child}/${child2}")
    				message("BUILD FOR '${child2}' GENERATED")
    			endif()
    		ENDIF()
        ENDIF()
      ENDFOREACH()
  ENDFOREACH()
  SET(${result} ${${result}} ${names} ${names2})
  	FOREACH(n ${names})
  		add_subdirectory(${curdir}/${n} ${bindir}/${n})
  	ENDFOREACH()
  	 FOREACH(n2 ${path2})
      	add_subdirectory(${curdir}/${n2} ${bindir}/${n2})
     ENDFOREACH()
ENDMACRO()

MACRO(VALIADATE_PATH result)
	set( pathlist "${ARGN}" )
	FOREACH(currentpath ${pathlist})
		IF(EXISTS ${currentpath})
			SET(${result} ${currentpath} CACHE PATH "Project specific path. Set manually if it was not found.")
			message("${result} FOUND AT ${currentpath}")
		ENDIF()
	ENDFOREACH()
	IF (NOT ${result})
		SET(${result} "PATH-NOTFOUND" CACHE PATH "Project specific path. Set manually if it was not found.")
		message("ERROR: ${result} NOT FOUND")
	ENDIF ()
ENDMACRO()