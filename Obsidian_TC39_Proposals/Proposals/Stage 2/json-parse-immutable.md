[[Stage 2]]
Classification: [[API Change]]
Human Validated: No
Title: JSON.parseImmutable
Authors: Robin Ricard, Richard Button, Nicolò Ribaudo, Ashley Claymore
Champions: Robin Ricard, Richard Button, Nicolò Ribaudo, Ashley Claymore
Last Presented: July 2022
Stage Upgrades: 
Stage 1: 2022-07-28  
Stage 2: NA  
Stage 2.7: NA  
Stage 3: NA  
Stage 4: NA  
Last Commit: 2022-07-28
Keywords: #immutable #data_structure #json #records #tuples #ergo #creation #efficient #deeply #return
GitHub Link: https://github.com/tc39/proposal-json-parseimmutable
GitHub Note Link: None

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

This proposal complements the [Records and Tuples Proposal][rec-tup-proposal].
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
