---
title: code
layout: post
parent: program
---

coding-style
{: .label .label-green}

# code style

> 关于编码规范/风格的学习和借鉴
> - 提高代码可读性, 工程师加入项目后可以快速理解
> - 简介的代码方便终生维护项目
> - 统一的代码编写规范/风格, 有利于团队协作编程

## google style guild

> [https://github.com/google/styleguide](https://github.com/google/styleguide)  

1. 源文件使用`UTF-8`编码
2. 不能使用`Tab`缩进, 除了`ASCII horizontal space character (0x20)`空格可以显示, 其余其他空格不能使用
3. 源文件排布
    - License copyright
    - Package statement
    - Import statements
    - Exactly one top-level class
    每个部分使用空行分隔
4. `if, else, for, do, while`语句使用`{}`, 就算只有1条语句
5. 单行长度不超过100`Unicode`
    例外: 
    - javadoc url, JSNI 方法参考
    - `package` `import` statement
    - 在注释中表示执行命令行的语句 shell
    - 非常长的变量, 按照换行规则调整
6. 类型表示大写, `Long, Double, Flout`类型数字:`100L, 10.45D, 0.35F`使用大写方便区分
7. package命名, 一般使用小写+`.`分隔; Class命名, 使用`UpperCamelCase`; 方法使用`LowerCamelCase`方式; 常量使用大写字母+下划线, 比如`UPPER_SNAKE_CASE`, 任何不可变的对象是常量
    ```java
    // Constants
    static final int NUMBER = 5;
    static final ImmutableList<String> NAMES = ImmutableList.of("Ed", "Ann");
    static final Map<String, Integer> AGES = ImmutableMap.of("Ed", 35, "Ann", 32);
    static final Joiner COMMA_JOINER = Joiner.on(','); // because Joiner is immutable
    static final SomeMutableType[] EMPTY_ARRAY = {};
    
    // Not constants
    static String nonFinal = "non-final";
    final String nonStatic = "non-static";
    static final Set<String> mutableCollection = new HashSet<String>();
    static final ImmutableSet<SomeMutableType> mutableElements = ImmutableSet.of(mutable);
    static final ImmutableMap<String, SomeMutableType> mutableValues =
        ImmutableMap.of("Ed", mutableInstance, "Ann", mutableInstance2);
    static final Logger logger = Logger.getLogger(MyClass.getName());
    static final String[] nonEmptyArray = {"these", "can", "change"};
    ```
8. 一些特殊的命名, "XML HTTP request" -> `XmlHttpRequest`; "new customer ID" -> `newCustomerId`; "supports IPv6 on IOS" -> `supportsIpv6OnIos`
9. class静态常量的使用, 按照`Class.XXX`的形式使用


## oracle code convertion

> [https://www.oracle.com/java/technologies/cc-java-programming-language.html](https://www.oracle.com/java/technologies/cc-java-programming-language.html)

1. 单个`Java`文件行数最好不要超过2000行
2. `Java` 源文件一般按找如下格式
    1. Beginning comments
    2. Package and Import statements
    2. Class and interface declarations
    ```java
    /**
     * Classname
     * Version info 
     * Copyright notice
     **/
     package xxx.xxx.xxx;
     
     import xxx.xxx.xxx.xxx;
     
     /** 
      * Class or interface 文档 ... 
      */
      public class/interface Xxxx {
          // 1. class static variables 
          // 2. instance variables
          // 3. constructors
          // 4. methods 声明
      }
    ```
3. 缩进, `4 Space`应当作为所进的单元
4. 一行代码长度不能超过`80`字符, 文档一般不超过`70`字符
    > 在操作符之前换行
    > 将表达式新的一行和上一行同等级别的对齐; 或者向后缩进
5. `if`语句应当使用`{}`包围, 就算只有1条语句


## spring code style

> [spring-framework-Code-Style 代码格式规范](https://github.com/spring-projects/spring-framework/wiki/Code-Style)  
> [spring java 编码规范](https://github.com/xebia-functional/coding-guidelines/tree/master/java/spring)

1. 源文件编码`UTF-8`
2. 与其他规范不同, 缩进建议使用`tabs(not spaces)` ?
3. import package 顺序, 注意静态导入一般在生产代码中不允许
    import `java.*`
    blank line
    import `javax.*`
    import `jakarta.*`
    blank line
    import all other imports
    blank line
    import `org.springframework.*`
    blank line
    import **static** all other imports
4. 代码快风格`K&R style`
    ```java
    return new MyClass() {
    	@Override 
    	public void method() {
    		if (condition()) {
    			something();
    		}
    		else {
    			try {
    				alternative();
    			} 
    			catch (ProblemException ex) {
    				recover();
    			}
    		}
    	}
    };
    ```
5. 单行代码长度限制90字符, 非硬性限制, 范围在90 ~ 105之间最好, 不能超过120个字符






