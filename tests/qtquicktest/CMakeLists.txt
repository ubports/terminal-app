#find_program(XVFB_RUN_BIN xvfb-run)
#if(NOT XVFB_RUN_BIN)
#  message(FATAL_ERROR "Could not find xvfb-run, please install the xvfb package")
#endif()
#set(XVFB_RUN_CMD ${XVFB_RUN_BIN} -a -s "-screen 0 1024x768x24")

include(FindPkgConfig)
find_package(Qt5Core)

# copy qml test files to build directory
if(NOT "${CMAKE_CURRENT_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_BINARY_DIR}")
add_custom_target(qmlTestFiles ALL
    COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/*.qml ${CMAKE_CURRENT_BINARY_DIR}
)
endif(NOT "${CMAKE_CURRENT_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_BINARY_DIR}")

set(QTQUICK_TEST tst_qtquicktest)
add_executable(${QTQUICK_TEST} qtquicktest.cpp)
qt5_use_modules(${QTQUICK_TEST} Core Qml Quick Test QuickTest)
#add_test(${QTQUICK_TEST} ${XVFB_RUN_CMD} ${CMAKE_CURRENT_BINARY_DIR}/${QTQUICK_TEST})
