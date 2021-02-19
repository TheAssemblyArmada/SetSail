# Build and link the launcher.
include(CMakeParseArguments)
set(GenerateSetsailLauncherCurrentDir ${CMAKE_CURRENT_LIST_DIR})
message("GenerateSetsailLauncherCurrentDir is ${GenerateSetsailLauncherCurrentDir}")
include(${GenerateSetsailLauncherCurrentDir}/ProductVersion.cmake)

add_library(launcher_common OBJECT ${GenerateSetsailLauncherCurrentDir}/sha.cpp)
target_link_libraries(launcher_common PUBLIC base)
target_include_directories(launcher_common PUBLIC ${GenerateSetsailLauncherCurrentDir})

function(generate_setsail_launcher outfiles)
    set (options)
    set (oneValueArgs
        PREFIX
        ENTRYPOINT
        DLLNAME
        EXENAME
        HASH
        LAUNCHER)
    set (multiValueArgs)
    cmake_parse_arguments(SETSAIL "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    if(NOT SETSAIL_PREFIX)
        set(SETSAIL_PREFIX setsail)
    endif()

    if(NOT SETSAIL_ENTRYPOINT)
        set(SETSAIL_ENTRYPOINT 0)
    endif()

    if(NOT SETSAIL_DLLNAME)
        set(SETSAIL_DLLNAME "${SETSAIL_PREFIX}.dll")
    endif()

    if(NOT SETSAIL_EXENAME)
        set(SETSAIL_EXENAME "${SETSAIL_PREFIX}.exe")
    endif()

     if(NOT SETSAIL_HASH)
        set(SETSAIL_HASH "deadbeef")
    endif()

    if(NOT SETSAIL_LAUNCHER)
        set(SETSAIL_LAUNCHER ${SETSAIL_PREFIX}launcher)
    endif()

    set(_LauncherSourceFile ${CMAKE_CURRENT_BINARY_DIR}/${SETSAIL_PREFIX}launcher.cpp)
    message("GenerateSetsailLauncherCurrentDir is ${GenerateSetsailLauncherCurrentDir}")
    configure_file(${GenerateSetsailLauncherCurrentDir}/launcher.cpp.in ${_LauncherSourceFile} @ONLY)

    generate_product_version(
        SETSAIL_RC
        NAME "${SETSAIL_PREFIX} Launcher"
        BUNDLE "SetSail Launchers"
        VERSION_MAJOR 1
        VERSION_MINOR 0
        COMPANY_NAME "Assembly Armada"
        COMPANY_COPYRIGHT "Code released under GPLv2 or later."
        ORIGINAL_FILENAME "setsaillauncher.exe"
        RCFILE_PREFIX "${SETSAIL_PREFIX}"
        ICON "${GenerateSetsailLauncherCurrentDir}/launcher.ico"
    )

    add_executable(${SETSAIL_LAUNCHER} ${_LauncherSourceFile} ${SETSAIL_RC})
    target_link_libraries(${SETSAIL_LAUNCHER} PUBLIC launcher_common)
    message("Configuring a launcher as ${SETSAIL_LAUNCHER} using entry at ${SETSAIL_ENTRYPOINT} to inject ${SETSAIL_DLLNAME} into ${SETSAIL_EXENAME}")
    set (${outfiles} ${${SETSAIL_LAUNCHER}} PARENT_SCOPE)
endfunction()
