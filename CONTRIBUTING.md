# Contributing

:+1::tada: Thank you for considering a contribution to UBports! :tada::+1:

The following is a set of guidelines for contributing to the UBports Core Apps project. This document covers:

* Important concepts on the Ubuntu Touch platforms
* The contribution process
* Styleguides and conventions

If you haven't already, get in touch with us on [our channels](/SUPPORT.md). We're on Telegram, IRC, Matrix, and we run a forum as well.

By joining our community activities, you agree to abide by our [CODE_OF_CONDUCT.md](/CODE_OF_CONDUCT.md).


## Table of Contents

* [What should I know before I get started?](#what-should-i-know-before-i-get-started)

    * [Qt 5 and QtQuick 2](#qt-5-and-qtquick-2)
    * [Click packages](#click-packages)
    * [Security and Confinement limitations](#security-and-confinement-limitations)

* [How Can I Contribute?](#how-can-i-contribute)

    * [Bugs and Enhancement suggestions](#bugs-and-enhancement-suggestions)
    * [Your first code contribution](#your-first-code-contribution)
    * [Pull Requests](#pull-requests)
    * [Design UI and UX](#design-ui-and-ux)
    * [Translations](#translations)
    * [Testing and Quality assurance](#testing-and-quality-assurance)
    * [Talk about your work](#talk-about-your-work)

* [Styleguides](#styleguides)

    * [Git commit messages](#git-commit-messages)
    * [Coding conventions](#coding-conventions)

* [Additional Notes](#additional-notes)

    * [Issue and Pull Request Labels](#issue-and-pull-request-labels)
    * [Credits](#credits)


## What should I know before I get started?

### Qt 5 and QtQuick 2

All the front-end software used in Ubuntu Touch uses Qt and QtQuick frameworks. QtQuick allows us to leverage OpenGL performances while designing a responsive and adaptive GUI. Therefore a large part of the Ubuntu Touch software is written in C++, QML (Qt Modeling Language), and JavaScript.

At the top of that, we support the Ubuntu UI Toolkit library, an extension to QML that enables more powerful responsive features. It also enables our set of applications to seamlessly scale across multiple form factors - from smartphones to desktops.

As part of our work on Ubuntu Touch 16.04, we're also planning to migrate our apps to QtQuick Controls 2, which provides better performances.

- [UBports QML Docs](https://api-docs.ubports.com/sdk/apps/qml/index.html)

### Click packages

Ubuntu Touch does not use Debian packages for distributing third party apps. Canonical &mdash; the then project maintainer &mdash; decided to create a new packaging format, called "Click".

By using Click, it's possible to run processes inside a sandbox (using AppArmor features) and simplify the app deployment.

In order to build and create those packages, we use a tool created by one of our community members, Brian Douglass. That tool is called 'Clickable'.

By using Clickable, we can create .click packages nearly on any GNU/Linux distribution, and take advantage of Docker containers.
It also allow us to run Ubuntu Touch apps on the current desktop, without compromising the stability of the host system.

Make sure to read Clickable documentation and know its basics.

- [Click packaging format docs](https://click.readthedocs.io/en/latest/)
- [Clickable docs](http://clickable.bhdouglass.com/en/latest/)

### Security and Confinement limitations

All the apps on Ubuntu Touch are restricted on what they can do on an actual device. This is **by design**.

Even if the official suite of core apps could make exceptions &mdash; it's been developed by a trusted collective of developers &mdash; we do want to enforce good practises.

Exceptions are therefore applied only when **strictly** necessary, which means that all the possible and reasonable solutions has been already tested.

To new contributors, we ask to get familiar with the concepts around the app confinement.

- [Application Confinement on _Ubuntu Wiki_](https://wiki.ubuntu.com/SecurityTeam/Specifications/ApplicationConfinement)
- [Content Management & Exchange](https://api-docs.ubports.com/sdk/apps/qml/Ubuntu.Content/Ubuntu%20Content%20API.html)

## How Can I Contribute?

### Bugs and Enhancement suggestions

We use the [GitHub issues](https://github.com/ubports/terminal-app/issues) to track all our bugs and feature requests.

When [submitting a new issue](https://github.com/ubports/terminal-app/issues/new), please check that it hasn't already been raised by someone else.

We provide a template for new issues which will help you structure your issue. This way we make sure it can be picked up and actioned easily.

Provide as much information possible, and explain what you're currently experiencing, and what you'd expect to experience. 

Further information about bug reporting are available on the [UBports Docs](https://docs.ubports.com/en/latest/contribute/bugreporting.html) website.

### Your first code contribution

Unsure where to begin contributing? You can start by looking through these `good-first-issue` and `help-wanted` issues:

* [Good first issues][good-first] - issues which should only require a few lines of code, and a test or two.
* [Help wanted issues][help-wanted] - issues which should be a bit more involved than `good first` issues.

Both issue lists are sorted by total number of comments. While not perfect, number of comments is a reasonable proxy for impact a given change will have.

Get in touch with us on [our channels](/SUPPORT.md), if you need further support.

[good-first]: https://github.com/ubports/terminal-app/issues?q=label%3A%22good+first+issue%22+is%3Aissue+is%3Aopen
[help-wanted]: https://github.com/ubports/terminal-app/issues?q=label%3A%22help+wanted%22+is%3Aissue+is%3Aopen

### Pull requests

To work on an issue, fork this repo and create a new branch on your local fork. When you're happy and would like to propose that changeset to be merged back upstream, open a pull request to merge from your local `origin/master` to  `upstream/develop`.

When committing changes, make sure to group related changes so that the project is always in a working state.

Read also [Git commit messages](#git-commit-messages) from this document.

### Design UI and UX

Good software doesn't just work, but it's also accessible, beautiful, and usable.

Here's where we need your help!
If you are an artist or a designer, feel free to open a report on our GitHub Issues trackers, open a discussion in the [Design section](https://forums.ubports.com/category/40/design) of our forum, or contact us using one of our [channels](/SUPPORT.md).

We want to create a community of designers that helps with the creation of great apps.

If you think we could offer a better support for people who'd like to start designing for Ubuntu Touch, please [fill an issue](https://github.com/ubports/ubuntu-touch/issues) on our global tracker.

### Translations

We use our [UBports Weblate](https://translate.ubports.com/) instance as unified interface for the localization of all our projects. Go to the [terminal-app page](https://translate.ubports.com/projects/ubports/terminal-app/), and pick your language.
It's really that easy!

More information are available on the [UBports Documentation](https://docs.ubports.com/en/latest/contribute/translations.html) website.

### Testing and Quality assurance

We appreciate any help that can level up the quality of our set of applications or tools, so... welcome on board!

Read [our docs](https://docs.ubports.com/en/latest/contribute/quality-assurance.html) for further information and get in touch with us!

### Talk about your work

It's always nice to show off your progress and get input from the wider community.

Posting screenshots or, better still, screencasts will let non-developers and future users see what is being done. Raising excitement around your contributions is also a great way to get more people involved in making them.

If you have a personal blog, you can use it to chronicle your Core Apps contributions, solicit feedback and comments, and generally make people aware of what you are doing.

You are also encouraged to use the channels we mentioned above, to talk about major features or milestones, ask for design input, or to seek advice on how best to implement something.

Not only will you be able to receive help, but you will also show how active the development is.

## Styleguides

### Git commit messages

We are trying to use a more rigorous convention for Git commit messages, in order to make it easier to generate changelog for projects.

```
#<IssueId> Capitalized, short (50 chars or less) summary

More detailed explanatory text, if necessary.  Wrap it to about 72
characters or so.  In some contexts, the first line is treated as the
subject of an email and the rest of the text as the body.  The blank
line separating the summary from the body is critical (unless you omit
the body entirely); tools like rebase can get confused if you run the
two together.

Write your commit message in the imperative: "Fix bug" and not "Fixed bug"
 or "Fixes bug."  This convention matches up with commit messages generated
by commands like git merge and git revert.

Further paragraphs come after blank lines.

- Bullet points are okay, too

- Typically a hyphen or asterisk is used for the bullet, followed by a single space, with blank lines in between, but conventions vary here

- Use a hanging indent
 
Closes #234, #245, #999
```

### Coding conventions

We are trying to use a common code style throughout the code base to maintain uniformity and improve code clarity.
Listed below are the code styles guides that will be followed based on the language used.

 - [QML Coding Convertions](http://doc.qt.io/qt-5/qml-codingconventions.html)
 - [JS & C++ Conventions](https://google.github.io/styleguide/cppguide.html)
 - Python &mdash; Code should follow [PEP8](https://www.python.org/dev/peps/pep-0008/) and Flake regulations

__Note:__ In the QML code convention, ignore the Javascript code section guidelines.
So the sections that should be taken into account in the QML conventions are QML Object Declarations, Grouped Properties and Lists.

## Additional Notes

### Issue and Pull Request labels

This section describes the standard labels used when dealing with new issues in UBports projects. Most labels are used across all UBports repositories, but some are specific to the `ubports/*-app` projects.

[GitHub search](https://help.github.com/articles/searching-issues/) makes it easy to use labels for finding groups of issues or pull requests you're interested in.
The labels are loosely grouped by their purpose, but it's not required that every issue have a label from every group or that an issue can't have more than one label from the same group.

Feel free to open an issue on `ubports/ubuntu-touch` if you have suggestions for new labels, and if you notice some labels are missing on some repositories, then please open an issue on that repository.

#### Type of Issue and Issue state

The project follows the general conventions as defined in the [UBports official documentation](https://docs.ubports.com/en/latest/about/process/issue-tracking.html).
The only exceptions are represented by `blocked` and `stale` label.

| Label name           | :mag_right: this repository              | :mag_right: `ubports` org               | Description                                                                                                                              |
| -------------------- | ---------------------------------------- | --------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| `needs confirmation` | [search][search-repo-needs-confirmation] | [search][search-org-needs-confirmation] | The bug needs confirmation and/or further information from affected users.                                                               |
| `bug`                | [search][search-repo-bug]                | [search][search-org-bug]                | This issue is a confirmed bug. If it’s reproducable, reproduction steps are described.                                                   |
| `opinion`            | [search][search-repo-opinion]            | [search][search-org-opinion]            | This issue needs further discussion.                                                                                                     |
| `enhancement`        | [search][search-repo-enhancement]        | [search][search-org-enhancement]        | This issue is a feature request.                                                                                                         |
| `question`           | [search][search-repo-question]           | [search][search-org-question]           | This issue is a support request or general question. We would appreciate help from the community in resolving these issues.              |
| `invalid`            | [search][search-repo-invalid]            | [search][search-org-invalid]            | This issue can not be confirmed or was reported in the wrong tracker.                                                                    |
| `duplicate`          | [search][search-repo-duplicate]          | [search][search-org-duplicate]          | This has already been reported somewhere else. We usually provide a link to the original discussion and close.                           |
| `help-wanted`        | [search][search-repo-help-wanted]        | [search][search-org-help-wanted]        | This issue is ready to be picked up by a community developer.                                                                            |
| `good-first-issue`   | [search][search-repo-good-first-issue]   | [search][search-org-good-first-issue]   | This issue is not critical and trivial to fix. It is reserved for new contributors as a place to start.                                  |
| `wontfix`            | [search][search-repo-wontfix]            | [search][search-org-wontfix]            | This issue will not be fixed for now, either because they're working as intended or for some other reason.                               |
| `blocked`            | [search][search-repo-blocked]            | -                                       | This issue depends on another issues and can not be solved right now.                                                                    |
| `stale`              | [search][search-repo-stale]              | -                                       | This issue has been opened without any activity for more than three months. To keep a reasonably-sized backlog, it will be closed within seven days. |

#### Topic categories  

  The following labels are only applied across the UBports Core Apps suite, and reflect the specific needs of the UBports front end projects.

| Label name      | :mag_right: this repository         | Description                           |
| --------------- | ----------------------------------- | ------------------------------------- |
| `documentation` | [search][search-repo-documentation] | Related to any type of documentation. |
| `performance`   | [search][search-repo-performance]   | Related to performance.               |
| `security`      | [search][search-repo-security]      | Related to security.                  |
| `ui`            | [search][search-repo-ui]            | Related to visual design.             |
| `crash`         | [search][search-repo-crash]         | Reports of app completely crashing.   |

#### Pull Request labels

  The following labels are only applied across the UBports Core Apps suite, and reflect the specific needs of the UBports front end projects.

| Label name         | :mag_right: this repository            | Description                                                                              |
| ------------------ | -------------------------------------- | ---------------------------------------------------------------------------------------- |
| `work-in-progress` | [search][search-repo-wip]              | Pull requests which are still being worked on, more changes will follow.                 |
| `needs-review`     | [search][search-repo-needs-review]     | Pull requests which need code review, and approval from maintainers or core team.        |
| `under-review`     | [search][search-repo-under-review]     | Pull requests being reviewed by maintainers or core team.                                |
| `requires-changes` | [search][search-repo-requires-changes] | Pull requests which need to be updated based on review comments and then reviewed again. |
| `needs-testing`    | [search][search-repo-needs-testing]    | Pull requests which need manual testing.                                                 |

[search-repo-needs-confirmation]: https://github.com/ubports/terminal-app/issues?q=is%3Aopen+is%3Aissue+label%3Aneeds+confirmation
[search-org-needs-confirmation]: https://github.com/search?utf8=✓&type=Issues&q=org%3Aubports+label%3A"needs+confirmation"

[search-repo-bug]: https://github.com/ubports/terminal-app/issues?q=is%3Aopen+is%3Aissue+label%3Abug
[search-org-bug]: https://github.com/search?utf8=✓&type=Issues&q=org%3Aubports+label%3A"bug"

[search-repo-opinion]: https://github.com/ubports/terminal-app/issues?q=is%3Aopen+is%3Aissue+label%3Aopinion
[search-org-opinion]: https://github.com/search?utf8=✓&type=Issues&q=org%3Aubports+label%3A"opinion"

[search-repo-enhancement]: https://github.com/ubports/terminal-app/issues?q=is%3Aopen+is%3Aissue+label%3Aenhancement
[search-org-enhancement]: https://github.com/search?utf8=✓&type=Issues&q=org%3Aubports+label%3A"enhancement"

[search-repo-question]: https://github.com/ubports/terminal-app/issues?q=is%3Aopen+is%3Aissue+label%3Aquestion
[search-org-question]: https://github.com/search?utf8=✓&type=Issues&q=org%3Aubports+label%3A"question"

[search-repo-invalid]: https://github.com/ubports/terminal-app/issues?q=is%3Aopen+is%3Aissue+label%3Ainvalid
[search-org-invalid]: https://github.com/search?utf8=✓&type=Issues&q=org%3Aubports+label%3A"invalid"

[search-repo-duplicate]: https://github.com/ubports/terminal-app/issues?q=is%3Aopen+is%3Aissue+label%3Aduplicate
[search-org-duplicate]: https://github.com/search?utf8=✓&type=Issues&q=org%3Aubports+label%3A"duplicate"

[search-repo-help-wanted]: https://github.com/ubports/terminal-app/issues?q=is%3Aopen+is%3Aissue+label%3Ahelp+wanted
[search-org-help-wanted]: https://github.com/search?utf8=✓&type=Issues&q=org%3Aubports+label%3A"help+wanted"

[search-repo-good-first-issue]: https://github.com/ubports/terminal-app/issues?q=is%3Aopen+is%3Aissue+label%3Agood+first+issue
[search-org-good-first-issue]: https://github.com/search?utf8=✓&type=Issues&q=org%3Aubports+label%3A"good+first+issue"

[search-repo-wontfix]: https://github.com/ubports/terminal-app/issues?q=is%3Aopen+is%3Aissue+label%3Awontfix
[search-org-wontfix]: https://github.com/search?utf8=✓&type=Issues&q=org%3Aubports+label%3A"wontfix"

[search-repo-blocked]: https://github.com/ubports/terminal-app/issues?q=is%3Aopen+is%3Aissue+label%3Ablocked

[search-repo-stale]: https://github.com/ubports/terminal-app/issues?q=is%3Aopen+is%3Aissue+label%3Astale



[search-repo-documentation]: https://github.com/ubports/terminal-app/issues?q=is%3Aopen+is%3Aissue+label%3Adocumentation
[search-repo-performance]: https://github.com/ubports/terminal-app/issues?q=is%3Aopen+is%3Aissue+label%3Aperformance
[search-repo-security]: https://github.com/ubports/terminal-app/issues?q=is%3Aopen+is%3Aissue+label%3Asecurity
[search-repo-ui]: https://github.com/ubports/terminal-app/issues?q=is%3Aopen+is%3Aissue+label%3Aui
[search-repo-crash]: https://github.com/ubports/terminal-app/issues?q=is%3Aopen+is%3Aissue+label%3Acrash

[search-repo-wip]: https://github.com/ubports/terminal-app/pulls?utf8=✓&q=is%3Apr+is%3Aopen+label%3Awork-in-progress
[search-repo-needs-review]: https://github.com/ubports/terminal-app/pulls?utf8=✓&q=is%3Apr+is%3Aopen+label%3Aneeds-review
[search-repo-under-review]: https://github.com/ubports/terminal-app/pulls?utf8=✓&q=is%3Apr+is%3Aopen+label%3Aunder-review
[search-repo-requires-changes]: https://github.com/ubports/terminal-app/pulls?utf8=✓&q=is%3Apr+is%3Aopen+label%3Arequires-changes
[search-repo-needs-testing]: https://github.com/ubports/terminal-app/pulls?utf8=✓&q=is%3Apr+is%3Aopen+label%3Aneeds-testing

### Credits

 - This document has been modelled after the `atom/atom` counterpart.
   All the credits goes to them for their very inspiring dedication.
 - [How To Write A Proper Git Commit Message on _Medium_](https://medium.com/@steveamaza/how-to-write-a-proper-git-commit-message-e028865e5791)
