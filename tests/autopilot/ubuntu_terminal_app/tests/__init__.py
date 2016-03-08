# -*- Mode: Python; coding: utf-8; indent-tabs-mode: nil; tab-width: 4 -*-
# Copyright 2013 Canonical
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License version 3, as published
# by the Free Software Foundation.

"""Terminal app autopilot tests."""

import os.path
import fixtures
import logging
import tempfile
import gi

from autopilot import logging as autopilot_logging
from autopilot.testcase import AutopilotTestCase
import ubuntuuitoolkit

import ubuntu_terminal_app
gi.require_version('Click', '0.4')
from gi.repository import Click


logger = logging.getLogger(__name__)


class TerminalTestCase(AutopilotTestCase):

    """A common testcase class that provides useful methods for the terminal
    app.

    """

    local_build_location = os.path.dirname(os.path.dirname(os.getcwd()))
    sdk_build_location = os.path.join(os.path.dirname(local_build_location),
                                      os.path.basename(local_build_location)
                                      + '-build')

    local_build_location_qml = os.path.join(
        local_build_location, 'src', 'app', 'qml', 'ubuntu-terminal-app.qml')
    local_build_location_binary = os.path.join(local_build_location,
                                               'src', 'app', 'terminal')
    sdk_build_location_qml = os.path.join(
        sdk_build_location, 'src', 'app', 'qml', 'ubuntu-terminal-app.qml')
    sdk_build_location_binary = os.path.join(sdk_build_location,
                                             'src', 'app', 'terminal')
    installed_location_binary = os.path.join('usr', 'bin',
                                             'ubuntu-terminal-app')
    installed_location_qml = os.path.join('usr', 'share',
                                          'ubuntu-terminal-app', 'qml',
                                          'ubuntu-terminal-app.qml')

    def setUp(self):
        super(TerminalTestCase, self).setUp()
        launcher_method, _ = self.get_launcher_method_and_type()
        self.app = ubuntu_terminal_app.TerminalApp(launcher_method())

    def get_launcher_method_and_type(self):
        if os.path.exists(self.local_build_location_binary):
            launcher = self.launch_test_local
            test_type = 'local'
        elif os.path.exists(self.sdk_build_location_binary):
            launcher = self.launch_test_sdk
            test_type = 'sdk'
        elif os.path.exists(self.installed_location_binary):
            launcher = self.launch_test_installed
            test_type = 'deb'
        else:
            launcher = self.launch_test_click
            test_type = 'click'
        return launcher, test_type

    @autopilot_logging.log_action(logger.info)
    def launch_test_local(self):
        plugin_location = os.path.join(self.local_build_location,
                                       'src', 'plugin')
        self.useFixture(fixtures.EnvironmentVariable(
            'QML2_IMPORT_PATH', newvalue=plugin_location))
        return self.launch_test_application(
            self.local_build_location_binary,
            app_type='qt',
            emulator_base=ubuntuuitoolkit.UbuntuUIToolkitCustomProxyObjectBase)

    @autopilot_logging.log_action(logger.info)
    def launch_test_sdk(self):
        plugin_location = os.path.join(self.sdk_build_location,
                                       'src', 'plugin')
        self.useFixture(fixtures.EnvironmentVariable(
            'QML2_IMPORT_PATH', newvalue=plugin_location))

        return self.launch_test_application(
            self.sdk_build_location_binary,
            app_type='qt',
            emulator_base=ubuntuuitoolkit.UbuntuUIToolkitCustomProxyObjectBase)

    @autopilot_logging.log_action(logger.info)
    def launch_test_installed(self):
        return self.launch_test_application(
            self.installed_location_binary,
            '-q', self.installed_location_qml,
            app_type='qt',
            emulator_base=ubuntuuitoolkit.UbuntuUIToolkitCustomProxyObjectBase)

    @autopilot_logging.log_action(logger.info)
    def launch_test_click(self):
        # We need to pass the "--forceAuth false" argument to the terminal app
        # binary, but ubuntu-app-launch doesn't pass arguments to the exec line
        # on the desktop file. So we make a test desktop file that has the
        # "--forceAuth false"  on the exec line.
        desktop_file_path = self.write_sandbox_desktop_file()
        desktop_file_name = os.path.basename(desktop_file_path)
        application_name, _ = os.path.splitext(desktop_file_name)
        return self.launch_upstart_application(
            application_name,
            emulator_base=ubuntuuitoolkit.UbuntuUIToolkitCustomProxyObjectBase)

    def write_sandbox_desktop_file(self):
        desktop_file_dir = self.get_local_desktop_file_directory()
        desktop_file = self.get_named_temporary_file(
            suffix='.desktop', dir=desktop_file_dir)
        desktop_file.write('[Desktop Entry]\n')
        version, installed_path = self.get_installed_version_and_directory()
        terminal_sandbox_exec = (
            'aa-exec-click -p com.ubuntu.terminal_terminal_{}'
            ' -- terminal --forceAuth false'.format(version))
        desktop_file_dict = {
            'Type': 'Application',
            'Name': 'terminal',
            'Exec': terminal_sandbox_exec,
            'Icon': 'Not important',
            'Path': installed_path
        }
        for key, value in desktop_file_dict.items():
            desktop_file.write('{key}={value}\n'.format(key=key, value=value))
        desktop_file.close()
        logger.debug(terminal_sandbox_exec)
        for key, value in desktop_file_dict.items():
            logger.debug("%s: %s" % (key, value))
        return desktop_file.name

    def get_local_desktop_file_directory(self):
        return os.path.join(
            os.path.expanduser('~'), '.local', 'share', 'applications')

    def get_named_temporary_file(
            self, dir=None, mode='w+t', delete=False, suffix=''):
        # Discard files with underscores which look like an APP_ID to Unity
        # See https://bugs.launchpad.net/ubuntu-ui-toolkit/+bug/1329141
        chars = tempfile._RandomNameSequence.characters.strip("_")
        tempfile._RandomNameSequence.characters = chars
        return tempfile.NamedTemporaryFile(
            dir=dir, mode=mode, delete=delete, suffix=suffix)

    def get_installed_version_and_directory(self):
        db = Click.DB()
        db.read()
        package_name = 'com.ubuntu.terminal'
        registry = Click.User.for_user(db, name=os.environ.get('USER'))
        version = registry.get_version(package_name)
        directory = registry.get_path(package_name)
        return version, directory
