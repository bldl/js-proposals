#Stage1Tag
Classification: #API_Change
Human Validated: No
Title: Standardized Debug
Authors: Gus Caplan
Champions: Gus Caplan
Date: November 2020
GitHub Link: https://github.com/tc39/proposal-standardized-debug
GitHub Note Link: https://github.com/tc39/notes/blob/HEAD/meetings/2020-11/nov-17.md#standardized-debug-for-stage-2

# Proposal Description:
# Standardized Debug

This proposal is at Stage 1 of the [TC39 Process](https://tc39.es/process-document/).

## Motivation

Different environments expose different APIs for interacting with debugger
facilities. Some of them do not expose any APIs for this at all. This proposal
aims to provide standardized debugging facilities across all ECMAScript
implementations. Additionally, the APIs are constrained to be identity
functions - that is, they return the value which is passed to them.

This proposal suggests adding the following meta-property-functions to ES:

- `debugger.log ( v )`
- `debugger.break ( [ v ] )`

Note that, like `import()`, they are only valid in call expression form. For
example, `x().then(debugger.break)` would be invalid. You would have to do
`x().then((v) => debugger.break(v))`. This limitation is in place to ensure
these methods (particularly `break`) are only ever invoked from ECMAScript code.
