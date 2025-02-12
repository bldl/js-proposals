#Stage4Tag
Classification: [[Syntactic Change]]
Human Validated: KW
Title: Exponentiation operator
Authors: Rick Waldron
Champions: Rick Waldron
Date: January 2016
Last Commit: 2022-01-24
GitHub Link: https://github.com/tc39/proposal-exponentiation-operator
GitHub Note Link: https://github.com/tc39/notes/blob/HEAD/meetings/2016-01/jan-28.md#5xviii-exponentiation-operator-rw

# Proposal Description:

# Exponentiation Operator

[Specification](https://tc39.es/ecma262/#sec-exp-operator)

## Status

**Stage 4**

Implementation Progress
  - Traceur
  - Babel
  - V8 (https://code.google.com/p/v8/issues/detail?id=3915)
  - SpiderMonkey (https://bugzilla.mozilla.org/show_bug.cgi?id=1135708)

## Authors

- Rick Waldron
- Claude Pache
- Brendan Eich 

## Reviewers

- Brian Terlson
- Erik Arvidsson
- Dmitry Lomov
- Cait Potter
- Jason Orendorff
- Waldemar Horwat




## Informative

- Commonly used in mathematics, physics and robotics.
- [Infix notation](http://en.wikipedia.org/wiki/Infix_notation) is more succinct than function notation, which makes it more preferable

#### Prior Art

- Python
  - `math.pow(x, y)`
  - `x ** y`
- CoffeeScript
  - `x ** y`
- F#
  - `x ** y`
- Ruby
  - `x ** y`
- Perl
  - `x ** y`
- Lua, Basic, MATLAB, etc.
  - `x ^ y`


#### Usage


```js
// x ** y

let squared = 2 ** 2;
// same as: 2 * 2

let cubed = 2 ** 3;
// same as: 2 * 2 * 2

```

```js
// x **= y

let a = 2;
a **= 2;
// same as: a = a * a;



let b = 3;
b **= 3;
// same as: b = b * b * b;

```



#### Render Spec

```
ecmarkup spec/index.html index.html
```