#ifndef INPUTINFO_H
#define INPUTINFO_H

#include <QObject>

class QInputInfoManager;

class InputInfo : public QObject
{
    Q_OBJECT
    Q_PROPERTY(bool mouseAttached READ mouseAttached NOTIFY mouseAttachedChanged)
    Q_PROPERTY(bool keyboardAttached READ keyboardAttached NOTIFY keyboardAttachedChanged)

public:
    InputInfo(QObject *parent = 0);
    ~InputInfo();

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

#endif // INPUTINFO_H
