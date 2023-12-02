# Spring Aop: 面向切面编程
Aop - Aspect Oriented Programming

- [Aspect Oriented Programming with Spring](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop)
- [AOP避坑指南 - 廖雪峰的官方网站](https://www.liaoxuefeng.com/wiki/1252599548343744/1339039378571298)
AOP 通过提供另一种构思程序结构的方式对 OOP 编程范式作了补充。OOP 中的模块划分单位是类，而 AOP 中的模块划分单位则是aspect 。Aspect 带来了将跨越多种类型的关注客体进行模块化的能力。

AOP 是 Spring 的关键组件，尽管 Spring IoC 容器不依赖于AOP，但是 AOP 带来了功能能强大的中间件解决方案。AOP 在 Spring 框架中被用来：

- 提供声明式企业服务。最重要的这种类型服务是：[declarative transaction management](https://docs.spring.io/spring-framework/docs/current/reference/html/data-access.html#transaction-declarative)。
- 让用户实现自定义的 aspects，使用 AOP 补充 OOP 的使用。

## 1. AOP概念
### 核心术语

以下是一些 AOP 的中心概念或术语，这些术语并不是 Spring 特有的。

- **Aspect - 切面**：对跨越多个类的关注客体抽象出的模块。在企业应用中典型例子是事务管理。Spring AOP 中 Aspect 是用 Java 常规类或者带注解的 Java 类来实现的。
- **Join point - 连接点**：程序执行点，例如方法执行或异常处理。在 Spring 中，Join point 一定代表方法执行。
- **Advice - 通知**：在某个 Join point 触发时，Aspect 采取的动作。Advice 类型包括 before、around、after。包括 Spring 在内的很多 AOP 框架都把 Advice 建模为拦截器，围绕 Join point 维护一系列拦截器。
- **Pointcut - 切点**：匹配 Join point 的谓词。Advice 和 Pointcut 表达式相关联，在 Pointcut 所匹配的 Join point 时机执行。用 Pointcut 表达式匹配 Join point 是 Spring AOP 的核心概念，Spring 默认使用 Aspectj 的 Pointcut 语法。
- **Introduction - **：替一个类型声明额外的方法或属性。Spring AOP 让开发者能给被施加 Advice 的对象引入新的 interface 及其实现。
- Target object：被一组 Aspect 施加 advice 的对象。有时也被叫做“advised object”。由于 Spring AOP 是使用动态代理实现的，所以目标对象一定是一个被代理的对象。
- **AOP proxy - 代理**：AOP 框架创建的用来实现 Aspect 契约（执行 Advice 方法等……）的对象。Spring 框架中，AOP proxy 对象是 JDK 动态代理或者 CGLIB 代理。
- **Weaving - 织入**：把 Aspect 和其他应用类型和对象连接起来创建 advised object。这个过程可以在编译期间、加载期间或运行期间执行。Spring AOP 和其他纯 Java AOP 框架一样在运行期间进行 weaving。

### Advice 类型

Spring AOP包含下面的 advice 类型：

- **Before advice**：在join point之前执行的advice，但是不能在join point之前阻止对应方法的执行流程（除非advice抛出了异常）。
- **After returning advice**：在join point正常结束之后执行的advice。
- **After throwing advice**：如果join point通过抛出异常结束才执行的advice。
- **After advice**：无论join point以何种方式退出都会执行的advice。
- **Around advice**：围绕join point进行期间执行的advice。这是功能最强大的一种advice，around advice在方法调用之前和之后都可以执行自定义的行为，它也负责决定是继续join point还是通过返回它自己的返回值或者抛出异常来阻止方法的执行。把整个目标方法包裹起来，在**被调用前和调用之后分别调用通知功能**相关的类`org.aopalliance.intercept.MethodInterceptor`。

Around advice 是最通用的 advice 类型。由于 Spring AOP 提供了全套的各种 advice 类型，建议使用刚好足够满足需求的 advice 类型。例如，你只是想用某个方法的返回值来更新缓存，那么最好使用 after returning advice 而不是 around advice 。越是用专门的 advice 类型越能带来更简洁的编程模型、减少潜在的错误。

AOP 中由 pointcut 匹配 join point 的概念是其与只提供拦截功能的传统技术之间的显著区别。Pointcut 让 advice 能够独立于面向对象层次结构针对一组类或对象。例如，可以对散布在多个业务对象中间的一组方法应用 around advice 来提供声明式事务管理服务。

### 代理作用时期 - Weaving
-   `编译期`：切面在目标类编译时被织入，这种方式需要特殊的编译器。**AspectJ 的织入编译器就是以这种方式织入切面的。**
-   `类加载期`：切面在目标类加载到 JVM 时被织入，这种方式需要特殊的类加载器( ClassLoader )，它可以在目标类引入应用之前增强目标类的字节码。
-   `运行期`：切面在应用运行的某个时期被织入。一般情况下，在织入切面时，AOP容器会为目标对象动态创建一个代理对象，**Spring AOP 采用的就是这种织入方式。**

## 2. Spring AOP的功能与目标

Spring AOP 是纯 Java 实现的，不需要专门的编译过程。由于Spring AOP 不需要控制类加载器层次结构，所以适合在 Servlet 容器或应用服务器中使用。

Spring AOP 当前只支持方法执行的 join point，尽管可以不打破Spring AOP API 来实现字段拦截，但是 Spring 没有提供字段拦截支持。**如果有字段访问和更新的 join point 需求，考虑使用 AspectJ 之类的语言**。

Spring AOP 实现方法与其他多数 AOP 框架不同，目标也不是提供最完备的 AOP 实现，而是提供 AOP 实现和 Spring IoC 容器之间的紧密集成，帮助解决企业应用中的常见问题。因此 Spring 框架的 AOP 功能常常是和 IoC 结合使用的。Aspect 是用常见的 Bean 定义语法来配置的，这是和其他 AOP 实现之间的重要区别。

## 3. AOP 代理

**[AOP Proxies](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-introduction-proxies)**

Spring AOP 默认使用标准的 JDK 动态代理作为 AOP 代理，JDK 动态代理能用来代理接口。Spring AOP 也使用 CGLIB 代理，当有的业务对象没有实现任何接口时会使用 CGLIB 代理。由于面向接口编程的最佳实践，业务类通常会实现一些业务接口。在需要针对不在接口中定义的方法使用 advice 或者需要把被代理对象以实体类传递给目标方法时，也可以[强制使用CGLIB代理](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-proxying)。

请牢牢把握 Spring AOP是基于代理实现的， [Understanding AOP Proxies](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-understanding-aop-proxies) 详细解释了Spring AOP代理的实现细节。

## 4. 使用 Spring AOP

这里 Spring Framework 介绍了基于 AspectJ 和 Schema-based 的两种使用方式，包含了如何定义 `Aspect`、`Pointcut`、`Advice`、`Introduction`，以及一段 AOP 示例代码。

以 Java 代码使用 Aop 切面：
**@AspectJ support [Aspect Oriented Programming with Spring: 5.4](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-ataspectj)**：

- [Enabling @AspectJ Support](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-aspectj-support)
- [Declaring an Aspect](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-at-aspectj)
- [Declaring a Pointcut](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-pointcuts)
- [Declaring Advice](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-advice)
- [Introductions](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-introductions)
- [Aspect Instantiation Models](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-instantiation-models)
- [An AOP Example](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-ataspectj-example)

XML 方式使用 Aop 切面：
**Schema-based AOP support [Aspect Oriented Programming with Spring: 5.5](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-schema)**：

- [Declaring an Aspect](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-schema-declaring-an-aspect)
- [Declaring a Pointcut](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-schema-pointcuts)
- [Declaring Advice](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-schema-advice)
- [Introductions](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-schema-introductions)
- [Aspect Instantiation Models](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-schema-instatiation-models)
- [Advisors](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-schema-advisors)
- [An AOP Schema Example](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-schema-example)

**Choosing which AOP Declaration Style to Use [Aspect Oriented Programming with Spring: 5.6](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-choosing)**：

- [Spring AOP or Full AspectJ?](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-spring-or-aspectj)
- [@AspectJ or XML for Spring AOP?](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-ataspectj-or-xml)
- 混用 Aspect 类型 [5.7 Mixing Aspect Types](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-mixing-styles)：在同一个配置中完全可以把 AspectJ 代理和 Schema 代理混用，或者 AspectJ 代理和 Schema 模式声明的 advisor 混搭，甚至混用其他类型的代理和拦截器。所有类型的 AOP 组件都是用同样的底层支持机制实现的，因此共存毫无困难。

编程式创建 @AspectJ 代理：[5.9 Programmatic Creation of @AspectJ Proxies](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-aspectj-programmatic)，在应用中使用 @AspectJ [5.10 Using AspectJ with Sprint Applications](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-using-aspectj)。
### 声明 Aspect - 切面

有两种方式声明 Aspect：
- 通过在应用配置类（带有 `@Configuration` 的 Java 类）上添加  `@EnableAspectJAutoProxy` 注解，任何带有 `@Aspect` 注解的 Java 类都会被 spring 自动注册为 Aspect。
- 如果没有配置 Spring 自动扫描 Aspect 类，除了需要添加 `@Aspect` 注解之外，需要手动把该类注册为 Spring Bean。（在配置类中引入 ` @Bean ` 定义或者直接在 Java 类上加 ` @Component ` /或其他等价的注解 ）

注意：
在 Spring AOP 中，Aspect 作用的目标不能是 Aspect。类上的 @Aspect 注释将其标记为一个 Aspect，因此也断绝了为其添加自动代理的可能。

### 声明 PointCut - 切点

切点声明确定了 Aspect 连接点作用的范围和时间。Spring AOP 只支持 Spring bean 的方法执行连接点，所以你可以认为切入点是匹配 Spring Bean 方法的执行。

切点声明由两部分组成：
1. 由切点名称和任意参数构成的切点签名。
2. 遵循 AspectJ 语法的切点表达式，用来确定切面通知关注哪些方法的执行。Spring Aop 中的切点声明采用 AspectJ 表达式。

在 `@Aspect` 注解风格的 Aop 使用场景中，切点签名就是一个返回值类型为 void 的常规 Java 类方法，切点表达式则在 `@PointCut` 注解中体现，必须是一个合法的 AspectJ 表达式。有关 AspectJ 的切入点语言的完整讨论，参考 [AspectJ Programming Guide](https://www.eclipse.org/aspectj/doc/released/progguide/index.html)。深入了解可以阅读 [AspectJ 5 Developer’s Notebook](https://www.eclipse.org/aspectj/doc/released/adk15notebook/index.html)。

>The pointcut expression that forms the value of the `@Pointcut` annotation is a regular AspectJ pointcut expression. For a full discussion of AspectJ’s pointcut language, see the [AspectJ Programming Guide](https://www.eclipse.org/aspectj/doc/released/progguide/index.html) (and, for extensions, the [AspectJ 5 Developer’s Notebook](https://www.eclipse.org/aspectj/doc/released/adk15notebook/index.html)) or one of the books on AspectJ (such as _Eclipse AspectJ_, by Colyer et al., or _AspectJ in Action_, by Ramnivas Laddad).

#### 支持的切点类型：切点描述符

Spring Aop 支持在切点表达式中使用下面几种切点描述符：

| 切点描述符  | 含义                                |
|--------------|-----------------------------------|
| arg()        | 限制连接点匹配参数为指定类型的执行方法               |
| @args()      | 限制连接点匹配参数由指定注解标注的执行方法             |
| execution()  | 用于匹配是连接点的执行方法                     |
| this()       | 限制连接点匹配的AOP代理的bean引用为指定类型的类       |
| target       | 限制连接点匹配目标对象为指定类型的类                |
| @target()    | 限制连接点匹配特定的执行对象，这些对象对应的类要具有指定类型的注解 |
| within()     | 限制连接点匹配指定的类型                      |
| @within()    | 限制连接点匹配指定注解所标注的类型                 |
| @annotation () | 限定匹配带有指定注解的连接点                    |

Spring AOP 还支持一个名为 `bean` 的切点描述符，允许您将连接点的匹配限制为特定命名的 Spring bean 或一组 Spring bean（使用通配符）。 `bean` 描述符的形式为： `bean(idOrNameOfBean)` ， `idOrNameOfBean` 可以是任何 Spring bean 的名称。提供了使用该字符的有限通配符支持 `*` ，因此，如果您为 Spring bean 建立了一些命名约定，则可以编写一个切点表达式来选择它们。与其他切点描述符的情况一样， PCD 也可以与 (and)、(or) 和 (negation) 运算符 `bean` 一起使用。 `&&``||``!`

完整的 AspectJ 切入点语言支持 Spring 不支持的额外切入点描述符： `call` 、 `get` 、 `set` 、 `preinitialization` 、 `staticinitialization` 、 `initialization` 、 `handler` 、 `adviceexecution` 、 `withincode` 、 `cflow` 、 `cflowbelow` 、 `if` 、 `@this` 、 `@withincode` 。在由 Spring AOP 解释的切入点表达式中使用这些切入点描述符会导致抛出 `IllegalArgumentException` 。Spring AOP 支持的切点描述符集可能会在未来的版本中扩展，以支持更多的 AspectJ 切点描述符。

因为 Spring AOP 将匹配限制为仅方法执行连接点，所以前面对切点描述符的讨论给出了比您在 AspectJ 编程指南中可以找到的更窄的定义。此外，AspectJ 本身具有基于类型的语义，并且在执行连接点处，两者都 `this` 引用 `target` 同一个对象：执行方法的对象。而 Spring AOP 是一个基于代理的系统，区分代理对象本身（绑定到 `this` ）和代理背后的目标对象（绑定到 `target` ）。

#### 组合切点表达式

在切点表达式中可以通过与、或、非运算符（ `&&` 、 `||` 、 `!` ）来构成复杂的切点表达式。同时也可以按切点名称引用切点表达式，切点表达式的引用同样支持与或非运算符。下面是一个例子：

```java
package com.xyz;

@Aspect
public class Pointcuts {

    @Pointcut("execution(public * *(..))")
    public void publicMethod() {} (1)

    @Pointcut("within(com.xyz.trading..*)")
    public void inTrading() {} (2)

    @Pointcut("publicMethod() && inTrading()")
    public void tradingOperation() {} (3)
}
```

最好的做法是从较小的命名切入点构建更复杂的切入点表达式，如上所示。当按名称引用切入点时，将应用正常的 Java 可见性规则（您可以看到 `private` 相同类型的切入点、 `protected` 层次结构中的切入点、 `public` 任何地方的切入点，等等）。可见性不影响切入点匹配。

#### 最佳实践：共享切点定义

在使用企业应用程序时，开发人员通常需要从多个方面引用应用程序的模块和特定的操作集。为此，我们建议定义一个专门的方面 Aspect 来捕获常用的命名切入点表达式。下面是一个示例：
```java
package com.xyz;

import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Pointcut;

@Aspect
public class CommonPointcuts {

    /**
     * A join point is in the web layer if the method is defined
     * in a type in the com.xyz.web package or any sub-package
     * under that.
     */
    @Pointcut("within(com.xyz.web..*)")
    public void inWebLayer() {}

    /**
     * A join point is in the service layer if the method is defined
     * in a type in the com.xyz.service package or any sub-package
     * under that.
     */
    @Pointcut("within(com.xyz.service..*)")
    public void inServiceLayer() {}

    /**
     * A join point is in the data access layer if the method is defined
     * in a type in the com.xyz.dao package or any sub-package
     * under that.
     */
    @Pointcut("within(com.xyz.dao..*)")
    public void inDataAccessLayer() {}

    /**
     * A business service is the execution of any method defined on a service
     * interface. This definition assumes that interfaces are placed in the
     * "service" package, and that implementation types are in sub-packages.
     *
     * If you group service interfaces by functional area (for example,
     * in packages com.xyz.abc.service and com.xyz.def.service) then
     * the pointcut expression "execution(* com.xyz..service.*.*(..))"
     * could be used instead.
     *
     * Alternatively, you can write the expression using the 'bean'
     * PCD, like so "bean(*Service)". (This assumes that you have
     * named your Spring service beans in a consistent fashion.)
     */
    @Pointcut("execution(* com.xyz..service.*.*(..))")
    public void businessService() {}

    /**
     * A data access operation is the execution of any method defined on a
     * DAO interface. This definition assumes that interfaces are placed in the
     * "dao" package, and that implementation types are in sub-packages.
     */
    @Pointcut("execution(* com.xyz.dao.*.*(..))")
    public void dataAccessOperation() {}

}
```

#### 编译期切点条件处理

// TODO [Writing Good PointCuts](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#writing-good-pointcuts)

在编译期间，AspectJ 处理切入点以优化匹配性能。检查代码并确定每个连接点是否匹配（静态或动态）给定的切入点是一个代价高昂的过程。（动态匹配是指静态分析无法完全确定匹配，代码运行时会在代码中放置一个测试来判断是否存在实际匹配）。在第一次遇到切入点声明时，AspectJ 将其重写为匹配过程的最佳形式。这是什么意思？基本上，切入点在 DNF（析取范式）中被重写，并且切入点的组件被排序，以便首先检查那些评估成本更低的组件。

但是，AspectJ 只能处理它被告知的内容。为了获得最佳的匹配性能，您应该考虑您要实现的目标，并在定义中尽可能缩小匹配的搜索空间。现有的指示符自然属于三组之一：种类、范围和上下文：

-   Kinded 指示符选择一种特定类型的连接点： `execution`、`get`、`set`、`call`和`handler`。
-   范围指示符选择一组感兴趣的连接点（可能有多种）：`within`和`withincode`
-   上下文指示符根据上下文匹配（并可选地绑定）： `this`, `target`, 和`@annotation`

一个写得很好的切入点应该至少包括前两种类型（类型和范围）。您可以包括上下文指示符以基于连接点上下文进行匹配或绑定该上下文以用于建议。仅提供 kinded 指示符或仅提供上下文指示符可行，但可能会影响织入性能（使用的时间和内存），因为需要进行额外的处理和分析。作用域指示符的匹配速度非常快，使用它们意味着 AspectJ 可以非常快速地消除不应进一步处理的连接点组。如果可能的话，一个好的切入点应该总是包含一个切入点。


### 声明 Advice - 通知
Advice 与一个切点表达式相关联，在切点所匹配的方法执行点之前、之后以及执行点前后进行自定义的操作。关联的切点表达式可以是内联的表达式，也可以是一个切点名称引用。

对于所有的 Advice 类型，都有相应的注解以便配置： `@Before` 、 `@After` `@AfterReturning` `@AfterThrowing` `@Around` 。

#### 关于 Advice 的参数绑定

Spring 的 Advice 是类型化的，这意味着可以在 Advice 方法签名中声明需要的参数，而避免了处理 `Object[]` 数组的麻烦。

所有的 Advice 都会声明第一个参数为 `JoinPoint` 类型，其中 Around Advice 需要声明为 `PreceedingJoinPoint` ，它是 `JoinPoint` 的子接口。 `JoinPoint` 接口提供了一些有用的方法：

-   `getArgs()` : 返回被通知方法的参数。
-   `getThis()` : 返回代理对象，因为 Spring Aop 是基于代理的。
-   `getTarget()` : 返回被通知对象（也就是被代理对象）。
-   `getSignature()` 返回被通知方法的描述信息。
-   `toString()` : 打印被通知方法的描述信息。

除去第一个参数，Advice 方法体还能声明任意的其他参数。在 `AfterReturning` 和 `AfterThrowing` 通知中，可以把返回值或抛出的异常对象绑定到 Advice 定义的方法体中。
// TODO

对于其他类型的通知，可以利用切点表达式中的 `args` 描述符。在 `args` 表达式中用参数名称代替参数类型，对应参数的值就会在触发通知时传递到 Advice 方法。
```java
@Before("execution(* com.xyz.dao.*.*(..)) && args(account,..)")
public void validateAccount(Account account) {
    // ...
}
```

上面的例子中，切入点表达式的 args (account,..) 部分起到了两点作用：
1. 限制切点匹配至少接收一个参数的方法，并且第一个参数的类型为 `Account`
2. 通过 Advice 方法体的 `account` 参数接受所匹配方法调用的实际对象

关于如何确定参数名称，Spring Aop 设计了一套 `ParameterNameDiscoverer` 实现，具体参考 [Determine Argument Names](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-ataspectj-advice-params-names)。对于除了 `ParameterNameDiscoverer` 之外，切点注解和通知注解都提供了 `argNames` 属性以便显式指定参数名称。

还有一种写法是：声明一个带参数的切点，并通过 Advice 声明把参数传递过来：
```java
@Pointcut("execution(* com.xyz.dao.*.*(..)) && args(account,..)")
private void accountDataAccessOperation(Account account) {}

@Before("accountDataAccessOperation(account)")
public void validateAccount(Account account) {
    // ...
}
```

代理对象 `this` 、目标对象 `target` 还有一些相关的注解（ `@within` , `@target` , `@annotation` , and `@args` ）都可以通过类似的方式绑定到 Advice 方法。例如：
```java
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
public @interface Auditable {
    AuditCode value();
}

@Before("com.xyz.Pointcuts.publicMethod() && @annotation(auditable)") (1)
public void audit(Auditable auditable) {
    AuditCode code = auditable.value();
    // ...
}
```

#### **泛型 Aop**
Spring Aop 也可以在类声明和方法参数中使用泛型。
```java
public interface Sample<T> {
    void sampleGenericMethod(T param);
    void sampleGenericCollectionMethod(Collection<T> param);
}

@Before("execution(* ..Sample+.sampleGenericMethod(*)) && args(param)")
public void beforeSampleMethod(MyType param) {
    // Advice implementation
}

@Before("execution(* ..Sample+.sampleGenericCollectionMethod(*)) && args(param)")
public void beforeSampleMethod(Collection<MyType> param) {
    // Advice implementation
}

```

#### Advice 的顺序问题
[Advice Ordering](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-ataspectj-advice-ordering)
// TODO

当多个 Advice 匹配到同一个对象的同一个方法调用时，该如何确定这些 Advice 执行的顺序？Spring Aop 采用和 AspectJ 相同的优先级策略。在方法调用点的入口方向，高优先级的 Advice 先运行；在出口方向，低优先级的 Advice 先运行。

对于定义在不同 Aspect 类中的多个 Advice，除非预先指定了优先级，否则他们的执行顺序是不确定的。Spring 有两种方法控制 Advice 的优先级，用一个数值代表优先级，数值越小优先级越高：
- 定义 Aspect 类的同时让其实现 `Ordered` 接口，在 `getOrder` 方法中返回代表优先级的数值。
- 在 Aspect 类上添加 `@Order` 注解设置优先级的数值。
从 Spring Framework 5.2.7 开始，在同一 Aspect 类中定义的、需要在同一连接点运行的 Advice 方法会根据其类型被分配优先级，优先级从高到低的顺序如下为： `@Around` , `@Before` , `@After` , `@AfterReturning` , `@AfterThrowing` 。但是请注意， `@After` Advice 方法将在同一方面的任何 `@AfterReturning` 或 `@AfterThrowing` 建议方法之后被调用，这符合 AspectJ 对 `@After` 的 "最后建议"语义。


### Introduction
// TODO

Introduction 可以让切面能替被通知对象实现一个接口，替被通知（代理）对象调用自己提供的实现类。这种功能在 AspectJ 中叫做跨类型声明（inter-type declaration）。

只要把需要实现的接口声明为切面类的一个成员，并在其上添加 `DeclareParents` 注解，即可实现 Introduction 功能。被 `@DeclareParents` 所注解字段的类型，就是切面在匹配到被代理对象之后将要引入的类型。因此把这个功能叫做 Introduction。

`@DeclareParents` 注解让切点所匹配的类型实现了一个父接口，并指定了对应的实现类。该注解的 `value` 属性是一个 AspectJ 的类型表达式 (type pattern)，任何匹配到的 Spring Bean 都会实现注解所对应字段的接口，并把 `defaultImpl` 属性所提供的类作为相应接口的实现类。

### 进阶 - Aspect Instantiation Model
// TODO

[Aspect Instantiation Model](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-instantiation-models)


### Further Resources

More information on AspectJ can be found on the [AspectJ website](https://www.eclipse.org/aspectj).

*Eclipse AspectJ* by Adrian Colyer et. al. (Addison-Wesley, 2005) provides a comprehensive introduction and reference for the AspectJ language.

*AspectJ in Action*, Second Edition by Ramnivas Laddad (Manning, 2009) comes highly recommended. The focus of the book is on AspectJ, but a lot of general AOP themes are explored (in some depth).

使用实例：
[DataFlow/WebLogAspect.java at develop · xdsselab/DataFlow](https://github.com/xdsselab/DataFlow/blob/develop/common/src/main/java/com/bdilab/dataflow/common/aop/WebLogAspect.java)

## 5. 代理机制

**[AOP: 5.8 Proxying Mechanisms](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-proxying)**

### JDK 动态代理 和 CGLIB 代理

Spring AOP 使用 JDK 动态代理或 CGLIB 给目标对象创建代理。JDK 动态代理的好处是内置的，而 CGLIB 则是一个常用的开源类库（包装在 `spring-core` 组件中）。

Java 动态代理是利用反射机制生成一个实现代理接口的代理类，在调用具体方法前调用内部 InvokeHandler 来处理，InvokeHandler 将会调用 invoke 方法并处理目标实际方法。

而 cglib 动态代理是利用 asm 开源包，对代理对象类的 class 文件加载进来，通过修改其字节码生成子类来处理。

- 如果目标对象实现了接口，默认情况下会采用 JDK 的动态代理实现 AOP
- 如果目标对象实现了接口，可以强制使用 CGLIB 实现 AOP
- 如果目标对象没有实现了接口，必须采用 CGLIB 库，spring 会自动在 JDK 动态代理和 CGLIB 之间转换


如果需要被代理的目标对象至少实现了某个接口，会使用 JDK 动态代理，目标对象类型所实现的所有接口都会被代理。而如果该对象没有实现任何接口，就会使用 CGLIB 为其创建代理。

如果想强制 Spring 使用 CGLIB 代理（比如，要代理目标对象所定义的全部方法，而不仅是其实现接口的方法）也是可以的。但是要考虑一下问题：

-  使用 CGLIB 时不能对 `final` 方法执行 advise，因为 `final` 方法不能在运行时生成的子类中被覆盖。
- 对 Spring 4.0 而言，被代理对象的构造方法不能多次调用，因为 CGLIB 代理对象是通过 *Objenesis* 创建的。除非你的 JVM 支持*构造器 bypass*，否则不会有 CGLIB 多次调用构造方法及其调试日志。

如果确定要强制使用 CGLIB 代理，可以把 `<aop:config>` 元素中的 `proxy-target-class` 设为 `true`：

```xml
<aop:config proxy-target-class="true">
    <!-- other beans defined here... -->
</aop:config>
```

如果 要在 @AspectJ 的自动代理支持中使用 CGLIB 代理，把 `<aop:aspectj-autoproxy>` 元素的 `proxy-target-class` 设为 `true`：

```xml
<aop:aspectj-autoproxy proxy-target-class="true"/>
```

> Multiple `<aop:config/>` sections are collapsed into a single unified auto-proxy creator at runtime, which applies the *strongest* proxy settings that any of the `<aop:config/>` sections (typically from different XML bean definition files) specified. This also applies to the `<tx:annotation-driven/>` and `<aop:aspectj-autoproxy/>` elements.
>
> To be clear, using `proxy-target-class="true"` on `<tx:annotation-driven/>`, `<aop:aspectj-autoproxy/>`, or `<aop:config/>` elements forces the use of CGLIB proxies *for all three of them*.

多个 `<aop:config/>` 会在运行时合并成一个统一的配置，会采用 *strongest*  （通常是来自多个不同的 bean 定义文件）。 `<tx:annotation-driven/>` 和 `<aop:aspectj-autoproxy/>` 同样遵守这个规则。需要说明的是在这三种元素中任一个定义了 `proxy-target-class="true"` 都会让这三种元素全都强制使用 CGLIB 代理。

### 理解 AOP 代理

[Understanding AOP Proxies](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-understanding-aop-proxies) 

Spring AOP is proxy-based. It is vitally important that you grasp the semantics of what that last statement actually means before you write your own aspects or use any of the Spring AOP-based aspects supplied with the Spring Framework.

Consider first the scenario where you have a plain-vanilla, un-proxied, nothing-special-about-it, straight object reference, as the following code snippet shows:

Java

```java
public class SimplePojo implements Pojo {

    public void foo() {
        // this next method invocation is a direct call on the 'this' reference
        this.bar();
    }

    public void bar() {
        // some logic...
    }
}
```

If you invoke a method on an object reference, the method is invoked directly on that object reference, as the following image and listing show:

![aop proxy plain pojo call](aop_proxy_plain_pojo_call.png)

Java

```java
public class Main {

    public static void main(String[] args) {
        Pojo pojo = new SimplePojo();
        // this is a direct method call on the 'pojo' reference
        pojo.foo();
    }
}
```

Things change slightly when the reference that client code has is a proxy. Consider the following diagram and code snippet:

![aop proxy call](aop_proxy_call.png)

Java

Kotlin

```java
public class Main {

    public static void main(String[] args) {
        ProxyFactory factory = new ProxyFactory(new SimplePojo());
        factory.addInterface(Pojo.class);
        factory.addAdvice(new RetryAdvice());

        Pojo pojo = (Pojo) factory.getProxy();
        // this is a method call on the proxy!
        pojo.foo();
    }
}
```

The key thing to understand here is that the client code inside the `main(..)` method of the `Main` class has a reference to the proxy. This means that method calls on that object reference are calls on the proxy. As a result, the proxy can delegate to all of the interceptors (advice) that are relevant to that particular method call. However, once the call has finally reached the target object (the `SimplePojo` reference in this case), any method calls that it may make on itself, such as `this.bar()` or `this.foo()`, are going to be invoked against the `this` reference, and not the proxy. This has important implications. It means that self-invocation is not going to result in the advice associated with a method invocation getting a chance to run.

Okay, so what is to be done about this? The best approach (the term "best" is used loosely here) is to refactor your code such that the self-invocation does not happen. This does entail some work on your part, but it is the best, least-invasive approach. The next approach is absolutely horrendous, and we hesitate to point it out, precisely because it is so horrendous. You can (painful as it is to us) totally tie the logic within your class to Spring AOP, as the following example shows:

Java

```java
public class SimplePojo implements Pojo {

    public void foo() {
        // this works, but... gah!
        ((Pojo) AopContext.currentProxy()).bar();
    }

    public void bar() {
        // some logic...
    }
}
```

This totally couples your code to Spring AOP, and it makes the class itself aware of the fact that it is being used in an AOP context, which flies in the face of AOP. It also requires some additional configuration when the proxy is being created, as the following example shows:

Java

```java
public class Main {

    public static void main(String[] args) {
        ProxyFactory factory = new ProxyFactory(new SimplePojo());
        factory.addInterface(Pojo.class);
        factory.addAdvice(new RetryAdvice());
        factory.setExposeProxy(true);

        Pojo pojo = (Pojo) factory.getProxy();
        // this is a method call on the proxy!
        pojo.foo();
    }
}

```

Finally, it must be noted that AspectJ does not have this self-invocation issue because it is not a proxy-based AOP framework.