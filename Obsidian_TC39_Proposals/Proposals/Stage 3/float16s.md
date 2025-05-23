[[Stage 3]]<br>Classification: [[API Change]]<br>Human Validated: KW<br>Title: Float16 on TypedArrays, DataView, Math.f16round<br>Authors: Leo Balter<br>Champions: Leo Balter, Kevin Gibbons<br>Last Presented: May 2023<br>Stage Upgrades:<br>Stage 1: 2023-02-18  
Stage 2: 2023-03-26  
Stage 2.7: NA  
Stage 3: 2023-05-16  
Stage 4: NA<br>Last Commit: 2024-12-05<br>Topics: #arrays #memory #numbers #others #performance<br>Keywords:  #typedarray #memory_management #floating_point #math #performance<br>GitHub Link: https://github.com/tc39/proposal-float16array <br>GitHub Note Link: https://github.com/tc39/notes/blob/HEAD/meetings/2023-05/may-16.md#float16array-for-stage-3
# Proposal Description:
# Float16Array

A proposal to add float16 (aka half-precision or binary16) TypedArrays to JavaScript.

## Status

Authors: Kevin Gibbons

Champions: Leo Balter, Kevin Gibbons

This proposal is at Stage 3 of [The TC39 Process](https://tc39.es/process-document/) as of the May 2023 meeting. It awaits implementations.

Spec text is available [here](https://tc39.es/proposal-float16array/).

## Implementations

This proposal is ready for engines to implement and ship. See [this issue](https://github.com/tc39/proposal-float16array/issues/7) for current status of implementations.

## Motivation

- Explicit request from the Color on the Web CG, for [their use case](https://github.com/w3c/ColorWeb-CG/blob/main/canvas_float.md) with float-backed canvases.
- Useful for GPU operations, where full precision often isn't necessary and memory constraints are serious.
  - WebGPU [supports float16](https://github.com/gpuweb/gpuweb/issues/2512). It exposes/consumes raw ArrayBuffers. When those contain 32-bit floats, [the pattern](https://gpuweb.github.io/gpuweb/explainer/#example-eed014f1) is to wrap the buffer in `new Float32Array(...)`; that doesn't work when they contain 16-bit floats.
  - [Increasingly relevant](https://github.com/huggingface/blog/blob/main/stable_diffusion.md) with new tools like Stable Diffusion, where full-precision representations don't fit in VRAM on many machines.
- WebGL/WebGL2 support float16.
  - WebGL's `OES_texture_half_float` extension and WebGL2 [support float16 texture](https://registry.khronos.org/webgl/extensions/OES_texture_half_float/), and also both `EXT_color_buffer_half_float` extensions [support float16 render target](https://registry.khronos.org/webgl/extensions/EXT_color_buffer_half_float/). They expose/consume Uint16Arrays; that is not easy to handle.
- ARM and IA-32 and Intel® 64 architectures support float16 intrinsics.
  - In the C++23 specification, [`std::float16_t` will be supported](https://en.cppreference.com/w/cpp/types/floating-point) to call the CPU instructions.
- Faking it in userland has [serious performance costs](https://github.com/petamoriken/float16/issues/781).

## Proposal

This would add a new kind of TypedArray, `Float16Array`, to complement the existing `Float32Array` and `Float64Array`. It would also add two new methods on `DataView` for reading and setting float16 values, as `getFloat16` and `setFloat16`, to complement the existing similar methods for working with full and double precision floats, as well as `Math.f16round`, to complement the existing `Math.fround`.

## Userland

[@petramoriken](https://github.com/petamoriken) has [a package implementing `Float16Array`](https://github.com/petamoriken/float16) which gets 100k+ downloads/week [on npm](https://www.npmjs.com/package/@petamoriken/float16). See that repository for examples of some of the limitations and downsides of trying to do this purely in userland - notably the impossibility of integrating correctly with other web platform features like `WebGL`'s `HALF_FLOAT` buffers and `structuredClone`.
<br>