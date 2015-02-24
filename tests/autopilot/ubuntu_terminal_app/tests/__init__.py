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

from autopilot import logging as autopilot_logging
from autopilot.testcase import AutopilotTestCase
import ubuntuuitoolkit

import ubuntu_terminal_app
from gi.repository import Click

logger = logging.getLogger(__name__)

# TODO Insert new tests here.
