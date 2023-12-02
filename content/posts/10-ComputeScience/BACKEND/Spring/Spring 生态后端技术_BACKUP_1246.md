---
scope: learn
draft: true
---


# Spring Framework

## Spring IoC 容器

**[The ToC Container](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans)**

IoC容器的全称叫做控制反转（Inversion of Control ），这是一种设计思想。依赖注入（dependency injection, DI）则是驱动这种设计思想的技术。

Spring的`org.springframework.beans` 和`org.springframework.context`两个包构成了Spring IoC容器的基础，其中`BeanFactory`接口提供了能够管理任何类型对象的高级配置机制、驱动了Spring框架的核心功能，`ApplicationContext`是`BeanFactory`的子接口，在其基础上拓展了应用层的丰富功能。

Spring中构成应用骨架、并由IoC容器托管的对象叫做`Bean`，除此之外`Bean`和应用中的普通Java对象没有任何区别。Spring IoC容器负责`Bean`的初始化、配置、组装，托管其生命周期，`ApplicationContext`就代表IoC容器。IoC容器需要获取配置元数据来控制自己的行为，元数据表述了容器托管对象之间丰富的依赖关系，可以通过xml文件、Java注解、Java代码多种方式表达。

Spring 工作原理的高层抽象如下图：

![container magic](container_magic.png)

### 依赖注入
[依赖注入](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-collaborators)

Spring托管对象通过构造函数参数、工厂方法参数、实例字段定义其依赖的对象，IoC容器在创建`Bean`时会自动注入依赖。这个过程和先获取依赖类位置，再构造依赖对象的过程正好相反。在依赖注入的原则下编写的代码会更加简洁、更容易解耦。托管对象不需要查找依赖、不需要知道依赖对象所处位置或所属类别。

