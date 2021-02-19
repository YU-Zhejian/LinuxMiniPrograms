# `code-spec`: How to write readable codes for greenhands.

This is a how-to documentation for those greenhands who have not been taught how to code.

If you've already installed Pandoc (Available from <https://www.pandoc.org/>), you may execute `build.cmd` (Microsoft Windows) or `build.sh` (GNU/Linux) to compile (render) it into HTML. You may also use GNU Make to build multiple targets\* if you know how to use them.

\* Available targets: all, docx, pdf, html

Some of the following texts are adapted from <https://github.com/YU-Zhejian/IBI-ICA-G6>, the first group project I've been into.

Suppose you're working with people with Git.

## General Principles

1. 代码千万行，注释第一行；注释不规范，同事两行泪。
	With thousands of codes the comments are the most important; you will see your colleague weeping with non-standard comments.
	(This line is originated from the movie *Wondering Earth* and appears in every public project of me.)
	
2. This public projects prefers **MERGING** than **REBASING**. If you follow that guideline, you’ll be fine. If you don’t, people will hate you, and you’ll be scorned by friends and family.

	The reason why I write this is because when woring with idiots who can even cause problems when merging, it is wise to kept them out of high-level skills like rebasing, branch-filtering or cherry-picking. Otherwise your repository may boom and you will be blamed for failing to give them a good explain.

3. **NEVER PREFORM FORCE PUSH**. If you accidentally committed and pushed something wrong, fix it as fast as possible and commit \& push it again.

4. Pull before you push, or you will be **rejected** by Git (the ***software***, not me).

5. Beware of merge conflicts, they bite you!

6. **DO NOT ADD ARCHIVES (e. g. Zip).** Use **Markdown/LaTeX** instead of Word or RTF when documenting changes. This allows Git to show what was modified by `git diff` instead of telling us this is a f\*\*ing binary.

7. **THINK TWICE BEFORE YOU COMMIT OR PUSH.**

8. If there are temporary files created by the editor, please add them to `.gitignore` to make Git ignore them.

9. Use **LF** instead of **CRLF** as the line endings. Use UTF-8 instead of ANSI as default encoding. Those who use GNU/Linux will appreciate you. And **DO ADD A NEWLINE CHARACTER AT THE END OF A FILE.** That is, to left the last line of your script **blank**. The reason of doing this is to make your colleagues read the code more easily under a GNU/Linux Terminal by `cat`.

## The Workflow

Our workflow is simple. Just pull-edit-add-commit-push to the master branch.

### Branching

You're encouraged to branch offline, but please **DO NOT PUSH YOUR BRANCH ONLINE**, unless necessary (e. g. Huge disagreement within our team).

Why? Because if you pushed all your branches,

1. The size of our repository will be huge, which will greatly slow Git down.

2. Who will be responsible for merging them to master? It would be weird for me to merge all those branches and deal with those dick-checking conflicts.

So, why do I recommend our centralized model? Please read the following message:

> 我认为直接在master上开发能够分摊merge的压力（谁push不了谁来merge），历史清晰（一条线）且责任明确（出问题了看谁push的就行了）。

### Fork

I do not recommend you to fork our repository--If you're inside this group, please think of a way to merge your commit without creating a pull request (which will be ignored--I am not available to see your request). If you're not, we'll definitely accuse you of performing academic misconduct.

## File In This Folder (FITF) for /

`.gitignore` This file contains a list of patterns. Those files with their filename matching the pattern will be ignored by Git.

`BeforeAdd.sh` This is a bash script which turns `CRLF` into `LF`.

`FITF.md` This file.

`Readme.md` This indicates what is in this folder.

`Formative.md` Our formative ICA's answer.

`docs/` Folder containing documents which may be useful.

## Python Specifications

The following specifications are made to make our code more readable:

1. All `python` file should be ended with extension name `py` and under `python 3`.
2. Use `# TODO: blablabla` when pending to do something.
3. The way of indenting pseudocode should be the same as those uncommented codes.
4. Use **FOUR WHITE SPACE** or **ONE TAB CHARACTER** as indentation.
5. There're **NO** need of adding `#!/usr/bin/env python` at the head of a file. The reason why I add this line is because this enables me to execute the script directly under a GNU/Linux terminal without specifying `python` as my interpreter.

## Recommended Software

Use `Typora` to read & edit Markdown files.

## FAQ

1. Why don't we use `git-flow` on <https://nvie.com/posts/a-successful-git-branching-model/>? It seems to be a mature model of collaborating.

   *Life is short and we should not waste our time like this.*

2. Do you think our current workflow will make this project unstable?

   *No point to be stable--We'll check before handing it on.*

# Readme for the Workflow

## Aim

After this "practical", you should know:

1. The basic idea of "Centralized Workflow" (Chacon, S. and Straub, B. 2018).
2. How to handle conflicts when pushing your commits.

## Backgrounds

### The Emergence of Conflict

When you're about to push your commits to the server, conflicts emerge when your commit is not **fast-forward**. The git server will **Reject** your commit and you should **Merge** what is on the server to your workflow.

e. g. `git clone` on local1

```
Remote 1-->2
	   |   |
Local1 1-->2
```

`git commit` on local1

```
Remote 1-->2
	   |   |
Local1 1-->2-->4
# Your commit is fast-forward. You can push and no conflict will emerge.
```

However, if someone else pushed his/her commits before yours, there will be problems. e. g.

```
Remote 1-->2---->3
	   |   |     |
Local1 1-->2-->4 |
				 |
Local2 1-->2---->3
```

Now, what you should do is to pull others' commit and merge them into your workflow.

### Merge

Sometimes, merge can be done by git automatically. However, this mechanism fails when you and Local2 both modified a specific line. Under that circumstance, you should reopen the file, merge the changes by an editor, add and commit.

## Procedure

1. Open the file `trial.py` and add some words to **the second line**. Stage and commit your changes.
2. Push your changes back to GitHub. If your changes are **NOT** rejected, back to step 1.
3. If your changes are rejected, pull the newest changes from GitHub and merge them properly.
4. *(Optional)* After finishing those steps, do it again by command line interface.

## Please Pay Attention

1. **DO NOT PERFORM FORCE PUSH.** That can destroy the entire repository!
2. USE `LF` instead of `CRLF` in line endings.

## The Code

These code should be typed into a GNU/Linux terminal. You do not need to append them to `trial.py`.

````bash
git pull
notepad workflow/trial.py
git add .
git commit -m "YOUR COMMIT MESSAGE"
git push
````

If there are conflicts:

````bash
git pull
# Here you should see an error message.
notepad workflow/trial.py
git add .
git commit -m "YOUR COMMIT MESSAGE"
git push
````

You can use `git status` to check if there are conflicts to be solved.

## Reference

Chacon, S. and Straub, B. (2018) *Pro Git 2.1.87*, APress. doi: 10.1007/978-1-4842-0076-6. Available from <https://git-scm.com/book/en/v2>, last accessed 2021-02-19.
