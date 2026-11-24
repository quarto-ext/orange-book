# Orange Book Format Extension for Quarto

A Quarto format extension that provides Typst book support using the [orange-book](https://typst.app/universe/package/orange-book) package.

## Installation

Orange-book will be bundled with Quarto 1.9 and will be the default extension for Typst book projects.

However, if you want to explicitly install and use this extension

```bash
quarto add quarto-ext/orange-book
```

## Usage

In your `_quarto.yml`:

```yaml
project:
  type: book

format: orange-book-typst
```

## Cover

The cover of the book takes its main colour from `color.primary` and its logo from `logo.medium` of the brand file.
You can also set three options of the orange-book package with a `cover` map:

```yaml
format:
  orange-book-typst:
    cover:
      background: secondary
      image: cover.png
      alt: A description of the image.
      copyright: Copyright 2026 Jane Smith.
```

- `background` is the name of a colour of the brand file, and it fills the title box.
  The name `none` removes the fill.
  A hex value does not work, because Pandoc escapes the `#`.
- `image` is the path of an image that fills the cover page.
- `alt` is the alternative text of the image.
  With `pdf-standard: ua-1`, an image without `alt` stops the build.
- `copyright` is the text that the package prints at the bottom of the page after the cover.

All four keys are optional.

## Features

- Transforms book parts into `#part[...]` calls for proper orange-book formatting
- Handles appendix sections with `#show: appendices.with(...)`
- Chapter-based numbering for equations, callouts, and cross-references
- Integrates with Quarto's brand system for colors and logos

## Requirements

- Quarto >= 1.9.17
- The `orange-book` Typst package (automatically imported and bundled with [typst-gather](https://prerelease.quarto.org/docs/advanced/typst/typst-gather.html))

## How It Works

This extension:

1. Provides template partials (`typst-show.typ`, `numbering.typ`) that configure the orange-book package
2. Includes a Lua filter (`orange-book.lua`) that transforms Quarto's book structure into orange-book-specific Typst commands
3. Uses Quarto's `file_metadata` API to detect book item types (parts, chapters, appendices)

## License

MIT
