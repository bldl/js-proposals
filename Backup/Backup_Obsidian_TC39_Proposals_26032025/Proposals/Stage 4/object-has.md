[[Stage 4]]<br>Classification: [[API Change]]<br>Human Validated: KW<br>Title: Accessible Object.prototype.hasOwnProperty<br>Authors: Jamie Kyle<br>Champions: Tierney Cyren, Jamie Kyle<br>Last Presented: August 2021<br>Stage Upgrades:<br>Stage 1: NA  
Stage 2: 2021-04-20  
Stage 2.7: NA  
Stage 3: 2021-05-25  
Stage 4: 2021-08-31<br>Last Commit: 2021-08-31<br>Keywords: #object #method #property #prototype #accessibility #redefinition #inheritance #polyfill #dictionary #eslint<br>GitHub Link: https://github.com/tc39/proposal-accessible-object-hasownproperty <br>GitHub Note Link: https://github.com/tc39/notes/blob/HEAD/meetings/2021-08/aug-31.md#accessible-object-hasownproperty-for-stage-4
# Proposal Description:
# Accessible `Object.prototype.hasOwnProperty()`

Proposal for an `Object.hasOwn()` method to make `Object.prototype.hasOwnProperty()` more accessible.

## 👋 Now Gathering Community Feedback

