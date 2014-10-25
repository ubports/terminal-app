#include "qmltermwidget.h"

#include "TerminalDisplay.h"
#include "Session.h"
#include "ColorScheme.h"
#include <QFileInfo>
#include <QInputMethodQueryEvent>

QMLTermWidget::QMLTermWidget():
    m_session(new Session()),
    m_terminalDisplay(new TerminalDisplay()),
    m_currentColorScheme("DarkPastels")
{
    // What it can do
    setFlag(ItemHasContents, true);
    setFlag(ItemAcceptsInputMethod, true);
    setFlag(ItemIsFocusScope, true);

    // Initialize default settings
    initSession();
    initTerminalDisplay();
    m_session->addView(m_terminalDisplay);

    // Connect the signals
    connect(m_terminalDisplay, SIGNAL(imageUpdated(QRect)), this, SLOT(update(QRect)));
    connect(this, SIGNAL(heightChanged()), this, SLOT(simulateResize()));
    connect(this, SIGNAL(widthChanged()), this, SLOT(simulateResize()));
    connect(m_session, SIGNAL(finished()), this, SIGNAL(sessionFinished()));
    connect(m_terminalDisplay, SIGNAL(updated(QRect)), this, SLOT(update(QRect)) );
}

void QMLTermWidget::initSession()
{
    QStringList args("");
    m_session->setTitle(Session::NameRole, "QTermWidget");
    m_session->setProgram(getenv("SHELL"));
    m_session->setArguments(args);
    m_session->setAutoClose(true);
    m_session->setCodec(QTextCodec::codecForName("UTF-8"));
    m_session->setFlowControlEnabled(true);
    m_session->setHistoryType(HistoryTypeBuffer(1000));
    m_session->setDarkBackground(true);
    m_session->setKeyBindings("");
}

void QMLTermWidget::initTerminalDisplay()
{
    m_terminalDisplay->setBellMode(TerminalDisplay::NotifyBell);
    m_terminalDisplay->setTerminalSizeHint(false);
    m_terminalDisplay->setTripleClickMode(TerminalDisplay::SelectWholeLine);
    m_terminalDisplay->setTerminalSizeStartup(true);
    m_terminalDisplay->setRandomSeed(m_session->sessionId() * 31);
    m_terminalDisplay->setAttribute(Qt::WA_DontShowOnScreen);
    m_terminalDisplay->setVisible(true);
}

int QMLTermWidget::getShellPID()
{
    return m_session->processId();
}

void QMLTermWidget::update(const QRect &rect)
{
    QQuickPaintedItem::update(rect);
}

void QMLTermWidget::changeDir(const QString & dir)
{
    /*
       this is a very hackish way of trying to determine if the shell is in
       the foreground before attempting to change the directory.  It may not
       be portable to anything other than Linux.
    */
    QString strCmd;
    strCmd.setNum(getShellPID());
    strCmd.prepend("ps -j ");
    strCmd.append(" | tail -1 | awk '{ print $5 }' | grep -q \\+");
    int retval = system(strCmd.toStdString().c_str());

    if (!retval) {
        QString cmd = "cd " + dir + "\n";
        sendText(cmd);
    }
}

void QMLTermWidget::paint(QPainter *painter)
{
    QRectF dest = contentsBoundingRect();
    QRegion region(dest.toRect());
    m_terminalDisplay->render(painter, QPoint(), region);
}

void QMLTermWidget::setTerminalFont(QFont &font)
{
    m_terminalDisplay->setVTFont(font);
}

QFont QMLTermWidget::getTerminalFont()
{
    return m_terminalDisplay->getVTFont();
}

void QMLTermWidget::setShellProgram(QString &program)
{
    m_session->setProgram(program);
}

void QMLTermWidget::setInitialWorkingDir(QString &dir)
{
    m_session->setInitialWorkingDirectory(dir);
}

void QMLTermWidget::setArguments(QStringList &arguments)
{
    m_session->setArguments(arguments);
}

void QMLTermWidget::setKeyBindings(QString &id)
{
    m_session->setKeyBindings(id);
}

QString QMLTermWidget::getKeyBindings()
{
    return m_session->keyBindings();
}

void QMLTermWidget::sendText(QString &text)
{
    m_session->sendText(text);
}

// Interactions events simulations
void QMLTermWidget::simulateKeyPress(int key, int modifiers, bool pressed, quint32 nativeScanCode, const QString &text)
{
    Q_UNUSED(nativeScanCode);
    QEvent::Type type = pressed ? QEvent::KeyPress : QEvent::KeyRelease;
    QKeyEvent event = QKeyEvent(type, key, (Qt::KeyboardModifier) modifiers, text);
    m_terminalDisplay->keyPressedSignal(&event);
}

void QMLTermWidget::simulateWheel(int x, int y, int buttons, int modifiers, QPointF angleDelta){
    QWheelEvent event(QPointF(x,y), angleDelta.y(), (Qt::MouseButton) buttons, (Qt::KeyboardModifier) modifiers);
    m_terminalDisplay->simulateWheelEvent(&event);
}

void QMLTermWidget::simulateMouseMove(int x, int y, int button, int buttons, int modifiers){
    QMouseEvent event(QEvent::MouseMove, QPointF(x, y),(Qt::MouseButton) button, (Qt::MouseButtons) buttons, (Qt::KeyboardModifiers) modifiers);
    m_terminalDisplay->simulateMouseMove(&event);
}

