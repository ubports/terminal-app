#ifndef QMLTERMWIDGET_H
#define QMLTERMWIDGET_H

#include <QQuickPaintedItem>
#include <QStringList>

#include "TerminalDisplay.h"
#include "Session.h"
#include "QTextCodec"

using namespace Konsole;

class QMLTermWidget: public QQuickPaintedItem
{
    Q_OBJECT
    Q_PROPERTY(QFont font READ getTerminalFont WRITE setTerminalFont)
    Q_PROPERTY(int lineSpace WRITE setLineSpacing)
    Q_PROPERTY(QString initialWorkingDirectory WRITE setInitialWorkingDir)
    Q_PROPERTY(QString shellProgram WRITE setShellProgram)
    Q_PROPERTY(QStringList shellArguments WRITE setArguments)
    Q_PROPERTY(QStringList environment WRITE setEnvironment)
    Q_PROPERTY(QStringList availableColorSchemes READ getAvailableColorSchemes)
    Q_PROPERTY(QString colorScheme READ getColorScheme WRITE setColorScheme NOTIFY colorSchemeChanged)
    Q_PROPERTY(QString keyBindings READ getKeyBindings WRITE setKeyBindings)
    Q_PROPERTY(QColor backgroundColor READ getBackgroundColor NOTIFY colorSchemeChanged)

public:
    QMLTermWidget();

    QFont getTerminalFont();
    void setTerminalFont(QFont &font);

    void setLineSpacing(int lineSpace);

    void setShellProgram(QString &program);

    void setInitialWorkingDir(QString &dir);

    void setArguments(QStringList &arguments);
    void setEnvironment(QStringList &env);

    QString getKeyBindings();
    void setKeyBindings(QString &id);

    int getShellPID();

    QStringList getAvailableColorSchemes();
    QString getColorScheme();
    void setColorScheme(QString &origName);

    QColor getBackgroundColor();

    void paint(QPainter *painter);

public slots:
    void sendText(QString &text);

    void getWorkingDirectory();

    void startShellProgram();

    void copyClipboard();
    void pasteClipboard();
    void pasteSelection();

    void simulateKeyPress(int key, int modifiers, bool pressed, quint32 nativeScanCode, const QString &text);
    void simulateWheel(int x, int y, int buttons, int modifiers, QPointF angleDelta);
    void simulateMouseMove(int x, int y, int button, int buttons, int modifiers);
    void simulateMousePress(int x, int y, int button, int buttons, int modifiers);
    void simulateMouseRelease(int x, int y, int button, int buttons, int modifiers);
    void simulateMouseDoubleClick(int x, int y, int button, int buttons, int modifiers);

    void update(const QRect &rect);

    void changeDir(const QString & dir);

protected:
    void keyPressEvent(QKeyEvent *event);
    void inputMethodEvent(QInputMethodEvent* event);
    void inputMethodQuery(QInputMethodQueryEvent *event);
    bool event(QEvent* event);

protected slots:
    void simulateResize();

private:
    void initSession();
    void initTerminalDisplay();

signals:
    void sessionFinished();
    void colorSchemeChanged();

private:
    Session *m_session;
    TerminalDisplay *m_terminalDisplay;
    QString m_currentColorScheme;
};

#endif // QMLTERMWIDGET_H
