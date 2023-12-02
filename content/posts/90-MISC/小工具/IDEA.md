---
draft: true
categories: ["misc"]
created: 2022-07-21T19:17:12 (UTC +08:00)
tags: []
source: https://www.cnblogs.com/wangcp-2014/p/11540221.html
author: 飘飘雪
---

## Intellij idea 的全局搜索快捷键方法 - 飘飘雪 - 博客园

> ## Excerpt
> 1、Ctrl+N 按名字搜索类相当于 eclipse 的 ctrl+shift+R，输入类名可以定位到这个类文件，就像 idea 在其它的搜索部分的表现一样，搜索类名也能对你所要搜索的内容多个部分进行匹配，而且

---
#### 1、Ctrl+N 按名字搜索类

相当于 eclipse 的 ctrl+shift+R，输入**类名**可以定位到这个类文件，就像 idea 在其它的搜索部分的表现一样，搜索类名也能对你所要搜索的内容多个部分进行匹配，而且如果能匹配的自己写的类，优先匹配自己写的类，甚至不是自己写的类也能搜索。

#### 2、Ctrl+Shift+N 按文件名搜索文件

同搜索类类似，只不过可以匹配所有类型的文件了。

#### 3、Ctrl+H

查看类的继承关系，例如 HashMap 的父类是 AbstractMap，子类则有一大堆。

#### 4、Ctrl+Alt+B 查看子类方法实现

Ctrl+B 可以查看父类或父方法定义，但是不如 ctrl+鼠标左键方便。但是在这里，Ctrl+B 或 ctrl+鼠标左键只能看见 Map 接口的抽象方法 put 的定义，不是我们想要的，这时候 Ctrl+Alt+B 就可以查看 HashMap 的 put 方法。

#### 5、Alt+F7 查找类或方法在哪被使用

相当于 eclipse 的 ctrl+shif+H, 但是速度快得多。

#### 6、Ctrl+F/Ctrl+Shift+F 按照文本的内容查找

相当于 eclipse 的 ctrl+H，速度优势更加明显。其中 Ctrl+F 是在本页查找，Ctrl+Shift+F 是全局查找。

#### 7、Shift+Shift 搜索任何东西

Shift+shift 非常强大，可搜索类、资源、配置项、方法等，还能搜索路径。其中搜索路径非常实用，例如你写了一个功能叫 hello，在 java，js，css，jsp 中都有 hello 的文件夹，那我们可以搜索"hello/"找到路径中包含 hello 的文件夹。

#### 8、查看接口的实现类

IDEA 风格 ctrl + alt +B     或者     Ctrl+Alt+鼠标左键

#### 9、当前文件内容替换

Ctrl + r

