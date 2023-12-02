---
scope: learn
draft: true
---
# Java 程序执行过程



这部分介绍 *Java* 程序执行过程中发生的活动，内容的组织方式都是围绕 *Java* 虚拟机和构成程序的类、接口、对象的生命周期。

*Java* 虚拟机启动后加载某个类，然后调用这个类的 *main* 方法。在虚拟机启动部分概述执行 *main* 方法中涉及到的 类加载、链接、初始化步骤，作为概念介绍。后续部分详细讲解类加载、链接和初始化过程，之后继续介绍对象创建和对象析构的过程、描述类卸载和程序退出的流程。

1. 虚拟机启动
2. 加载类和接口
3. 类和接口的链接
4. 类和接口的初始化
5. 类实例创建
6. 对象析构
7. 类和接口的卸载
8. 程序退出

## 1. Java 虚拟机启动

在执行一个类的 *main* 方法时，*Java* 虚拟机启动、给 *main* 方法传递一个字符串数组的参数。在这里的实例中，这个类叫做 *Test*。

*Java* 虚拟机启动的精确语义在 *Java* 虚拟机标准的第 5 章有介绍（ The Java Virtual Machine Specification, Java SE 8 Edition ）。这里只从 *Java* 语言的角度简述一下 虚拟机启动过程。

给虚拟机指定初始类的方式不在标注讨论范围之内，不过典型情况都是使用命令行提供主类的全限定名称，再紧接上给 *main* 方法传递的参数。例如下面的命令会启动虚拟机执行 *Test* 类的 *main* 方法，给 *main* 传递 包含四个字符串的数组作为参数：

```bash
java Test reboot Bot Dot Enzo
```

下面是 虚拟机执行 *Test* 类时的类加载、链接和初始化过程。

### 加载 Test 类

执行 Test.main 首先会查找虚拟机是否有 这个类的二进制表示，如果虚拟机找不到当前类的二进制表示，就会使用类加载器尝试找到类的二进制表示。如果类加载过程失败，就会抛出错误。



### 链接 Test 类：验证、准备、（可选的）解析

在加载 Test 类之后，需要先对 Test 类进行初始化才能执行其 main 方法，而所有类和接口一样都要链接之后才能初始化。连接过程包括验证、准备和可选的解析过程。

验证过程会用合适的符号表检查被加载的 Test 类是不是 *well-formed*。也会检查实现 Test 类的代码是否遵守 Java 语言和 Java 虚拟机的语义要求。如果在验证过程中检测到问题会抛出错误。

准备过程先给 Java 虚拟机分配静态存储和虚拟机内部实现所需的数据结构，比如方法表。

解析过程是检查从 Test 类到其它类和接口的符号引用。这个过程会加载 Test 类中涉及到的其他类和接口，检查引用是否正确。

**积极解析和惰式解析**

解析过程在初次链接时是可选的。有的解析实现很早就解析被连接的类或接口的符号引用，甚至还会递归的解析被符号引用所指向的目标类或接口的符号引用（这种解析可能导致来自进一步加载和链接的错误）。这种实现代表着一个极端，与 *C* 语言简单实现中已经使用很多年的静态链接相似。（ *C* 语言的静态链接中，编译好的程序通常以类似 *a.out* 的文件表示，这个文件包含程序完全链接的版本，程序中使用的所有来自类库的例行程序都被包括进来。这些例程的副本被直接包括进 *a.out* 文件中）

另一种解析实现则可能选择只在符号引用被使用时才会解析这个符号链接。对所有符号链接都应用这种策略代表着惰式解析的极端。这种情况下，如果 Test 类有一些指向其他类的符号引用，如果有一个符号引用被使用才会解析一个，而如果这些符号引用在程序执行过程中没有被使用就根本不会解析。

在解析时唯一的要求就是解析过程中检测到的任何错误必须在程序执行某些动作时报告，程序的这些导致错误的行为可能直接或间接地要求链接错误所涉及的类或接口。如果选择上述的**静态解析**实现，加载和连接错误可能在程序执行前就发生（如果这些错误涉及到 Test 类符号引用所指向的类，或者在递归的符号引用链上的类或接口）。而在使用**惰式解析**的虚拟机系统中，只有在错误的符号引用被程序执行过程中使用才会报告错误。



### 初始化 Test 类：执行初始化代码

