# Markoff [![GitHub release](https://img.shields.io/github/release/kaishin/markoff.svg)]() ![Platform](https://img.shields.io/badge/platform-OS%20X-lightgrey.svg) ![Platform](https://img.shields.io/badge/license-ISC-lightgrey.svg)
A light-weight [CommonMark] previewer for macOS.

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


## Setup

Make sure you have [Carthage] installed, then run in the project root:

~~~shell
carthage update --platform mac
~~~

## License

See LICENSE file.

Markoff was initially maintained and funded by [thoughtbot, inc](https://thoughtbot.com).

[cmark]: https://github.com/jgm/cmark
[CommonMark]: http://commonmark.org
[highlight.js]: https://highlightjs.org
[LICENSE]: https://raw.githubusercontent.com/kaishin/Markoff/master/LICENSE
[Carthage]: https://github.com/Carthage/Carthage
