[[Inactive]]<br>Classification: [[Syntactic Change]]<br>Human Validated: KW<br>Title: Unused Function Parameters<br>Authors: Gus Caplan<br>[Rejected][unused-params-notes]: the need to solve the problem does not outweigh the hazards<br>Last Presented: None<br>Stage Upgrades:<br>Stage 1: NA
Stage 2: NA  
Stage 2.7: NA  
Stage 3: NA  
Stage 4: NA<br>Last Commit: 2020-08-12<br>Keywords: #unused_parameters #function_syntax #placeholder_syntax #elisions #parameter_binding #javascript_functions #lambda_expressions #syntax_proposal #code_clarity #destructuring<br>GitHub Link: https://github.com/devsnek/proposal-unused-function-parameters <br>GitHub Note Link: https://github.com/tc39/notes/blob/HEAD/meetings/2020-09/sept-24.md#unused-function-parameters-for-stage-1
# Proposal Description:<br>
# Unused Function Parameters

## The Problem

```js
doSomething((unused1, unused2, somethingUseful) => {
  doSomethingWith(somethingUseful);
});

doSomething((_, __, somethingUseful) => {
  doSomethingWith(somethingUseful);
});
```

## Solutions

### Elisions

```js
doSomething(( , , somethingUseful) => {
  doSomethingWith(somethingUseful);
});
```

- Matches with existing destructuring
  - `([, c])` is already valid
- Some might say it looks weird

### Placeholder Syntax

```js
doSomething((?, ?, somethingUseful) => {
  doSomethingWith(somethingUseful);
});

doSomething((*, *, somethingUseful) => {
  doSomethingWith(somethingUseful);
});

// etc.
```

- Most explicit, clearly "using up" a parameter without binding it
- Requires more syntax

### Placeholder Identifier

```js
doSomething((_, _, somethingUseful) => {
  doSomethingWith(somethingUseful);
});

doSomething((_, _, somethingUseful) => {
  print(_); // IdentifierReference : `_` early error?
  doSomethingWith(somethingUseful);
});
```

- Arguably most natural, other languages use this (C#, Rust, etc.)
- Any valid identifiers are already valid identifiers, could conflict with existing code