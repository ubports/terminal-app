Prerequisites to approving a Pull Request (PR)
==============================================

Over time, it has been found that insufficient testing by reviewers sometimes leads to terminal trunk not buildable in Qtcreator due to manifest errors, or translation pot file not updated. As such, please follow the checklist below before top-approving a PR.

Checklist
=========

*   Does the PR add/remove user visible strings? If Yes, has the pot file been
    updated?

*   Does the PR change the UI? If Yes, has it been approved by design?

*   Did you perform an exploratory manual test run of your code change and any
    related functionality?

*   Did you perform an exploratory manual test run of your code change and any
    related functionality?

*   Is the terminal trunk buildable and runnable using Qtcreator/clickable?

*   Was the copyright years updated if necessary?

The above checklist is more of a guideline to help terminal app stay buildable,
stable and up to date.
