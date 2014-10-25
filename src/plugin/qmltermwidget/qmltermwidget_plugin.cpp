#include "qmltermwidget_plugin.h"
#include "qmltermwidget.h"

#include <qqml.h>

void QmltermwidgetPlugin::registerTypes(const char *uri)
{
    // @uri org.qterminal.qmlterminal
    qmlRegisterType<QMLTermWidget>(uri, 1, 0, "QMLTermWidget");
}
