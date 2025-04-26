[[Stage 1]]<br>Classification: [[Syntactic Change]] [[Semantic Change]]<br>Human Validated: KW<br>Title: async do expressions<br>Authors: Kevin Gibbons<br>Champions: Kevin Gibbons<br>Last Presented: January 2021<br>Stage Upgrades:<br>Stage 1: 2021-01-27  
Stage 2: NA  
Stage 2.7: NA  
Stage 3: NA  
Stage 4: NA<br>Last Commit: 2021-02-03<br>Topics: #async #others<br>Keywords: #asynchronous #expression #promise<br>GitHub Link: https://github.com/tc39/proposal-async-do-expressions <br>GitHub Note Link: https://github.com/tc39/notes/blob/HEAD/meetings/2021-01/jan-27.md#async-do-expressions
# Proposal Description:
# ECMAScript proposal: `async do` expressions

`async do` expressions allow you to introduce an asynchronous context within synchronous code without needing an immediately-invoked async function expression.

This proposal builds off of the [[do]] expressions proposal.

This proposal has [preliminary spec text](https://tc39.github.io/proposal-async-do-expressions/).

## Motivation

Currently the boundary between synchronous and asynchronous code requires defining and invoking an `async` function. In the case that you just want to perform a single operation, that's a lot of syntax for a relatively primitive operation: `(async () => {...})()`. This lets you write `async do {...}` instead.

## Examples

```js
// at the top level of a script

async do {
  await readFile('in.txt');
  let query = await ask('???');
  // etc
}
```

```js
Promise.all([
  async do {
    let result = await fetch('thing A');
    await result.json();
  },
  async do {
    let result = await fetch('thing B');
    await result.json();
  },
]).then(([a, b]) => console.log([a, b]));
```
<br>