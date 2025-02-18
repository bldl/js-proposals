#Stage0Tag
Classification: [[API Change]]
Human Validated: KW
Title: Reflect.{isCallable,isConstructor}
Authors: Caitlin Potter
Champions: Caitlin Potter
Date: None
Last Commit: None
GitHub Link: https://github.com/caitp/TC39-Proposals/blob/HEAD/tc39-reflect-isconstructor-iscallable.md
GitHub Note Link: None

# Proposal Description:

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

4. Return [IsConstructor](https://tc39.es/ecma262/#sec-isconstructor)(<var>argument</var>).