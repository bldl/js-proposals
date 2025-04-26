[[Stage 0]]<br>Classification: [[API Change]]<br>Human Validated: KW<br>Title: Structured Clone<br>Authors: Dmitry Lomov<br>Champions: Dmitry Lomov<br>Last Presented: Jan 2014<br>Stage Upgrades:<br>Stage 1: NA  
Stage 2: NA  
Stage 2.7: NA  
Stage 3: NA  
Stage 4: NA<br>Last Commit: 2014-01-21<br>Topics: #realms #others #objects<br>Keywords: #realm #operator #cloning <br>GitHub Link: https://github.com/dslomov/ecmascript-structured-clone <br>GitHub Note Link: https://github.com/tc39/notes/blob/HEAD/meetings/2014-01/jan-30.md#structured-clone
# Proposal Description:<br>
# Structured cloning and transfer
## Overview

Structured cloning algorithm defines the semantics of copying a well-defined subset of ECMAScript 
objects between Code Realms. This algorithm is extensible by host environment to support cloning of host objects.

Optionally, some kinds of objects may support a "transfer" operation, the effect of which is to transfer 
"ownership" of some resource associated with an object to a different Code Realm. 
The object then becomes unusable in the source Code Realm. 

----

This specification combines and subsumes http://www.whatwg.org/specs/web-apps/current-work/#dom-messageport-postmessage and 
http://www.whatwg.org/specs/web-apps/current-work/#structured-clone as they really belong together.

HTML spec will be updated to refer to this specification of the _StructuredClone_ algorithm.

----

We introduce a StructuredClone operator.

Transferable objects carry a Transfer internal data property that is either a transfer operator or "neutered", 
and an OnSuccessfulTransfer internal method.

Objects defined outside ECMAScript need to define a Clone internal method that returns a copy of the 
object.

Note: _The first iteration is not user-pluggable. It is about moving the semantics into ECMAScript
proper and tying them down._


## StructuredClone(input, transferList, targetRealm)

The operator StructuredClone either returns a _structured clone_ of _input_ or throws an exception.
A _structured clone_ of an object _input_ is an object in Code Realm _targetRealm_. _transferList_ is a list of objects that should be transferred during cloning of _input_.

1. Let _memory_ be a map of source-to-destination object mappings.
2. For each object _transferable_ in _transferList_:
    1. If _transferable_ does not have a Transfer internal data property whose value is an operator, 
       throw a DataCloneError exception.
    2. Let _transferResult_ be a result of a call to a _transferable_'s internal method 
        Transfer with argument _targetRealm_.
    3. ReturnIfAbrupt( _transferResult_ )
    4. Append a mapping from _transferable_ to _transferResult_ to _memory_.
2. Let _clone_ be the result of InternalStructuredClone( _input_, _memory_, _targetRealm_ ).
3. ReturnIfAbrupt( _clone_ ).
4. For each object _transferable_ in _transferList_:
    1. Let _transferResult_ be a target of mapping from _transferable_ in _memory_.  
    2. Run _transferable_'s internal method \[\[OnSuccessfulTransfer\]\]\(_transferResult_, _targetRealm_).
5. Return _clone_.


## InternalStructuredClone(input, memory, targetRealm)

The operator InternalStructuredClone either returns a _structured clone_ of _input_ in Code Realm _targetRealm_
or throws an exception.

1. If _input_ is the source object of a pair of objects in _memory_, then return the destination object in that pair of objects.
2. If _input_'s Transfer is “neutered”, throw a DataCloneError exception.
3. If _input_ is a primitive value, return _input_.
4. Let _deepClone_ be false.
5. If _input_ has a BooleanData internal data property:
   *  Let _output_ be a new Boolean object in _targetRealm_ whose BooleanData is BooleanData of _input_.
1. If _input_ has a NumberData internal data property: 
   *  Let _output_ be a new Number object in _targetRealm_ whose NumberData is NumberData of _input_.
1. If _input_ has a StringData internal data property: 
   *  Let _output_ be a new String object in _targetRealm_ whose StringData is StringData of _input_.
1. If _input_ has a DateValue internal data property:
    * Let _output_ be a new Date object in _targetRealm_ whose DateValue is DateValue of _input_.
2. If _input_.RegExpMatcher exists: 
    * Let _output_ be   new RegExp object _r_ in _targetRealm_ such that: 
        * RegExpMatcher of _r_ is RegExpMatcher of _input_.
        * OriginalSource of _r_ is OriginalSource of _input_.
        * OriginalFlags of _r_ is OriginalFlags of _input_.
3. If _input_ has ArrayBufferData internal data property:
    1. Set _output_ to CopyArrayBufferToRealm\(_input_, _targetRealm_).
