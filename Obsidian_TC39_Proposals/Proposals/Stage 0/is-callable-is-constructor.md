[[Stage 0]]<br>Classification: [[API Change]]<br>Human Validated: KW<br>Title: Reflect.{isCallable,isConstructor}<br>Authors: Caitlin Potter<br>Champions: Caitlin Potter<br>Last Presented: None<br>Stage Upgrades:<br>Stage 1: NA  
Stage 2: NA  
Stage 2.7: NA  
Stage 3: NA  
Stage 4: NA<br>Last Commit: 2020-11-06<br>Keywords: #legacy #framework <br>GitHub Link: https://github.com/caitp/TC39-Proposals/blob/HEAD/tc39-reflect-isconstructor-iscallable.md <br>GitHub Note Link: None
# Proposal Description:<br>
Function.isCallable() / Function.isConstructor()
==============================================

## Why are these useful?

- Help support classes/other new function definitions in legacy framework code without significant changes
- Expose a pretty important part of the runtime to applications, who also may wish to use them
- Not require depending on slow (and inconsistent across implementations) `Function.toString()` processing or try/catch statements

## The very tiny normative language:

### Function.isCallable ( <var>argument</var> )

When the `isCallable` function is called with argument <var>argument</var>, the following steps are taken:

1. If [IsCallable](https://tc39.es/ecma262/#sec-iscallable)(<var>argument</var>) is **false**, return **false**.
2. If <var>argument</var> has a \[\[IsClassConstructor]] internal slot with value **true**, return **false**.
3. Return **true**.

(Should be "Return [IsCallable](https://tc39.es/ecma262/#sec-iscallable)(<var>argument</var>)", but adjusted to not report Class constructors as callable, as they throw unconditionally without invoking any author code)

### Function.isConstructor ( <var>argument</var> )

When the `isConstructor` function is called with argument <var>argument</var>, the following steps are taken:

1. Return [IsConstructor](https://tc39.es/ecma262/#sec-isconstructor)(<var>argument</var>).