[[Stage 0]]<br>Classification: [[Syntactic Change]] [[Semantic Change]]<br>Human Validated: KW<br>Title: Method parameter decorators<br>Authors: Igor Minar<br>Champions: Igor Minar<br>Last Presented: None<br>Stage Upgrades:<br>Stage 1: NA  
Stage 2: NA  
Stage 2.7: NA  
Stage 3: NA  
Stage 4: NA<br>Last Commit: 2016-01-25<br>Topics: #objects #others<br>Keywords: #decorators #metadata #reflection <br>GitHub Link: https://goo.gl/r1XT9b <br>GitHub Note Link: None
# Proposal Description:<br>
Method Parameter Decorators

ECMA-262 Proposal

Author: @IgorMinar, Short Url: [https://goo.gl/r1XT9b](https://goo.gl/r1XT9b)

Status: [Stage 0 candidate](https://github.com/tc39/ecma262/pull/323), Last Update: 2016-01-25

  
  

This proposal builds on top of the [[decorators]] and adds decorator support for method parameters.

  
  

# What are method parameter decorators?

  

Method parameter decorators are decorators that operate on method and constructor parameters.

  

Method property decorators are intended primarily for providing additional information (metadata) about a method signature and meaning of the method's parameters. Any code that is inspecting or invoking the method can reflect upon its parameters and metadata associated with them and make decisions about what arguments to invoke the function with.

  

# Motivating Use Cases

  

## Declarative meta-programming

  
  

### Callbacks requesting specific parameters

  

Callbacks that could potentially receive a large number of optional arguments could use parameter decorators to specify a small number of arguments from a large pool of possible arguments. This make the code much easier to read (no need to list uninteresting arguments) and could allow the callback caller to avoid performing possibly expensive work of preparing all optional arguments.

  

class MyComponent {

  refresh(@lastRefreshTime timeStamp) { … }

}

  

### Dependency Injection

  

Dependency injection libraries, would use parameter decorators for specifying dependencies to be injected into the constructor:

  

class MyRobot {

  constructor(

@leg('right') rightLeg,

@leg('left') leftLeg,

@head head ) { … }

}

  
  

# Basic Usage

  

### Usage

  

class MyComponent {

  refresh(@lastRefreshTime timeStamp) { … }

}

  
  

### Decorator definition

  

export function lastRefreshTime(...) {

  // at minimum, the arguments of this function should contain:

  // - reference to owner of the parameter (the method)

  // - parameter index

  // - parameter name

  // - is parameter a rest parameter?

  

  // store parameter metadata using the same storage mechanism

  // as the one used for methods

}

  

# Implementation Discussion / FAQ

  

## Possible Implementation Approaches

  

While for Stage 0, we are not aiming to specify the particular implementation approach, there are at least three approaches that have been discussed or implemented so far:

  

- The TypeScript v1.5-1.8 implementation based on [Reflect.metadata](https://github.com/rbuckton/ReflectDecorators)
    
- [Mirrors](https://gist.github.com/rbuckton/8e6806fb6852b50e4052/) as proposed by Ron Buckton
    
- [Property Descriptors](https://docs.google.com/document/d/14U4h8YN4NNGG86YUjVTc5rp5hab0zvUzC-u4PMg9giA/edit)
    

  

## Timing of the method parameter decorators in respect to method decorators

  

In order to enable method decorators to have more contextual information about the method they are decorating, I'm proposed the the parameter decorators are executed before the method decorators. 

  
  

## Intercepting parameter values during method invocation

  

In order to avoid unpredictable performance characteristics and interfering with invocation of methods, method parameter decorators don't have the ability to augment the decorated target during method invocation. They are evaluated during the evaluation of the containing class, not when the decorated class is instantiated or when it's decorated methods are called.

  
  

## Function expression and function declaration parameters

  
This proposal currently targets only method parameters, because function expressions and declarations don't currently have a proposal that would be in Stage 0 or higher. [As soon as that changes](https://goo.gl/8MmCMG), this proposal can be expanded to also include function expression and/or function declaration parameters.