4. If _input_ has ViewedArrayBuffer internal data property, then:
    2. let _arrayBuffer_ be a value of _input_'s ViewedArrayBuffer internal data property.   
    3. let _arrayBufferClone_ be InternalStructuredClone\(_arrayBuffer_, _memory_, _targetRealm_)
    4. ReturnIfAbrupt\(_arrayBufferClone_\)
    5. if _input_ *instanceof* %DataView% intrinsic object in current realm:
       1. Let _output_ be an instance of %DataView% intrinsic object in _targetRealm_.
       2. Set _output_'s ViewedArrayBuffer to _arrayBufferClone_.
       3. Set _output_'s ByteOffset to _input_'s ByteOffset.
       4. Set _output_'s ByteLength to _input_'s ByteLength.
    6. 5. erwise, if _input_ *instanceof* %_TypedArray_% for one of typed arrays' intrinsics _TypedArray_ in
       current code realm:
       6. Let _output_ be an instance of %_TypedArray_% intrinsic object in _targetRealm_.
       7. Set _output_'s ByteOffset to _input_'s ByteOffset.
       8. Set _output_'s ByteLength to _input_'s ByteLength.
       9. Set _output_'s ArrayLength to _input_'s ArrayLength.
5. If _input_ has MapData internal data property, ...
6. If _input_ has SetData internal data property, ...
7. If _input_ is an exotic Array object:
    1. Let _output_ be a new Array in _targetRealm_.
    2. Set _output_.length to _input_.length.
    3. Set _deepClone_ to true.
8. Otherwise, if IsCallable( _input_), throw a DataCloneError exception.
9. Otherwise, if input has ErrorData propety, throw a DataCloneError exception.
10. Otherwise, if input has Clone internal method: 
    4. Set _output_ to a result of input.Clone( _targetRealm_ )
11. Otherwise, if input is an exotic object, throw a DataCloneError exception.
12. Otherwise: 
    5. Let _object_ be a new Object in _targetRealm_.
    6. set _deepClone_ to true.
13. Add a mapping from _input_ (the source object) to _output_ (the destination object) to _memory_.
14. If _deepClone_ is true:
15. 1. Let _keys_ be _input_.OwnPropertyKeys().
16. 2. For each _key_ in _keys_:
      1. If _key_ is a primitive String value, set _outputKey_ to _key_
      2. TODO: Symbols
      3. Let _sourceValue_ be a result of a call to _input_'s internal method Get( _key_, _input_).
      4. ReturnIfAbrupt( _sourceValue_).
      5. Let _clonedValue_ be InternalStructuredClone( _sourceValue_, _memory_). 
      6. ReturnIfAbrupt( _clonedValue_).
      7. Let _outputSet_ be a result of a call to _output_'s internal method Set( _outputKey_, _clonedValue_, _output_).
      8. ReturnIfAbrupt( _outputSet_ )
17. Return _output_.

## Definition of Transfer(targetRealm) on ECMAScript exotic objects.

Definition of _object_.Transfer ( _targetRealm_ ):

1. If _object_ has an ArrayBufferData internal data property then:
2. . Return CopyArrayBufferToRealm(_object_, _targetRealm_).


## Definition of CopyArrayBufferToRealm(_arrayBuffer_, _targetRealm_)

1. Let _result_ be a new ArrayBuffer _arrayBuffer_ in _targetRealm_.
2. Let _length_ be a value of _arrayBuffer_'s ArrayBufferByteLength internal slot.
3. Let _srcBlock_ be the value of _arrayBuffer_'s ArrayBufferData internal slot. 
4. Let _setStatus_ be a result of SetArrayBufferData(_result_,_length_).
5. ReturnIfAbrupt(_setStatus_).
6. Let _targetBlock_ be a value of _result_'s ArrayBufferData internal slot.
7. Perform CopyDataBlock(targetBlock, 0, srcBlock, 0, length).
8. Return _result_.

## Definition of \[\[OnSuccessfulTransfer]]\() on ECMAScript exotic objects.

Definition of internal method _object_. OnSuccessfulTransfer ( _transferResult_, _targetRealm_ ):

1. If _object_ has an ArrayBufferData internal data property then:
    1. Let _neuteringResult_ be SetArrayBufferData( _object_, 0 ).
    2. ReturnIfAbrupt( _neuteringResult_ ).
    3. Set value of _object_'s Transfer internal data property to "neutered".

## DataCloneError error object

Indicates failure of the structured clone algorithm.

{Rationale: typically, ECMAScript operations throw RangeError for similar failures, 
but we need to preserve DOM compatibnility}