Please see the [Implementations](#implementations) section for polyfills and a codemod to start using `Object.hasOwn()` in your code today. 

If you are using `Object.hasOwn()` please provide feedback in [issue #18](https://github.com/tc39/proposal-accessible-object-hasownproperty/issues/18) (positive and/or negative feedback is encouraged).

## Status

This proposal is currently at [Stage 4](https://github.com/tc39/proposals/blob/master/finished-proposals.md)

Authors:

- [@jamiebuilds](https://github.com/jamiebuilds) (Jamie Kyle, Rome)
- Champion: [@bnb](https://github.com/bnb) (Tierney Cyren, Microsoft)

Slides:

- [For stage 1](https://docs.google.com/presentation/d/1FvDwrmzin_qGMzH-Cc8l5bHK91UxkpZJwuugoay5aNQ/edit#slide=id.p) on [2021/04](https://github.com/tc39/agendas/blob/master/2021/04.md) (Reached Stage 2)
- [For stage 3](https://docs.google.com/presentation/d/1r5_Jw-gR8cRNo7SJyWtd6h_fEyVFJr9t3a2FvCBPiLE/edit?usp=sharing) on [2021/05](https://github.com/tc39/agendas/blob/master/2021/05.md) (Reached Stage 3)
- [Stage 3 update](https://docs.google.com/presentation/d/1UbbNOjNB6XpMGo1GGwl0b8lVsNoCPPPLBByPYc7i5IY/edit?usp=sharing) on 2021/07
- [For stage 4](https://docs.google.com/presentation/d/177vM52Cd6Dij-ta6vmw4Wi1sCKrzbCKjavSBpbdz9fM/edit?usp=sharing) on 2021/08 (Reached Stage 4)

## Motivation

Today, it is very common (especially in library code) to write code like:

```js
let hasOwnProperty = Object.prototype.hasOwnProperty

if (hasOwnProperty.call(object, "foo")) {
  console.log("has property foo")
}
```

This proposal simplifies that code to:

```js
if (Object.hasOwn(object, "foo")) {
  console.log("has property foo")
}
```

There are a number of existing libraries which make this more convenient:

- [npm: has][npm-has]
- [npm: lodash.has][npm-lodash-has]
- [See Related](#related)

This is a common practices because methods on `Object.prototype` can sometimes be unavailable or redefined.

### `Object.create(null)`

`Object.create(null)` will create an object that does not inherit from `Object.prototype`, making those methods inaccessible.

```js
Object.create(null).hasOwnProperty("foo")
// Uncaught TypeError: Object.create(...).hasOwnProperty is not a function
```

### Redefining `hasOwnProperty`

If you do not directly own every property defined of an object, you can't be 100% certain that calling `.hasOwnProperty()` is calling the built-in method:

```js
let object = {
  hasOwnProperty() {
    throw new Error("gotcha!")
  }
}

object.hasOwnProperty("foo")
// Uncaught Error: gotcha!
```

### ESLint `no-prototype-builtins`

ESLint has a [built-in rule][eslint-no-prototype-builtins] for banning use of prototype builtins like `hasOwnProperty`.

> **From the ESLint documentation for `no-prototype-builtins`:**
>
> ---
>
> Examples of incorrect code for this rule:
>
> ```js
> /*eslint no-prototype-builtins: "error"*/
> var hasBarProperty = foo.hasOwnProperty("bar");
> ...
> ```
>
> Examples of correct code for this rule:
>
> ```js
> /*eslint no-prototype-builtins: "error"*/
> var hasBarProperty = Object.prototype.hasOwnProperty.call(foo, "bar");
> ...
> ```

### MDN `hasOwnProperty()` advice

The MDN documentation for `Object.prototype.hasOwnProperty` includes [advice][mdn-hasownproperty-advice] not to use it off of the prototype chain directly:

> JavaScript does not protect the property name hasOwnProperty; thus, if the possibility exists that an object might have a property with this name, it is necessary to use an external hasOwnProperty to get correct results [...]

## Proposal

This proposal adds a `Object.hasOwn(object, property)` method with the same behavior as calling `hasOwnProperty.call(object, property)`

```js
let object = { foo: false }
Object.hasOwn(object, "foo") // true

let object2 = Object.create({ foo: true })
Object.hasOwn(object2, "foo") // false

let object3 = Object.create(null)
Object.hasOwn(object3, "foo") // false
```

## Implementations

Native implementations of `Object.hasOwn` in JavaScript engines are available in:

- Browsers:
  - [V8](https://chromium-review.googlesource.com/c/v8/v8/+/2922117) ([shipped](https://v8.dev/blog/v8-release-93))
  - [SpiderMonkey](https://hg.mozilla.org/try/rev/94515f78324e83d4fd84f4b0ab764b34aabe6d80) (feature-flagged)
  - [JavaScriptCore](https://bugs.webkit.org/show_bug.cgi?id=226291#c2) (in-progress)
- Others:
  - [SerenityOS: LibJS](https://github.com/SerenityOS/serenity/commit/3ee092cd0cacb999469e50aa5ff220e397df2d79)
  - [engine262](https://github.com/engine262/engine262/pull/163)

Polyfills of `Object.hasOwn()` are available in:

- [./polyfill.js](./polyfill.js)
- [npm: object.hasown](https://www.npmjs.com/package/object.hasown)
- [core-js](https://github.com/zloirock/core-js/#accessible-objecthasownproperty)

A codemod to migrate to `Object.hasOwn()` from similar libraries is available:

- [`Object.hasOwn()` codemod](https://gist.github.com/jamiebuilds/f4ff76397d31b69c484240379170af8c)

There's also an eslint rule for enforcing usage of `hasOwn` instead of `hasOwnProperty`:

- [`unicorn/prefer-object-has-own`](https://github.com/sindresorhus/eslint-plugin-unicorn/blob/main/docs/rules/prefer-object-has-own.md)

## Q&A

### Why not `Object.hasOwnProperty(object, property)`?

`Object.hasOwnProperty(property)` already exists today because `Object` itself inherits from `Object.prototype` so defining a new method with a different signature would be a breaking change.

### Why the name `hasOwn`?

See [Issue #3](https://github.com/tc39/proposal-accessible-object-hasownproperty/issues/3)

### Why not use `Map` for dictionaries instead of objects?

Excerpt from https://v8.dev/features/object-fromentries#objects-vs.-maps

> JavaScript also supports Maps, which are often a more suitable data structure than regular objects. So in code that you have full control over, you might be using maps instead of objects. However, as a developer, you do not always get to choose the representation. Sometimes the data you’re operating on comes from an external API or from some library function that gives you an object instead of a map.

### Why not place this method on `Reflect`?

The purpose of `Reflect` is to contain, 1:1, a method for each `Proxy` trap. There is already a method on `Proxy` that traps `hasOwnProperty` (`getOwnPropertyDescriptor`) so it doesn't make sense to add an additional trap, therefore it doesn't make sense to place this method on `Reflect`.

## Related

- [npm: `has`][npm-has]
- [npm: `lodash.has`][npm-lodash-has]
- [underscore `_.has`][underscore-has]
- [npm: `just-has`][npm-just-has]
- [ramda: `R.has`][ramda-has]
- [eslint `no-prototype-builtins`][eslint-no-prototype-builtins]
- [MDN `hasOwnProperty()` advice][mdn-hasownproperty-advice]

[npm-has]: https://www.npmjs.com/package/has
[npm-lodash-has]: https://www.npmjs.com/package/lodash.has
[underscore-has]: https://underscorejs.org/#has
[npm-just-has]: https://www.npmjs.com/package/just-has
[ramda-has]: https://ramdajs.com/docs/#has
[eslint-no-prototype-builtins]: https://eslint.org/docs/rules/no-prototype-builtins
[mdn-hasownproperty-advice]: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Object/hasOwnProperty#using_hasownproperty_as_a_property_name
<br>