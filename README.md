# Markoff [![GitHub release](https://img.shields.io/github/release/thoughtbot/markoff.svg)]() ![Platform](https://img.shields.io/badge/platform-OS%20X-lightgrey.svg) ![Platform](https://img.shields.io/badge/license-ISC-lightgrey.svg)
A light-weight [CommonMark] previewer for OSX.

![Screenshot](https://images.thoughtbot.com/markoff/MarkoffScreenshot.jpg)

- Uses `cmark`, a [C implementation][cmark] of [CommonMark], for parsing and
rendering. This is a lot of faster than other existing Ruby and JavaScript
solutions.
- Allows you to select your default editor and open the previewed document in it
by hitting `Cmd+e`, using the menu item, or clicking the toolbar button.
- Uses [highlight.js] for syntax highlighting.
- Detects YAML frontmatter and renders it as a special code block.
- Auto-reloads the preview whenever the original file is saved. Depending on
your editor, you might be able to set up auto-save to get an always up-to-date
preview without manually saving.
- Shows basic information such word and character count.

[![Download on the App Store](appstore.svg)](https://itunes.apple.com/us/app/markoff/id1084713122)

## Setup

Make sure you have Carthage installed, then run in the project root:

~~~shell
carthage update --platform mac
~~~

## License

See LICENSE file.

![thoughtbot](https://thoughtbot.com/logo.png)

Markoff is maintained and funded by thoughtbot, inc.
The names and logos for thoughtbot are trademarks of thoughtbot, inc.

We can help you with OS X development, ReactiveCocoa, Swift, and more. [Get in touch][hire].

[App Store]: https://itunes.apple.com/us/app/markoff/id1084713122
[cmark]: https://github.com/jgm/cmark
[CommonMark]: http://commonmark.org
[community]: https://thoughtbot.com/community?utm_source=github
[highlight.js]: https://highlightjs.org
[hire]: https://thoughtbot.com/hire-us?utm_source=github
[LICENSE]: LICENSE
