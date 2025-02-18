#InactiveTag
Classification: [[Syntactic Change]]
Human Validated: KW
Title: Unused Function Parameters
Champions: Gus Caplan
Reason for Withdrawal: [Rejected][unused-params-notes]: the need to solve the problem does not outweigh the hazards
Date: None
Last Commit: None
GitHub Link: https://github.com/devsnek/proposal-unused-function-parameters
GitHub Note Link: https://github.com/tc39/notes/blob/HEAD/meetings/2020-09/sept-24.md#unused-function-parameters-for-stage-1

# Proposal Description:

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