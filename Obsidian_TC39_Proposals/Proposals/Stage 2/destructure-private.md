[[Stage 2]]<br>Classification: [[Syntactic Change]]<br>Human Validated: No<br>Title: Destructure Private Fields<br>Authors: Justin Ridgewell<br>Champions: Justin Ridgewell<br>Last Presented: December 2021<br>Stage Upgrades:<br>Stage 1: 2021-09-05  
Stage 2: 2021-10-29  
Stage 2.7: NA  
Stage 3: NA  
Stage 4: NA<br>Last Commit: 2024-07-15<br>Keywords: #private #destructuring #fields #class #instance #syntax #references #properties #local #comparison<br>GitHub Link: https://github.com/tc39/proposal-destructuring-private <br>GitHub Note Link: https://github.com/tc39/notes/blob/HEAD/meetings/2021-12/dec-14.md#destructuring-private-fields
# Proposal Description:
# proposal-destructuring-private

A proposal to integrate private fields and destructuring.

```js
class Foo {
  #x = 1;

  constructor() {
    console.log(this.#x); // => 1
    
    const { #x: x } = this;
    console.log(x); // => 1
  }

  equals({ #x: otherX }) {
    const { #x: currentX } = this;
    return currentX === otherX;
  }
}
```

## Champions

- Justin Ridgewell ([@jridgewell](https://github.com/jridgewell/))

## Status

Current [Stage](https://tc39.es/process-document/): 2

## Motivation

Destructuring is a popular feature to store local references to an
object's properties. Private Field's proposal targeted the minimum
features needed to support the goal of private properties in class
instances. Unfortunately, this left destructuring out.

This proposal avoids questions of reification of Private Fields by
limiting this to syntax only. It also doesn't need to worry about
"shorthand" syntax (`#x` in an expression being shorthand for
`this.#x`), because the Committee has decided we will not persue
shorthand syntax after the [Ergonomic Brand Checks][ergo-brand-check]
Proposal.

## Related

- https://github.com/tc39/proposal-class-fields/issues/4

[ergo-brand-check]: https://github.com/tc39/proposal-private-fields-in-in
<br>