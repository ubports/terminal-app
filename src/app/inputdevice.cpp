#include "inputdevice.h"

#include <QtSystemInfo/QInputDevice>
#include <QtSystemInfo/QInputInfoManager>

InputDevice::InputDevice(QObject *parent) :
    QObject(parent),
    m_keyboardAttached(false),
    m_mouseAttached(false),
    m_inputDevicesWatcher(new QInputInfoManager())
{
    // Initialize signals when the watcher is ready.
    // QInputInfoManager() emits deviceAdded() signal multiple times during its
    // initializations.
    connect(m_inputDevicesWatcher, &QInputInfoManager::ready,
            this, &InputDevice::init);
}

InputDevice::~InputDevice()
{
    delete m_inputDevicesWatcher;
}

void InputDevice::init()
{
    // Connect signals
    connect(m_inputDevicesWatcher, &QInputInfoManager::deviceAdded,
            this, &InputDevice::checkDevicesCount);

    connect(m_inputDevicesWatcher, &QInputInfoManager::deviceRemoved,
            this, &InputDevice::checkDevicesCount);

    checkDevicesCount();
}

void InputDevice::checkDevicesCount()
{
    int mouseCount = m_inputDevicesWatcher->count(QInputDevice::Mouse);
    int touchPadCount = m_inputDevicesWatcher->count(QInputDevice::TouchPad);
    int keybCount = m_inputDevicesWatcher->count(QInputDevice::Keyboard);

    setMouseAttached(mouseCount || touchPadCount);
    setKeyboardAttached(keybCount);
}

void InputDevice::setKeyboardAttached(bool keyboardAttached)
{
    if (m_keyboardAttached == keyboardAttached)
        return;

    qDebug() << "[InputDevice] Is keyboard attached?" << keyboardAttached;

    m_keyboardAttached = keyboardAttached;
    Q_EMIT keyboardAttachedChanged();
}

void InputDevice::setMouseAttached(bool mouseAttached)
{
    if (m_mouseAttached == mouseAttached)
        return;

    qDebug() << "[InputDevice] Is mouse attached?" << mouseAttached;

    m_mouseAttached = mouseAttached;
    Q_EMIT mouseAttachedChanged();
}
