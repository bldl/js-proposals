[[Stage 4]]<br>Classification: [[Semantic Change]]<br>Human Validated: KW<br>Title: Well-formed JSON.stringify<br>Authors: Richard Gibson<br>Champions: Mathias Bynens<br>Last Presented: January 2019<br>Stage Upgrades:<br>Stage 1: NA 
Stage 2: 2018-05-23  
Stage 2.7: NA  
Stage 3: 2018-09-26  
Stage 4: 2019-01-29<br>Last Commit: 2019-01-29<br>Topics: #intl #others #objects<br>Keywords: #unicode #string #json <br>GitHub Link: https://github.com/tc39/proposal-well-formed-stringify <br>GitHub Note Link: https://github.com/tc39/notes/blob/HEAD/meetings/2019-01/jan-29.md#well-formed-jsonstringify-for-stage-4
# Proposal Description:
# Well-formed JSON.stringify

A proposal to prevent `JSON.stringify` from returning ill-formed Unicode strings.

## Status
This proposal is at stage 4 of [the TC39 Process](https://tc39.github.io/process-document/).

## Champions
* Mathias Bynens

## Motivation
[RFC 8259 section 8.1](https://tools.ietf.org/html/rfc8259#section-8.1) requires JSON text exchanged outside the scope of a closed ecosystem to be encoded using UTF-8, but [`JSON.stringify`](https://tc39.github.io/ecma262/#sec-json.stringify) can return strings including code points that have no representation in UTF-8 (specifically, surrogate code points U+D800 through U+DFFF).
And contrary to [the description of `JSON.stringify`](https://tc39.github.io/ecma262/#sec-json.stringify), such strings are not "in UTF-16" because "isolated UTF-16 code units in the range D800₁₆..DFFF₁₆ are ill-formed" per [The Unicode Standard, Version 10.0.0, Section 3.4](https://unicode.org/versions/Unicode10.0.0/ch03.pdf#G7404) at definition D91 and excluded from being "in UTF-16" per definition D89.

However, returning such invalid Unicode strings is unnecessary, because JSON strings can include Unicode escape sequences.

## Proposed Solution
Rather than return unpaired surrogate code points as single UTF-16 code units, represent them with JSON escape sequences.

## Illustrative examples
```js
// Non-BMP characters still serialize to surrogate pairs.
JSON.stringify('𝌆')
// → '"𝌆"'
JSON.stringify('\uD834\uDF06')
// → '"𝌆"'

// Unpaired surrogate code units will serialize to escape sequences.
JSON.stringify('\uDF06\uD834')
// → '"\\udf06\\ud834"'
JSON.stringify('\uDEAD')
// → '"\\udead"'
```

## Discussion
### Backwards Compatibility
This change is backwards-compatible, under an assumption of consumer compliance with the JSON specification.
User-visible effects will be limited to the replacement of some rare single UTF-16 code units in `JSON.stringify` output with equivalent six-character escape sequences that can be represented both in UTF-16 and in UTF-8.
It is the authors' opinion that any consumer accepting the current ill-formed output will be unaffected by this change (this is true in particular of ECMAScript `JSON.parse`).
Any consumer rejecting the current ill-formed output will have a new opportunity to accept its well-formed representation, although such consumers may still reject input that specifies strings including Unicode code points that are not scalar values (e.g., because they only accept [I-JSON](https://tools.ietf.org/html/rfc7493) input), but those that accept it must have mechanisms for dealing with unpaired surrogates (as mentioned in the specification of JSON).

### Validity
Unicode escape sequences are valid JSON, and—being completely ASCII—are well-formed in both UTF-16 and UTF-8.

## Specification
The specification is available in [ecmarkup](spec.emu) or [rendered HTML](https://tc39.github.io/proposal-well-formed-stringify/).

## Implementations
* [V8](https://bugs.chromium.org/p/v8/issues/detail?id=7782), enabled by default in V8 v7.2.10 and Chrome 72
* [SpiderMonkey](https://bugzilla.mozilla.org/show_bug.cgi?id=1469021), shipping in Firefox 64
* [JavaScriptCore](https://bugs.webkit.org/show_bug.cgi?id=191677), shipping in [Safari Technology Preview 73](https://webkit.org/blog/8555/release-notes-for-safari-technology-preview-73/)
<br>