[[Stage 4]]<br>Classification: [[API Change]]<br>Human Validated: KW<br>Title: Array Grouping<br>Authors: Justin Ridgewell<br>Champions: Justin Ridgewell, Jordan Harband<br>Last Presented: November 2023<br>Stage Upgrades:<br>Stage 1: 2021-07-15  
Stage 2: 2021-10-27  
Stage 2.7: NA  
Stage 3: 2023-08-01  
Stage 4: 2023-11-27<br>Last Commit: 2023-11-27<br>Keywords: #grouping #array #object #map #iterables #method #prototype #key #data #tuples<br>GitHub Link: https://github.com/tc39/proposal-array-grouping <br>GitHub Note Link: https://github.com/tc39/notes/blob/HEAD/meetings/2023-11/november-27.md#array-grouping-for-stage-4
# Proposal Description:
# proposal-array-grouping

Note: this proposal is now [at stage 4](https://github.com/tc39/proposals/commit/e11ea25d41c8ab28b6632b5d355359dcb528ee6f). See the spec PR here: https://github.com/tc39/ecma262/pull/3176

A proposal to make grouping of items in an array (and iterables) easier.

```js
const array = [1, 2, 3, 4, 5];

// `Object.groupBy` groups items by arbitrary key.
// In this case, we're grouping by even/odd keys
Object.groupBy(array, (num, index) => {
  return num % 2 === 0 ? 'even': 'odd';
});
// =>  { odd: [1, 3, 5], even: [2, 4] }

// `Map.groupBy` returns items in a Map, and is useful for grouping
// using an object key.
const odd  = { odd: true };
const even = { even: true };
Map.groupBy(array, (num, index) => {
  return num % 2 === 0 ? even: odd;
});
// =>  Map { {odd: true}: [1, 3, 5], {even: true}: [2, 4] }
```

## Champions

- Justin Ridgewell ([@jridgewell](https://github.com/jridgewell))
- Jordan Harband ([@ljharb](https://github.com/ljharb))

## Status

Current [Stage](https://tc39.es/process-document/): 4

## Motivation

Array grouping is an extremely common operation, best exemplified by
SQL's `GROUP BY` clause and MapReduce programming (which is better
thought of map-group-reduce). The ability to combine like data into
groups allows developers to compute higher order datasets, like the
average age of a cohort or daily LCP values for a webpage.

Two methods are offered, `Object.groupBy` and `Map.groupBy`. The first
returns a null-prototype object, which allows ergonomic destructuring
and prevents accidental collisions with global Object properties. The
second returns a regular `Map` instance, which allows grouping on
complex key types (imagine a compound key or [tuple]).

## Why static methods?

We've [found][sugar-bug] a web compatibility issue with the name
`Array.prototype.groupBy`. The [Sugar][sugar] library until v1.4.0
conditionally monkey-patches `Array.prototype` with an incompatible
method. By providing a native `groupBy`, these versions of Sugar would
fail to install their implementation, and any sites that depend on their
behavior would break. We've found some 660 origins that use these
versions of the Sugar library.

We then attempted the name `Array.prototype.group`, but this ran into
[code that uses an array as an arbitrary hashmap][arraymap-bug]. Because
these bugs are exceptionally difficult to detect (it requires devs to
detect and know how to report the bug to us), the committee didn't want
to attempt another prototype method name. Instead we chose to use static
method, which we believe is unorthodox enough to not risk a web
compatibility issue. This also gives us a nice way to support Records
and Tuples in the future.

## Polyfill

- A polyfill is available in the [core-js] library. You can find it in
  the [ECMAScript proposals section][core-js-section].

## Related

- Lodash
  - [`_.groupBy`][lodash] ([850k downloads/week][lodash-npm])

[tuple]: https://github.com/tc39/proposal-record-tuple
[core-js]: https://github.com/zloirock/core-js
[core-js-section]: https://github.com/zloirock/core-js#array-grouping
[lodash]: https://lodash.com/docs/4.17.15#groupBy
[lodash-npm]: https://www.npmjs.com/package/lodash.groupby
[sugar]: https://sugarjs.com/
[sugar-bug]: https://github.com/tc39/proposal-array-grouping/issues/37
[arraymap-bug]: https://github.com/tc39/proposal-array-grouping/issues/44
<br>