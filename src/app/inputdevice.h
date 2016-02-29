#ifndef INPUTDEVICE_H
#define INPUTDEVICE_H

#include <QObject>

class QInputInfoManager;

class InputDevice : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool mouseAttached READ mouseAttached NOTIFY mouseAttachedChanged)
    Q_PROPERTY(bool keyboardAttached READ keyboardAttached NOTIFY keyboardAttachedChanged)

public:
    InputDevice(QObject *parent = 0);
    ~InputDevice();

    bool keyboardAttached() const { return m_keyboardAttached; }
    bool mouseAttached() const { return m_mouseAttached; }

Q_SIGNALS:
    void keyboardAttachedChanged();
    void mouseAttachedChanged();

private slots:
    void checkDevicesCount();
    void init();

private:
    bool m_keyboardAttached;
    bool m_mouseAttached;

    QInputInfoManager* m_inputDevicesWatcher;

private:
    void setKeyboardAttached(bool keyboardAttached);
    void setMouseAttached(bool mouseAttached);
};

#endif // INPUTDEVICE_H
