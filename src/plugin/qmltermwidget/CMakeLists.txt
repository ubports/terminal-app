include_directories(
    ${CMAKE_CURRENT_SOURCE_DIR} qtermwidget/lib qtermwidget
)

set(PLUGIN_DIR QMLTermWidget)
add_definitions(-DHAVE_POSIX_OPENPT -DHAVE_SYS_TIME_H -DHAVE_UPDWTMPX)
add_definitions(-DQ_WS_UBUNTU)

set(qmltermwidget_SRCS
    qmltermwidget.h
    qmltermwidget.cpp
    qmltermwidget_plugin.h
    qmltermwidget_plugin.cpp
    qtermwidget/lib/BlockArray.h 
    qtermwidget/lib/CharacterColor.h 
    qtermwidget/lib/Character.h 
    qtermwidget/lib/ColorScheme.h 
    qtermwidget/lib/ColorTables.h 
    qtermwidget/lib/DefaultTranslatorText.h 
    qtermwidget/lib/Emulation.h 
    qtermwidget/lib/ExtendedDefaultTranslator.h 
    qtermwidget/lib/Filter.h 
    qtermwidget/lib/History.h 
    qtermwidget/lib/HistorySearch.h 
    qtermwidget/lib/KeyboardTranslator.h 
    qtermwidget/lib/konsole_wcwidth.h 
    qtermwidget/lib/kprocess.h 
    qtermwidget/lib/kptydevice.h 
    qtermwidget/lib/kpty.h 
    qtermwidget/lib/kpty_p.h 
    qtermwidget/lib/kptyprocess.h 
    qtermwidget/lib/LineFont.h 
    qtermwidget/lib/Pty.h 
    qtermwidget/lib/Screen.h 
    qtermwidget/lib/ScreenWindow.h 
    #qtermwidget/lib/SearchBar.h
    qtermwidget/lib/Session.h 
    qtermwidget/lib/ShellCommand.h 
    qtermwidget/lib/TerminalCharacterDecoder.h 
    qtermwidget/lib/TerminalDisplay.h 
    qtermwidget/lib/tools.h 
    qtermwidget/lib/Vt102Emulation.h 
    #qtermwidget/lib/qtermwidget.h
    qtermwidget/lib/BlockArray.cpp 
    qtermwidget/lib/ColorScheme.cpp 
    qtermwidget/lib/Emulation.cpp 
    qtermwidget/lib/Filter.cpp 
    qtermwidget/lib/History.cpp 
    qtermwidget/lib/HistorySearch.cpp 
    qtermwidget/lib/KeyboardTranslator.cpp 
    qtermwidget/lib/konsole_wcwidth.cpp 
    qtermwidget/lib/kprocess.cpp 
    qtermwidget/lib/kpty.cpp 
    qtermwidget/lib/kptydevice.cpp 
    qtermwidget/lib/kptyprocess.cpp 
    qtermwidget/lib/Pty.cpp 
    #qtermwidget/lib/qtermwidget.cpp
    qtermwidget/lib/Screen.cpp 
    qtermwidget/lib/ScreenWindow.cpp 
    #qtermwidget/lib/SearchBar.cpp
    qtermwidget/lib/Session.cpp 
    qtermwidget/lib/ShellCommand.cpp 
    qtermwidget/lib/TerminalCharacterDecoder.cpp 
    qtermwidget/lib/TerminalDisplay.cpp 
    qtermwidget/lib/tools.cpp 
    qtermwidget/lib/Vt102Emulation.cpp
)

add_library(qmltermwidget MODULE
    ${qmltermwidget_SRCS}
)

qt5_use_modules(qmltermwidget Gui Qml Quick Widgets)

# Copy the plugin, the qmldir file and other assets to the build dir for running in QtCreator
if(NOT "${CMAKE_CURRENT_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_BINARY_DIR}")
    add_custom_target(qmltermwidget-qmldir ALL
        COMMAND cp ${CMAKE_CURRENT_SOURCE_DIR}/qmldir ${CMAKE_CURRENT_BINARY_DIR}/../${PLUGIN_DIR}
        DEPENDS ${QMLFILES}
    )
    add_custom_target(qmltermwidget-layouts-schemes ALL
        COMMAND cp -a ${CMAKE_CURRENT_SOURCE_DIR}/qtermwidget/lib/color-schemes ${CMAKE_CURRENT_BINARY_DIR}/../${PLUGIN_DIR}
        COMMAND cp -a ${CMAKE_CURRENT_SOURCE_DIR}/qtermwidget/lib/kb-layouts ${CMAKE_CURRENT_BINARY_DIR}/../${PLUGIN_DIR}
        DEPENDS ${QMLFILES}
    )
    add_custom_command(TARGET qmltermwidget POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/../${PLUGIN_DIR}
        COMMENT "Creating plugin directory layout in the build dir"
        COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:qmltermwidget> ${CMAKE_CURRENT_BINARY_DIR}/../${PLUGIN_DIR}
        COMMENT "Copying to output directory"
    )
endif(NOT "${CMAKE_CURRENT_SOURCE_DIR}" STREQUAL "${CMAKE_CURRENT_BINARY_DIR}")


install(TARGETS qmltermwidget DESTINATION ${QT_IMPORTS_DIR}/${PLUGIN_DIR})
install(FILES qmldir DESTINATION ${QT_IMPORTS_DIR}/${PLUGIN_DIR})
install(DIRECTORY qtermwidget/lib/color-schemes DESTINATION ${QT_IMPORTS_DIR}/${PLUGIN_DIR})
install(DIRECTORY qtermwidget/lib/kb-layouts DESTINATION ${QT_IMPORTS_DIR}/${PLUGIN_DIR})