在 JVM 调用 Test.main 之前，必须初始化 Test 类型。初始化过程包括按照文本顺序执行 Test 类的变量初始化和静态初始化代码。在 初始化 Test 类之前，需要先从顶级父类开始，递归地初始化其父类，然后才能初始化 Test 本身。在最简单的情况下，Test 会有一个隐式直接父类 Object，如果 Object 类还没有被初始化，就要在初始化 Test 类之前先初始化 Object。

如果 Test 类有其他父类，比如 Super，就要先初始化 Super 类。如果 Super 类还没有执行加载、验证、准备过程就要先进行这些操作。根据 JVM 实现的不同，可能也会递归地解析 Super 类的符号引用。

因此，初始化过程也有可能导致加载、链接和初始化错误，包括涉及其他类型的上述错误。





### 调用 Test.main

在 Test 类的初始化完成之后，JVM 调用 Test 类的 main 方法。要确保 Test.main 能被正确调用，main 方法必须声明为 `public static void`，同时必须指定一个字符串数组类型的形参。因此，下面两种声明都是可以的：

```java
public static void main(String[] args)
public static void main(String... args)
```

## 2. 加载类和接口

类加载指的是通过类名查找类或接口的二进制格式的过程。可能会现场计算某个类的二进制格式，但更常见的情况是从 Java 编译器提前编译好的类文件获取累的二进制格式，然后从这个二进制格式构建一个 Class 对象来表示该类或接口。

类加载过程的精确语义在 Java 8 虚拟机标准的第 5 章中有介绍，这里只从 Java 语言的视角简述类加载过程。

类或接口的二进制格式通常是 Java 8 虚拟机标准中描述的类文件格式，但只要是满足 Java 语言规范中 $ 13.1 节的要求的二进制格式都是可以的。类加载器（例如`ClassLoader`类）可以通过 `defineClass` 方法从类文件的二进制类格式构造相应的 类对象。

正常的类加载器会遵守下列过程：

- 对于相同的类名类加载器应该返回同样的类对象
- 如果 类加载器 *L1* 把类 *C* 的加载工作委派（ delegate ）给 另一个类加载器 *L2*，对于类 *C* 的直接父类或直接父接口、或者类 *C* 中的一个字段、或者类 *C* 的成员方法和构造函数、或者类 *C* 中成员方法的返回值的类型，类加载器 *L1* 和 *L2* 对所有这些类型都应该返回同样的类对象

损坏的类加载器可能会违背这些属性，但是违背这些原则并不会破幻 Java 类型系统的安全性，因为 JVM 有保护措施。Java 编程语言设计的一个基本原则是，运行时类型系统不能被用 Java 编程语言编写的代码所颠覆，甚至不能被 `ClassLoader` 和 `SecurityManager` 这样的敏感系统类的实现所颠覆。 

### 2.1 加载过程

类加载过程由 `ClassLoader` 类及其子类实现。
`ClassLoader` 类不同的子类可能会实现不一样的类加载策略。尤其是有的类加载器可能会缓存类和接口的二进制表示，在预料到类的使用时预加载类文件、或者集中家在一组相关的类文件。有时这些类加载活动对正在运行的应用并不是透明的，例如类加载器缓存旧版类文件导致某个类最新编译的版本无法找到。但是类加载器的责任只是报告程序中没有预读取和集中加载策略时有可能发生的错误。

如果在类加载过程中发生了错误，会在程序中直接或间接使用该类的位置抛出 `LinkageError` 下述子类之一的对象：

- `ClassCircularityError`: 由于该类是自己的父类或父接口而加载出错（即类层次结构中出现了环形继承）
- `ClassFormatError`：代表所需类或接口的二进制数据格式错误
- `NoClassDefFoundError`：通过相关类加载器无法找到目标类或接口的定义

由于类加载过程涉及到了给新数据结构分配内存，所以类加载过程可能由于内存不足而失败，报告 `OutOfMemoryError`。



### 创建和加载

// TODO JVMS $ 5.3 Page 337

#### 引导类加载器



#### 用户定义的类加载器





#### 创建类数组



#### 从类文件表示获取类对象







### 访问控制

// TODO JVMS $ 5.4.4 Page 356





## 3. 链接类和接口

链接是从类或接口类型获取其二进制格式，并加入 JVM 运行时状态，以便目标类或接口能被执行的过程。

连接过程包含了三种不同的活动：验证、准备和解析符号链接。

Java 虚拟机标准允许实现上的灵活性，只要在类或接口的链接（以及递归链接时的类加载）过程， 遵守了 Java 语言的语义、目标类或接口在其初始化过程之前已经完成了验证和准备工作、并且在程序执行的某个动作引用了连接出错的类或接口时，报告相关错误。

