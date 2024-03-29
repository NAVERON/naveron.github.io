---
title: git
layout: post
parent: program
---

git  
{: .label }

# git

## git 资料

> Git 官网地址 : [https://git-scm.com](https://git-scm.com)  
> Git 各平台可视化操作客户端 : [https://git-scm.com/downloads/guis](https://git-scm.com/downloads/guis)  
> 官方git指导书 : [Git probook](https://git-scm.com/book/en/v2)  
> ...

**本学习摘录自以下教程, 仅提供学习**  

> 在线动画演示和练习操作git的网站 [https://github.com/pcottle/learnGitBranching](https://github.com/pcottle/learnGitBranching) : [Learn Git Branching](https://learngitbranching.js.org)  

## git 命令 

### git 本地分支

#### 创建分支

```shell
git branch xxx # 创建一个分支, 但是不切换到锌粉之
git checkout -b xxx # 创建并切换新分支 
```

#### 撤销变更

一般有2个命令, `git reset` `git revert`, reset命令彻底删除更改, 回退上一个版本, revert新增一个提交, 表示某一个提交撤回  
一般本地自己的提交使用`reset`命令删除, 远程主库使用`revert`命令, 用来告诉所有人撤销信息  s

#### 修改一些commit

- `cherry-pick` 命令, 挑选提交新增到目标分支  
- `rebase -i/--interactive` 命令, 可以修改多个提交的顺序, 删除某个多余的提交, 病休该提交语句message  
- `git commit --amend` 可以修改最近一次提交的message
- `git tag v1 c1` 设置c1提交位置tag  

案例 `git rebase -i HEAD~4`合并当前位置向前4个提交 
如果需要在某一个提交节点打上tag, 可以使用`tag`命令

#### git 的指针`HEAD`概念

git使用`checkout`命令时, 可以看作是操作当前指针指向某一个提交, 而不是分支名, 一次提交HEAD自动跟随提交前进  

> 每一次提交会生成哈希值(给予SHA-1), `git log`查询所有的提交记录  
> `^`上一个提交, `~<num>`向前几个提交, 如`git checkout main^`会将当前指向指向前一个提交

### git 远程分支 

一般团队合作的时候, 流程类似如下  
- 克隆远程仓库到本地
- 基于主分支创建自己的分支
- 在自己的分支上开发和提交
- `git fetch` 获取最新远程提交
- `get rebase origin/main` rebase操作, 将自己的提交迁移到主提交之后, 这里可能会存在解决冲突的问题
- 以上两步`git pull --rebase`实现
- `git push` 推送子级的提交到原成
- 一般团队开发中, 免不了提交冲突, 多人开发同一块内容会导致这种问题, 最好的办法是适当使用rebase + 合理的项目管理 

> `rebase` 和 `merge`的主要区别是 : merge保留了提交历史, rebase 梳理了提交线, 提交很整齐; 两者根据实际情况使用  

#### 追踪分支trace

一般`git pull`命令或从远程克隆到本地时, git会自动创建并设置本地分支追踪远程分支, 比如`main`追踪`origin/main`分支  
如果需要自定义设置git某个分支追踪某个远程分支， 可以使用以下语法实现  

```shell
git branch -u origin/main xxx 
git checkout -b xxx origin/main && git pull or git push
```

#### push参数

一般我们使用`git push` 命令会把当前的本地分支推送到track远程分支, 这里可以指定push参数  

```shell
git push <remote> <place>
git push origin main
# 表示推送 `main`分支HEAD 到`origin` 中的`main`分支上 
```

更甚至, 想把本地的某一个分支推送到远程其他分支上  

```shell
git push origin <source>:<destination> 
git push origin feature:main
# 以上表示将本地的feature 推送到远程main分支上 
```

#### fetch参数

与push类似， 可以将远程/本地的提交同步  

```shell
git fetch origin foo
# 将远程仓库foo分支的提交拉取， 同步到本地 origin/foo 分支上
git fetch origin main:foo # 将远程main提交记录 同步到本地origin/foo 分支上
如果目标分支没有远程, 会直接同步到本地分支
```

> `git fetch`如果不带参数, 会同步所有远程分支到本地对应的远程分支, 拉取最新的提交更新  

pull 相当于fetch和merge的合体  
一个很有意思的案例`get pull origin main:foo`, 当前本地分支在`test`, 这样操作会从远程拉取main分支, 并在本地创建foo分支, foo分支提交是从main分支同步过来的, 然后当前分支合并`foo`分支的提交  

### git 之前的笔记

#### 基本的命令

- 初始化仓库 git init  
- 如果已经在github上有了仓库，或者直接clone，或者初始化后，先pull请求合并，然后push同步到远程仓库  

#### 写作过程中的过程

1. 首先更改某一个文件的内容  
2. `git status`可以表明当前仓库的状态：被修改了什么，哪些没有提交  
  需要提交时，首先需要**add**命令：
3. `git add <filename>`或者`git add .`提交所有文件  
  一次可以提交多个文件，以空格分开  
4. 最后是提交到仓库中，使用`git commit -m "comment..."`命令  
  如果需要提交到远程仓库，使用`git push`命令  

_需要比较文件修改了什么内容，使用`git diff <filename>`命令_  

#### 版本回退问题

HEAD指向当前版本
`git log`查看提交记录，`git reflog`查看命令历史，以便于确定回到哪个版本, 理解**暂缓区**的概念  

#### 分支学习

查看分支：`git branch`  
创建分支：`git branch <name>`  
切换分支：`git checkout <name>`  
切换+创建：`git checkout -b <name>`  
合并某分支到当前分支：`git merge <name>`  
删除分支：`git branch -d <name>`  

## git mermaid 

一般的开发流程/过程表示  

```mermaid
---
title: 开发团队使用git协作开发示意图
---

gitGraph
    commit id: "init repo"
    branch preview
    checkout preview
    commit id: "pre build branch"
    
    branch dev1
    branch dev2
    
    %% 开发1拉取分支开发
    checkout dev1
    commit id: "init"
    commit id: "complete"
    
    %% 开发2拉取分支开发
    checkout dev2
    commit id: "func 2"
    commit id: "feature 2"
    commit id: "finish"

    checkout preview
    merge dev1
    commit id: "deploy 1" tag: "v0.0.1"
    merge dev2
    commit id: "deploy 2" tag: "v0.0.2"

    branch bugfix1
    checkout bugfix1
    commit id: "bugfix sth ..."
    commit id: "bug fixup, test"

    checkout preview
    merge bugfix1
    commit id: "for test"

    %% branch 后直接跟commit相当于checkout
    branch bugfix2
    checkout bugfix2
    commit
    commit
    commit

    checkout preview
    merge bugfix2
    commit id: "rebuild project" tag: "v0.0.3"

    %% 默认分支 main, 一个大版本完成后, 整体合并到main分支准备发布
    checkout main
    merge preview
    commit id: "build big version" tag: "v0.1.0"

    %% 继续preview分支拆分开发分支继续开发
    checkout preview

    branch dev3
    checkout dev3
    commit
    commit
    checkout preview
    merge dev3
    checkout main
    merge preview
```


