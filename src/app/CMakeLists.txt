file(GLOB_RECURSE QML_SRCS *.qml *.js *.json)

set(terminal_SRCS
    main.cpp
    fileio.cpp
    inputdevice.cpp
    ${QML_SRCS}
)

add_executable(terminal ${terminal_SRCS})

qt5_use_modules(terminal Gui Qml Quick Widgets SystemInfo)

if(NOT "${CMAKE_CURRENT_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_BINARY_DIR}")
add_custom_target(terminal-qmlfiles ALL
    COMMAND cp -r ${CMAKE_CURRENT_SOURCE_DIR}/qml ${CMAKE_CURRENT_BINARY_DIR}
    DEPENDS ${QMLFILES}
)
endif(NOT "${CMAKE_CURRENT_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_BINARY_DIR}")

install(DIRECTORY qml DESTINATION ${DATA_DIR})
if(CLICK_MODE)
  install(TARGETS terminal DESTINATION ${BIN_DIR})
else()
  install(TARGETS terminal RUNTIME DESTINATION bin)
endif()
