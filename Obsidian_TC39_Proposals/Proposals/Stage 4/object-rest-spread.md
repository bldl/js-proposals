[[Stage 4]]<br>Classification: [[Syntactic Change]] [[Semantic Change]]<br>Human Validated: KW<br>Title: Rest/Spread Properties<br>Authors: Sebastian Markbåge<br>Champions: Sebastian Markbåge<br>Last Presented: January 2018<br>Stage Upgrades:<br>Stage 1: 2014-10-29  
Stage 2: 2015-08-25  
Stage 2.7: NA  
Stage 3: 2016-09-29  
Stage 4: 2018-02-13<br>Last Commit: 2022-01-24<br>Keywords: #rest_properties #spread_properties #object_destructuring #object_literals #enumerable #property_keys #transpilers #object_initializers #property_values #copy<br>GitHub Link: https://github.com/tc39/proposal-object-rest-spread <br>GitHub Note Link: https://github.com/tc39/notes/blob/HEAD/meetings/2018-01/jan-23.md#restspread-properties-for-stage-4
# Proposal Description:
Object Rest/Spread Properties for ECMAScript
--------------------------------------------

ECMAScript 6 introduces [rest elements](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment) for array destructuring assignment and [spread elements](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Spread_operator) for array literals.

This proposal introduces analogous [rest properties](Rest.md) for object destructuring assignment and [spread properties](Spread.md) for object literals.

### [Specification](https://tc39.github.io/proposal-object-rest-spread/)

[Specification](https://tc39.github.io/proposal-object-rest-spread/)

### [Rest Properties](Rest.md)

Rest properties collect the remaining own enumerable property keys that are not already picked off by the destructuring pattern. Those keys and their values are copied onto a new object.

```javascript
let { x, y, ...z } = { x: 1, y: 2, a: 3, b: 4 };
x; // 1
y; // 2
z; // { a: 3, b: 4 }
```

### [Spread Properties](Spread.md)

Spread properties in object initializers copies own enumerable properties from a provided object onto the newly created object.

```javascript
let n = { x, y, ...z };
n; // { x: 1, y: 2, a: 3, b: 4 }
```

### Transpilers

[Babel](https://babeljs.io/docs/plugins/transform-object-rest-spread/)

[Bublé](https://github.com/Rich-Harris/buble/)

[JSTransform](https://github.com/facebook/jstransform)

[TypeScript](https://github.com/Microsoft/TypeScript)

## [Status of this Proposal](https://github.com/tc39/ecma262)

It is a Stage 4 proposal for ECMAScript.

## [Known Issues](Issues.md)

This proposal only iterates over __own__ properties. [See why this matters.](Issues.md)
<br>