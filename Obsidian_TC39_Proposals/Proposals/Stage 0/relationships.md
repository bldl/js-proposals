[[Stage 0]]<br>Classification: [[Semantic Change]] [[Syntactic Change]]<br>Human Validated: No<br>Title: Relationships<br>Authors: Mark Miller, Waldemar Horwat<br>Champions: Mark Miller, Waldemar Horwat<br>Last Presented: None<br>Stage Upgrades:<br>Stage 1: NA  
Stage 2: NA  
Stage 2.7: NA  
Stage 3: NA  
Stage 4: NA<br>Last Commit: 2013-08-05<br>Keywords: #relationships #private_symbols #unique_symbols #weakmap #prototype_chain #property_access #proxy_traps #fields #object_mutability #symbol_lookup<br>Link: https://web.archive.org/web/20160804042554/http://wiki.ecmascript.org/doku.php?id=strawman:relationships <br>GitHub Note Link: None
# Proposal Description:<br>
# Relationships

This proposal is based on input gathered from the March 2013 TC39 meeting, after MarkM’s discussion of “relationships”: [relationships.pdf](https://web.archive.org/web/20160804042554/http://wiki.ecmascript.org/lib/exe/fetch.php?id=strawman%3Arelationships&cache=cache&media=meetings:relationships.pdf "meetings:relationships.pdf")

Currently, there are three core abstractions by which an object x can represent that it is in a relationship r with a value y, depending on the kind of object that r is:

- If r is a string, then r names a property whose value is y. This property respects all the normal reflective rules.
    
- If r is a unique symbol, then r names a property whose value is y. This property respects all the normal reflective rules.
    
- If r is a so-called “private symbol”, then x makes visible only to those who hold r that x is in the r relationship with y. This is hidden from the normal reflective rules, to prevent discovery (getOwnPropertyNames) and theft (proxy traps).
    

In addition, if r is any value other than the above cases, then r is coerced to a string, and this stringified r is used according to the first case above.

In this proposal, we make “unique symbols” and so-called “private symbols” more different from each other. The unqualified “symbol” means the same thing as “unique symbol”, and represents a new primitive type that can be used to name properties much as strings can. Their novel feature is their unforgeable uniqueness – the only way to obtain a particular symbol is either to create the symbol or to obtain it from something that already has access to it. Thus, unlike strings, they can be used to name properties with fewer worries about _accidental_ collisions.

By contrast, so-called “private symbols” become “field” objects. When r is a field, then we would equivalently say “x has an r field whose value is y.” Both fields and properties are forms of relationship.

This strawman is primarily about semantics, but we introduce some expository syntactic conventions for discussing these semantics. Whether this syntax itself becomes accepted is a separate debate.

## Semantics, Expository Syntax

  x @ r // The object x is in the r relationship with what value?
  x @ r = y; // Store that x is in the r relationship with value y.

The syntax above can be used for all three kinds of r, and therefore for both forms of relationship. The key is that the semantics of “`@`” does case splitting on the kind of value r is. To do so, we need to determine whether r represents a field object but without breaking compatibility with pre-ES6 JavaScript code. The test looks like a duck typing test, in that we’re detecting presence or absence of properties, but we’re doing this for unique-symbol-named properties rather than string valued properties. Thus, we avoid the _accidental_ collision dangers of string-based duck typing, and avoid breaking legacy code.

We assume two unique symbols for this purpose, which we name “`@geti`” and “`@seti`“. We add methods for these symbols to `Map.prototype` and `WeakMap.prototype`, enabling their instances to pass this safe duck typing test so that they can serve as fields.

  xExpr @ relExpr
    let x = the result of evaluating the xExpr expression
    let r = the result of evaluating the relExpr expression
    return the result of calling [[GetRelationship]](x, r)

  [[GetRelationship]](x, r)
    if r is a string or symbol, or if (let getter = r.[[Get]](@geti)) is undefined, then
      return the value of x.[[Get]]( r ), i.e.
      // In this case, "x@r" means the same thing as "x[r]"
    else
      return the result of getter.[[Call]](r, x)
      // In this case, "x@r" mean the same as "r[@geti](x)"

  xExpr @ relExpr = yExpr
    let x = the result of evaluating the xExpr expression
    let r = the result of evaluating the relExpr expression
    let y = the result of evaluating the yExpr expression
    return the result of calling [[SetRelationship]](x, r, y)

  [[SetRelationship]](x, r, y)
    if r is a string or symbol, or if (let setter = r.[[Get]](@seti) is undefined, then
      return the value of x.[[Set]](r, y), i.e.
      // In this case, "x@r = y" means the same thing as "x[r] = y"
    else      
      return the result of setter.[[Call]](r, x, y)
      // In this case, "x@r = y" mean the same as "r[@seti](x, y)"

## Interactions with Proxies

The [[GetRelationship]] and [[SetRelationship]] internal functions do not themselves trap, nor do they test if any of their operands are proxies. Rather, by engaging in the logic specified above, when their operands are proxies, they trigger traps on these proxies. To understand how, let’s explore how xExpr@relExpr executes when both operand expressions evaluate to proxies.

1. The expressions are evaluated and [[GetRelationship]](x, r) is called.
    
2. r is neither a string nor a symbol
    
3. “let getter = r.[[Get]](@geti)” triggers r’s “get” trap with unique symbol @geti as the property name.
    
4. Whatever r’s get trap returns is the getter.
    
5. If the getter is undefined, then
    
    1. “x.[[Get]]( r )” will trigger x’s “get” trap, but with a stringification of r (since r is not a unique symbol)
        
        1. let toString = r.[[Get]](”toString”)
            
        2. let rStr = toString.[[Call]](r, [])
            
        3. (Fill in remaining steps of coercion to string)
            
        4. trigger x’s get trap with rStr as the property name.
            
    2. Return what x’s get trap returns.
        
6. else
    
    1. return getter.[[Call]](r, x)
        

Note that, if getter is itself a proxy, then the last line above triggers the getter’s “call” trap.

## @geti and @seti behavior on WeakMaps and Maps

  function [[MapGetInherited]](this, base) {
    while (base !== null) {
      if ([[MapHas]](this, base)) {
        return [[MapGet]](this, base);
      }
      base = base.[[GetPrototype]];
    }
    return void 0;
  }
  Map.prototype[@geti] = [[MapGetInherited]];
  Map.prototype[@seti] = [[MapSet]];
 
  function [[WeakMapGetInherited]](this, base) {
    while (base !== null) {
      if ([[WeakMapHas]](this, base)) {
        return [[WeakMapGet]](this, base);
      }
      base = base.[[GetPrototype]];
    }
    return void 0;
  }
  WeakMap.prototype[@geti] = [[WeakMapGetInherited]];
  WeakMap.prototype[@seti] = [[WeakMapSet]];

In other words, initially Map.prototype.set === Map.prototype[@seti]. Map.prototype[@geti] is like Map.prototype.get, except that it follows the argument’s prototype chain upward until it finds it as a key or it exhausts the prototype chain.

Semantically, likewise for WeakMaps. However, WeakMaps are expected to store their associations as weakmap→value fields within the key objects, much as properties are stored within these key objects. Thus, the implementation of [[WeakMapGetInherited]] should reuse all the machinery already built for optimizing inherited property lookup.

## How this answers some open design questions

Q: Should we scope this get/set protocol of private symbols only to proxies, or should we open it up to arbitrary objects? (so that `nonProxy[psymbol]` also triggers the symbol’s “get” method)

A: Open it up to arbitrary objects. This is necessary anyway to achieve transparency across membranes.

Q: Do we want to introduce a separate “private symbol” type, or instead adapt WeakMaps to play the role of private symbols?

A: Since so-called “private symbols”, i.e., fields, are duckish typed by the presence of @geti and @seti, we enable WeakMaps and WeakMap proxies to be used as fields, but we do not preclude other objects from being used as fields. However, to get efficient lookup by built-in support, it seems we cannot do better than the optimizations expected for WeakMaps anyway.

Q: Should unique symbols follow the same protocol as private symbols w.r.t. interception by proxies?

A: Absolutely not. Regarding how they cross the proxy boundary, unique symbols and fields are opposites. Unique fields cross the boundary by trapping on the base object, whereas fields cross the boundary by trapping on the field (see below for more).

## Why we need both unique symbols and private fields

There has been a lot of debate re. whether ES needs both unique symbols _and_ private fields, given that both features provide some form of collision-free namespacing. However, from a mutability and sharing perspective, they serve opposite use cases, and so both appear necessary.

Paraphrasing from MarkM’s post on [es-discuss](https://web.archive.org/web/20160804042554/http://esdiscuss.org/topic/unique-public-symbols-as-strings#content-24 "http://esdiscuss.org/topic/unique-public-symbols-as-strings#content-24"):

##### Use case for something like unique symbols / public symbols / guids / funny-looking strings

Given that `base@r = v` succeeds at mutating something, we account for the mutable state as belonging to `base`. This allows `r` to be transitively immutable, and so sharable between subsystems that should not be able to communicate. All the unique symbols mentioned in the ES6 spec itself are of this form. Clearly, everyone (even across realms) must mean the same thing by `@iterator`, and so `@iterator` should not be mutable.

When doing the operation across a membrane, where let’s say the original of all three objects are on the other side of the membrane, it should be the proxy for the `base` object which traps the operation. Ideally, `r` should not be proxied, but should pass through the membrane in both directions untranslated.

By trapping at `base`, a `base` proxy which did not know `r` is able to obtain `r` in its trap handler.

##### Use case for something like private symbols / weak maps / fields

Given that `base@r = v` succeeds at mutating something, we account for the mutable state as belonging to `r`. This allows `base` to be transitively immutable, and so sharable between subsystems that should not be able to communicate. (Note that, although we account for the mutable state as belonging to `r` in the semantics, the implementation should always store the actual mutable state in the storage record implementing the base object, just as it would do for an internal property.)

When doing the operation across a membrane, where let’s say the original of all three objects are on the other side of the membrane, it should be the proxy for the `r` object which traps the operation.

By trapping at `r`, an `r` proxy which did not know `base` is able to obtain the base in its trap handler.