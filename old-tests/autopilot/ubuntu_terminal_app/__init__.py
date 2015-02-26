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

from time import sleep
import sqlite3
import os.path
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

    def get_slider_item(self, slider):
        return self.wait_select_single("Slider", objectName=slider)

    def get_control_panel(self):
        return self.wait_select_single("CtrlKeys", objectName="kbCtrl")

    def get_function_panel(self):
        return self.wait_select_single("FnKeys", objectName="kbFn")

    def get_text_panel(self):
        return self.wait_select_single("ScrlKeys", objectName="kbScrl")

    def get_terminal_page(self):
        return self.wait_select_single("Terminal", objectName="pgTerm")

    def get_circle_menu(self):
        return self.wait_select_single("CircleMenu", objectName="cmenu")

    def long_tap_terminal_center(self):
        x, y, w, h = self.globalRect
        tap_x = (x + w) / 2
        tap_y = (y + h) / 3

        # tap in the top third of the screen, to avoid OSK
        self.pointing_device.move(tap_x, tap_y)
        self.pointing_device.press()
        # we can hold the press for a long time without issue
        # so we'll ensure the app recieves our signal when under load
        sleep(4)
        self.pointing_device.release()

    def drag_horizontal_slider(self, slider, pos):
        """Drag slider until value is set"""
        slItem = self.get_slider_item(slider)

        slRect = slItem.select_single("SliderStyle")

        slideMin = int(slItem.minimumValue)
        slideMax = int(slItem.maximumValue)

        if pos > slideMax:
            raise ValueError("Pos cannot be greater than" + str(slideMax))

        if pos < slideMin:
            raise ValueError("Pos cannot be less than" + str(slideMin))

        x, y, w, h = slRect.globalRect
        # calculate the approximate slide step width
        # we take half of the theoretical step value just to make
        # sure we don't miss any values
        step = w / ((slideMax - slideMin) * 2)
        sx = x + step
        sy = y + h / 2
        loop = 1

        # set the slider to minimum value and loop
        self.pointing_device.move(sx, sy)
        self.pointing_device.click()

        # drag through the slider until the pos matches our desired value
        # in case of bad sliding, loop will also timeout
        while round(slItem.value) != pos and slItem.value < slideMax \
                and loop <= (slideMax * 2):
                valuePos = int(sx + step)
                self.pointing_device.drag(sx, sy, valuePos, sy)
                sx = valuePos
                sleep(1)
                loop = loop + 1


class DbMan(object):

    """
    Helper functions for dealing with sqlite databases
    """

    def get_db(self):
        dbs_path = os.path.expanduser(
            "~/.local/share/com.ubuntu.terminal/Databases")
        if not os.path.exists(dbs_path):
            return None

        files = [f for f in os.listdir(dbs_path)
                 if os.path.splitext(f)[1] == ".ini"]
        for f in files:
            ini_path = os.path.join(dbs_path, f)
            with open(ini_path) as ini:
                for line in ini:
                    if "=" in line:
                        key, val = line.strip().split("=")
                        if key == "Name" and val == "UbuntuTerminalDB":
                            try:
                                return ini_path.replace(".ini", ".sqlite")
                            except OSError:
                                pass
        return None

    def clean_db(self):
        path = self.get_db()
        if path is None:
            self.assertNotEquals(path, None)
        try:
            os.remove(path)
        except OSError:
            pass

    def get_font_size_from_storage(self):
        db = self.get_db()
        conn = sqlite3.connect(db)

        with conn:
            cur = conn.cursor()
            cur.execute("SELECT value FROM config WHERE item='fontSize'")
            row = cur.fetchone()
            if row is None:
                self.assertNotEquals(row, None)
            return int(row[0])

    def get_color_scheme_from_storage(self):
        db = self.get_db()
        conn = sqlite3.connect(db)

        with conn:
            cur = conn.cursor()
            cur.execute("SELECT value FROM config WHERE item='colorScheme'")
            row = cur.fetchone()
            if row is None:
                self.assertNotEquals(row, None)
            return row[0]
