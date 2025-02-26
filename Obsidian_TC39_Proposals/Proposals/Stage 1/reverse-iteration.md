[[Stage 1]]<br>Classification: [[Syntactic Change]]<br>Human Validated: No<br>Title: Reverse iteration<br>Authors: Leo Balter, Jordan Harband<br>Champions: Leo Balter, Jordan Harband<br>Last Presented: July 2019<br>Stage Upgrades:<br>Stage 1: 2019-07-23  
Stage 2: NA  
Stage 2.7: NA  
Stage 3: NA  
Stage 4: NA<br>Last Commit: 2019-07-23<br>Keywords: #repository #template #proposal #github #merge #git #commit #output #hook #spec<br>GitHub Link: https://github.com/tc39/proposal-reverseIterator <br>GitHub Note Link: https://github.com/tc39/notes/blob/HEAD/meetings/2019-07/july-23.md#symbolreverse
# Proposal Description:
# template-for-proposals

A repository template for ECMAScript proposals.

## Before creating a proposal

Please ensure the following:
  1. You are a member of TC39
  1. You have read the [process document](https://tc39.github.io/process-document/)
  1. You have reviewed the [existing proposals](https://github.com/tc39/proposals/)

## Create your proposal repo

Follow these steps:
  1.  Create your own repo, clone this one, and copy its contents into your repo. (Note: Do not fork this repo in GitHub's web interface, as that will later prevent transfer into the TC39 organization)
  1.  Go to your repo settings “Options” page, under “GitHub Pages”, and set the source to the **master branch** and click Save.
      1. Ensure "Issues" is checked.
      1. Also, you probably want to disable "Wiki" and "Projects"
  1.  Avoid merge conflicts with build process output files by running:
      ```sh
      git config --local --add merge.output.driver true
      git config --local --add merge.output.driver true
      ```
  1.  Add a post-rewrite git hook to auto-rebuild the output on every commit:
      ```sh
      cp hooks/post-rewrite .git/hooks/post-rewrite
      chmod +x .git/hooks/post-rewrite
      ```

## Maintain your proposal repo

  1. Make your changes to `spec.emu` (ecmarkup uses HTML syntax, but is not HTML, so I strongly suggest not naming it ".html")
  1. Any commit that makes meaningful changes to the spec, should run `npm run build` and commit the resulting output.
  1. Whenever you update `ecmarkup`, run `npm run build` and commit any changes that come from that dependency.
<br>