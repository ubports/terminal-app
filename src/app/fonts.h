/*
 * Copyright: 2016 Canonical Ltd.
 *
 * This file is part of ubuntu-terminal-app
 *
 * ubuntu-terminal-app is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * ubuntu-terminal-app is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * Author: Florian Boucault <florian.boucault@canonical.com>
 */

#ifndef FONTS_H
#define FONTS_H

#include <QObject>
#include <QList>
#include <QFontDatabase>
#include <QStringList>

class Fonts : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QStringList monospaceFamilies READ monospaceFamilies NOTIFY monospaceFamiliesChanged)

public:
    Fonts();

    QStringList monospaceFamilies() const;

Q_SIGNALS:
    void monospaceFamiliesChanged();

protected:
    void updateFamilies();

private:
    QStringList m_monospaceFamilies;
    QFontDatabase m_fontDatabase;
};

#endif // FONTS_H