依赖注入主要包含基于构造函数的依赖注入和基于Setter的依赖注入。
### Bean 生命周期
[【Spring】详解Bean的六种作用域、执行流程、生命周期_51CTO博客_spring中bean的作用域和生命周期](https://blog.51cto.com/panyujie/5551094#_prototype_286)
[浅析Spring中bean的作用域|spring|websocket|session|xml_网易订阅](https://www.163.com/dy/article/FCI4T3IF05488SSE.html)

### 自动装配
[自动装配](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-autowire)

自动装配模式：

| Mode          | Explanation                                                  |
| :------------ | :----------------------------------------------------------- |
| `no`          | (Default) No autowiring. Bean references must be defined by `ref` elements. Changing the default setting is not recommended for larger deployments, because specifying collaborators explicitly gives greater control and clarity. To some extent, it documents the structure of a system. |
| `byName`      | Autowiring by property name. Spring looks for a bean with the same name as the property that needs to be autowired. For example, if a bean definition is set to autowire by name and it contains a `master` property (that is, it has a `setMaster(..)` method), Spring looks for a bean definition named `master` and uses it to set the property. |
| `byType`      | Lets a property be autowired if exactly one bean of the property type exists in the container. If more than one exists, a fatal exception is thrown, which indicates that you may not use `byType` autowiring for that bean. If there are no matching beans, nothing happens (the property is not set). |
| `constructor` | Analogous to `byType` but applies to constructor arguments. If there is not exactly one bean of the constructor argument type in the container, a fatal error is raised. |

### Bean 作用域
[Bean 作用域](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-scopes)

Bean定义包含了从类创建其实例的方式，对于一个类可以创建多个对象。而通过设置Bean作用域，就可以控制Bean定义对应的对象数量以及这些对象的生命周期。Bean的默认作用域为singleton。

| Scope                                                        | Description                                                  |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| [singleton](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-scopes-singleton) | (Default) 每个Spring容器中一个Bean定义对应一个对象。         |
| [prototype](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-scopes-prototype) | 一个Bean定义可以对应任何数量的对象。当Bean作用域是非单例的原型作用域时，每次请求某个Bean都会创建一个新的Bean对象。**单例作用域和原型作用域的使用规则是：对有状态Bean使用原型作用域，对无状态Bean使用单例作用域。** |
| [request](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-scopes-request) | 一个Bean定义对应一个HTTP请求的生命周期，每个HTTP请求拥有一个bean对象 。只在 web-aware Spring `ApplicationContext` 的上下文中有效。 |
| [session](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-scopes-session) | 一个Bean定义对应一个 HTTP `Session`的生命周期。              |
| [application](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-scopes-application) | 一个Bean定义对应一个 `ServletContext` 的生命周期。 Only valid in the context of a web-aware Spring `ApplicationContext`. |
| [websocket](https://docs.spring.io/spring-framework/docs/current/reference/html/web.html#websocket-stomp-websocket-scope) | 一个Bean定义对应一个 `WebSocket` 的生命周期。                |

相比其他作用域，Spring对原型作用域的Bean对象并没有提供完整的生命周期管理。容器初始化、配置、组装原型Bean对象之后将其交付给使用者，不再进行任何管理。虽然初始化生命周期函数对任何作用域的Bean对象都会调用，但是销毁生命周期函数对原型作用域对象是不会被调用的。使用者必须手动清理原型作用域对象、释放其可能占用的重要资源。在某些方面Spring容器相对原型Bean对象的角色与`new`操作符相似，等原型Bean对象组装好之后所有生命周期管理都要由使用者负责。

#### 带原型Bean依赖的单例Bean
[带原型Bean依赖的单例Bean](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-factory-scopes-sing-prot-interaction)

#### `Request`、`Session`、`Application`、`Websocket`作用域

这四种作用域只有在使用web类型的`ApplicationContext`实现类时才可用，否则会出现`IlleagalStateException`提示未知作用域。他们都绑定了一个请求、会话等对象，每有一个新的请求或会话就会创建一个新的Bean对象，当相应的请求或会话结束，Bean对象也被销毁。每个Bean对象都是有内部状态的，所以操作一个Bean对象后其他Bean对象是不可见的。

使用时可以通过`@RequestScope`、 `@SessionScope`、 `@ApplicationScope`、 `@WebsocketScope`等注解设置作用域。

### 基于注解的几种依赖注入
[基于注解的几种依赖注入](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-annotation-config)

基于XML和基于注解的容器配置各有优缺点。注解的使用方式带来了更短、更简洁的配置，而XML则更擅长把各种组件装配起来、不需要触及源代码、也不需要改动后重新编译。有的开发者更喜欢通过注解将容器配置和源码融为一体，而有些也可能认为加了注解的类不再是POJO，而且分散的配置不易管理。

- [@Required](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-required-annotation)
- [Using @Autowired](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-autowired-annotation)
- [Fine-tuning Annotation-based Autowiring with @Primary](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-autowired-annotation-primary)
- [Fine-tuning Annotation-based Autowiring with Qualifiers](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-autowired-annotation-qualifiers)
- [Using Generics as Autowiring Qualifiers](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-generics-as-qualifiers)
- [Using CustomAutowireConfigurer](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-custom-autowire-configurer)
- [Injection with @Resource](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-resource-annotation)
- [Using @Value](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-value-annotations)
- [Using @PostConstruct and @PreDestroy](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-postconstruct-and-predestroy-annotations)

#### @AutoWired

@AutoWired自动装配是基于类型匹配，可以用于构造函数、Settter方法、属性字段等，还可以用于特定类型数组来自动装配匹配类型的所有依赖。

#### @Resource

@Resource使用基于Bean名称的自动装配，接受一个`name`参数作为需要注入的Bean名称。如果没有显式提供`name`参数，将从字段名或Setter方法推断出默认Bean名称。

#### @Value

@Value用来注入外部属性。

#### @PostConstruct和@PreDestroy

这两个是生命周期方法注入，把实例方法注入为Bean生命周期方法。
#### 为什么 AutoWired 注入失败而 Resource 注入成功？

### Java-based Container Configuration
[Java-based Container Configuration](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-java)

- [Basic Concepts: `@Bean` and `@Configuration`](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-java-basic-concepts)
- [Instantiating the Spring Container by Using `AnnotationConfigApplicationContext`](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-java-instantiating-container)
- [Using the `@Bean` Annotation](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-java-bean-annotation)
- [Using the `@Configuration` annotation](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-java-configuration-annotation)
- [Composing Java-based Configurations](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-java-composing-configuration-classes)
- [Bean Definition Profiles](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-definition-profiles)
- [`PropertySource` Abstraction](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-property-source-abstraction)
- [Using `@PropertySource`](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-using-propertysource)
- [Placeholder Resolution in Statements](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#beans-placeholder-resolution-in-statements)
## Spring Aop: 面向切面编程

[Spring Aop - 面向切面编程](Spring%20Aop%20-%20面向切面编程.md)

<<<<<<< HEAD
**[Aspect Oriented Programming with Spring](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop)**
[AOP避坑指南 - 廖雪峰的官方网站](https://www.liaoxuefeng.com/wiki/1252599548343744/1339039378571298)
AOP 通过提供另一种构思程序结构的方式对 OOP 编程范式作了补充。OOP 中的模块划分单位是类，而 AOP 中的模块划分单位则是aspect 。Aspect 带来了将跨越多种类型的关注客体进行模块化的能力。

AOP 是 Spring 的关键组件，尽管 Spring IoC 容器不依赖于AOP，但是 AOP 带来了功能能强大的中间件解决方案。AOP 在 Spring 框架中被用来：

- 提供声明式企业服务。最重要的这种类型服务是：[declarative transaction management](https://docs.spring.io/spring-framework/docs/current/reference/html/data-access.html#transaction-declarative)。
- 让用户实现自定义的 aspects，使用 AOP 补充 OOP 的使用。

### 1. AOP概念

#### 核心术语

以下是一些 AOP 的中心概念或术语，这些术语并不是 Spring 特有的。

- Aspect：对跨越多个类的关注客体抽象出的模块。在企业应用中典型例子是事务管理。Spring AOP中Aspect是用Java常规类或者带注解的Java类来实现的。
- Join point：程序执行点，例如方法执行或异常处理。在Spring中，Join point一定代表方法执行。
- Advice：在某个Join point触发时，Aspect采取的动作。Advice类型包括 before、around、after。包括Spring在内的很多AOP框架都把Advice建模为拦截器，围绕Join point维护一系列拦截器。
- Pointcut：匹配Join point的谓词。Advice和Pointcut表达式相关联，在Pointcut所匹配的Join point时机执行。用Pointcut表达式匹配Join point是Spring AOP的核心概念，Spring默认使用Aspectj的Pointcut语法。
- Introduction：替一个类型声明额外的方法或属性。Spring AOP让开发者能给被施加 Advice 的对象引入新的 interface 及其实现。
- Target object：被一组 Aspect 施加 advice 的对象。有时也被叫做“advised object”。由于 Spring AOP 是使用动态代理实现的，所以目标对象一定是一个被代理的对象。
- AOP proxy：AOP框架创建的用来实现Aspect契约（执行Advice方法等……）的对象。Spring框架中，AOP proxy对象是JDK动态代理或者CGLIB代理。
- Weaving：把Aspect和其他应用类型和对象连接起来创建advised object。这个过程可以在编译期间、加载期间或运行期间执行。Spring AOP和其他纯Java AOP框架一样在运行期间进行weaving。

#### Advice 类型

Spring AOP包含下面的 advice 类型：

- **Before advice**：在join point之前执行的advice，但是不能在join point之前阻止对应方法的执行流程（除非advice抛出了异常）。
- **After returning advice**：在join point正常结束之后执行的advice。
- **After throwing advice**：如果join point通过抛出异常结束才执行的advice。
- **After advice**：无论join point以何种方式退出都会执行的advice。
- **Around advice**：围绕join point进行期间执行的advice。这是功能最强大的一种advice，around advice在方法调用之前和之后都可以执行自定义的行为，它也负责决定是继续join point还是通过返回它自己的返回值或者抛出异常来阻止方法的执行。

Around advice 是最通用的 advice 类型。由于 Spring AOP 提供了全套的各种 advice 类型，建议使用刚好足够满足需求的 advice 类型。例如，你只是想用某个方法的返回值来更新缓存，那么最好使用 after returning advice 而不是 around advice 。越是用专门的 advice 类型越能带来更简洁的编程模型、减少潜在的错误。

AOP 中由 pointcut 匹配 join point 的概念是其与只提供拦截功能的传统技术之间的显著区别。Pointcut 让 advice 能够独立于面向对象层次结构针对一组类或对象。例如，可以对散布在多个业务对象中间的一组方法应用 around advice 来提供声明式事务管理服务。

### 2. Spring AOP的功能与目标

Spring AOP 是纯 Java 实现的，不需要专门的编译过程。由于Spring AOP 不需要控制类加载器层次结构，所以适合在 Servlet 容器或应用服务器中使用。

Spring AOP 当前只支持方法执行的 join point，尽管可以不打破Spring AOP API 来实现字段拦截，但是 Spring 没有提供字段拦截支持。**如果有字段访问和更新的 join point 需求，考虑使用 AspectJ 之类的*语言***。

Spring AOP 实现方法与其他多数 AOP 框架不同，目标也不是提供最完备的 AOP 实现，而是提供 AOP 实现和 Spring IoC 容器之间的紧密集成，帮助解决企业应用中的常见问题。因此 Spring 框架的 AOP 功能常常是和 IoC 结合使用的。Aspect 是用常见的 Bean 定义语法来配置的，这是和其他 AOP 实现之间的重要区别。

### 3. AOP 代理

**[AOP Proxies](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-introduction-proxies)**

Spring AOP默认使用标准JDK动态代理，作为AOP 代理。JDK动态代理能用来代理接口。Spring AOP也使用CGLIB代理，当有的业务对象没有实现任何接口时会使用CGLIB代理。由于面向接口编程的最佳实践，业务类通常会实现一些业务接口。在需要针对不在接口中定义的方法使用advice或者需要把被代理对象以实体类传递给目标方法时，也可以[强制使用CGLIB代理](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-proxying)。

请牢牢把握 Spring AOP是基于代理实现的， [Understanding AOP Proxies](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-understanding-aop-proxies) 详细解释了Spring AOP代理的实现细节。

Tri### 4. 使用 Spring AOP

这里 Spring Framework 介绍了基于 AspectJ 和 Schema-based 的两种使用方式，包含了如何定义 `Aspect`、`Pointcut`、`Advice`、`Introduction`，以及一段 AOP 示例代码。

**@AspectJ support [Aspect Oriented Programming with Spring: 5.4](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-ataspectj)**：

- [Enabling @AspectJ Support](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-aspectj-support)
- [Declaring an Aspect](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-at-aspectj)
- [Declaring a Pointcut](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-pointcuts)
- [Declaring Advice](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-advice)
- [Introductions](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-introductions)
- [Aspect Instantiation Models](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-instantiation-models)
- [An AOP Example](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-ataspectj-example)

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

**Further Resources**

More information on AspectJ can be found on the [AspectJ website](https://www.eclipse.org/aspectj).

*Eclipse AspectJ* by Adrian Colyer et. al. (Addison-Wesley, 2005) provides a comprehensive introduction and reference for the AspectJ language.

*AspectJ in Action*, Second Edition by Ramnivas Laddad (Manning, 2009) comes highly recommended. The focus of the book is on AspectJ, but a lot of general AOP themes are explored (in some depth).

使用实例：
[DataFlow/WebLogAspect.java at develop · xdsselab/DataFlow](https://github.com/xdsselab/DataFlow/blob/develop/common/src/main/java/com/bdilab/dataflow/common/aop/WebLogAspect.java)

### 5. 代理机制

**[AOP: 5.8 Proxying Mechanisms](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-proxying)**

#### JDK 动态代理 和 CGLIB 代理

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

#### 理解 AOP 代理

 **[Understanding AOP Proxies](https://docs.spring.io/spring-framework/docs/current/reference/html/core.html#aop-understanding-aop-proxies)** 

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
=======
>>>>>>> origin/main
## 杂项
### 数据校验
[(154条消息) spring 注解验证@NotNull等使用方法_长沙郭富城的博客-CSDN博客_notnull](https://blog.csdn.net/qq920447939/article/details/80198438)
[Difference Between @NotNull, @NotEmpty, and @NotBlank Constraints in Bean Validation | Baeldung](https://www.baeldung.com/java-bean-validation-not-null-empty-blank)

## 问题案例
### CGLIB 代理
Spring 通过 CGLIB 动态创建的代理类继承自被代理类，但不会调用被代理类的构造函数（不会初始化被代理类的任何成员变量）。

[AOP避坑指南 - 廖雪峰的官方网站](https://www.liaoxuefeng.com/wiki/1252599548343744/1339039378571298): <https://www.liaoxuefeng.com/wiki/1252599548343744/1339039378571298>

# 参考资料

[Spring AOP 扫盲 - 程序员cxuan - 博客园](https://www.cnblogs.com/cxuanBlog/p/13060510.html): <https://www.cnblogs.com/cxuanBlog/p/13060510.html>
