# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
#
# Copyright (C) 2013 Canonical Ltd.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation; version 3.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program. If not, see <http://www.gnu.org/licenses/>.

"""Terminal app autopilot helpers."""

import ubuntuuitoolkit


class TerminalApp(object):

    """Autopilot helper object for the terminal application."""

    def __init__(self, app_proxy):
        self.app = app_proxy
        self.main_view = self.app.select_single(MainView)

    @property
    def pointing_device(self):
        return self.app.pointing_device


class MainView(ubuntuuitoolkit.MainView):

    """Autopilot custom proxy object for the MainView."""

    def __init__(self, *args):
        super(MainView, self).__init__(*args)
        self.visible.wait_for(True)
