[[Stage 2.7]]<br>Classification: [[API Change]]<br>Human Validated: KW<br>Title: Iterator Sequencing<br>Authors: Michael Ficarra<br>Champions: Michael Ficarra<br>Last Presented: October 2024<br>Stage Upgrades:<br>Stage 1: 2023-09-27  
Stage 2: 2024-06-21  
Stage 2.7: 2024-10-08  
Stage 3: NA  
Stage 4: NA<br>Last Commit: 2024-12-03<br>Topics: #iterators<br>Keywords: #iterator #concatenate #generator <br>GitHub Link: https://github.com/tc39/proposal-iterator-sequencing <br>GitHub Note Link: https://github.com/tc39/notes/blob/HEAD/meetings/2024-10/october-08.md#iterator-sequencing-for-stage-27
# Proposal Description:
Iterator Sequencing
===================

A TC39 proposal to create iterators by sequencing existing iterators.

**Stage:** 2.7

**Specification:** https://tc39.es/proposal-iterator-sequencing/

## presentations to committee

- [October 2024](https://docs.google.com/presentation/d/1Z5Bz_4xpwRX7tjwmrMakrj3_II8Qy40fnAq-TrPdt0U)
- [June 2024](https://docs.google.com/presentation/d/1gOs4UDAcaIF6Dc9z1qXus-ljizrRTSty5O-GbcM9NTs)
- [January 2024](https://docs.google.com/presentation/d/1KhdGLNXOxWFEg3EhDDv9P-dkLxPKBTuI0EkEUc_fdNA)
- [November 2023](https://docs.google.com/presentation/d/1wMUfikXIIz7woLN-5MbYbW8an40c8ZPrN1ehzWVf4zw)
- [September 2023](https://docs.google.com/presentation/d/1myebbwYiacqh419Vi2-EjtcQcaWpyMlZ8lbayi5OAZs)

## motivation

Often you have 2 or more iterators, the values of which you would like to
consume in sequence, as if they were a single iterator. Iterator libraries (and
standard libraries of other languages) often have a function called `concat` or
`chain` to do this. In JavaScript today, one can accomplish this with generators:

```js
let lows = Iterator.from([0, 1, 2, 3]);
let highs = Iterator.from([6, 7, 8, 9]);

let lowsAndHighs = function* () {
  yield* lows;
  yield* highs;
}();

Array.from(lowsAndHighs); // [0, 1, 2, 3, 6, 7, 8, 9]
```

It is also useful to be able to sequence immediate values among the iterators,
as one would do with `yield` using the generator approach.

```js
let digits = function* () {
  yield* lows;
  yield 4;
  yield 5;
  yield* highs;
}();

Array.from(digits); // [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
```

We should explore how to make this more ergonomic and functional.

## chosen solution

```js
let digits = Iterator.concat(lows, [4, 5], highs);
```

For the (rare) case of infinite iterators of iterators, use `flatMap` with the identity function.

```js
function* p() {
  for (let n = 1;; ++n) {
    yield Array(n).fill(n);
  }
}
let repeatedNats = p().flatMap(x => x);
```

## prior art

### other languages

| language | data type    | exactly 2     | arbitrary |
|----------|--------------|---------------|-----------|
| Clojure  | lazy seq     |               | `concat`  |
| Elm      | List         | `append`/`++` | `concat`  |
| Haskell  | Semigroup    | `<>`          | `mconcat` |
| OCaml    | Seq          | `append`      | `concat`  |
| Python   | iterator     |               | `chain`   |
| Ruby     | Enumerable   |               | `chain`   |
| Rust     | Iterator     | `chain`       | `flatten` |
| Scala    | Iterator     | `concat`/`++` |           |
| Swift    | LazySequence |               | `joined`  |

### JS libraries

| library                    | exactly 2                  | arbitrary     |
|----------------------------|----------------------------|---------------|
| @softwareventures/iterator | `prependOnce`/`appendOnce` | `concatOnce`  |
| extra-iterable             |                            | `concat`      |
| immutable.js               |                            | `Seq::concat` |
| iterablefu                 |                            | `concatenate` |
| itertools-ts               |                            | `chain`       |
| lodash                     |                            | `flatten`     |
| ramda                      | `concat`                   | `unnest`      |
| sequency                   | `plus`                     |               |
| wu                         |                            | `chain`       |
<br>