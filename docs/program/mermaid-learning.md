
# Mermaid 学习笔记

> 官方站点：[https://mermaid.js.org/](https://mermaid.js.org/)

Mermaid 是一个很实用的流程图和结构图工具。它不需要复杂的本地安装，直接在 Markdown 里写语法就能生成图，特别适合我这种喜欢用文档记笔记的人。

## 示例

### flowchart/graph

> 流程图

```mermaid
flowchart TB
    init(["init state"])
    calcute[/"calcute number"/]
    running["simple running"]
    check{"verify and check"}
    process[["for advance build"]]
    error{{"wrong things"}}
    ends(("end state"))
    sub_init(["sub init"])
    sub_task["sub process"]
    sub_check{"verify"}
    sub_normal_running[[running]]
    sub_finish(("finish of sub"))
    mini_init(("hello"))
    working((("very circle")))
    init --> calcute
    calcute --> running
    running ==> check
    check -- yes --> process
    check -- no --> error
    process -.success.-> ends
    error -.-> ends
    subgraph one
        direction TB
        sub_init --> sub_task --> sub_check ==> sub_normal_running -.-> sub_finish
    end
    subgraph two
        direction TB
        mini_init --> working
        working ==> check
    end
    one -- just demo --> two
```

```mermaid
flowchart LR
    AA ==> BB["boom"]
    BB --> CC((("flow chart")))
    %% flowchart better
    EE[("database")]
    CC --> EE
```

### sequence

> 时序图

```mermaid
sequenceDiagram
    autonumber
    actor eng as engineer
    participant auth
    participant user
    participant data
    eng ->>+ auth : query login uri
    auth ->> auth : circle processing
    auth --x- eng : here u are
    eng --) user : verify and query data
    user -->> data : query data of user
    data --x eng : all things
    Note right of user : db store
    eng --)+ data : upload
    data -) user : check user
    user ->> data : success
    data ->>- eng : data of list
    Note over user, data : processing
    loop checks
        eng ->> auth : communicate until lock
    end
    alt names
        user --) auth : fetch all users
        auth --> data : sync ...
        data ->> user : all is ok
    else tiny
        data ->> user : hello
        user ->> data : ok
    end
    par same one
        auth ->> user : iiii
        user ->> auth : jjjj
    and next one
        user ->> data : hhhh
        data --) user : kkkk
    end
```

### class

> 类关系图, 可以描述类之间的继承组合关系

```mermaid
classDiagram
    class Animal {
        +long id
        +string name
        +check(int num) void
        +test(boolean status) string
    }
    class Dog {
        +long id
        +string action
        +doAction() string
        +update(string action) boolean
    }
    class Cat {
        +int id
        +string name
        +int age
        +doCall() int
    }
    class Person {
        +long id
        +string status
        +string[] animals
        +invoke(string name) string
    }
    class Actions {
        <<interface>>
        +doSth() void
    }
    class Color {
        <<enumeration>>
        +READ
        +BLUE
        +GREEN
        +draw() void
    }
    note "hello world"
    Dog --|> Animal : test1
    Cat --|> Animal : demo
    Person --o Animal : use
    Color "1" ..o "1" Person : compacity
    Actions ..> Person : depends
```

### entity relation

> 实体关系图 : 一般可以表达数据库表之间的关系

```mermaid
---
    title: just for practice ER
---
erDiagram
    PRODUCT {
        varchar id
        varchar name
        int status
        datetime createTime
    }
    NORMAL {
        long id
        varchar age
        bool state
    }
    BOOK {
        long id PK "auto primary key"
        varchar author FK "address from other"
        varchar address
        datetime time
    }
    PRODUCT || -- |{ NORMAL : is
    NORMAL }| -- |{ BOOK : books
    BOOK || -- o| PRODUCT : allow
```

### state

> 状态转换图, 描述自动转换机的状态变化比较方便合适

```mermaid
stateDiagram-v2
    s1 : hello
    s2 : world
    s3 : test
    s4 : pick up
    w1 : w1
    w2 : w2
    w3 : w3
    [*] --> s1 : init
    [*] --> s2 : pop
    state center {
        [*] --> s3
    }
    center --> s4
    s4 --> [*] : finished
    state paralle {
        direction LR
        [*] --> s1 : ooo
        s1 --> w1
        --
        [*] --> w1
        w1 --> w2
        --
        [*] --> w2
        w2 --> w3
        w3 --> center
    }
```

### user journey

> 用户旅程 

```mermaid
journey
    title my life
    section work
        ride : 4 : me
        wash : 6 : me
        subway : 3 : me, cat
    section life
        read : 8 : me
        sleep : 6 : me, cat
        warm : 2 : cat
```

### gantt

> 甘特图, 表示各个任务的进展和当前状态

```mermaid
gantt
    title demo 123
    dateFormat YYYY-MM-DD
    section work
        hello : active, tid1, 2023-05-03, 2023-05-12
        world : crit, tid2, after tid1, 7d
    section life
        sleep : active, m1, 2023-04-01, 2023-05-02
        pip : done, m2, after m1, 1w
    section find
        prepare : active, p1, after tid2, 7d
        insert : milestone, k1, after p1, 0d
```

也可以作成柱状图表示数据, 一个特别的使用方法 : )

```mermaid
gantt
    title Git Issues - days since last update
    dateFormat X
    axisFormat %s
    section Issue19062
        71 : 0, 71
    section Issue19401
        36 : 0, 36
    section Issue193
        34 : 0, 34
    section Issue7441
        9 : 0, 9
    section Issue1300
        10 : 0, 10
```

### pie and quadrant

```mermaid
pie 
    title test345
    "dog" : 10
    "cat" : 80
    "pig" : 23
    "chicken" : 56
```

~~`Obsidian`暂时不支持mermaid最新绘图类型, IDEA的插件是支持的~~  

```mermaid
quadrantChart
    title show range of axis
    x-axis lease --> large
    y-axis space --> time
    quadrant-1 hi
    quadrant-2 hello
    quadrant-3 ok
    quadrant-4 see u
    main : [0.1, 0.4]
    dev : [0.4, 0.7]
```

### git

```mermaid
---
title: Example Git diagram
---
gitGraph
   commit
   commit
   branch develop
   checkout develop
   commit
   commit
   checkout main
   merge develop
   commit
   commit
```


## 实际场景中的使用

> 这部分主要是把前面的思路串起来，用更结构化的方式来表达实际场景中的流程和关系。

## 其他类似工具

> 下面这些工具也非常适合做思维导图、流程图或知识整理：

- [PlantUML](https://plantuml.com/zh/)  
- [Graphviz](https://graphviz.org/)  
- [Typora](https://typora.io/)  
- [Joblin](https://joplinapp.org/)  
- [Swimm](https://swimm.io/)  


