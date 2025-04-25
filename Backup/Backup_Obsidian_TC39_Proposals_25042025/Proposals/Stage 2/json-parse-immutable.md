[[Stage 2]]<br>Classification: [[Syntactic Change]] [[Semantic Change]]<br>Human Validated: KW<br>Title: JSON.parseImmutable<br>Authors: Robin Ricard, Richard Button, Nicolò Ribaudo, Ashley Claymore<br>Champions: Robin Ricard, Richard Button, Nicolò Ribaudo, Ashley Claymore<br>Last Presented: July 2022<br>Stage Upgrades:<br>Stage 1: NA  
Stage 2: 2022-07-28  
Stage 2.7: NA  
Stage 3: NA  
Stage 4: NA<br>Last Commit: 2022-07-28<br>Keywords: #json #parse #performance #tuple #record<br>GitHub Link: https://github.com/tc39/proposal-json-parseimmutable <br>GitHub Note Link: https://github.com/tc39/notes/blob/main/meetings/2022-07/jul-19.md#conclusiondecision-2
# Proposal Description:
# JSON.parseImmutable Proposal

## Status

Stage 2

**Champions:**

- Robin Ricard (Bloomberg)
- Rick Button (Bloomberg)
- Nicolò Ribaudo (Igalia)
- Ashley Claymore (Bloomberg)

## Overview

This proposal complements the [[record-tuple]] proposal.
It was originally part of that proposal but split off into a separate proposal to reduce the scope of the core Records and Tuples proposal. [#330](https://github.com/tc39/proposal-record-tuple/issues/330)

The problem being explored is ergonomic and efficient creation of a deeply immutable data structure from a [JSON][json-mdn] string.

```javascript
JSON.parse(data, (key, value) => {
  if (typeof value === 'object' && value !== null) {
      if (Array.isArray(value)) {
        return Tuple.from(value);
      } else {
        return Record(value);
      }
  }
  return value;
});
```

Could be replaced with:

```javascript
JSON.parseImmutable(data);
```

<!-- References -->
[rec-tup-proposal]: https://github.com/tc39/proposal-record-tuple
[json-mdn]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/JSON
<br>