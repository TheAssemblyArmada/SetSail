# Build and link the launcher.

if(NOT SETSAIL_ENTRY)
    set(SETSAIL_ENTRY 0)
endif()

if(NOT SETSAIL_DLL)
    set(SETSAIL_DLL "dummy.dll")
endif()

if(NOT SETSAIL_EXE)
    set(SETSAIL_EXE "dummy.exe")
endif()

if(NOT SETSAIL_LAUNCHER)
    set(SETSAIL_LAUNCHER launchdummy)
endif()

configure_file(launcher.cpp.in launcher.cpp @ONLY)

add_executable(${SETSAIL_LAUNCHER} ${CMAKE_CURRENT_BINARY_DIR}/launcher.cpp sha.cpp resource.rc)
target_link_libraries(${SETSAIL_LAUNCHER} base)
target_include_directories(${SETSAIL_LAUNCHER} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
