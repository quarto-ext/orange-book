#import "@local/orange-book:0.7.1": book, part, chapter, appendices

#show: book.with(
$if(title)$
  title: [$title$],
$endif$
$if(subtitle)$
  subtitle: [$subtitle$],
$endif$
$if(by-author)$
  author: "$for(by-author)$$it.name.literal$$sep$, $endfor$",
$endif$
$if(date)$
  date: "$date$",
$endif$
$if(lang)$
  lang: "$lang$",
$endif$
  main-color: brand-color.at("primary", default: blue),
  logo: {
    let logo-info = brand-logo.at("medium", default: none)
    if logo-info != none { image(logo-info.path, alt: logo-info.at("alt", default: none)) }
  },
$if(toc-depth)$
  outline-depth: $toc-depth$,
$endif$
$if(lof)$
  list-of-figure-title: "$if(crossref.lof-title)$$crossref.lof-title$$else$$crossref-lof-title$$endif$",
$endif$
$if(lot)$
  list-of-table-title: "$if(crossref.lot-title)$$crossref.lot-title$$else$$crossref-lot-title$$endif$",
$endif$
)

$if(margin-geometry)$

// Override heading styling on verso (even) pages only.
// Orange-book uses place(dx: -width - gap) for heading numbers, which works on recto
// pages but on verso pages the offset goes into the outer margin (where marginalia lives).
#show heading: it => {
  if it.level == 1 { it } else {
    context {
      let is-recto = calc.odd(here().page())
      if is-recto { it } else {
        // Verso page: use inline numbering instead of placed offset
        let size = if it.level == 2 { 1.5em } else if it.level == 3 { 1.1em } else { 1em }
        let color = if it.level < 4 { brand-color.at("primary", default: blue) } else { black }
        let space = if it.level == 2 { 1em } else if it.level == 3 { 0.9em } else { 0.7em }

        set text(size: size)
        let num = if it.numbering != none {
          text(fill: color)[#counter(heading).display(it.numbering)]
        }
        block(num + [ ] + it.body)
        v(space, weak: true)
      }
    }
  }
}

// Configure marginalia page geometry for book context
// Geometry computed by Quarto's meta.lua filter (typstGeometryFromPaperWidth)
// IMPORTANT: This must come AFTER book.with() to override the book format's margin settings
#import "@preview/marginalia:0.3.1" as marginalia

#show: marginalia.setup.with(
  inner: (
    far: $margin-geometry.inner.far$,
    width: $margin-geometry.inner.width$,
    sep: $margin-geometry.inner.separation$,
  ),
  outer: (
    far: $margin-geometry.outer.far$,
    width: $margin-geometry.outer.width$,
    sep: $margin-geometry.outer.separation$,
  ),
  top: $if(margin.top)$$margin.top$$else$1.25in$endif$,
  bottom: $if(margin.bottom)$$margin.bottom$$else$1.25in$endif$,
  // CRITICAL: Enable book mode for recto/verso awareness
  book: true,
  clearance: $margin-geometry.clearance$,
)
$endif$
