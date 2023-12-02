`interface`，它是 Go 语言实现抽象的一个非常强大的工具。当向接口变量赋予一个实体类型的时候，接口会存储实体的类型信息，反射就是通过接口的类型信息实现的，反射建立在类型的基础上。

Go 语言在 reflect 包里定义了各种类型，实现了反射的各种函数，通过它们可以在运行时检测类型的信息、改变类型的值。

# 基本原理

Go 语言中，每个变量都有一个静态类型，在编译阶段就确定了的，比如 `int, float64, []int` 等等。注意，这个类型是声明时候的类型，不是底层数据类型。

Go 官方博客里就举了一个例子：

```go
type MyInt int
var i int
var j MyInt
```

尽管 `i`，`j` 的底层类型都是 `int`，但我们知道，他们是不同的静态类型，除非进行类型转换，否则，`i` 和 `j` 不能同时出现在等号两侧。`j` 的静态类型就是 `MyInt`。

## Interface 底层结构

反射主要与 `interface{}` 类型相关。关于 `interface` 的底层结构，这里简要介绍一下。

```go
type iface struct {
	tab *itab
	data unsafe.Pointer
}

type itab struct {
	inter *interfacetype
	_type *_type
	link *itab
	hash uint32
	bad bool
	inhash bool
	unused [2]byte
	fun [1]uintptr
}
```

其中 `itab` 由具体类型 `_type` 以及 `interfacetype` 组成。`_type` 表示具体类型，而 `interfacetype` 则表示具体类型实现的接口类型。

![](99-Attachment/56564826-82527600-65e1-11e9-956d-d98a212bc863.png)

实际上，`iface` 描述的是非空接口，它包含方法；与之相对的是 `eface`，描述的是空接口，不包含任何方法，Go 语言里有的类型都 “实现了” 空接口。

```go
type eface struct {
	_type *_type
	data unsafe.Pointer
}
```

相比 `iface`，`eface` 就比较简单了。只维护了一个 `_type` 字段，表示空接口所承载的具体的实体类型。`data` 描述了具体的值。

![](99-Attachment/56565105-318f4d00-65e2-11e9-96bd-4b2e192791dc.png)

## 反射示例

还是用 Go 官方关于反射的博客里的例子，当然，我会用图形来详细解释，结合两者来看会更清楚。顺便提一下，搞技术的不要害怕英文资料，要想成为技术专家，读英文原始资料是技术提高的一条必经之路。

先明确一点：接口变量可以存储任何实现了接口定义的所有方法的变量。

Go 语言中最常见的就是 `Reader` 和 `Writer` 接口：

```go
type Reader interface {
	Read(p []byte) (n int, err error)
}

type Writer interface {
	Write(p []byte) (n int, err error)
}
```

接下来，就是接口之间的各种转换和赋值了：

```go
var r io.Reader
tty, err := os.OpenFile("/Users/qcrao/Desktop/test", os.O_RDWR, 0)
if err != nil {
	return nil, err
}
r = tty
```

首先声明 `r` 的类型是 `io.Reader`，注意，这是 `r` 的静态类型，此时它的动态类型为 `nil`，并且它的动态值也是 `nil`。

之后，`r = tty` 这一语句，将 `r` 的动态类型变成 `*os.File`，动态值则变成非空，表示打开的文件对象。这时，r 可以用`<value, type>`对来表示为： `<tty, *os.File>`。

![](99-Attachment/56844299-b29b5c80-68e0-11e9-8211-d227448806b7.png)

注意看上图，此时虽然 `fun` 所指向的函数只有一个 `Read` 函数，其实 `*os.File` 还包含 `Write` 函数，也就是说 `*os.File` 其实还实现了 `io.Writer` 接口。因此下面的断言语句可以执行：

```go
var w io.Writer
w = r.(io.Writer)
```

之所以用断言，而不能直接赋值，是因为 `r` 的静态类型是 `io.Reader`，并没有实现 `io.Writer` 接口。断言能否成功，看 `r` 的动态类型是否符合要求。

这样，w 也可以表示成 `<tty, *os.File>`，仅管它和 `r` 一样，但是 w 可调用的函数取决于它的静态类型 `io.Writer`，也就是说它只能有这样的调用形式： `w.Write()` 。`w` 的内存形式如下图：

![](99-Attachment/57341967-09215a00-716f-11e9-99cc-cfaa0f312b54.png)

和 `r` 相比，仅仅是 `fun` 对应的函数变了：`Read -> Write`。

最后，再来一个赋值：

```go
var empty interface{}
empty = w
```

由于 `empty` 是一个空接口，因此所有的类型都实现了它，w 可以直接赋给它，不需要执行断言操作。

![](99-Attachment/56844669-9b5f6d80-68e6-11e9-8a31-8d38951c7742.png)

从上面的三张图可以看到，interface 包含三部分信息：`_type` 是类型信息，`*data` 指向实际类型的实际值，`itab` 包含实际类型的信息，包括大小、包路径，还包含绑定在类型上的各种方法（图上没有画出方法），补充一下关于 os.File 结构体的图：

![](99-Attachment/56946658-4bd6a700-6b5d-11e9-9a3d-0e781957be31.png)

## 示例：展示接口信息

这一节的最后，展示一个技巧：

先参考源码，分别定义一个“伪装”的 `iface` 和 `eface` 结构体。

```go
type iface struct {
	tab *itab
	data unsafe.Pointer
}
type itab struct {
	inter uintptr
	_type uintptr
	link uintptr
	hash uint32
	_ [4]byte
	fun [1]uintptr
}
type eface struct {
	_type uintptr
	data unsafe.Pointer
}
```

接着，将接口变量占据的内存内容强制解释成上面定义的类型，再打印出来：

```go
package main
import (
"os"
"fmt"
"io"
"unsafe"
)

func main() {
	var r io.Reader
	fmt.Printf("initial r: %T, %v\n", r, r)
	tty, _ := os.OpenFile("/Users/qcrao/Desktop/test", os.O_RDWR, 0)
	fmt.Printf("tty: %T, %v\n", tty, tty)
	// 给 r 赋值
	r = tty
	fmt.Printf("r: %T, %v\n", r, r)
	rIface := (*iface)(unsafe.Pointer(&r))
	fmt.Printf("r: iface.tab._type = %#x, iface.data = %#x\n", rIface.tab._type, rIface.data)
	// 给 w 赋值
	var w io.Writer
	w = r.(io.Writer)
	fmt.Printf("w: %T, %v\n", w, w)
	wIface := (*iface)(unsafe.Pointer(&w))
	fmt.Printf("w: iface.tab._type = %#x, iface.data = %#x\n", wIface.tab._type, wIface.data)
	// 给 empty 赋值
	var empty interface{}
	empty = w
	fmt.Printf("empty: %T, %v\n", empty, empty)
	emptyEface := (*eface)(unsafe.Pointer(&empty))
	fmt.Printf("empty: eface._type = %#x, eface.data = %#x\n", emptyEface._type, emptyEface.data)
}
```

运行结果：

```
initial r: <nil>, <nil>
tty: *os.File, &{0xc4200820f0}
r: *os.File, &{0xc4200820f0}
r: iface.tab._type = 0x10bfcc0, iface.data = 0xc420080020
w: *os.File, &{0xc4200820f0}
w: iface.tab._type = 0x10bfcc0, iface.data = 0xc420080020
empty: *os.File, &{0xc4200820f0}
empty: eface._type = 0x10bfcc0, eface.data = 0xc420080020
```

`r，w，empty` 的动态类型和动态值都一样。不再详细解释了，结合前面的图可以看得非常清晰。
