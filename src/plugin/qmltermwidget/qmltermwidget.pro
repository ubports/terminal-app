TEMPLATE = lib
TARGET = qmltermwidget
QT += qml quick widgets
CONFIG += qt plugin debug

include(qtermwidget.pri)

DESTDIR = $$OUT_PWD/QMLTermWidget

SOURCES += \
    qmltermwidget_plugin.cpp \
    qmltermwidget.cpp \

HEADERS += \
    qmltermwidget_plugin.h \
    qmltermwidget.h \

OTHER_FILES = qmldir

defineTest(copyToDestdir) {
    files = $$1
    for(FILE, files) {
        DDIR = $$DESTDIR
        # Replace slashes in paths with backslashes for Windows
        win32:FILE ~= s,/,\\,g
        win32:DDIR ~= s,/,\\,g
        QMAKE_POST_LINK += $$QMAKE_COPY $$quote($$FILE) $$quote($$DDIR) $$escape_expand(\\n\\t)
    }
    export(QMAKE_POST_LINK)
}
