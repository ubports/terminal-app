DEFINES += HAVE_POSIX_OPENPT HAVE_SYS_TIME_H
!macx:DEFINES += HAVE_UPDWTMPX

INCLUDEPATH += $$PWD/qtermwidget/lib
DEPENDPATH  += $$PWD/qtermwidget/lib

HEADERS = $$PWD/qtermwidget/lib/BlockArray.h \
    $$PWD/qtermwidget/lib/CharacterColor.h \
    $$PWD/qtermwidget/lib/Character.h \
    $$PWD/qtermwidget/lib/ColorScheme.h \
    $$PWD/qtermwidget/lib/ColorTables.h \
    $$PWD/qtermwidget/lib/DefaultTranslatorText.h \
    $$PWD/qtermwidget/lib/Emulation.h \
    $$PWD/qtermwidget/lib/ExtendedDefaultTranslator.h \
    $$PWD/qtermwidget/lib/Filter.h \
    $$PWD/qtermwidget/lib/History.h \
    $$PWD/qtermwidget/lib/HistorySearch.h \
    $$PWD/qtermwidget/lib/KeyboardTranslator.h \
    $$PWD/qtermwidget/lib/konsole_wcwidth.h \
    $$PWD/qtermwidget/lib/kprocess.h \
    $$PWD/qtermwidget/lib/kptydevice.h \
    $$PWD/qtermwidget/lib/kpty.h \
    $$PWD/qtermwidget/lib/kpty_p.h \
    $$PWD/qtermwidget/lib/kptyprocess.h \
    $$PWD/qtermwidget/lib/LineFont.h \
    $$PWD/qtermwidget/lib/Pty.h \
    $$PWD/qtermwidget/lib/Screen.h \
    $$PWD/qtermwidget/lib/ScreenWindow.h \
    $$PWD/qtermwidget/lib/SearchBar.h \
    $$PWD/qtermwidget/lib/Session.h \
    $$PWD/qtermwidget/lib/ShellCommand.h \
    $$PWD/qtermwidget/lib/TerminalCharacterDecoder.h \
    $$PWD/qtermwidget/lib/TerminalDisplay.h \
    $$PWD/qtermwidget/lib/tools.h \
    $$PWD/qtermwidget/lib/Vt102Emulation.h \
    $$PWD/qtermwidget/lib/qtermwidget.h


SOURCES = $$PWD/qtermwidget/lib/BlockArray.cpp \
    $$PWD/qtermwidget/lib/ColorScheme.cpp \
    $$PWD/qtermwidget/lib/Emulation.cpp \
    $$PWD/qtermwidget/lib/Filter.cpp \
    $$PWD/qtermwidget/lib/History.cpp \
    $$PWD/qtermwidget/lib/HistorySearch.cpp \
    $$PWD/qtermwidget/lib/KeyboardTranslator.cpp \
    $$PWD/qtermwidget/lib/konsole_wcwidth.cpp \
    $$PWD/qtermwidget/lib/kprocess.cpp \
    $$PWD/qtermwidget/lib/kpty.cpp \
    $$PWD/qtermwidget/lib/kptydevice.cpp \
    $$PWD/qtermwidget/lib/kptyprocess.cpp \
    $$PWD/qtermwidget/lib/Pty.cpp \
    $$PWD/qtermwidget/lib/qtermwidget.cpp \
    $$PWD/qtermwidget/lib/Screen.cpp \
    $$PWD/qtermwidget/lib/ScreenWindow.cpp \
    $$PWD/qtermwidget/lib/SearchBar.cpp \
    $$PWD/qtermwidget/lib/Session.cpp \
    $$PWD/qtermwidget/lib/ShellCommand.cpp \
    $$PWD/qtermwidget/lib/TerminalCharacterDecoder.cpp \
    $$PWD/qtermwidget/lib/TerminalDisplay.cpp \
    $$PWD/qtermwidget/lib/tools.cpp \
    $$PWD/qtermwidget/lib/Vt102Emulation.cpp

FORMS = $$PWD/qtermwidget/lib/SearchBar.ui


