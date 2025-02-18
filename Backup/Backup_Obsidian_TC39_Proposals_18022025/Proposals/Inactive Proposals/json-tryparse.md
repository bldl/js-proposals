#InactiveTag
Classification: [[API Change]]
Human Validated: KW
Title: JSON.tryParse
Champions: Jack Works
Reason for Withdrawal: Rejected; some deemed this too specific a solution for a generalized language-wide problem
Date: None
Last Commit: None
GitHub Link: https://github.com/Jack-Works/proposal-json-tryParse
GitHub Note Link: None

# Proposal Description:

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