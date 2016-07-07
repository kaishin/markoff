# Markoff fork with MathJax support

A light-weight [CommonMark] previewer for OSX with [MathJax](https://www.mathjax.org/) support to render beautiful math expressions.

![Screenshot](https://cloud.githubusercontent.com/assets/19753339/16591942/9975df9e-42de-11e6-8709-b9f3e68b5e94.png)

* Uses `cmark`, a [C implementation][cmark] of [CommonMark], for parsing and rendering. This is a lot of faster than other existing Ruby and JavaScript solutions.
* Uses [MathJax](https://www.mathjax.org/) to render beautiful math expressions.
* Allows you to select your default editor and open the previewed document in it by hitting `Cmd+e`, using the menu item, or clicking the toolbar button.
* Uses [highlight.js] for syntax highlighting.
* Detects YAML frontmatter and renders it as a special code block.
* Auto-reloads the preview whenever the original file is saved. Depending on your editor, you might be able to set up auto-save to get an always up-to-date preview without manually saving.
* Shows basic information such word and character count.

## Setup

Make sure you have [Carthage] installed, then run in the project root:

```shell
carthage update --platform mac
```

## License

See LICENSE file.

* Markoff is maintained and funded by thoughtbot, inc.
* This fork is maintained by me.

[cmark]: https://github.com/jgm/cmark
[CommonMark]: http://commonmark.org
[community]: https://thoughtbot.com/community?utm_source=github
[highlight.js]: https://highlightjs.org
[LICENSE]: https://raw.githubusercontent.com/thoughtbot/Markoff/master/LICENSE
[Carthage]: https://github.com/Carthage/Carthage
