# Markoff 2 ![Platform](https://img.shields.io/badge/platform-macOS%2011-lightgrey.svg) ![Platform](https://img.shields.io/badge/license-ISC-lightgrey.svg)

A lightweight CommonMark previewer for macOS Big Sur and later.


- Uses [SwiftDoc](https://github.com/SwiftDocOrg)'s [CommonMark](https://github.com/SwiftDocOrg/CommonMark) implementation for transforming the markdown into HTML.
- Uses the [Composable Architecture](https://github.com/pointfreeco/swift-composable-architecture).
- Uses the new SwiftUI lifecycle for document-based apps.
- Auto-reloads the preview whenever the original file is saved. Depending on
your editor, you might be able to set up auto-save to get an always up-to-date
preview without manually saving.
- Shows basic metadata such word and character count.

### Left to Do for 2.0

- [ ] Code syntax highlighting.
- [ ] Select default editor.
- [ ] Add printing support.
- [ ] Add addtional CSS styles.

## Setup

1. Open the project in Xcode 12 or later.
2. There is no step 2.

If you use another text editor, follow your usual SPM workflow.

## Previous Versions

The previous versions of the app are in the `markoff-1` and `markoff-2` branches.

- The `markoff-1` branch is deprecated.
- The `markoff-2` branch is compatible with Catalina, and will get some minor patches in the future. 

All future development will take place in the `main` branch.

## License

See LICENSE file.

## Author

[Reda Lemeden](https://redalemeden.com)

[LICENSE]: https://raw.githubusercontent.com/kaishin/Markoff/master/LICENSE