## IDEA 插件
#### JSON Parser
[(170条消息) IntelliJ Idea 常用11款插件（提高开发效率），附优秀主题插件_我是七月呀的博客-CSDN博客_idea美化sql插件](https://blog.csdn.net/weixin_44655599/article/details/113702163?utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromMachineLearnPai2%7Edefault-3.control&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromMachineLearnPai2%7Edefault-3.control#t10)
Maven
#### Maven Helper
[(170条消息) IntelliJ IDEA 好用插件之Maven Helper 解决依赖冲突_文晓武的博客-CSDN博客](https://blog.csdn.net/yangbindxj/article/details/122706007)
#### Maven Dependency Helper
#### Maven Executor
#### Maven Version Refactor
#### Maven-search


#### JWT Analyzer
[JWT (JSON Web Token) Analyzer - IntelliJ IDEs Plugin | Marketplace](https://plugins.jetbrains.com/plugin/9831-jwt-json-web-token-analyzer)
### JShell Console
[IDEA 中 Jshell 的使用 - vwa - 博客园](https://www.cnblogs.com/vawa/p/14377531.html)

### Swagger Tools
[Swagger Tools - IntelliJ IDEA & Android Studio Plugin | Marketplace](https://plugins.jetbrains.com/plugin/14130-swagger-tools)

### 热部署


[Java系列 | 远程热部署在美团的落地实践 - 美团技术团队](https://tech.meituan.com/2022/03/17/java-hotswap-sonic.html): <https://tech.meituan.com/2022/03/17/java-hotswap-sonic.html>


## IDEA 配置
### 颜色方案

```xml
<scheme name="Github" version="142" parent_scheme="Default">  
  <option name="FONT_SCALE" value="1.0" />  
  <metaInfo>  
    <property name="created">2022-11-10T18:22:08</property>  
    <property name="ide">idea</property>  
    <property name="ideVersion">2022.1.3.0.0</property>  
    <property name="modified">2022-11-10T18:22:50</property>  
    <property name="originalScheme">Github</property>  
  </metaInfo>  
  <option name="LINE_SPACING" value="1.0" />  
  <option name="EDITOR_FONT_SIZE" value="13" />  
  <option name="EDITOR_FONT_NAME" value="Consolas" />  
  <colors>  
    <option name="CARET_COLOR" value="333333" />  
    <option name="CARET_ROW_COLOR" value="f8eec7" />  
    <option name="GUTTER_BACKGROUND" value="ffffff" />  
    <option name="INDENT_GUIDE" value="e0e0e0" />  
    <option name="LINE_NUMBERS_COLOR" value="333333" />  
    <option name="SELECTED_INDENT_GUIDE" value="e0e0e0" />  
    <option name="SELECTION_BACKGROUND" value="b0cde7" />  
    <option name="WHITESPACES" value="e0e0e0" />  
  </colors>  
  <attributes>  
    <option name="BAD_CHARACTER">  
      <value>  
        <option name="FOREGROUND" value="ff0000" />  
      </value>  
    </option>  
    <option name="BREAKPOINT_ATTRIBUTES">  
      <value>  
        <option name="BACKGROUND" value="ffc8c8" />  
      </value>  
    </option>  
    <option name="BUILDOUT.KEY">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="BUILDOUT.KEY_VALUE_SEPARATOR">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="BUILDOUT.LINE_COMMENT">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="BUILDOUT.SECTION_NAME">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="BUILDOUT.VALUE">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="CLASS_REFERENCE">  
      <value>  
        <option name="FOREGROUND" value="333333" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.BAD_CHARACTER">  
      <value>  
        <option name="FOREGROUND" value="ff0000" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.BLOCK_COMMENT">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.BOOLEAN">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.BRACE">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.BRACKET">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.CLASS_NAME">  
      <value>  
        <option name="FOREGROUND" value="795da3" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.COLON">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.COMMA">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.DOT">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.ESCAPE_SEQUENCE">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.EXISTENTIAL">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.EXPRESSIONS_SUBSTITUTION_MARK">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.FUNCTION">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.FUNCTION_BINDING">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.FUNCTION_NAME">  
      <value>  
        <option name="FOREGROUND" value="795da3" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.GLOBAL_VARIABLE">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.HEREDOC_CONTENT">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.HEREDOC_ID">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.HEREGEX_CONTENT">  
      <value>  
        <option name="FOREGROUND" value="9926" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.HEREGEX_ID">  
      <value>  
        <option name="FOREGROUND" value="9926" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.IDENTIFIER">  
      <value>  
        <option name="FOREGROUND" value="333333" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.JAVASCRIPT_ID">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.KEYWORD">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.LINE_COMMENT">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.LOCAL_VARIABLE">  
      <value>  
        <option name="FOREGROUND" value="333333" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.NUMBER">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.OBJECT_KEY">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.OPERATIONS">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.PARENTHESIS">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.PROTOTYPE">  
      <value>  
        <option name="FOREGROUND" value="795da3" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.RANGE">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.REGULAR_EXPRESSION_CONTENT">  
      <value>  
        <option name="FOREGROUND" value="9926" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.REGULAR_EXPRESSION_FLAG">  
      <value>  
        <option name="FOREGROUND" value="9926" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.REGULAR_EXPRESSION_ID">  
      <value>  
        <option name="FOREGROUND" value="9926" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.SEMICOLON">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.SPLAT">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.STRING">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.STRING_LITERAL">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="COFFEESCRIPT.THIS">  
      <value>  
        <option name="FOREGROUND" value="df5000" />  
      </value>  
    </option>  
    <option name="CONDITIONALLY_NOT_COMPILED">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="CONSOLE_BLUE_OUTPUT">  
      <value>  
        <option name="FOREGROUND" value="ff" />  
      </value>  
    </option>  
    <option name="CONSOLE_CYAN_OUTPUT">  
      <value>  
        <option name="FOREGROUND" value="b2b2" />  
      </value>  
    </option>  
    <option name="CONSOLE_GRAY_OUTPUT">  
      <value>  
        <option name="FOREGROUND" value="595959" />  
      </value>  
    </option>  
    <option name="CONSOLE_GREEN_OUTPUT">  
      <value>  
        <option name="FOREGROUND" value="8000" />  
      </value>  
    </option>  
    <option name="CONSOLE_MAGENTA_OUTPUT">  
      <value>  
        <option name="FOREGROUND" value="ff00ff" />  
      </value>  
    </option>  
    <option name="CONSOLE_RED_OUTPUT">  
      <value>  
        <option name="FOREGROUND" value="ff0000" />  
      </value>  
    </option>  
    <option name="CONSOLE_YELLOW_OUTPUT">  
      <value>  
        <option name="FOREGROUND" value="ffcc00" />  
      </value>  
    </option>  
    <option name="CSS.COMMENT">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="CSS.FUNCTION">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="CSS.IDENT">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="CSS.NUMBER">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="CSS.PROPERTY_NAME">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="CSS.PROPERTY_VALUE">  
      <value>  
        <option name="FOREGROUND" value="8000" />  
        <option name="FONT_TYPE" value="1" />  
      </value>  
    </option>  
    <option name="CSS.TAG_NAME">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="CSS.URL">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="CUSTOM_INVALID_STRING_ESCAPE_ATTRIBUTES">  
      <value>  
        <option name="FOREGROUND" value="ff0000" />  
      </value>  
    </option>  
    <option name="CUSTOM_LINE_COMMENT_ATTRIBUTES">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
        <option name="FONT_TYPE" value="2" />  
      </value>  
    </option>  
    <option name="CUSTOM_MULTI_LINE_COMMENT_ATTRIBUTES">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
        <option name="FONT_TYPE" value="2" />  
      </value>  
    </option>  
    <option name="CUSTOM_NUMBER_ATTRIBUTES">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="CUSTOM_STRING_ATTRIBUTES">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
        <option name="FONT_TYPE" value="1" />  
      </value>  
    </option>  
    <option name="CUSTOM_VALID_STRING_ESCAPE_ATTRIBUTES">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
        <option name="FONT_TYPE" value="1" />  
      </value>  
    </option>  
    <option name="Clojure Atom">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="Clojure Character">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="Clojure Keyword">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="Clojure Line comment">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="Clojure Literal">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="Clojure Numbers">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="Clojure Strings">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="DEFAULT_ATTRIBUTE">  
      <value>  
        <option name="FOREGROUND" value="795da3" />  
      </value>  
    </option>  
    <option name="DEFAULT_BLOCK_COMMENT">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="DEFAULT_BRACES">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="DEFAULT_BRACKETS">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="DEFAULT_CLASS_NAME">  
      <value>  
        <option name="FOREGROUND" value="333333" />  
      </value>  
    </option>  
    <option name="DEFAULT_COMMA">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="DEFAULT_CONSTANT">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="DEFAULT_DOC_COMMENT">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="DEFAULT_DOC_COMMENT_TAG">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="DEFAULT_DOC_MARKUP">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="DEFAULT_DOT">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="DEFAULT_ENTITY">  
      <value>  
        <option name="FOREGROUND" value="0" />  
      </value>  
    </option>  
    <option name="DEFAULT_FUNCTION_CALL">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="DEFAULT_FUNCTION_DECLARATION">  
      <value>  
        <option name="FOREGROUND" value="795da3" />  
      </value>  
    </option>  
    <option name="DEFAULT_GLOBAL_VARIABLE">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
        <option name="FONT_TYPE" value="2" />  
      </value>  
    </option>  
    <option name="DEFAULT_IDENTIFIER">  
      <value>  
        <option name="FOREGROUND" value="795da3" />  
      </value>  
    </option>  
    <option name="DEFAULT_INSTANCE_FIELD">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="DEFAULT_INSTANCE_METHOD">  
      <value>  
        <option name="FOREGROUND" value="795da3" />  
      </value>  
    </option>  
    <option name="DEFAULT_INTERFACE_NAME">  
      <value>  
        <option name="FOREGROUND" value="333333" />  
      </value>  
    </option>  
    <option name="DEFAULT_INVALID_STRING_ESCAPE">  
      <value>  
        <option name="FOREGROUND" value="ff0000" />  
      </value>  
    </option>  
    <option name="DEFAULT_KEYWORD">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="DEFAULT_LABEL">  
      <value>  
        <option name="FOREGROUND" value="795da3" />  
      </value>  
    </option>  
    <option name="DEFAULT_LINE_COMMENT">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="DEFAULT_LOCAL_VARIABLE">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="DEFAULT_METADATA" baseAttributes="TEXT" />  
    <option name="DEFAULT_NUMBER">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="DEFAULT_OPERATION_SIGN">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="DEFAULT_PARAMETER">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="DEFAULT_PARENTHS">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="DEFAULT_PREDEFINED_SYMBOL">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="DEFAULT_SEMICOLON">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="DEFAULT_STATIC_FIELD">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
        <option name="FONT_TYPE" value="2" />  
      </value>  
    </option>  
    <option name="DEFAULT_STATIC_METHOD">  
      <value>  
        <option name="FOREGROUND" value="795da3" />  
      </value>  
    </option>  
    <option name="DEFAULT_STRING">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="DEFAULT_TAG">  
      <value>  
        <option name="FOREGROUND" value="333333" />  
      </value>  
    </option>  
    <option name="DEFAULT_TEMPLATE_LANGUAGE_COLOR" baseAttributes="TEXT" />  
    <option name="DEFAULT_VALID_STRING_ESCAPE">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="DJANGO_COMMENT">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="DJANGO_FILTER">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="DJANGO_ID">  
      <value>  
        <option name="FOREGROUND" value="795da3" />  
      </value>  
    </option>  
    <option name="DJANGO_KEYWORD">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="DJANGO_NUMBER">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="DJANGO_STRING_LITERAL">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="DJANGO_TAG_NAME">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="DJANGO_TAG_START_END">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="ENUM_CONST">  
      <value>  
        <option name="FOREGROUND" value="990073" />  
      </value>  
    </option>  
    <option name="ERRORS_ATTRIBUTES">  
      <value>  
        <option name="EFFECT_COLOR" value="ff0000" />  
        <option name="ERROR_STRIPE_COLOR" value="ff0000" />  
        <option name="EFFECT_TYPE" value="2" />  
      </value>  
    </option>  
    <option name="FOLLOWED_HYPERLINK_ATTRIBUTES">  
      <value>  
        <option name="FOREGROUND" value="ff" />  
        <option name="BACKGROUND" value="e9e9e9" />  
        <option name="FONT_TYPE" value="2" />  
        <option name="EFFECT_COLOR" value="ff" />  
        <option name="EFFECT_TYPE" value="1" />  
      </value>  
    </option>  
    <option name="First symbol in list">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
        <option name="FONT_TYPE" value="1" />  
      </value>  
    </option>  
    <option name="GENERIC_SERVER_ERROR_OR_WARNING">  
      <value>  
        <option name="EFFECT_COLOR" value="f49810" />  
        <option name="ERROR_STRIPE_COLOR" value="f49810" />  
        <option name="EFFECT_TYPE" value="2" />  
      </value>  
    </option>  
    <option name="GHERKIN_COMMENT">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="GHERKIN_KEYWORD">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="GHERKIN_OUTLINE_PARAMETER_SUBSTITUTION">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="GHERKIN_PYSTRING">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="GHERKIN_REGEXP_PARAMETER">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="GHERKIN_TABLE_HEADER_CELL">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="GHERKIN_TABLE_PIPE">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="GHERKIN_TAG">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="GQL_ID">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="GQL_INT_LITERAL">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="GQL_KEYWORD">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="GQL_STRING_LITERAL">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="HAML_CLASS">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="HAML_COMMENT">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="HAML_ID">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="HAML_PARENTHS">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="HAML_STRING">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="HAML_STRING_INTERPOLATED">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="HAML_TAG">  
      <value>  
        <option name="FOREGROUND" value="333333" />  
      </value>  
    </option>  
    <option name="HAML_TAG_NAME">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="HAML_WS_REMOVAL">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="HTML_ATTRIBUTE_NAME">  
      <value>  
        <option name="FOREGROUND" value="795da3" />  
      </value>  
    </option>  
    <option name="HTML_ATTRIBUTE_VALUE">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
        <option name="FONT_TYPE" value="1" />  
      </value>  
    </option>  
    <option name="HTML_COMMENT">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="HTML_ENTITY_REFERENCE">  
      <value>  
        <option name="FOREGROUND" value="0" />  
        <option name="FONT_TYPE" value="1" />  
      </value>  
    </option>  
    <option name="HTML_TAG">  
      <value>  
        <option name="FOREGROUND" value="333333" />  
      </value>  
    </option>  
    <option name="HTML_TAG_NAME">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="HYPERLINK_ATTRIBUTES">  
      <value>  
        <option name="FOREGROUND" value="ff" />  
        <option name="FONT_TYPE" value="2" />  
        <option name="EFFECT_COLOR" value="ff" />  
        <option name="EFFECT_TYPE" value="1" />  
      </value>  
    </option>  
    <option name="IDENTIFIER_UNDER_CARET_ATTRIBUTES">  
      <value>  
        <option name="BACKGROUND" value="e4e4ff" />  
        <option name="ERROR_STRIPE_COLOR" value="ccccff" />  
      </value>  
    </option>  
    <option name="INFO_ATTRIBUTES">  
      <value>  
        <option name="EFFECT_COLOR" value="cccccc" />  
        <option name="ERROR_STRIPE_COLOR" value="ffffcc" />  
        <option name="EFFECT_TYPE" value="2" />  
      </value>  
    </option>  
    <option name="IVAR">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="JADE_FILE_PATH">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="JADE_FILTER_NAME">  
      <value>  
        <option name="FOREGROUND" value="795da3" />  
      </value>  
    </option>  
    <option name="JADE_JS_BLOCK">  
      <value>  
        <option name="FOREGROUND" value="795da3" />  
      </value>  
    </option>  
    <option name="JADE_STATEMENTS">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="JAVA_BLOCK_COMMENT">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="JAVA_BRACES">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="JAVA_BRACKETS">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="JAVA_COMMA">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="JAVA_DOC_COMMENT">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="JAVA_DOC_MARKUP">  
      <value>  
        <option name="BACKGROUND" value="e2ffe2" />  
      </value>  
    </option>  
    <option name="JAVA_DOC_TAG">  
      <value>  
        <option name="FONT_TYPE" value="1" />  
        <option name="EFFECT_COLOR" value="808080" />  
        <option name="EFFECT_TYPE" value="1" />  
      </value>  
    </option>  
    <option name="JAVA_DOT">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="JAVA_INVALID_STRING_ESCAPE">  
      <value>  
        <option name="FOREGROUND" value="ff0000" />  
      </value>  
    </option>  
    <option name="JAVA_KEYWORD">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="JAVA_LINE_COMMENT">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="JAVA_NUMBER">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="JAVA_OPERATION_SIGN">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="JAVA_PARENTH">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="JAVA_SEMICOLON">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="JAVA_STRING">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="JAVA_VALID_STRING_ESCAPE">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="JS.GLOBAL_VARIABLE">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
        <option name="FONT_TYPE" value="2" />  
      </value>  
    </option>  
    <option name="JS.INSTANCE_MEMBER_FUNCTION">  
      <value>  
        <option name="FOREGROUND" value="795da3" />  
      </value>  
    </option>  
    <option name="JS.LOCAL_VARIABLE">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="JS.PARAMETER">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="JS.REGEXP">  
      <value>  
        <option name="FOREGROUND" value="9926" />  
      </value>  
    </option>  
    <option name="LABEL">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="LESS_JS_CODE_DELIM">  
      <value>  
        <option name="FOREGROUND" value="333333" />  
      </value>  
    </option>  
    <option name="LESS_VARIABLE">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="MACRONAME">  
      <value>  
        <option name="FOREGROUND" value="795da3" />  
      </value>  
    </option>  
    <option name="OC.BADCHARACTER">  
      <value>  
        <option name="FOREGROUND" value="ff0000" />  
      </value>  
    </option>  
    <option name="OC.BLOCK_COMMENT">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="OC.CPP_KEYWORD">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="OC.DIRECTIVE">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="OC.EXTERN_VARIABLE">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="OC.GLOBAL_VARIABLE">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="OC.KEYWORD">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="OC.LINE_COMMENT">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="OC.LOCAL_VARIABLE">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="OC.MESSAGE_ARGUMENT">  
      <value>  
        <option name="FOREGROUND" value="795da3" />  
      </value>  
    </option>  
    <option name="OC.METHOD_DECLARATION">  
      <value>  
        <option name="FOREGROUND" value="795da3" />  
      </value>  
    </option>  
    <option name="OC.NUMBER">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="OC.PARAMETER">  
      <value>  
        <option name="FOREGROUND" value="333333" />  
      </value>  
    </option>  
    <option name="OC.PROPERTY">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="OC.SELFSUPERTHIS">  
      <value>  
        <option name="FOREGROUND" value="df5000" />  
      </value>  
    </option>  
    <option name="OC.STRING">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="OC.STRUCT_FIELD">  
      <value>  
        <option name="FOREGROUND" value="990073" />  
      </value>  
    </option>  
    <option name="OC_FORMAT_TOKEN">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="PHP_PARAMETER">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="PHP_VAR">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="PROTOCOL_REFERENCE">  
      <value>  
        <option name="FOREGROUND" value="333333" />  
      </value>  
    </option>  
    <option name="PUPPET_BAD_CHARACTER">  
      <value>  
        <option name="FOREGROUND" value="ff0000" />  
      </value>  
    </option>  
    <option name="PUPPET_BLOCK_COMMENT">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="PUPPET_BRACES">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="PUPPET_BRACKETS">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="PUPPET_CLASS">  
      <value>  
        <option name="FOREGROUND" value="0" />  
      </value>  
    </option>  
    <option name="PUPPET_COMMA">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="PUPPET_DOT">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="PUPPET_ESCAPE_SEQUENCE">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="PUPPET_KEYWORD">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="PUPPET_NUMBER">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="PUPPET_OPERATION_SIGN">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="PUPPET_PARENTH">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="PUPPET_REGEX">  
      <value>  
        <option name="FOREGROUND" value="9926" />  
      </value>  
    </option>  
    <option name="PUPPET_SEMICOLON">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="PUPPET_SQ_STRING">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="PUPPET_STRING">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="PUPPET_VARIABLE">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="PUPPET_VARIABLE_INTERPOLATION">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="PY.BRACES">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="PY.BRACKETS">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="PY.BUILTIN_NAME">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="PY.CLASS_DEFINITION">  
      <value>  
        <option name="FOREGROUND" value="333333" />  
      </value>  
    </option>  
    <option name="PY.COMMA">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="PY.DECORATOR">  
      <value>  
        <option name="FOREGROUND" value="795da3" />  
      </value>  
    </option>  
    <option name="PY.DOC_COMMENT">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="PY.DOT">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="PY.FUNC_DEFINITION">  
      <value>  
        <option name="FOREGROUND" value="795da3" />  
      </value>  
    </option>  
    <option name="PY.INVALID_STRING_ESCAPE">  
      <value>  
        <option name="FOREGROUND" value="ff0000" />  
      </value>  
    </option>  
    <option name="PY.KEYWORD">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="PY.LINE_COMMENT">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="PY.NUMBER">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="PY.OPERATION_SIGN">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="PY.PARENTHS">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="PY.PREDEFINED_USAGE">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="PY.STRING">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="PY.VALID_STRING_ESCAPE">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="REST.EXPLICIT">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="REST.FIELD">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="REST.LINE_COMMENT">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="REST.REF.NAME">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="REST.SECTION.HEADER">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="RHTML_COMMENT_ID">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="RHTML_EXPRESSION_END_ID">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="RHTML_EXPRESSION_START_ID">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="RHTML_OMIT_NEW_LINE_ID">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="RHTML_SCRIPTLET_END_ID">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="RHTML_SCRIPTLET_START_ID">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="RUBY_BAD_CHARACTER">  
      <value>  
        <option name="FOREGROUND" value="ff0000" />  
      </value>  
    </option>  
    <option name="RUBY_BRACKETS">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="RUBY_COLON">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="RUBY_COMMA">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="RUBY_COMMENT">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="RUBY_CONSTANT">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="RUBY_CONSTANT_DECLARATION">  
      <value>  
        <option name="FOREGROUND" value="0" />  
      </value>  
    </option>  
    <option name="RUBY_CVAR">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="RUBY_DOT">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="RUBY_ESCAPE_SEQUENCE">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="RUBY_EXPR_IN_STRING">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="RUBY_GVAR">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="RUBY_HASH_ASSOC">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="RUBY_HEREDOC_CONTENT">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="RUBY_HEREDOC_ID">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="RUBY_IDENTIFIER">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="RUBY_INTERPOLATED_STRING">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="RUBY_INVALID_ESCAPE_SEQUENCE">  
      <value>  
        <option name="FOREGROUND" value="ff0000" />  
      </value>  
    </option>  
    <option name="RUBY_IVAR">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="RUBY_KEYWORD">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="RUBY_LINE_CONTINUATION">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="RUBY_LOCAL_VAR_ID">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="RUBY_METHOD_NAME">  
      <value>  
        <option name="FOREGROUND" value="795da3" />  
      </value>  
    </option>  
    <option name="RUBY_NUMBER">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="RUBY_OPERATION_SIGN">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="RUBY_PARAMDEF_CALL">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="RUBY_PARAMETER_ID">  
      <value>  
        <option name="FOREGROUND" value="ff0078" />  
      </value>  
    </option>  
    <option name="RUBY_REGEXP">  
      <value>  
        <option name="FOREGROUND" value="9926" />  
      </value>  
    </option>  
    <option name="RUBY_SEMICOLON">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="RUBY_SPECIFIC_CALL">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="RUBY_STRING">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="RUBY_SYMBOL">  
      <value>  
        <option name="FOREGROUND" value="990073" />  
      </value>  
    </option>  
    <option name="RUBY_WORDS">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="SASS_COMMENT">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="SASS_DEFAULT">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="SASS_EXTEND">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="SASS_FUNCTION">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="SASS_IDENTIFIER">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="SASS_IMPORTANT">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="SASS_KEYWORD">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="SASS_MIXIN">  
      <value>  
        <option name="FOREGROUND" value="795da3" />  
      </value>  
    </option>  
    <option name="SASS_NUMBER">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="SASS_PROPERTY_NAME">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="SASS_PROPERTY_VALUE">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="SASS_STRING">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="SASS_TAG_NAME">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="SASS_URL">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="SASS_VARIABLE">  
      <value>  
        <option name="FOREGROUND" value="86b3" />  
      </value>  
    </option>  
    <option name="SLIM_BAD_CHARACTER">  
      <value>  
        <option name="FOREGROUND" value="ff0000" />  
      </value>  
    </option>  
    <option name="SLIM_CLASS">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="SLIM_COMMENT">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="SLIM_DOCTYPE_KWD">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="SLIM_FILTER">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="SLIM_ID">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="SLIM_INTERPOLATION">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="SLIM_PARENTHS">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="SLIM_STRING_INTERPOLATED">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="SLIM_TAG">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="SLIM_TAG_ATTR_KEY">  
      <value>  
        <option name="FOREGROUND" value="795da3" />  
      </value>  
    </option>  
    <option name="SLIM_TAG_START">  
      <value>  
        <option name="FOREGROUND" value="333333" />  
      </value>  
    </option>  
    <option name="SPY-JS.EXCEPTION">  
      <value>  
        <option name="BACKGROUND" value="ffcccc" />  
        <option name="EFFECT_COLOR" value="333333" />  
        <option name="EFFECT_TYPE" value="2" />  
      </value>  
    </option>  
    <option name="SPY-JS.FUNCTION_SCOPE">  
      <value>  
        <option name="BACKGROUND" value="fffff0" />  
        <option name="EFFECT_COLOR" value="333333" />  
        <option name="EFFECT_TYPE" value="2" />  
      </value>  
    </option>  
    <option name="SPY-JS.PATH_LEVEL_ONE">  
      <value>  
        <option name="BACKGROUND" value="e2ffe2" />  
        <option name="EFFECT_COLOR" value="333333" />  
        <option name="EFFECT_TYPE" value="2" />  
      </value>  
    </option>  
    <option name="SPY-JS.PATH_LEVEL_TWO">  
      <value>  
        <option name="EFFECT_COLOR" value="333333" />  
        <option name="EFFECT_TYPE" value="1" />  
      </value>  
    </option>  
    <option name="SPY-JS.PROGRAM_SCOPE">  
      <value>  
        <option name="BACKGROUND" value="ffffff" />  
        <option name="EFFECT_COLOR" value="333333" />  
        <option name="EFFECT_TYPE" value="2" />  
      </value>  
    </option>  
    <option name="SPY-JS.VALUE_HINT" baseAttributes="" />  
    <option name="STATIC_FIELD_ATTRIBUTES">  
      <value>  
        <option name="FOREGROUND" value="660e7a" />  
        <option name="FONT_TYPE" value="3" />  
      </value>  
    </option>  
    <option name="STATIC_METHOD_ATTRIBUTES">  
      <value>  
        <option name="FONT_TYPE" value="2" />  
      </value>  
    </option>  
    <option name="TAG_ATTR_KEY">  
      <value>  
        <option name="FOREGROUND" value="795da3" />  
      </value>  
    </option>  
    <option name="TEXT">  
      <value>  
        <option name="FOREGROUND" value="333333" />  
        <option name="BACKGROUND" value="ffffff" />  
      </value>  
    </option>  
    <option name="TEXT_SEARCH_RESULT_ATTRIBUTES">  
      <value>  
        <option name="BACKGROUND" value="ffff00" />  
        <option name="ERROR_STRIPE_COLOR" value="ff00" />  
      </value>  
    </option>  
    <option name="TODO_DEFAULT_ATTRIBUTES">  
      <value>  
        <option name="FOREGROUND" value="ff" />  
        <option name="FONT_TYPE" value="3" />  
        <option name="ERROR_STRIPE_COLOR" value="ff" />  
      </value>  
    </option>  
    <option name="TYPEDEF">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="WARNING_ATTRIBUTES">  
      <value>  
        <option name="BACKGROUND" value="f6ebbc" />  
        <option name="EFFECT_COLOR" value="333333" />  
        <option name="ERROR_STRIPE_COLOR" value="ffff00" />  
        <option name="EFFECT_TYPE" value="1" />  
      </value>  
    </option>  
    <option name="WRITE_IDENTIFIER_UNDER_CARET_ATTRIBUTES">  
      <value>  
        <option name="BACKGROUND" value="ffe4ff" />  
        <option name="ERROR_STRIPE_COLOR" value="ffcdff" />  
      </value>  
    </option>  
    <option name="XML_ATTRIBUTE_NAME">  
      <value>  
        <option name="FOREGROUND" value="795da3" />  
      </value>  
    </option>  
    <option name="XML_ATTRIBUTE_VALUE">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="XML_ENTITY_REFERENCE">  
      <value>  
        <option name="FOREGROUND" value="0" />  
      </value>  
    </option>  
    <option name="XML_TAG">  
      <value>  
        <option name="FOREGROUND" value="333333" />  
      </value>  
    </option>  
    <option name="XML_TAG_DATA">  
      <value>  
        <option name="FONT_TYPE" value="1" />  
      </value>  
    </option>  
    <option name="XML_TAG_NAME">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="YAML_COMMENT">  
      <value>  
        <option name="FOREGROUND" value="969896" />  
      </value>  
    </option>  
    <option name="YAML_SCALAR_DSTRING">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="YAML_SCALAR_KEY">  
      <value>  
        <option name="FOREGROUND" value="63a35c" />  
      </value>  
    </option>  
    <option name="YAML_SCALAR_LIST">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="YAML_SCALAR_STRING">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="YAML_SCALAR_VALUE">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
    <option name="YAML_SIGN">  
      <value>  
        <option name="FOREGROUND" value="a71d5d" />  
      </value>  
    </option>  
    <option name="YAML_TEXT">  
      <value>  
        <option name="FOREGROUND" value="183691" />  
      </value>  
    </option>  
  </attributes>  
</scheme>
```
### 3. Editor Tabs

Preferences —> General —> Editor —> Editor Tabs  
![在这里插入图片描述](https://img-blog.csdnimg.cn/7198a87ddb124c7aabfbd01b815bd04b.png)  
![在这里插入图片描述](https://img-blog.csdnimg.cn/441e4f8fdeb0463d82c875b5442b2a7c.png)

### 4. 注释紧贴代码

Preferences —> General —> Editor —> Java  
![在这里插入图片描述](https://img-blog.csdnimg.cn/08f15eb942e7497dafae239e4b8b33dd.png)  
![在这里插入图片描述](https://img-blog.csdnimg.cn/a76744b9d7e2403388a69c212f4f1130.png)

### 5. 生成作者和时间等信息

Preferences —> General —> Editor —> File and Code Templates  
![在这里插入图片描述](https://img-blog.csdnimg.cn/e5b46e3e9ae74758afb7adddfd3398aa.png)