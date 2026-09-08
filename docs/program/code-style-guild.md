
# Code Style

> 关于编码规范和代码风格的学习与借鉴：
> - 提高代码可读性，工程师加入项目后可以更快理解代码；
> - 简洁、清晰的代码更便于长期维护；
> - 统一的代码风格和规范，有利于团队协作和项目演进。

## Google Style Guide

> [https://github.com/google/styleguide](https://github.com/google/styleguide)

1. 源文件使用 `UTF-8` 编码。
2. 不使用 `Tab` 缩进，除了 ASCII 空格字符（`0x20`）可以正常显示外，其他空格不应使用。
3. 源文件排版顺序：
   - License copyright
   - Package statement
   - Import statements
   - Exactly one top-level class
   
   每一部分之间使用空行分隔。
4. `if`、`else`、`for`、`do`、`while` 等语句都必须使用 `{}`，即使只有一条语句也要加括号。
5. 单行长度不要超过 100 个 Unicode 字符。
   例外情况：
   - Javadoc 的 URL、JSNI 方法引用；
   - `package` 和 `import` 语句；
   - 注释中展示 shell 命令行语句；
   - 非常长的变量名，根据换行规则进行调整。
6. 类型名使用大写表示，例如 `Long`、`Double`、`Float`；数值字面量使用大写后缀，像 `100L`、`10.45D`、`0.35F`，这样更容易区分。
7. `package` 命名通常使用小写并用 `.` 分隔；类命名使用 `UpperCamelCase`；方法命名使用 `LowerCamelCase`；常量命名使用大写字母和下划线，例如 `UPPER_SNAKE_CASE`；任何不可变对象都可以视为常量。

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

8. 一些特殊命名规则：
   - "XML HTTP request" -> `XmlHttpRequest`
   - "new customer ID" -> `newCustomerId`
   - "supports IPv6 on IOS" -> `supportsIpv6OnIos`
9. 类的静态常量应使用 `Class.XXX` 的形式访问。

---

## Oracle Code Convention

> [https://www.oracle.com/java/technologies/cc-java-programming-language.html](https://www.oracle.com/java/technologies/cc-java-programming-language.html)

1. 单个 `Java` 源文件最好不要超过 2000 行。
2. `Java` 源文件一般按照以下顺序组织：
   1. Beginning comments
   2. Package and Import statements
   3. Class and interface declarations

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

3. 缩进时，建议使用 `4 spaces` 作为一个缩进单位。
4. 一行代码长度通常不超过 `80` 个字符，文档内容不超过 `70` 个字符。
   > 在操作符之前换行；  
   > 新的一行表达式应与上一行同级对齐，或者向后缩进。
5. `if` 语句必须使用 `{}` 包裹，即使只有一条语句也要这样写。

---

## Spring Code Style

> [spring-framework-Code-Style 代码格式规范](https://github.com/spring-projects/spring-framework/wiki/Code-Style)  
> [spring java 编码规范](https://github.com/xebia-functional/coding-guidelines/tree/master/java/spring)

1. 源文件编码使用 `UTF-8`。
2. 与其他规范不同，Spring 的编码风格建议使用 `tabs`（而不是空格）？
3. `import` 包顺序应规范化，注意静态导入一般不应出现在生产代码中：
   - `java.*`
   - 空行
   - `javax.*`
   - `jakarta.*`
   - 空行
   - 其他普通导入
   - 空行
   - `org.springframework.*`
   - 空行
   - **static** 导入
4. 代码块风格采用 `K&R style`。

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

5. 单行代码长度限制为 90 个字符，这是一个非硬性限制；90 到 105 之间最合适，最长不要超过 120 个字符。

