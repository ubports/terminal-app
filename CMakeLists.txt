project(com.ubuntu.terminal C CXX)
cmake_minimum_required(VERSION 2.8.9)
find_program(INTLTOOL_MERGE intltool-merge)
find_program(INTLTOOL_EXTRACT intltool-extract)

set(CMAKE_AUTOMOC ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11 -fno-permissive -pedantic -Wall -Wextra -fPIC")

# Standard install paths
include(GNUInstallDirs)

option(INSTALL_TESTS "Install the tests on make install" on)
option(CLICK_MODE "Installs to a contained location" on)

set(APP_NAME terminal)
set(DESKTOP_FILE "${PROJECT_NAME}.desktop")
set(APP_HARDCODE ubuntu-terminal-app)
set(MAIN_QML ubuntu-terminal-app.qml)
set(ICON_FILE terminal64.png)
set(AUTOPILOT_DIR ubuntu_terminal_app)
set(EXEC "${APP_NAME}")
set(UBUNTU_MANIFEST_PATH "manifest.json.in" CACHE INTERNAL "Relative path to the manifest file")

if(CLICK_MODE)
    # Find out the architecture for package building
    # to determine the plugin's installation path
    execute_process(
        COMMAND dpkg-architecture -qDEB_HOST_MULTIARCH
        OUTPUT_VARIABLE ARCH_TRIPLET
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set(CMAKE_INSTALL_PREFIX /)
    set(CMAKE_INSTALL_BINDIR /)
    set(DATA_DIR /)
    set(DESKTOP_DIR ${DATA_DIR})
    set(ICON ${ICON_FILE})
    set(QT_IMPORTS_DIR "/lib/${ARCH_TRIPLET}")
    set(BIN_DIR /lib/${ARCH_TRIPLET}/bin)

    if(NOT GIT_REVNO)
        execute_process(
          COMMAND git rev-list --first-parent --all --count
          WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
          OUTPUT_VARIABLE GIT_REVNO
          OUTPUT_STRIP_TRAILING_WHITESPACE
        )
    endif(NOT GIT_REVNO)
    if(NOT GIT_REVNO)
        set(GIT_REVNO "latest")
    endif(NOT GIT_REVNO)

    execute_process(
      COMMAND dpkg-architecture -qDEB_HOST_ARCH
      OUTPUT_VARIABLE CLICK_ARCH
      OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    configure_file(manifest.json.in ${CMAKE_CURRENT_BINARY_DIR}/manifest.json)
    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/manifest.json terminal.apparmor DESTINATION ${CMAKE_INSTALL_PREFIX})

    # make the click files visible in qtcreator
    file(GLOB CLICK_FILES
         RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
         *.json *.json.in *.apparmor)

    add_custom_target(com_ubuntu_terminal_CLICKFiles ALL SOURCES ${CLICK_FILES})
else(CLICK_MODE)
    execute_process(
        COMMAND qmake -query QT_INSTALL_QML
        OUTPUT_VARIABLE QT_IMPORTS_DIR
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    set(DATA_DIR ${CMAKE_INSTALL_DATADIR}/${APP_NAME})
    set(ICON ${CMAKE_INSTALL_PREFIX}/${DATA_DIR}/${ICON_FILE})
    set(DESKTOP_DIR ${CMAKE_INSTALL_DATADIR}/applications)
endif(CLICK_MODE)

file(GLOB_RECURSE I18N_SRC_FILES
     RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}/po
     *.qml *.js *.cpp *.h)
list(APPEND I18N_SRC_FILES ${DESKTOP_FILE}.in.in.h)
list(SORT I18N_SRC_FILES)

file(GLOB SRC_FILES
     RELATIVE ${CMAKE_CURRENT_SOURCE_DIR}
     *.qml *.js *.png *.js)
install(FILES ${SRC_FILES}
    DESTINATION ${DATA_DIR})

configure_file(${DESKTOP_FILE}.in.in ${DESKTOP_FILE}.in)

add_custom_target(${DESKTOP_FILE} ALL
    COMMENT "Merging translations into ${DESKTOP_FILE}..."
    COMMAND LC_ALL=C ${INTLTOOL_MERGE} -d -u ${CMAKE_SOURCE_DIR}/po ${DESKTOP_FILE}.in ${DESKTOP_FILE}
)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${DESKTOP_FILE}
    DESTINATION ${DESKTOP_DIR})

# Tests
enable_testing()

add_subdirectory(po)
add_subdirectory(tests)
add_subdirectory(src)
