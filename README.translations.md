# Updating translations

Translations for the Terminal app happen in [Weblate](https://translate.ubports.com/projects/ubports/terminal-app/)
and are automatically committed weekly (saturday night) on the master branch in
the po/ folder.

They are then built and installed as part of the package build.
New translatable messages are being added to the pot file by
CMake (e.g. by running clickable) and added automatically to Weblate. So
developers don't really need to worry about translations.

However, there is one task that needs to be taken care of: exposing new
translatable messages to translators. So whenever you add new translatable
messages in the code, make sure to follow these steps:

 1. Run click-buddy retaining the build directory:
    `click-buddy --dir . --no-clean`
 2. Commit and push the branch and send a merge proposal as usual

And that's it, once the branch lands Launchpad should take care of all the rest!

# Behind the scenes

Behind the scenes, whenever the \*.pot file (also known as translations template) is committed to the master branch Weblate reads it and updates the translatable strings exposed in the web UI. This will enable translators to work on the new strings.
The translations template contains all translatable strings that have been extracted from the source code files.

Weblate will then commit translations on github weekly (saturday night)
in the form of textual \*.po files to the master branch. The PO files are also usually referred to as the translations files. You'll find a translation file for each language the app has been translated to.

Translations for core apps follow the standard [gettext format](https://www.gnu.org/software/gettext/).

* [Weblate](https://translate.ubports.com/projects/ubports/terminal-app/)
* [Gettext format](https://www.gnu.org/software/gettext/)