例如，有的实现可能选择采用这样的策略：只在符号链接被使用时才单独解析每个类或接口中的符号链接（惰式解析或延迟解析），或者会在类的验证过程中一次性递归地解析所有符号链接（静态解析）。这意味着在有的实现中，在类或接口已经初始化完成之后，符号连接的解析过程还在继续。

由于链接过程会给新的数据结构分配内存，所以连接过程也可能由于内存不足而失败退出，报告 `OutOfMemoryError`。

### 3.1 验证类的二进制格式

验证过程确保类或接口的二进制表示结构正确。例如，检查每个指令是否有有效的操作码、检查每个分支指令分支到其他指令的起始位置，而不是混入其他指令内部、检查每个方法被提供的方法签名正确、检查每个指令遵守 Java 虚拟机语言的类型原则。

如果在验证过程中发生了错误，在程序中导致验证目标类的位置会抛出 LinkageError 类下述子类之一的对象：

- `VerifyError`：类或接口的二进制定义无法通过一系列检查，表明其遵守 Java 虚拟机语言的语义、同时不破坏 Java 虚拟机的完整性 (See §13.4.2, §13.4.4, §13.4.9, and §13.4.17 for some examples.)

### 3.2 类或接口的准备

准备过程包括给类或接口创建静态字段（类变量和常量），并为其初始化为默认值。这个过程不需要执行任何源代码，静态字段的显式初始化代码是在类的初始化过程中执行，而不是在类的准备阶段。



Java 虚拟机实现可能会在准备阶段预计算一些额外的数据结构，一边让类或接口的后续操作更加高效。有用的数据结构之一是 方法表或者其他能让 Java 虚拟机在调用类实例方法时不需要搜索父类的其他数据结构。



### 3.3 解析符号链接

类或接口的二进制表示使用相应类或接口的 *binary name* 符号式地引用其他类或接口，以及他们的字段、方法、构造函数。对于字段和方法，这些符号引用包含这些字段和方法所属类的类型名，以及字段或方法本身的名称、和合适的类型信息。

在符号引用能被使用之前必须经历解析过程，这时会检查符号链接是否正确。通常如果这个引用会被重复使用，会把该符号引用用一个能被更加高效处理的直接引用代替。

如果在解析过程中发生的错误会被报告。最常见的情况是抛出一个属于 `IncompatibleClassChangeError` 类下述子类之一的对象，但是也有可能是不属于这些子类的其他子类，甚至是 `IncompatibleClassChangeError` 类本身。在程序中直接或间接地使用了出错的符号引用的位置，会报告解析错误。

- `IllegalAccessError`：符号引用表示字段使用或赋值、方法调用或者类对象创建，但是包含符号引用的代码没有对相应字段或方法的访问权限，因为目标方法或字段被声明为 *private*、*protected* 或包访问，或者未被声明为 *public*。

  比如一个字段原来声明为 *public*，但是在另一个类引用该字段之后，该字段又变成 *private* ，与之类似的情况出现时有可能报告 `IllegalAccessError`。

- `InstantiationError`：在类对象创建表达式中使用了符号链接，但是无法实例化该对象，因为符号链接指向的是接口或抽象类。比如某个类本来不是抽象类，但是另外的类引用了该类之后又变为抽象类，这时有可能报告 `InstantiationError`。

- `NoSuchFieldError`：符号链接指向类或接口中某个字段，但是目标类或接口没有这个字段名表示的字段。比如在某个类引用了目标类的一个字段并且已经编译过之后，目标类的相应字段被删除，有可能报告 `NoSuchFieldError`。

- `NoSuchMethodError`：符号链接指向类或接口的某个方法，但是目标类或接口没有方法名和方法签名都一致的方法。比如某个类引用了目标类的一个方法并且已经编译过之后，目标类的相应方法声明被删除，有可能报告 `NoSuchMethodError`。

除此之外，如果某个类声明了一个找不到实现的 *native* 本地方法，就会抛出 `LinkageError` 的子类 `UnsatisfiedLinkError` 错误。这个错误被报告的时机依赖于 *Java* 虚拟机的实现采用了哪种符号链接解析策略，可能是在这个错误方法被调用时，或者在更早的阶段。





## 4. 类和接口的初始化

类初始化包括执行其静态初始化代码块和静态字段的初始化语句。接口初始化包括执行接口中定义字段（常量）的初始化语句。

### 4.1 初始化发生的时机

对于类或接口类型 *T*，其初始化发生的时机如下：

