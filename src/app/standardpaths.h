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

#ifndef STANDARDPATHS_H
#define STANDARDPATHS_H

#include <QObject>
#include <QStringList>

class StandardPaths : public QObject
{
    Q_OBJECT
    Q_ENUMS(StandardLocation)

public:
    explicit StandardPaths(QObject *parent = 0);

    enum StandardLocation {
        DesktopLocation = 0,
        DocumentsLocation,
        FontsLocation,
        ApplicationsLocation,
        MusicLocation,
        MoviesLocation,
        PicturesLocation,
        TempLocation,
        HomeLocation,
        DataLocation,
        CacheLocation,
        GenericDataLocation,
        RuntimeLocation,
        ConfigLocation,
        DownloadLocation,
        GenericCacheLocation,
        GenericConfigLocation,
        AppDataLocation,
        AppConfigLocation,
        AppLocalDataLocation = DataLocation
    };

public slots:
    QStringList standardLocations(StandardLocation type) const;
    QString writableLocation(StandardLocation type) const;
};

#endif // STANDARDPATHS_H
