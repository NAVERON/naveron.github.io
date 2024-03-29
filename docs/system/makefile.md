---
title: makefile
layout: post
parent: system
---

C&C++
{: .label .label-purple}

make
{: .label}

compile
{: .label .label-green}

# 学习MakeFile

## make文件规则

1. 如果工程没有被编译过，则所有C文件都需要编译和链接  
2. 如果工程某个C文件被修改，那么只编译被修改的文件，并链接目标程序  
3. 如果工程的头文件被修改了，我们需要编译引用了这几个头文件的C文件，并链接目标程序  

```makefile
target : prerequisites
command
```

target 目标文件或者目录
prerequisites 目标文件或目录
command 马克file需要执行的命令(shell命令)

## make的工作：

1. 在当前目录下查找makefile文件  
2. 找出目标文件target  
3. 如果目标文件没有生成，或者目标依赖的的文件更新过则执行后面的命令command，生成target文件  
4. 如果target存在则会检查.o文件依赖性，重新生成.o文件  

## 声明变量

```makefile
object = ......
使用$(object)来使用这个变量
```
## makefile中间总结

makefile包含了5个东西：显示规则，隐晦规则，变量定义，文件指示和注释

> 1. 显式规则。显式规则说明了，如何生成一个或多的的目标文件。这是由Makefile的书写者明显指出，要生成的文件，文件的依赖文件，生成的命令。  
> 2. 隐晦规则。由于我们的make有自动推导的功能，所以隐晦的规则可以让我们比较粗糙地简略地书写Makefile，这是由make所支持的。  
> 3. 变量的定义。在Makefile中我们要定义一系列的变量，变量一般都是字符串，这个有点你C语言中的宏，当Makefile被执行时，其中的变量都会被扩展到相应的引用位置上。  
> 4. 文件指示。其包括了三个部分，一个是在一个Makefile中引用另一个Makefile，就像C语言中的include一样；另一个是指根据某些情况指定Makefile中的有效部分，就像C语言中的预编译#if一样；还有就是定义一个多行的命令。有关这一部分的内容，我会在后续的部分中讲述。  
> 5.  注释。Makefile中只有行注释，和UNIX的Shell脚本一样，其注释是用“#”字符，这个就像C/C++中的“//”一样。如果你要在你的Makefile中使用“#”字符，可以用反斜框进行转义，如：“\#”。  

## makefile命名

一般命名为Makefile或者makefile

## 引用其他makefile

`include<filename>`

## 执行步骤

1. 读入所有的Makefile  
2. 读入被include其他Makefile  
3. 初始化文件中的变量  
4. 推导隐晦规则，并分析所有规则  
5. 为所有的目标文件创建依赖关系链  
6. 根据依赖关系，决定哪些目标要重新生成  
7. 执行生成命令  

command如果不与target一行，需要以`[Tag]`开头，如果在一行，以`;`分隔，`\`作为换行符  