- 如果 *T* 是一个类：在类对象创建时进行类的初始化；
- 在类或接口中声明的静态方法被调用时
- 在类或接口中声明的静态字段被赋值时
- 在非常量的静态字段被使用时
- 如果 *T* 是顶级类，在 T 中执行一个词法嵌套的 `assert` 语句时 进行类或接口的初始化。



在类初始化时，还未初始化的父类和声明了默认方法的父接口要先初始化 。但接口的初始化本身并不会导致其父接口的初始化。

对静态字段的引用，只会触发真正声明该静态字段的类或接口的初始化，即使该字段可能通过子类名、子接口名或者实现了该接口的类名被引用。

`Class` 类和 `java.lang.reflect` 包中某些特定反射方法的调用也会触发类或接口的初始化。

在其他任何情况下都不会发生类或接口的初始化。

注意编译器有时会生成 *synthetic* 默认方法，也就是既不是显式声明也不是隐式声明的默认方法。尽管源码中没有任何表示应该初始化接口的迹象，但这一类方法确实会触发所属接口的初始化。



// TODO understand

这样做的目的是，类或接口有一组将其设置为一致性状态的初始化器，而这个状态是其他类可见的第一个状态。静态初始化代码块和类变量的初始化语句会按照文本顺序执行，但不会引用类中先使用后声明的类变量，即使这些类变量处于作用域中。设计这种限制是为了能在编译时期检测到多数环形初始化或其他形式的不经处理会出错的初始化。

初始化代码不受限制让有些意外情况得以存在：在有些类变量仍处于初始默认值状态、还未解析其初始化表达式时，类变量未经初始化的默认值对外界可见，但是这种情况在实践中很少（类对象的变量也存在这种情况）。这样的初始化器带来了 Java 语言的全面能力，但是要求程序员多加小心。这种能力给代码生成器增加了额外的负担，但是这种负担在任何情况下都会出现，因为Java编程语言是并发的 。

// TODO some examples for initialization ( $ 12.4.1 Page 366 )



### 4.2 初始化的详细流程

类或接口的初始化必须采用细心的同步机制，因为 Java 语言是多线程的，某个其他线程可能会和当前线程在同一时刻尝试初始化同一个类或接口。同时某个类或接口的初始化也可能导致递归地触发该类或接口本身的初始化。例如类 *A* 中的一个变量初始化语句有可能调用一个不相关类 *B* 的方法，*B* 类的这个方法转而又调用了类 *A* 的方法。java 虚拟机的实现就使用以下流程，负责处理同步和递归初始化。

 初始化过程假定 *Class* 对象已经被验证和准备，并且其状态表明以下四种情况之一：

- *Class* 对象已经经过验证、准备，但还没有被初始化
- *Class* 对象正在被某个线程 *T* 初始化
- *Class* 对象已经完成初始化并且可用
- *Class* 对象处于错误状态，很可能已经尝试过初始化但是失败了

对于每个类或接口 *C* 都有一个唯一的初始化锁 *LC*。从类或接口到其相应初始化锁的映射方式由 Java 虚拟机的实现方式决定。初始化类 *C* 的流程如下：

1. 在类 *C* 的初始化锁 *LC* 之上进行同步操作，这个过程会一直等待到当前线程能够访问 *LC* 为止

2. 如果 类 *C* 相应的 *Class* 对象状态表明有别的线程正在初始化类 *C*，就会释放 *LC* 并阻塞当前线程，直到被通知正在进行的初始化已经完成，当前线程会切换到运行态继续重复这个过程。

3. 如果 类 *C* 相应的 *Class* 对象表明当前线程正在初始化类 *C*，那么一定是递归的初始化请求，会直接释放 *LC* ，初始化正常结束。

4. 如果 类 *C* 的 *Class* 对象表明类 *C* 已经初始化完成，则不需要进行额外操作，释放 *LC* 并征程结束初始化。

5. 如果 类 *C* 的 *Class* 对象处于错误状态，则无法进行初始化，释放 *LC* 并抛出 `NoClassDefFoundError` 错误。

6. 如果都不属于以上四种情况，则记录当前线程正在初始化类 *C* 并释放初始化锁 *LC*。然后初始化类 *C* 的静态常量字段。

