# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
# Copyright 2013 Canonical
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3, as published
# by the Free Software Foundation.

"""Terminal app autopilot tests."""

from __future__ import absolute_import

from autopilot.matchers import Eventually
from testtools.matchers import Equals

from ubuntu_terminal_app.tests import TerminalTestCase
from ubuntu_terminal_app import DbMan
from ubuntuuitoolkit import ToolkitException
from testscenarios import TestWithScenarios

from time import sleep
import random


class TestMainWindow(TerminalTestCase):

    def test_circle_menu_shows(self):
        """Make sure that Circle Menu is visible
        on long tap"""
        self.app.main_view.long_tap_terminal_center()
        menu = self.app.main_view.get_circle_menu()
        self.assertThat(menu.visible, Eventually(Equals(True)))

    def test_header(self):
        """Make sure that Header is visible
        in Portrait Mode and not visible in landscape mode"""
        kterm = self.app.main_view.get_terminal_page()
        header = self.app.main_view.get_header()
        if kterm.width > kterm.height:
            self.assertThat(header.visible, Equals(False))
        else:
            self.assertThat(header.visible, Equals(True))


class TestPanel(TerminalTestCase, TestWithScenarios):

    scenarios = [
        ('controlpanel',
            {'button': 'controlkeysaction',
             'helper_method': 'get_control_panel'
             }),

        ('functionpanel',
            {'button': 'functionkeysaction',
             'helper_method': 'get_function_panel'
             }),

        ('textpanel',
            {'button': 'textkeysaction',
             'helper_method': 'get_text_panel'
             })
    ]

    def open_panel(self, button, helper_method):
        """Open named panel"""
        header = self.app.main_view.get_header()
        header.click_action_button(button)
        get_panel = getattr(self.app.main_view, helper_method)
        return get_panel()

    def hide_panel(self):
        """Close any open panel"""
        header = self.app.main_view.get_header()

        # the overflow panel can be left open, so we need to try again
        # https://bugs.launchpad.net/ubuntu-terminal-app/+bug/1363233
        try:
            header.click_action_button('hidepanelaction')
            try:
                sleep(2)
                header.click_action_button('hidepanelaction')
            except ToolkitException:
                pass
        except ToolkitException:
            pass

    def test_panels(self):
        """Make sure that Panel is visible
        when clicking the toolbar popup items and hides properly."""
        panel = self.open_panel(self.button, self.helper_method)
        self.assertThat(panel.visible, Eventually(Equals(True)))
        self.hide_panel()
        self.assertThat(panel.visible, Eventually(Equals(False)))


class TestSettings(TerminalTestCase, DbMan):

    def click_item_selector_item(self, selector, value):
        """Clicks item from item selector"""
        # This needs a toolkit helper
        # https://bugs.launchpad.net/ubuntu-ui-toolkit/+bug/1272345
        select = self.app.main_view.wait_select_single('ItemSelector',
                                                       objectName=selector)
        container = select.wait_select_single('Standard',
                                              objectName='listContainer')
        self.app.pointing_device.click_object(container)
        select.currentlyExpanded.wait_for(True)
        # waiting for currentlyExpanded is not enough
        # some animation is not accounted for and thus we sleep
        sleep(2)
        item = container.wait_select_single('Label', text=value)
        self.app.pointing_device.click_object(item)
        select.currentlyExpanded.wait_for(False)
        # waiting for currentlyExpanded is not enough
        # some animation is not accounted for and thus we sleep
        sleep(1)

    def test_color_scheme_changes(self):
        """Make sure that color scheme is set correctly"""

        # are these string translatable?
        # if so, we need to do this another way
        schemeList = ("BlackOnRandomLight",
                      "BlackOnWhite",
                      "BlackOnLightYellow",
                      "DarkPastels",
                      "GreenOnBlack",
                      "Linux",
                      "WhiteOnBlack")

        colorScheme = self.get_color_scheme_from_storage
        for scheme in schemeList:
            header = self.app.main_view.get_header()
            header.click_action_button('SettingsButton')
            self.click_item_selector_item("liSchemes", scheme)
            self.app.main_view.go_back()
            self.assertThat(colorScheme, Eventually(Equals(scheme)))

    def test_font_size_changes(self):
        """Make sure that font size is set correctly"""
        header = self.app.main_view.get_header()
        header.click_action_button('SettingsButton')

        font_size = self.get_font_size_from_storage

        # change font size to min
        self.app.main_view.drag_horizontal_slider("slFont", 8)
        self.assertThat(font_size, Eventually(Equals(8)))

        # change font size to max
        self.app.main_view.drag_horizontal_slider("slFont", 32)
        self.assertThat(font_size, Eventually(Equals(32)))

        # change font size to random sizes
        for loop in range(1, 3):
            randSize = random.randrange(9, 31, 1)
            self.app.main_view.drag_horizontal_slider("slFont", randSize)
            self.assertThat(font_size, Eventually(Equals(randSize)))
