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

# TODO Insert new tests here.
