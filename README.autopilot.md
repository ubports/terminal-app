Running Autopilot tests
=======================
If you are looking for more info about Autopilot or writing AP tests, here are some useful links to help you:

- [Ubuntu - Quality](http://developer.ubuntu.com/start/quality)
- [Autopilot - Python](https://developer.ubuntu.com/api/autopilot/python/1.5.0/)

For help and options on running tests, see:

- [Autopilot tests](https://developer.ubuntu.com/en/start/platform/guides/running-autopilot-tests/)

Prerequisites
=============

Install the following autopilot packages required to run the tests,

    $ sudo apt-get install python3-autopilot libautopilot-qt ubuntu-ui-toolkit-autopilot python3-autopilot-vis

Running tests on the desktop
============================

Using terminal:

*  Branch the Music app code, for example,

    $ bzr branch lp:ubuntu-terminal-app

*  Navigate to the tests/autopilot directory.

    $ cd tests/autopilot

*  run all tests.

    $ autopilot3 run -vv ubuntu_terminal_app

* to list all tests:

    $ autopilot3 list ubuntu_terminal_app

 To run only one test

    $ autopilot3 run -vv ubuntu_terminal_app.tests.test_name

* Debugging tests using autopilot vis

    $ autopilot3 launch -i Qt qmlscene src/app/terminal

    $ autopilot3 vis

Running tests using Ubuntu SDK
==============================

Refer this [tutorial](https://developer.ubuntu.com/en/start/platform/guides/running-autopilot-tests/) to run tests on Ubuntu SDK:

Running tests on device or emulator:
====================================

Using autopkg:

*  Branch the Music app code, for example,

    $ bzr branch lp:ubuntu-terminal-app

*  Navigate to the source directory.

    $ cd ubuntu-terminal-app

*  Build a click package

    $ click-buddy .

*  Run the tests on device (assumes only one click package in the directory)

    $ adt-run . *.click --- ssh -s adb -- -p <PASSWORD>