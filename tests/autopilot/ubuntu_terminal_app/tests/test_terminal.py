# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
# Copyright 2013 Canonical
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3, as published
# by the Free Software Foundation.

"""Terminal app autopilot tests."""

from ubuntu_terminal_app.tests import TerminalTestCase


class TestMainWindow(TerminalTestCase):
    def test_example_test(self):
        """Just launch app, assert on main view"""
        main_view = self.app.main_view
        self.assertTrue(main_view)
