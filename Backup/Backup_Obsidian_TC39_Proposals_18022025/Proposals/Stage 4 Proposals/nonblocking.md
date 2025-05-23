#Stage4Tag
Classification: [[API Change]]
Human Validated: KW
Title: Atomics.waitAsync
Authors: Lars Hansen
Champions: Shu-yu Guo, Lars Hansen
Date: May 2023
Last Commit: 2021-03-31
Expected Publication Year: 2024
GitHub Link: https://github.com/tc39/proposal-atomics-wait-async
GitHub Note Link: https://github.com/tc39/notes/blob/HEAD/meetings/2023-05/may-15.md#atomicswaitasync-for-stage-4

# Proposal Description:
# Asynchronous atomic wait for ECMAScript

A proposal for an "asynchronous atomic wait" for ECMAScript, primarily
for use in agents that are not allowed to block.

Champions: Shu-yu Guo (Google) and Lars T Hansen (Mozilla).

## Historical documents

Warning: The following documents are no longer being updated and are of
historical interest only.

See [PROPOSAL.md](PROPOSAL.md) for the evolving proposal text,
[polyfill.js](polyfill.js) for a simple polyfill implementation, and
[example.html](example.html) for some examples and test cases; this
file uses the polyfill.
