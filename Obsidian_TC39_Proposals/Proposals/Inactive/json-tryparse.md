[[Inactive]]<br>Classification: [[API Change]]<br>Human Validated: KW<br>Title: JSON.tryParse<br>Authors: Jack Works<br>Rejected; some deemed this too specific a solution for a generalized language-wide problem<br>Last Presented: None<br>Stage Upgrades:<br>Stage 1: NA
Stage 2: NA  
Stage 2.7: NA  
Stage 3: NA  
Stage 4: NA<br>Last Commit: 2024-04-23<br>Keywords: #json_parsing #error_handling #json_tryparse #graceful_fallback #parse_safety #javascript_utilities #json_validation #exception_suppression #ecmascript_proposals #runtime_resilience<br>GitHub Link: https://github.com/Jack-Works/proposal-json-tryParse <br>GitHub Note Link: https://github.com/tc39/notes/blob/main/meetings/2023-11/november-29.md#jsontryparse
# Proposal Description:<br>
# JSON.tryParse

Rejected by [tc39 on Nov 2023](https://github.com/tc39/notes/blob/main/meetings/2023-11/november-29.md#jsontryparse).

## Problem to solve

```js
try { return JSON.parse(str) } catch { return undefined }
```

## Prior art

[URL.canParse](https://developer.mozilla.org/en-US/docs/Web/API/URL/canParse_static)

## Spec

```markdown
JSON.parse ( _text_ [ , _reviver_ ] )

1. Let _result_ be Completion(Call(%JSON.parse%, *null*, << _text_, _reviver_ >> )).
2. If _result_ is an abrupt completion, return *undefined*.
3. Return _result_.
```