7. 接下来，如果 *C* 是类而不是接口，并且其父类还没有被初始化，用 *SC* 表示 *C* 的父类、*SI1, ..., SIn* 表示类 *C* 声明了默认方法的所有父接口。父接口的初始化顺序通过 类 *C* 直接实现的接口继承层次结构之上递归遍历的顺序决定，类 *C* 直接实现的接口之间按照 `implements` 语句中从左到右出现的顺序。对于类 *C* 每个直接实现的接口 *I*，递归枚举顺序按照接口 *I* 的 `extends` 语句中能够做到有出现的顺序，接口 *I* 自己处于最后。

   对于 *SC，SI1, ..., SIn* 序列中的每个类或接口 *S*，递归地执行整个初始化流程。如果有必要的话，先对 *S* 进行验证和准备。

   如果 *S* 的初始化过程由于抛出异常而中断，则获取初始化锁 *LC* 并把 类 *C* 的 *Class* 对象标记为错误状态、通知所有等待的线程、释放 *LC*、中断初始化过程，最后抛出 导致 *S* 初始化失败的异常。

8. 接下来通过查询相应的类加载器确定类 *C* 是否开启了断言。

9. 按照文本顺序，执行类的类变量初始化语句和静态初始化代码块，或者执行接口的静态常量字段初始化语句。

10. 如果初始化器的执行正常完成，则获取初始化锁 *LC*，把类 *C* 的 *Class* 对象标记为初始化完成，并通知所有等待的线程、释放 *LC*、正常完成初始化过程。

11. 如果初始化器无法正常执行完成，那么初始化器执行过程中肯定抛出了某个异常类 *E*。如果 *E* 不属于 `Error` 或其子类之一，就创建一个 `ExceptionInInitializerError` 的对象，把 *E* 作为参数，并用这个新对象在接下来的步骤中取代 *E* 。如果由于发生了 `OutOfMemoryError` 导致无法创建 `ExceptionInInitializerError` 的对象，就用 `OutOfMemoryError` 对象代替 *E*。

12. 获取 *LC*，把类 *C* 的 *Class* 对象标记为错误状态，通知所有等待的线程，释放 *LC*，并中断初始化过程、抛出前一步检测到的 异常 *E*。

    有的实现会在检测到类初始化已经完成时，为了优化考虑而省略步骤 1 的锁获取和步骤 4、5 的锁释放过程，只要在内存模型之下，获取锁时所有发生在获取锁之前的执行顺序，在施加优化之后这些顺序依然存在即可。

    代码生成器需要保留类或接口可能的初始化点，插入上述初始化流程的调用代码。如果这个初始化流程正常结束、*Class* 对象已经完成初始化并且可用，那么相应的初始化流程调用代码就没有必要、可以从生成的代码中删除。例如使用补丁删除代码或者重新生成代码。

    在有些情况下，如果一组相关类型的初始化顺序可以确定，编译时期代码分析可以省略很多检查生成代码中类型是否已经初始化完成的步骤。但是这样的代码分析必须充分考虑并发和**初始化代码不受限制**的事实。

## 5. 创建类对象

在解析类对象创建表达式导致类初始化时，会**显式创建**类对象。在以下情况中会**隐式创建**一个类对象：

