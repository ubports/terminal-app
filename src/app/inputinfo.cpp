#include "inputinfo.h"

#include <QtSystemInfo/QInputDevice>
#include <QtSystemInfo/QInputInfoManager>

InputInfo::InputInfo(QObject *parent) :
    QObject(parent),
    m_keyboardAttached(false),
    m_mouseAttached(false),
    m_inputDevicesWatcher(new QInputInfoManager())
{
    // Initialize signals when the watcher is ready.
    // QInputInfoManager() emits deviceAdded() signal multiple times during its
    // initializations.
    connect(m_inputDevicesWatcher, &QInputInfoManager::ready,
            this, &InputInfo::init);
}

InputInfo::~InputInfo()
{
    delete m_inputDevicesWatcher;
}

void InputInfo::init()
{
    // Connect signals
    connect(m_inputDevicesWatcher, &QInputInfoManager::deviceAdded,
            this, &InputInfo::checkDevicesCount);

    connect(m_inputDevicesWatcher, &QInputInfoManager::deviceRemoved,
            this, &InputInfo::checkDevicesCount);

    checkDevicesCount();
}

void InputInfo::checkDevicesCount()
{
    int mouseCount = m_inputDevicesWatcher->count(QInputDevice::Mouse);
    int touchPadCount = m_inputDevicesWatcher->count(QInputDevice::TouchPad);
    int keybCount = m_inputDevicesWatcher->count(QInputDevice::Keyboard);

    setMouseAttached(mouseCount || touchPadCount);
    setKeyboardAttached(keybCount);
}

void InputInfo::setKeyboardAttached(bool keyboardAttached)
{
    if (m_keyboardAttached == keyboardAttached)
        return;

    qDebug() << "[InputDevice] Is keyboard attached?" << keyboardAttached;

    m_keyboardAttached = keyboardAttached;
    Q_EMIT keyboardAttachedChanged();
}

void InputInfo::setMouseAttached(bool mouseAttached)
{
    if (m_mouseAttached == mouseAttached)
        return;

    qDebug() << "[InputDevice] Is mouse attached?" << mouseAttached;

    m_mouseAttached = mouseAttached;
    Q_EMIT mouseAttachedChanged();
}