void QMLTermWidget::simulateMousePress(int x, int y, int button, int buttons, int modifiers){
    QMouseEvent event(QEvent::MouseButtonPress, QPointF(x, y),(Qt::MouseButton) button, (Qt::MouseButtons) buttons, (Qt::KeyboardModifiers) modifiers);
    m_terminalDisplay->simulateMousePress(&event);
}

void QMLTermWidget::simulateMouseRelease(int x, int y, int button, int buttons, int modifiers){
    QMouseEvent event(QEvent::MouseButtonRelease, QPointF(x, y),(Qt::MouseButton) button, (Qt::MouseButtons) buttons, (Qt::KeyboardModifiers) modifiers);
    m_terminalDisplay->simulateMouseRelease(&event);
}

void QMLTermWidget::simulateMouseDoubleClick(int x, int y, int button, int buttons, int modifiers){
    QMouseEvent event(QEvent::MouseButtonDblClick, QPointF(x, y),(Qt::MouseButton) button, (Qt::MouseButtons) buttons, (Qt::KeyboardModifiers) modifiers);
    m_terminalDisplay->simulateMouseDoubleClick(&event);
}

void QMLTermWidget::startShellProgram()
{
    m_session->run();
}

void QMLTermWidget::simulateResize()
{
    m_terminalDisplay->resize(this->width(), this->height());
    // Prevents some flickering after resize
    update(QRect(0,0,this->width(), this->height()));
}

QStringList QMLTermWidget::getAvailableColorSchemes()
{
    QStringList ret;
    foreach (const ColorScheme* cs, ColorSchemeManager::instance()->allColorSchemes())
        ret.append(cs->name());
    return ret;
}

QString QMLTermWidget::getColorScheme()
{
    return m_currentColorScheme;
}

void QMLTermWidget::setColorScheme(QString &origName)
{
    if (origName == m_currentColorScheme)
        return;

    const ColorScheme *cs = 0;

    const bool isFile = QFile::exists(origName);
    const QString& name = isFile ?
            QFileInfo(origName).baseName() :
            origName;

    // avoid legacy (int) solution
    if (!getAvailableColorSchemes().contains(name))
    {
        if (isFile)
        {
            if (ColorSchemeManager::instance()->loadCustomColorScheme(origName))
                cs = ColorSchemeManager::instance()->findColorScheme(name);
            else
                qWarning () << Q_FUNC_INFO
                        << "cannot load color scheme from"
                        << origName;
        }

        if (!cs)
            cs = ColorSchemeManager::instance()->defaultColorScheme();
    }
    else
        cs = ColorSchemeManager::instance()->findColorScheme(name);

    if (! cs)
    {
        qDebug() << tr("Cannot load color scheme: %1").arg(name);
        return;
    }

    ColorEntry table[TABLE_COLORS];
    cs->getColorTable(table);

    m_terminalDisplay->setColorTable(table);
    emit colorSchemeChanged();
}

void QMLTermWidget::copyClipboard()
{
    m_terminalDisplay->copyClipboard();
}

void QMLTermWidget::pasteClipboard()
{
    m_terminalDisplay->pasteClipboard();
}

void QMLTermWidget::pasteSelection()
{
    m_terminalDisplay->pasteSelection();
}

void QMLTermWidget::setLineSpacing(int lineSpacing)
{
    m_terminalDisplay->setLineSpacing(lineSpacing);
}

void QMLTermWidget::inputMethodQuery(QInputMethodQueryEvent *event)
{
    event->setValue(Qt::ImEnabled, true);
    event->setValue(Qt::ImHints, QVariant(Qt::ImhNoPredictiveText |  Qt::ImhNoAutoUppercase));
    event->accept();
}

void QMLTermWidget::keyPressEvent(QKeyEvent *event)
{
    //Ubuntu VKB: This (very very ugly) hack fixes the missing backspace.
    if(event->key() == Qt::Key_Backspace && event->text().isEmpty()){
        QKeyEvent finalEvent(event->type(), event->key(), event->modifiers(), "");
        m_terminalDisplay->simulateKeyPress(&finalEvent);
        return;
    }
    m_terminalDisplay->simulateKeyPress(event);
}

void QMLTermWidget::inputMethodEvent( QInputMethodEvent* event )
{
    m_terminalDisplay->simulateInputMethodEvent(event);
}

bool QMLTermWidget::event(QEvent* event)
{
    bool eventHandled = false;
    switch (event->type())
    {
    case QEvent::KeyPress:
        keyPressEvent(static_cast<QKeyEvent *>(event));
        break;
    case QEvent::InputMethod:
        inputMethodEvent(static_cast<QInputMethodEvent *>(event));
        break;
    case QEvent::InputMethodQuery:
        inputMethodQuery(static_cast<QInputMethodQueryEvent *>(event));
        break;
    default:
        eventHandled = m_terminalDisplay->simulateEvent(event);
        break;
    }
    return eventHandled; //parent->event(event);
}

QColor QMLTermWidget::getBackgroundColor(){
    return m_terminalDisplay->getBackgroundColor();
}

