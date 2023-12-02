---
scope: learn
draft: true
title: Git 教程
author: 
created: 2022-07-25 13:38
updated: <%+~ tp.file.last_modified_date() %>
tags: 
lang: ["zh-cn", "en-us"]
---

# Git 学习资料

## 文档

[Git - Reference](https://git-scm.com/docs)

[Complete list of all commands](https://git-scm.com/docs/git#_git_commands)

## Git Book

[Git - Book](https://git-scm.com/book/en/v2)

[Git教程 - 廖雪峰的官方网站](https://www.liaoxuefeng.com/wiki/896043488029600)

## Git 原理

[Git for Computer Scientists](https://eagain.net/articles/git-for-computer-scientists/)

[Git Source Code Review](https://fabiensanglard.net/git_code_review/diff.php)

# Git 的玩法

## Git 相关命令的中文显示

Git 在显示中文文件或信息时，默认情况下可能会以字节的十进制值形式显示，而不是直接显示中文字符。为了使 Git 显示中文，你可以设置 `core.quotepath` 配置项为 `false`。

你可以通过以下命令来设置：

```bash
git config --global core.quotepath false
```

这将会允许 Git 在输出中正常显示中文字符，而不是以字节的十进制值形式显示。

## Git 代理

[Git设置代理 - 简书](https://www.jianshu.com/p/739f139cf13c)

## 使用 Git Attributes

[Git - Git Attributes](https://git-scm.com/book/en/v2/Customizing-Git-Git-Attributes#Binary-Files)

[Git - gitattributes Documentation](https://git-scm.com/docs/gitattributes)

## 如何保证 `.gitignore` 文件正确反映了你的意图？

`git ls-files` 是一个底层 API，但是最近用过之后感觉很有用。因为在 `.gitignore` 文件里写的匹配表达式往往要么范围太大导致错误地忽略了需要控制版本的文件，要么匹配范围太小需要排除的文件还是出现在远程仓库中。

[Git - git-ls-files Documentation](https://git-scm.com/docs/git-ls-files)

`ls-files` 命令提供了列出文件的各种功能，其中有一个 `-i --ignore` 选项可以让我们查看排除的文件。他需要和 `-c/-o`配合使用，让 Git知道你是要查看 已经被索引缓存的文件（`-c`）还是未跟踪的文件（`-o`）？要验证我们的 `.gitignore` 文件还需要通过 `-X | --exclude-from` 参数输入 `.gitignore` 文件所在的位置。

这样一来就我们就可以查看，仓库中有哪些文件是应该排除但是却被 Git 索引缓存的？

```bash
git ls-files -icx .gitignore
# 或者
git ls-files -ic --exclude-from .gitignore
```

本地仓库中有哪些文件是应该排除而且正确地被 Git 设置为不跟踪的？如果你想要排除的文件都出现在这里，而需要版本控制的文件都没有出现，就说明 `.gitignore` 针对仓库现在的状况是正确地。

```bash
git ls-files -iox .gitignore
```

## 如何让 Git 只跟踪文件的添加、删除、重命名？

Git 管理大文件：

[How to manage binary blobs with Git | Opensource.com](https://opensource.com/life/16/8/how-manage-binary-blobs-git-part-7)

[git annex walkthrough](https://git-annex.branchable.com/walkthrough/)

[Keep file in a Git repo, but don't track changes - Stack Overflow](https://stackoverflow.com/questions/9794931/keep-file-in-a-git-repo-but-dont-track-changes)

[git index - Git - Difference Between 'assume-unchanged' and 'skip-worktree' - Stack Overflow](https://stackoverflow.com/questions/13630849/git-difference-between-assume-unchanged-and-skip-worktree#)

[symlink - git assume unchanged vs skip worktree - ignoring a symbolic link - Stack Overflow](https://stackoverflow.com/questions/6138076/git-assume-unchanged-vs-skip-worktree-ignoring-a-symbolic-link)

[gitignore - git ignore vs. exclude vs. assume-unchanged - Stack Overflow](https://stackoverflow.com/questions/23097368/git-ignore-vs-exclude-vs-assume-unchanged/23305143#23305143)

[Git - git-update-index Documentation](https://git-scm.com/docs/git-update-index)

### `--skip-worktree` 配置项

[SKIP WORKTREE](https://git-scm.com/docs/git-update-index#_skip_worktree_bit)

`SKIP WORKTREE` 的作用可以描述为：让 Git 避免修改某个目录树下的文件。这个选项原本是为了支持`sparse checkout` 的实现，让用户能够只提取整个仓库目录树的一个子集。设置了 `SKIP WORKTREE` 之后，`switch`、`pull`、`merge` 之类的 Git 命令会避免修改对应的路径。但是如果在一些特殊的情况，比如 `merge` 或者 `rebase` 过程中出现冲突，这些标记了 `SKIP WORKTREE` 的路径还是有可能被修改。如果这个目录下有些文件不存在了，Git 也会把这些文件当做是故意删除，也就是说如果你删除了一些文件，在执行 `git add -u` 命令之后这些文件也不会被加入到暂存区，`git commit -a` 也不会提交对这些文件的删除操作。

在 `sparse checkout` 之后，如果一个文件在索引中有 `SKIP WORKTREE` 标记但是却出现在了工作路径中，Git 就会从索引中清除这个文件的 `SKIP WORKTREE` 标记。

要注意不是所有 Git 命令都会检查这个选项，也有些命令只有对 `SKIP WORKTEE` 的部分支持。与 skip-worktree 位相关的更新索引标志和读取树功能早于 [git-sparse-checkout[1]](https://git-scm.com/docs/git-sparse-checkout)命令的引入，该命令提供了一种更简单的方式来配置和处理 skip-worktree 位。如果您想减少工作树以仅处理存储库中文件的子集，我们强烈建议使用 [git-sparse-checkout[1]](https://git-scm.com/docs/git-sparse-checkout)优先于低级 update-index 和 read-tree 原语.

### `--assume-unchanged` 配置项

[ASSUME UNCHANGED BIT](https://git-scm.com/docs/git-update-index#_using_assume_unchanged_bit)

`assume-unchanged` 是因为性能问题设置的。很多 Git 操作都依赖高效的 `lstat (2)` 系统调用，以便简单快速地查看 `st_mtime` 信息，和 Git 索引文件记录的版本比较、判断文件内容是否改变。如果文件系统调用的性能不好，可以对一些路径设置 `assume unchanged` 比特。Git 对设置假定未修改的路径不会做任何检查判断文件是否修改，所以如果修改了相应的路径，要记得把 `assume unchanged` 选项关闭。

通过 `--assume-unchanged` 选项开启 `ASSUME UNCHANGED` 标记，通过 `--no-assume-unchanged` 清除标记。`git ls-files -v` 的输出也可以判断是否有 `ASSUME UNCHANGED` 标记。

`update-index` 命令会检查 `core.ignorestart` 配置，如果设置为 `true` 的话，通过`git update-index paths...`命令以及其他操作索引和工作路径的命令(e.g. *git apply --index*, *git checkout-index -u*, and *git read-tree -u*) 修改的路径会自动被标记为 `ASSUME UNCHANGED`。

如果 `git update-index --refresh` 命令发现工作路径文件和索引中一致，就会取消掉 `ASSUME UNCHANGED` 标记。

### 二者的区别

来自 Git 文档：

虽然说 `SKIP WORKTREE` 和 `ASSUME UNCHANGED` 听起来挺像，但他们的目标不同。`ASSUME UNCHANGED` 是让文件保留在工作路径但是认为这些文件不会被修改，也就不会检查文件的改动（通过系统调用 `lstat (2)`）。而 `SKIP WORKTREE` 则是如果标记了 `SKIP WORKTREE` 的路径下如果有文件不存在了，也不会更新这个路径、不会把文件的缺失或删除记录和提交。

来自 STACKOVERFLOW：

[git index - Git - Difference Between 'assume-unchanged' and 'skip-worktree' - Stack Overflow](https://stackoverflow.com/questions/13630849/git-difference-between-assume-unchanged-and-skip-worktree#)

`assume-unchanged` 是针对底层文件系统调用效率太低的情况设计的，不能有太多 `stat` 调用来判断文件是否改变。设置了 `ASSUME UNCHANGED` 位以后 Git 直接认为索引中文件所对应的工作路径中的文件副本没有改动，所以避免了大量的文件系统调用。一旦索引中的文件条目发生改变，这个位就会重置（比如 远程`upstream` 中的文件改变）。

`skip-worktree` 不一样：即使 Git 知道文件已经改变（或者需要通过 `reset -hard` 之类的命令来修改），它也不会去修改，而是使用 Git 索引中的版本。`SKIP WORKTREE` 只要不手动清除，它的作用一直持续到索引被丢弃。

### 适用场景

There is a good summary of the ramifications of this difference and the typical use cases here: [http://fallengamer.livejournal.com/93321.html](http://fallengamer.livejournal.com/93321.html) .

From that article:

- `--assume-unchanged` assumes that a developer **shouldn’t** change a file. This flag is meant for **improving performance** for not-changing folders like SDKs.
- `--skip-worktree` is useful when you instruct git not to touch a specific file ever because developers **should** change it. For example, if the main repository upstream hosts some production-ready **configuration files** and you don’t want to accidentally commit changes to those files, `--skip-worktree` is exactly what you want.

| Operation | File with assume-unchanged flag | File with skip-worktree flag | Comments |
|-----------|---------------------------------|------------------------------|----------|
| # File is changed both in local repository and upstream `git pull` | Git wouldn’t overwrite local file. Instead it would output conflicts and advices how to resolve them. | Git wouldn’t overwrite local file. Instead it would output conflicts and advices how to resolve them. | Git preserves local changes anyway. Thus you wouldn’t accidently lose any data that you marked with any of the flags. |
| # File is changed both in local repository and upstream, trying to pull anyway `git stash` `git pull` | Discards all local changes without any possibility to restore them. The effect is like ‘git reset --hard’. ‘git pull’ call will succeed. | Stash wouldn’t work on skip-worktree files. ‘git pull’ will fail with the same error as above. Developer is forced to manually reset skip-worktree flag to be able to stash and complete the failing pull. | Using skip-worktree results in some extra manual work but at least you wouldn’t lose any data if you had any local changes. |
| # No local changes, upstream file changed `git pull` | Content is updated, flag is lost. ‘git ls-files -v’ would show that flag is modified to H (from h). | Content is updated, flag is preserved. ‘git ls-files -v' would show the same S flag as before the pull. | Both flags wouldn’t prevent you from getting upstream changes. Git detects that you broke assume-unchanged promise and choses to reflect the reality by resetting the flag. |
| # With local file changed `git reset --hard` | File content is reverted. Flag is reset to H (from h). | File content is intact. Flag remains the same. | Git doesn’t touch skip-worktree file and reflects reality (the file promised to be unchanged actually was changed) for assume-unchanged file. |

分析

看起来**skip-worktree**正在非常努力地保存您的本地数据。但是，如果它是安全的，它不会阻止您获取上游更改。另外 git 不会在 pull 时重置标志。但是忽略“reset --hard”命令可能会令开发人员大吃一惊。

**Assume-unchanged**标志可能会在拉取操作中丢失，并且此类文件中的本地更改似乎对 git 并不重要。

上面的两个陈述都与 git 邮件存档相对应：

[http://thread.gmane.org/gmane.comp.version-control.git/146082](http://thread.gmane.org/gmane.comp.version-control.git/146082) - Junio（当前的 git 维护者）关于假设不变的意图的评论。

[http://osdir.com/ml/git/2009-12/msg01123.html](http://osdir.com/ml/git/2009-12/msg01123.html) - 在添加 skip-worktree 补丁时在 git 邮件列表中讨论的假设不变和 skip-worktree 之间的区别。

实际上，这两个标志都不够直观。**Assume-unchanged**假定开发人员不应该更改文件。如果一个文件被改变了——那么这个改变并不重要。此标志旨在提高 SDK 等不更改文件夹的性能。但是如果承诺被破坏并且文件实际上被更改，git 会恢复标志以反映现实。可能在通常不打算更改的文件夹中有一些不一致的标志是可以的。另一方面**跳过工作树**当您指示 git 永远不要触摸特定文件时很有用。这对于已经跟踪的配置文件很有用。上游主存储库托管一些生产就绪配置，但您希望更改配置中的一些设置以便能够进行一些本地测试。并且您不想意外检查此类文件中的更改以影响生产配置。在这种情况下，**skip-worktree**是完美的场景。

### `.gitignore`、`exclude` 和 `--assume-unchanged`

I"m going to accept [this emailed answer from Junio Hamano](http://git.661346.n2.nabble.com/gitignore-vs-exclude-vs-assume-unchanged-td7607901.html) (the maintainer of Git) because I think it explains some things more lucidly than the official docs, and it can be taken as "official" advice:

> The .gitignore and .git/info/exclude are the two UIs to invoke the same mechanism. In-tree .gitignore are to be shared among project members (i.e. everybody working on the project should consider the paths that match the ignore pattern in there as cruft). On the other hand, .git/info/exclude is meant for personal ignore patterns (i.e. you, while working on the project, consider them as cruft).
>
> Assume-unchanged should not be abused for an ignore mechanism. It is "I know my filesystem operations are slow. I"ll promise Git that I won"t change these paths by making them with that bit---that way, Git does not have to check if I changed things in there every time I ask for "git status" output". It does not mean anything other than that. Especially, it is _not_ a promise by Git that Git will always consider these paths are unmodified---if Git can determine a path that is marked as assume-unchanged has changed without incurring extra lstat(2) cost, it reserves the right to report that the path _has been_ modified (as a result, "git commit -a" is free to commit that change).

## 如何只推送某些提交？

[(154条消息) git push某个或某些特定提交_刘文壮的博客-CSDN博客_git push 指定commit](https://blog.csdn.net/u010730126/article/details/100743019)

## Git 操作

### 提交模板

[Git Commit Template 提交模板 - 野渡 - 博客园](https://www.cnblogs.com/yeduweichengzhaoyu/p/14330682.html)

1. 项目根目录下设置提交模版commit.template，文件名为：commit_template
内容如下：

```
feat|fix|docs|test|(<scope>): <subject> #TASK_NAME
<BLANK LINE>
<body>
<BLANK LINE>
In Progress|Closes:[#TASK_NAME](http://)
```

- `feat`: 新功能
- `fix`: 修复bug
- `docs`: 只有文档改变
- `style`: 并没有影响代码的意义(空格，去掉分号，格式的修改等)
- `refactor`: 代码的修改并没有修改bug，也没有添加新功能
- `perf`: 代码的修改提高的性能
- `test`: 添加测试
- `chore`: 构建过程或构建工具的改变(并没有生产环境代码的改变)

2. 运行git命令，设置模板

```Bash
git config --global commit.template /E/my-project/commit/_template
```

3. 执行git add 文件
4. git commit
5. 进入模板填写页面，填写完信息后，`esc` 键退出插入模式，`:wq`退出编辑并保存信息。
6. git push

![](image-20220725051609583.png)

### Git Notes

[Git - git-notes Documentation](https://git-scm.com/docs/git-notes)

Git Notes 的典型使用是不改变提交本身而能补充一些附加的提交消息。使用 `git log` 命令查看历史提交时也会显示提交对应的 Note，在 Note 内容之前会有顶格输出的"Note:"字样，跟提交消息区分开来。

Notes 也可以通过 `git format-patch` 的 `--notese` 选项被添加到 补丁上。

### 清理 Git 版本库

[Git - git-gc 文档](https://git-scm.com/docs/git-gc)

[git clean - Reduce git repository size - Stack Overflow](https://stackoverflow.com/questions/2116778/reduce-git-repository-size)

[Git - git-clean Documentation](https://git-scm.com/docs/git-clean)

[blog.felipebalbi.com » Blog Archive » Housekeeping your git repository](http://web.archive.org/web/20090219000020/http://blog.felipebalbi.com/?p=39)

[file - How to remove unused objects from a git repository? - Stack Overflow](https://stackoverflow.com/questions/3797907/how-to-remove-unused-objects-from-a-git-repository/14729486#14729486)

`git gc` 在当前版本库内运行一系列维护操作，包括压缩文件修订记录来减少磁盘占用、提高文件系统性能，从索引中删除过去通过 `git add` 命令被添加但是已经不存在的对象，打包 `refs`，清除 `reflog`、`rerere` 元数据和陈旧的工作树。还可以更新辅助索引，例如提交图。

- [diff](https://git-scm.com/docs/git-diff)
- [difftool](https://git-scm.com/docs/git-difftool)
- [range-diff](https://git-scm.com/docs/git-range-diff)

### 从 Git 历史中永久删除文件

[Removing sensitive data from a repository - GitHub Docs](https://docs.github.com/cn/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository)

GitHub 提供了两种：

- 使用 开源软件 BFG Repo-Cleaner，删除文件后强制推送。
- 使用 git-filter-repo
Git 本身有 `filter-branch` 命令可以改写一个分支的历史记录，但是文档里写了不推荐使用。而是推荐用 `git-filter-repo`。
这里选择了 `git filter-repo` 尝试。Windows 系统需要用 pip 安装，所以要先下载安装一个 Python。装好以后通过 pip 安装 `git-filter-repo`。

```bash
pip install git-filter-repo
```

![](image-20220726172555463.png)

安装好以后按照 GitHub 从仓库删除敏感数据的指引操作。[Removing sensitive data from a repository - GitHub Docs](https://docs.github.com/cn/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository#using-git-filter-repo)

首先进入源码根目录，执行命令。这一步对 Git 仓库做了很多改动：

- 强制 Git 处理一次所有分支和标签的全部历史记录
- 删除所有相关的文件，以及生成的空白提交
- 删除 `.git/config` 等配置文件。尤其是远程仓库的 URL 会被删除。
- 重写你所有的标签（ `tags` ）。
这一步指定需要把 `PATH-TO-YOUR-FILE-WITH-SENSITIVE-DATA` 改成你自己的路径。如果有多个文件也可以使用 多个 `--path` 参数分别指定路径，还可以使用正则表达式的路径匹配 `--path-regex`。
运行前建议加上 `--dry-run` 参数查看设定的删除文件是否正确。

```shell
git filter-repo --invert-paths --path PATH-TO-YOUR-FILE-WITH-SENSITIVE-DATA

git filter-repo --invert-paths "offlineDictionary.json" --path-regex ".*\.(pdf|docx|doc|xls|xlsx|pptx|ppt|csv|rtf|mp4)" --use-base-name --dry-run
```

删除以后，把路径下所有不需要删除的文件加入 Git 版本控制，然后提交。

```shell
$ echo "YOUR-FILE-WITH-SENSITIVE-DATA" >> .gitignore
$ git add .gitignore
$ git commit -m "Add YOUR-FILE-WITH-SENSITIVE-DATA to .gitignore"
> [main 051452f] Add YOUR-FILE-WITH-SENSITIVE-DATA to .gitignore
>  1 files changed, 1 insertions(+), 0 deletions(-)
```

确认删除了需要删除的文件、也没有误删其他文件的话，就可以强制提交到远程仓库了。

如果远程仓库有标签或者发行版，需要再次强制推送所有标签。

```shell
git push origin --force --tags
```

`git-filter-repo` 的示例用法：[git-filter-repo(1)](https://htmlpreview.github.io/?https://github.com/newren/git-filter-repo/blob/docs/html/git-filter-repo.html#EXAMPLES)

### 恢复版本库中误删的文件

[Git - git-log Documentation](https://git-scm.com/docs/git-log)

`git log` 是一个很方便的命令，除了显示提交历史以外还可以根据输入的路径或文件，找出对它们做了修改的历史提交。

#### Log 输出格式

`git log` 对每个提交的输出提交信息和本次提交修改的内容。通过 `--format` 选项可以控制提交信息的输出格式：[`--format`](https://git-scm.com/docs/git-log#Documentation/git-log.txt---formatltformatgt)

Pretty-print the contents of the commit logs in a given format, where `<format>` can be one of `oneline`, `short`, `medium`, `full`, *`fuller`*, *`reference`*, *`email`*, *`raw`*, *`format:<string>`* and *`tformat:<string>`*. When *`<format>`* is none of the above, and has *`%placeholder`* in it, it acts as if `--pretty=tformat:<format>` were given.

See the "PRETTY FORMATS" section for some additional details for each format. When *`=<format>`* part is omitted, it defaults to *`medium`*.

[Git - git-log Documentation](https://git-scm.com/docs/git-log#_pretty_formats): <https://git-scm.com/docs/git-log#_pretty_formats>

Note: you can specify the default pretty format in the repository configuration (see [git-config (1)](https://git-scm.com/docs/git-config)).

#### `--diff-filter` 过滤修改类型

通过 `--diff-filter` 选项还可以设置跟踪哪些类型的修改比如添加 (`A`)、删除 (`D`)，用对应的小写字母来表示排除一种修改类型。Git 中所有修改类型包括：添加 ( `A` )、复制 ( `C` )、删除 ( `D` )、修改文件内容 ( `M` )、重命名 ( `R` )、改变文件类型 ( `T` ，包括常规文件、符号链接、子模块等……)、未合并 ( `M` )、未知修改类型 ( `X` )和 Paring Broken ( `B` )。

看下面两个例子，一个是查看添加和删除 `path1` 目录下文件的历史提交，另一个是查看修改`path1` 目录下文件的历史提交中不属于添加和删除操作的部分。

```bash
# 找出添加或删除了 path1 目录下文件的提交
git log --name-status --diff-filter=AD --format=oneline path1

# 找出修改 path1 目录的提交中不属于 添加(A)和删除(D)的部分
git log --name-status --diff-filter=ad --format=oneline path1
```

#### `-p`、`-u` 和 `--patch` 创建补丁

通过创建补丁的选项，我们结合上面的例子就可以把整个版本库中关于某些文件的改动历史打成补丁，然后通过 `git apply` 命令把这些修改恢复过来。这对误删文件的场景十分有用。

```bash
# 创建补丁
git log -p -raw --diff-filter=A path1/deleted_file1 path2/*.the_type_of_deleted_files >patch
# 从补丁恢复文件
git apply patch
```

恢复文件后就可以把补丁文件删掉，然后把恢复回来的文件加入版本控制中，让版本库恢复到正常的状态。

### 通过 Git Rerere 处理冲突

[Git - Rerere](https://git-scm.com/book/en/v2/Git-Tools-Rerere)

### Git 重命名远程分支

The default branch has been renamed!

`githubSync/main` is now named main

If you have a local clone, you can update it by running the following commands.

```bash
git branch -m githubSync/main main
git fetch origin
git branch -u origin/main main
git remote set-head origin -a
```

[(152条消息) Git的基本使用,Github远程仓库的管理,obsidian Git插件的使用_等风也等你丶的博客-CSDN博客](https://blog.csdn.net/xbb2015011326/article/details/119544380)

### IDEA Shelve 和 Git Stash

[Use Git to work on several features simultaneously | IntelliJ IDEA](https://www.jetbrains.com/help/idea/2022.1/work-on-several-features-simultaneously.html#stash)

### Git Hook

[JELLY | 用 Git 钩子进行简单自动部署](https://jelly.jd.com/article/6006b1045b6c6a01506c87e1)

# Git 完整命令列表

[Git - git Documentation](https://git-scm.com/docs/git#_git_commands)

## 高级 API

### Main Porcelain Commands 主要命令

| 命令名称        | 描述                                                               |     |
| --------------- | ------------------------------------------------------------------ | --- |
| add             | Add file contents to the index                                     |     |
| am              | Apply a series of patches from a mailbox                           |     |
| archive         | Create an archive of files from a named tree                       |     |
| bisect          | Use binary search to find the commit that introduced a bug         |     |
| branch          | List, create, or delete branches                                   |     |
| bundle          | Move objects and refs by archive                                   |     |
| checkout        | Switch branches or restore working tree files                      |     |
| cherry-pick     | Apply the changes introduced by some existing commits              |     |
| citool          | Graphical alternative to git-commit                                |     |
| clean           | Remove untracked files from the working tree                       |     |
| clone           | Clone a repository into a new directory                            |     |
| commit          | Record changes to the repository                                   |     |
| describe        | Give an object a human readable name based on an available ref     |     |
| diff            | Show changes between commits, commit and working tree, etc         |     |
| fetch           | Download objects and refs from another repository                  |     |
| format-patch    | Prepare patches for e-mail submission                              |     |
| gc              | Cleanup unnecessary files and optimize the local repository        |     |
| gitk            | The Git repository browser                                         |     |
| grep            | Print lines matching a pattern                                     |     |
| gui             | A portable graphical interface to Git                              |     |
| init            | Create an empty Git repository or reinitialize an existing one     |     |
| log             | Show commit logs                                                   |     |
| maintenance     | Run tasks to optimize Git repository data                          |     |
| merge           | Join two or more development histories together                    |     |
| mv              | Move or rename a file, a directory, or a symlink                   |     |
| notes           | Add or inspect object notes                                        |     |
| pull            | Fetch from and integrate with another repository or a local branch |     |
| push            | Update remote refs along with associated objects                   |     |
| range-diff      | Compare two commit ranges (e.g. two versions of a branch)          |     |
| rebase          | Reapply commits on top of another base tip                         |     |
| reset           | Reset current HEAD to the specified state                          |     |
| restore         | Restore working tree files                                         |     |
| revert          | Revert some existing commits                                       |     |
| rm              | Remove files from the working tree and from the index              |     |
| shortlog        | Summarize 'git log' output                                         |     |
| show            | Show various types of objects                                      |     |
| sparse-checkout | Initialize and modify the sparse-checkout                          |     |
| stash           | Stash the changes in a dirty working directory away                |     |
| status          | Show the working tree status                                       |     |
| submodule       | Initialize, update or inspect submodules                           |     |
| switch          | Switch branches                                                    |     |
| tag             | Create, list, delete or verify a tag object signed with GPG        |     |
| worktree        | Manage multiple working trees                                      |     |

### Ancillary Commands / Manipulators 辅助的操纵类命令

|     | 命令名称        | 描述                                                               |
| --- | --------------- | ------------------------------------------------------------------ |
|  | config | Get and set repository or global options |
|  | fast-export | Git data exporter |
|  | fast-import | Backend for fast Git data importers |
|  | filter-branch | Rewrite branches |
|  | mergetool | Run merge conflict resolution tools to resolve merge conflicts |
|  | pack-refs | Pack heads and tags for efficient repository access |
|  | prune | Prune all unreachable objects from the object database |
|  | reflog | Manage reflog information |
|  | remote | Manage set of tracked repositories |
|  | repack | Pack unpacked objects in a repository |
|  | replace | Create, list, delete refs to replace objects |

### Ancillary Commands / Interrogators 审查类命令

|     | 命令名称        | 描述                                                               |
| --- | --------------- | ------------------------------------------------------------------ |
|  | annotate | Annotate file lines with commit information |
|  | blame | Show what revision and author last modified each line of a file |
|  | bugreport | Collect information for user to file a bug report |
|  | count-objects | Count unpacked number of objects and their disk consumption |
|  | difftool | Show changes using common diff tools |
|  | fsck | Verifies the connectivity and validity of the objects in the database |
|  | gitweb | Git web interface (web frontend to Git repositories) |
|  | help | Display help information about Git |
|  | instaweb | Instantly browse your working repository in gitweb |
|  | merge-tree | Show three-way merge without touching index |
|  | rerere | Reuse recorded resolution of conflicted merges |
|  | show-branch | Show branches and their commits |
|  | verify-commit | Check the GPG signature of commits |
|  | verify-tag | Check the GPG signature of tags |
|  | whatchanged | Show logs with difference each commit introduces |

### Interacting with Others 协作类命令

|     | 命令名称        | 描述                                                               |
| --- | --------------- | ------------------------------------------------------------------ |
|  | archimport | Import a GNU Arch repository into Git |
|  | cvsexportcommit | Export a single commit to a CVS checkout |
|  | cvsimport | Salvage your data out of another SCM people love to hate |
|  | cvsserver | A CVS server emulator for Git |
|  | imap-send | Send a collection of patches from stdin to an IMAP folder |
|  | p4 | Import from and submit to Perforce repositories |
|  | quiltimport | Applies a quilt patchset onto the current branch |
|  | request-pull | Generates a summary of pending changes |
|  | send-email | Send a collection of patches as emails |
|  | svn | Bidirectional operation between a Subversion repository and Git |

## 低级 API

### Manipulators 操纵类命令

|     | 命令名称        | 描述                                                               |
| --- | --------------- | ------------------------------------------------------------------ |
|  | apply | Apply a patch to files and/or to the index |
|  | checkout-index | Copy files from the index to the working tree |
|  | commit-graph | Write and verify Git commit-graph files |
|  | commit-tree | Create a new commit object |
|  | hash-object | Compute object ID and optionally creates a blob from a file |
|  | index-pack | Build pack index file for an existing packed archive |
|  | merge-file | Run a three-way file merge |
|  | merge-index | Run a merge for files needing merging |
|  | mktag | Creates a tag object with extra validation |
|  | mktree | Build a tree-object from ls-tree formatted text |
|  | multi-pack-index | Write and verify multi-pack-indexes |
|  | pack-objects | Create a packed archive of objects |
|  | prune-packed | Remove extra objects that are already in pack files |
|  | read-tree | Reads tree information into the index |
|  | symbolic-ref | Read, modify and delete symbolic refs |
|  | unpack-objects | Unpack objects from a packed archive |
|  | update-index | Register file contents in the working tree to the index |
|  | update-ref | Update the object name stored in a ref safely |
|  | write-tree | Create a tree object from the current index |

### Interrogators 审查类命令

|     | 命令名称        | 描述                                                               |
| --- | --------------- | ------------------------------------------------------------------ |
|  | cat-file | Provide content or type and size information for repository objects |
|  | cherry | Find commits yet to be applied to upstream |
|  | diff-files | Compares files in the working tree and the index |
|  | diff-index | Compare a tree to the working tree or index |
|  | diff-tree | Compares the content and mode of blobs found via two tree objects |
|  | for-each-ref | Output information on each ref |
|  | for-each-repo | Run a Git command on a list of repositories |
|  | get-tar-commit-id | Extract commit ID from an archive created using git-archive |
|  | ls-files | Show information about files in the index and the working tree |
|  | ls-remote | List references in a remote repository |
|  | ls-tree | List the contents of a tree object |
|  | merge-base | Find as good common ancestors as possible for a merge |
|  | name-rev | Find symbolic names for given revs |
|  | pack-redundant | Find redundant pack files |
|  | rev-list | Lists commit objects in reverse chronological order |
|  | rev-parse | Pick out and massage parameters |
|  | show-index | Show packed archive index |
|  | show-ref | List references in a local repository |
|  | unpack-file | Creates a temporary file with a blob's contents |
|  | var | Show a Git logical variable |
|  | verify-pack | Validate packed Git archive files |

### Syncing Repositories 同步命令

|     | 命令名称        | 描述                                                               |
| --- | --------------- | ------------------------------------------------------------------ |
|  | daemon | A really simple server for Git repositories |
|  | fetch-pack | Receive missing objects from another repository |
|  | http-backend | Server side implementation of Git over HTTP |
|  | send-pack | Push objects over Git protocol to another repository |
|  | update-server-info | Update auxiliary info file to help dumb servers |

### Internal Helpers 内部 API

|     | 命令名称        | 描述                                                               |
| --- | --------------- | ------------------------------------------------------------------ |
|  | check-attr | Display gitattributes information |
|  | check-ignore | Debug gitignore / exclude files |
|  | check-mailmap | Show canonical names and email addresses of contacts |
|  | check-ref-format | Ensures that a reference name is well formed |
|  | column | Display data in columns |
|  | credential | Retrieve and store user credentials |
|  | credential-cache | Helper to temporarily store passwords in memory |
|  | credential-store | Helper to store credentials on disk |
|  | fmt-merge-msg | Produce a merge commit message |
|  | interpret-trailers | Add or parse structured information in commit messages |
|  | mailinfo | Extracts patch and authorship from a single e-mail message |
|  | mailsplit | Simple UNIX mbox splitter program |
|  | merge-one-file | The standard helper program to use with git-merge-index |
|  | patch-id | Compute unique ID for a patch |
|  | sh-i18n | Git's i18n setup code for shell scripts |
|  | sh-setup | Common Git shell script setup code |
|  | stripspace | Remove unnecessary whitespace |

### External Commands

askyesno

credential-helper-selector

flow

lfs

update-git-for-windows

# Git 配置项

[Git 配置](Git%20配置.md)

`core.fileMode` 是控制 Git 是否保留文件的执行权限。
