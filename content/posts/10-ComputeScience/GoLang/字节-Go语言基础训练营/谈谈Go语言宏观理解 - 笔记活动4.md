---
title: 谈谈Go语言宏观理解之四 - 类型间关系 | 青训营笔记
author: cupid5trick
created: -1
tags: 
categories: 
access: private
draft: true
lang:
- zh-cn
- en-us
abstract:
keywords:
---

在 Go 语言官方文档中读到了 Go 语言设计理念的内容，讲的十分全面。计划用系列文章整理一下对Go语言的宏观理解。主要是翻译自原名为 Go History 的文章：Frequently Asked Questions (FAQ) - The Go Programming Language: <https://go.dev/doc/faq>。

先列一下文章链接：

  - [谈谈Go语言宏观理解之一 - 鲜明特性｜青训营笔记](https://juejin.cn/post/7237065904780574757/)
  - [谈谈Go语言宏观理解之二 - 并发系统 | 青训营笔记](https://juejin.cn/post/7239991117168279610)
  - [谈谈Go语言宏观理解之三 - 类型系统 | 青训营笔记](https://juejin.cn/post/7239987990161653815)

这篇文章通过一些具体的实例讨论Go语言类型系统的“隐式类型关系”。

# 如何保证类型“满足”接口？

你可以要求编译器通过尝试使用`T`的零值或`T`的空指针进行赋值，来检查类型`T`是否实现了接口`I`：

```Go
Type T struct{}
var _ I = T{}       // 验证T是否实现了I。
var _ I = (*T)(nil) // 验证*T是否实现了I。
```

如果`T`（或`*T`，相应地）没有实现`I`，这个错误将在编译时被捕获。

如果你希望一个接口的用户明确声明他们实现了这个接口，你可以在接口的方法集中添加一个带有描述性名称的方法。比如说

```Go
type Fooer interface {
    Foo()
    ImplementsFooer()
}
```

然后，一个类型必须实现`ImplementsFooer`方法才能成为`Fooer`，清楚地记录这一事实并在`go doc`的输出中公布。

```Go
type Bar struct{}
func (b Bar) ImplementsFooer() {}
func (b Bar) Foo() {}
```

大多数代码都不使用这种约束，因为它们限制了接口思想的效用。但有时，它们对于解决类似接口之间的歧义是必要的。

# 为什么不满足接口？

考虑用这个简单的接口来表示一个可以将自己与另一个值进行比较的对象：

```Go
type Equaler interface {
    Equal(Equaler) bool
}
```

和这个类型，`T`：

```Go
type T int
func (t T) Equal(u T) bool { return t == u } //不满足Equaler
```

与某些多态类型系统中的类似情况不同，`T`并没有实现`Equaler`。`T.Equal`的参数类型是`T`，而不是字面上所要求的`Equaler`类型。

在Go中，类型系统不提升`Equal`的参数；这是程序员的责任，如类型`T2`所说明的，它确实实现了`Equaler`：

```Go
type T2 int
func (t T2) Equal(u Equaler) bool { return t == u. (T2) }  //满足Equaler
```

不过，即使这样也和其他类型系统不同，因为**在Go中，任何满足`Equaler`的类型都可以作为参数传给`T2.Equal`，在运行时我们必须检查参数是否为`T2`类型**。有些语言在编译时就安排了这种保证。

一个相关的例子则是另一种情况：

```Go
type Opener interface {
   Open() Reader
}

func (t T3) Open() *os.File
```

在Go中，`T3`并不满足`Opener`，尽管它在其他语言中可能是这样。

虽然在这种情况下，Go的类型系统确实为程序员做了一些事情，但由于缺乏子类型，关于接口满足的规则非常容易说明：函数的名称和签名是否正是接口的名称和签名？Go的规则也很容易有效实现。我们觉得这些好处抵消了自动类型推广的不足。如果有一天Go采用了某种形式的多态类型，我们希望有一种方法来表达这些例子的想法，并让它们得到静态检查。