- 加载包含字符串字面量的类或接口时可能会创建表示该字符串的 `String` 对象。(This might not occur if the same String has previously been interned ( // TODO String Literals JLS §3.10.5 Page 35).)
- 执行导致包装转换的操作时。包装转换会给某个基本类型的变量创建相应包装类型的对象。
- 执行不属于常量表达式的字符串连接操作符时，通常会创建一个新的 `String` 对象来表示操作的结果。字符创链接运算符也可能给基本类型的值创建相应的临时包装对象。
- 执行方法引用表达式或者匿名表达式可能要求创建一个实现了 函数式接口的类对象。

以上每种情况都标志着在类对象创建过程中用专门的参数调用特定的构造函数（通常是调用无参构造函数）。

类对象创建时，要给相应类中声明的实例变量和所有父类中声明的实例变量分配内存空间，包括所有隐藏的实例变量（ $ 8.3 ）。如果内存空间不足以给对象分配内存，对象创建过程会以 `OutOfMemoryError` 错误中断。否则新对象中的所有实例变量包括在父类中声明的变量都会初始化为它们的默认值。

在返回新创建对象的引用之前，要通过如下流程使用相应的构造函数初始化新对象：

1. 给构造函数分配新创建的参数变量用于构造函数调用
2. 如果构造函数以同一个类的另外一个构造函数开始，则计算参数并使用同样的 5 步流程递归地调用构造函数。如果构造函数调用中断，则对象初始化过程以同样的原因中断。否则继续执行步骤 5 。
3. 当前构造函数没有显式调用同一个类的其他构造函数。如果构造函数的目标类不是 `Object`，那么构造函数将以父类构造函数的显式或隐式调用开始（ super ）。使用同样的 5 步流程递归地解析参数并调用父类构造函数。如果构造函数调用中断，则对象初始化过程以同样的原因中断，否则继续执行步骤 4 。
4. 执行当前类的实例初始化器和实例变量初始化器，按照源码中出现的顺序从左到右，把实例变量初始化器的值赋给相应的实例变量。如果这些初始化器执行过程中引发了异常，之后的初始化器都不会被处理，对象初始化流程中断，以同样的异常退出。否则，继续执行步骤 5 。
5. 执行构造函数的其余部分。如果执行中断，那么对象创建流程以同样的原因终端执行。否则，对象创建流程正常退出。

Unlike C++, the Java programming language does not specify altered rules for method dispatch during the creation of a new class instance.  If methods are invoked that are overridden in subclasses in the object being initialized, then these overriding methods are used, even before the new object is completely initialized.

**Example 12.5-1. Evaluation of Instance Creation**

```java
class Point {
int x, y;
Point() { x = 1; y = 1; }
}
class ColoredPoint extends Point {
int color = 0xFF00FF;
}
class Test {
public static void main(String[] args) {
ColoredPoint cp = new ColoredPoint();
System.out.println(cp.color);
}
}
```

Here, a new instance of ColoredPoint is created. First, space is allocated for the new ColoredPoint, to hold the fields x, y, and color. All these fields are then initialized to their default values (in this case, 0 for each field). Next, the ColoredPoint constructor with no arguments is first invoked. Since ColoredPoint declares no constructors, a default constructor of the following form is implicitly declared: 

```java
ColoredPoint() { super(); }
```



This constructor then invokes the `Point` constructor with no arguments. The `Point` constructor does not begin with an invocation of a constructor, so the Java compiler provides an implicit invocation of its superclass constructor of no arguments, as though it had been written:

```java
Point() { super(); x = 1; y = 1; }
```

Therefore, the constructor for `Object` which takes no arguments is invoked.

The class `Object` has no superclass, so the recursion terminates here. Next, any instance initializers and instance variable initializers of `Object` are invoked. Next, the body of the constructor of `Object` that takes no arguments is executed. No such constructor is declared in `Object`, so the Java compiler supplies a default one, which in this special case is: 

```java
Object() { }
```



This constructor executes without effect and returns.

Next, all initializers for the instance variables of class `Point` are executed. As it happens, the declarations of `x` and `y` do not provide any initialization expressions, so no action is required for this step of the example. Then the body of the `Point` constructor is executed, setting `x` to 1 and `y` to 1.

Next, the initializers for the instance variables of class `ColoredPoint` are executed. This step assigns the value `0xFF00FF` to color. Finally, the rest of the body of the `ColoredPoint` constructor is executed (the part after the invocation of super); there happen to be no statements in the rest of the body, so no further action is required and initialization is complete.

**Example 12.5-2. Dynamic Dispatch During Instance Creation**

```java
class Super {
Super() { printThree(); }
void printThree() { System.out.println("three"); }
}


class Test extends Super {
int three = (int)Math.PI; // That is, 3
void printThree() { System.out.println(three); }
public static void main(String[] args) {
Test t = new Test();
t.printThree();
}
}
```

This program produces the output:

0

3

This shows that the invocation of `printThree` in the constructor for class `Super` does not invoke the definition of `printThree` in class `Super`, but rather invokes the overriding
definition of `printThree` in class `Test`. This method therefore runs before the field initializers of `Test` have been executed, which is why the first value output is 0, the default value to which the field three of `Test` is initialized. The later invocation of `printThree` in method main invokes the same definition of `printThree`, but by that point the initializer for instance variable three has been executed, and so the value 3 is printed.





## 6. 类对象的析构

*Object* 类有一个叫做 *finalize* 的 *protected* 属性方法，这个方法可以被其他类重写。对于某个对象被调用的相应 *finalize* 方法定义叫做 析构器。在某个对象的存储空间将被垃圾回收器回收之前，*Java* 虚拟机会先调用该对象的析构函数。

析构函数为无法被自动存储管理器自动释放的资源提供了释放的机会。在这种情况下，仅回收被对象占用的内存不能保证其占用的资源也被回收。

*Java* 语言没有规定析构器应该多久调用一次，只规定了应该在对象相应的存储空间被重新利用之前执行析构过程。也没有规定哪个线程应该为某个特定对象调用析构函数。

需要注意可能会有很多个活跃的析构器线程（有时在有很大共享内存的多处理机上很有必要），如果有一个巨大的互联数据结构将要被回收时，该数据结构中所有对象的 `finalize` 方法会被同时调用，每个析构器调用发生在不同的线程中。

*Java* 语言对 `finalize` 方法的调用没有强加任何顺序，析构函数可以以任何顺序调用，甚至是并发调用。

> As an example, if a circularly linked group of unfinalized objects becomes unreachable (or finalizer-reachable), then all the objects may become finalizable together. Eventually, the finalizers for these objects may be invoked, in any order, or even concurrently using multiple threads. If the automatic storage manager later finds that the objects are unreachable, then their storage can be reclaimed.
>
> It is straightforward to implement a class that will cause a set of finalizer-like methods to be invoked in a specified order for a set of objects when all the objects become unreachable. Defining such a class is left as an exercise for the reader.

*Java* 虚拟机保证调用析构器的线程在析构器被调用时不会持有任何用户可见的锁。如果在析构过程中抛出了未被捕获的异常，这个异常会被忽略、该对象的析构过程终止。在对象的析构函数被调用之前，该对象的构造函数一定已经执行完成（ // TODO $ 17.4.5 的 happens-before 定义）。

*Object* 类声明的 *finialize* 方法不会执行任何行为。*Object* 类声明了 *finalize* 方法只意味着任何类的 *finalize* 方法都会调用其父类的 *finalize* 方法。只有在编程人员意图使父类中定义的析构行为作废时，子类的 *finalize* 方法才不应该调用父类的 *finalize* 方法 （析构函数和构造函数不同，不会自动调用父类的析构函数，父类的析构函数调用必须显式编码出来）。

> For efficiency, an implementation may keep track of classes that do not override the finalize method of class Object, or override it in a trivial way. For example:
>
> ```java
> protected void finalize() throws Throwable {
> 	super.finalize();
> }
> ```
>
> We encourage implementations to treat such objects as having a finalizer that is not overridden, and to finalize them more efficiently, as described in §12.6.1.

析构函数和其他所有方法一样可以被显式调用。在 `java.lang.ref` 包定义了弱引用，这个包中的功能可以和垃圾回收和析构器交互。和任何与 *Java* 语言有特殊交互的 API 一样，实现者必须了解 `java.lang.ref` API 中需要施加的约束。Java 语言规范中不谈论弱引用，读者应该参考 Java API 文档了解详细内容。

### 6.1 实现对象析构

每个对象都可以被两个属性描述：一方面该对象可能是 *reachable*、*finalizer-reachable* 或者 *unreachable*，另一方面也可能是 *unfinalized*、*finalizable* 或者 *finalized*。

- *reachable* 表示一个对象可以被任何活跃线程在后续的计算过程中访问。
- *finalizer-reachable* 表示一个对象通过某些可析构对象通过某些引用链可达，但是不能被任何活跃线程访问。
- *unreachable* 表示一个对象既不是 *reachable* 又不是 *finalizer-reachable*。
- *unfinalized* 表示该对象的析构函数还没有被自动调用。
- *finalized* 表示该对象的析构函数已经被自动调用。
- *finalizable* 表示该对象的析构函数还没有被自动调用，但是 Java 虚拟机最终会调用其析构函数。

对象 *o* 直到其构造函数已经成功执行完 *Object* 类的构造函数（没有抛出异常）才会成为 *finalizable*。对于某个对象字段析构前的每一次写入到对象析构前必须是可见的，进一步说，该对象字段析构前的每一次读取操作都不可以看到该对象析构过程启动之后的写入结果。

可以设计对程序的优化操作，减少被标记为 *reachable* 的对象，使其数量少于定义上属于 *reachable* 的对象。例如，Java 编译器或代码生成器也许会选择把一组不再使用的变量或参数设为 null，让这些对象的存储空间被尽快回收。另一个例子是对象的某字段保存在寄存器的情况。程序可能会从寄存器访问该对象而不是从内存访问，并且之后不会在访问该对象，这时就意味着该对象需要进行垃圾回收。要注意这种优化只在该对象的引用处于栈而不是处于堆中时，才被允许。

For example, consider the Finalizer Guardian pattern:

```java
class Foo {
	private final Object finalizerGuardian = new Object() {
		protected void finalize() throws Throwable {
		/* finalize outer Foo object */
		}
	}
}
```



The finalizer guardian forces super.finalize to be called if a subclass overrides finalize and does not explicitly call super.finalize.

If these optimizations are allowed for references that are stored on the heap, then a Java compiler can detect that the finalizerGuardian field is never read, null it out, collect the object immediately, and call the finalizer early. This runs counter to the intent: the programmer probably wanted to call the Foo finalizer when the Foo instance became unreachable. This sort of transformation is therefore not legal: the inner class object should be reachable for as long as the outer class object is reachable.

Transformations of this sort may result in invocations of the finalize method occurring earlier than might be otherwise expected. In order to allow the user to prevent this, we enforce the notion that synchronization may keep the object alive. If an object's finalizer can result in synchronization on that object, then that object must be alive and considered reachable whenever a lock is held on it.

Note that this does not prevent synchronization elimination: synchronization only keeps an object alive if a finalizer might synchronize on it. Since the finalizer occurs in another thread, in many cases the synchronization could not be removed anyway.





### 6.2 与内存模型的交互

内存模型必须能够决定何时执行析构器中发生的活动。这个部分描述对象析构和内存模型之间的交互。

// TODO 这部分与内存模型有关，暂时省略 （Page 377）



## 7. 类和接口的卸载

// TODO JLS 12.7 Page 378

Java 语言的实现会 卸载类。当且仅当类或接口定义的类加载器将要被 $ 12.6 所讨论的垃圾回收器回收时，类或接口将被卸载。被 *bootstrap* 类加载器所加载的类或接口不会被卸载。

类卸载是一个帮助减少资源占用的优化操作。很明显程序语义不应依赖于整个系统是否实现了或如何实现类卸载之类的优化操作。否则就会危害程序的可移植性。因此类或接口是否已经被卸载不应对程序透明。

然而，如果类或接口 *C* 已经被卸载，而它所定义的类加载器有可能成为 *reachable*，那么 *C* 有可能被重新加载回来。我们永远无法确保这种情况不会发生。即使 *C* 没有被已经加载的任何类引用，但它也可能被某个还未被加载的类或接口 *D* 所引用。当 *D* 被 *C* 所定义的类加载器加载进内存时，*D* 的执行就有可能造成 *C* 的重新加载。

举个例子，如果类的静态变量状态可能缺失、静态初始化代码块可能有副作用或者本地方法有可能保存静态状态，这时类的重新加载可能对程序并不是透明的。进一步来说，`Class` 对象的哈希值取决于他的身份。因此，总的来说几乎不可能以完全透明的方式重新加载类或接口。

Reloading may not be transparent if, for example, the class has static variables (whose state would be lost), static initializers (which may have side effects), or native methods (which may retain static state). Furthermore, the hash value of the Class object is dependent on its identity. Therefore it is, in general, impossible to reload a class or interface in a completely transparent manner.

由于我们无法保证卸载其定义的类加载器有可能成为 *reachable* 的类或接口不会造成类的重新加载，也不能保证类的重新加载对程序透明（可是类卸载必须对程序透明），所以在定义的类加载器有可能成为 *reachable* 时不可以卸载相应的类或接口。用相似的推理可以得出，被 *bootstrap* 类加载器所加载的类或接口不能被卸载。

Since we can never guarantee that unloading a class or interface whose loader is potentially reachable will not cause reloading, and reloading is never transparent, but unloading must be transparent, it follows that one must not unload a class or interface while its loader is potentially reachable. A similar line of reasoning can be used to deduce that classes and
interfaces loaded by the bootstrap loader can never be unloaded.

有人也许会争论说为什么在定义的类加载器将被回收时卸载类是安全的。如果定义的类加载器可以被回收，就不会有任何活跃的引用指向它（）。

One must also argue why it is safe to unload a class C if its defining class loader can be reclaimed. If the defining loader can be reclaimed, then there can never be any live references to it (this includes references that are not live, but might be resurrected by finalizers). This, in turn, can only be true if there are can never be any live references to any of the classes defined by that loader, including C, either from their instances or from code.

类卸载优化只适合加载大量类并且这些类使用一段时间后就不再使用的应用。一个基本的示例场景就是 web 浏览器，也有其他应用。这一类应用的特征就是通过显式使用类加载器来管理类，因此上述策略很适合这一类应用。

严格来说类卸载不是必须在 Java 规范中讨论，因为类卸载只是一种优化。但是这个问题十分微妙，所以这里提到它是为了澄清。  





## 8. 程序退出

一个程序在两种情况下停止其所有活动并退出：

- 所有非守护线程的线程终止
- 某个线程调用了 `Runtime` 类或者 `System` 类的 `exit` 方法，并且 `exit` 操作没有被 security manager 禁止。









