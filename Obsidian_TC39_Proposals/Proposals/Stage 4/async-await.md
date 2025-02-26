[[Stage 4]]<br>Classification: [[Syntactic Change]]<br>Human Validated: No<br>Title: Async functions<br>Authors: Brian Terlson<br>Champions: Brian Terlson<br>Last Presented: July 2016<br>Stage Upgrades:<br>Stage 1: 2014-01-28  
Stage 2: NA  
Stage 2.7: NA  
Stage 3: NA  
Stage 4: 2015-10-06<br>Last Commit: 2020-11-19<br>Keywords: #promises #generators #asynchronous #compilation #es5 #execution #vanilla #browser #runtimes #example<br>GitHub Link: https://github.com/tc39/proposal-async-await <br>GitHub Note Link: https://github.com/tc39/notes/blob/HEAD/meetings/2016-07/jul-28.md#10iv-async-functions
# Proposal Description:
# Async Functions for  ECMAScript

The introduction of Promises and Generators in ECMAScript presents an opportunity to dramatically improve the language-level model for writing asynchronous code in ECMAScript. The spec text can be found [here](https://tc39.github.io/ecmascript-asyncawait).


This proposal is implemented in a [regenerator](https://github.com/facebook/regenerator) which can compile ES5 code containing `async` and `await` down to vanilla ES5 to run in existing browsers and runtimes.

This repo contains a complete example using a large number of the features of the proposal.  To run this example:

```Shell
npm install
regenerator -r server.asyncawait.js | node
```
<br>