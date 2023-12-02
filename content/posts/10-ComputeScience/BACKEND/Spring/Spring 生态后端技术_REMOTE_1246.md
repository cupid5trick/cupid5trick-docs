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
