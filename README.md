# Markoff 2 ![Platform](https://img.shields.io/badge/platform-macOS%2011-lightgrey.svg) ![Platform](https://img.shields.io/badge/license-ISC-lightgrey.svg)

A lightweight [CommonMark] previewer for macOS Big Sur and later.


- Uses `cmark`, a [C implementation][cmark] of [CommonMark], for parsing and
rendering. This is a lot of faster than other existing Ruby and JavaScript
solutions.
- Uses the [Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture)
- Uses the new SwiftUI life cycle for document-based apps.
- Auto-reloads the preview whenever the original file is saved. Depending on
your editor, you might be able to set up auto-save to get an always up-to-date
preview without manually saving.
- Shows basic metadata such word and character count.

### Left to Do

- [ ] Code syntax highlighting.
- [ ] Select default editor.
- [ ] Add printing support.
- [ ] Add addtional CSS styles.

## Setup

1. Open the project in Xcode
2. There is no step 2.

If you use another text editor, follow your usual SPM workflow.

## License

See LICENSE file.

Markoff was initially maintained and funded by [thoughtbot, inc](https://thoughtbot.com).

[cmark]: https://github.com/SwiftDocOrg/CommonMark
[CommonMark]: http://commonmark.org
[LICENSE]: https://raw.githubusercontent.com/kaishin/Markoff/master/LICENSE
