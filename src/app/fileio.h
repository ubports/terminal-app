/*
 * Copyright: 2015 Canonical Ltd.
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
 * Author: Filippo Scognamiglio <flscogna@gmail.com>
 */

#ifndef FILEIO_H
#define FILEIO_H

#include <QObject>
#include <QFile>
#include <QTextStream>
#include <QUrl>

class FileIO : public QObject
{
    Q_OBJECT

public:
    FileIO();

public slots:
    bool write(const QString& sourceUrl, const QString& data);
    QString read(const QString& sourceUrl);
    bool remove(const QString& fileName);
    QString symLinkTarget(const QString& fileName);
    bool exists(const QString & fileName);
};

#endif // FILEIO_H
