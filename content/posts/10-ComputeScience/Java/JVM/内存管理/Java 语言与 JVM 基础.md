---
scope: learn
draft: true
---

[doocs/jvm: 🤗 JVM 底层原理最全知识总结](https://github.com/doocs/jvm): <https://github.com/doocs/jvm>

[Java HotSpot VM Options](https://www.oracle.com/java/technologies/javase/vmoptions-jsp.html#DebuggingOptions): <https://www.oracle.com/java/technologies/javase/vmoptions-jsp.html#DebuggingOptions>
[Java HotSpot VM Options | windows](https://docs.oracle.com/javase/8/docs/technotes/tools/windows/java.html): <https://docs.oracle.com/javase/8/docs/technotes/tools/windows/java.html>
[Java HotSpot VM Options | unix](https://docs.oracle.com/javase/8/docs/technotes/tools/unix/java.html): <https://docs.oracle.com/javase/8/docs/technotes/tools/unix/java.html>

# Java语言与JVM基础

- [Java各版本语言及JVM说明](https://docs.oracle.com/javase/specs/index.html)
- [Java8 SE API文档](https://docs.oracle.com/javase/8/docs/api/)
- [Description of Java Conceptual Diagram](https://docs.oracle.com/javase/8/docs/technotes/guides/desc_jdk_structure.html)
- [《深入理解 Java 虚拟机》 - 周志明](http://gohaima.com/e-book/1/index.html)
HotSpot
- [Java HotSpot Garbage Collection](https://www.oracle.com/java/technologies/javase/javase-core-technologies-apis.html)
- [HotSpot Virtual Machine Garbage Collection Tuning Guide](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning)
-  A [glossary of terms](https://openjdk.org/groups/hotspot/docs/HotSpotGlossary.html) found in the HotSpot sources and documentation.
-   An overview of the [runtime system](https://openjdk.org/groups/hotspot/docs/RuntimeOverview.html) - 运行子系统
-   An overview of the [serviceability features](https://openjdk.org/groups/hotspot/docs/Serviceability.html)
-   An overview of the [storage management system](https://openjdk.org/groups/hotspot/docs/StorageManagement.html) - 存储系统、垃圾收集

![](image-20220104172758675.png)


# Java 语言

## 类型系统

Java 是静态类型语言，意味着程序中每个变量和表达式都是在编译期就可以确定其类型的。Java 也是强类型语言，类型限制了变量能够保存的值、可以产生的表达式，限制了变量支持的操作，并确定了相应操作的语义。强类型和静态类型帮助在编译期检测错误。

Java 语言的类型可以分为 基本类型 和 引用类型。基本类型是boolean 和 数值类型，数值类型又包括整形（byte, short, int, long, char）和浮点型（float 和 double）。引用类型是 class 、interface、数组类型。除此之外还有一个特殊的 null 类型。对象（object）是 class 类型的实例或者动态创建的数组，所有引用类型的值都是对对象的引用，这些对象都支持 Object 类的方法。字符串字面量由 String 对象表示。

### 各种类型和变量

Java 类型包括基本类型和引用类型，相应的值是基本值和引用值。

还有一个特殊的 null 类型，是 null 表达式所属的类型，null 类型没有名称。因为 null 类型没有名称，所以不能声明 null 类型的变量 或者 类型转换为 null 类型。null 引用是 null 类型唯一的值，可以被赋值或类型转换到任意引用类型。

> 实践中编程人员可以忽略 null 类型，只把 null 当做一个可以是任意类型的特殊字面量。

### 引用类型和值

引用类型有四种：类、接口、类型变量和数组类型。

#### The Class Object
Object 类是所有其他类的父类。所有类和数组类型都继承了 Object 类的方法：

- The method `clone` is used to make a duplicate of an object.

- The method `equals` defines a notion of object equality, which is based on value,
  not reference, comparison.

- The method `finalize` is run just before an object is destroyed (§12.6).

- The method `getClass` returns the Class object that represents the class of the object.

  A Class object exists for each reference type. It can be used, for example, to discover the fully qualified name of a class, its members, its immediate superclass, and any interfaces that it implements.

  The type of a method invocation expression of getClass is `Class<? extends |T|>`, where T is the class or interface that was searched for getClass (§15.12.1) and |T| denotes the erasure of T (§4.6).
  A class method that is declared synchronized (§8.4.3.6) synchronizes on the monitor associated with the Class object of the class.

- The method `hashCode` is very useful, together with the method equals, in
  hashtables such as java.util.HashMap.

- The methods `wait`, `notify`, and `notifyAll` are used in concurrent programming
  using threads (§17.2).

- The method `toString` returns a String representation of the object.

### 类型变量

类型变量是在类、接口、方法和构造函数体中作为类型的非限定标识符。类型变量会在泛型类、泛型接口、构造函数、泛型方法中的带参类型声明中使用。

在带参类型中声明的类型变量作用域在 $ 6.3 节中有规定。

每个声明为类型参数的带参类型都有类型界限。如果没有显式声明类型界限默认限制上界为 Object。如果声明了类型界限，有以下情况：要么是一个类型变量 T，要么是 类或接口类型 T ，类或接口后面可以指定额外的若干个接口类型 I~1~ & ... & I~n~ （如果 I~1~ - I~n~ 中出现类或类型变量，会出现编译错误）。

类型界限中所有成分类型的类擦出器必须两两之间不同，否则会发生编译错误。

类型变量一定不能同时是同一个泛型接口不同参数化接口类型的子类型（GI<T,R> GI<A,B> GI<C,D>），否则会发生编译错误。

带类型界限的类型变量 x 的成员是类型变量声明处出现的交集类型（ intersection type $ 4.9 节）的成员。可以根据这段示例代码来理解：

```java
// Example 4.4.1. Members of a Type Variable
package TypeVarMembers;
class C {
        public void mCPublic() {}
        protected void mCProtected() {}
        void mCPackage() {}
        private void mCPrivate() {}
}
interface I {
	void mI();
}
class CT extends C implements I {
	public void mI() {}
}
class Test {
    <T extends C & I> void test(T t) {
        t.mI(); // OK
        t.mCPublic(); // OK
        t.mCProtected(); // OK
        t.mCPackage(); // OK
        t.mCPrivate(); // Compile-time error
    }
}

/**
 类型变量 T和 交集类型 C & I 有相同的成员，同时和 继承了类C、实现了接口 I 的类 CT 有相同的成员。因为接口的成员一定是 public，所以 mI 是 CT 和 T 的成员。在 C 的成员中，除私有方法 mCPrivate 外 都被 CT 继承， 因此都是 CT 和 T 的成员。

但是如果类 C 和 T 声明在不同的包，调用 mCPackage 就会导致编译错误，因为 mCPackage 没有显式指定 modifier 默认是包级访问权限，这时 mCPackage 不是 T 的成员。
**/
```



### 带参类型

泛型类或泛型接口的声明定义了一组带参类型。带参类型是以 `C<T1,...,Tn>` 形式出现的类或接口，*C* 是泛型类型的名称，*<T1,...,Tn>* 是表示该泛型类型某种参数化的类型参数列表。

泛型类型带有类型参数（形参） *F1,...,Fn* 和相应类型界限 *B1,...,Bn* 。每个参数化类型的类型参数（实参）*Ti*  的范围包括相应类型界限列表中类型的所有子类。也就是说，对于类型界限 *Bi* 中的每个类型 *S* ，*Ti* 是 *S[F1=T1, ..., Fn=Tn]* 的子类。

对于泛型类 *C*，如果以下条件全都满足，就认为 *C* 的参数化类型 *C<T1, ..., Tn>* 是 *well-formed*：

- *C* 是泛型类型的类名
- 类型参数（形参）的数量和泛型声明中的类型形参数量一致
- 在捕获转换（ capture conversion $5.1.10 节 ）中得到参数化类型 *C<X1, ..., Xn>* 时，对类型界限 *Bi* 中每个类型 *S* ，每个类型参数（实参）*Xi* 是 *S[F1:=X1, ..., Fn:=Xn]* 的子类

如果参数化类型不是 *well-formed*，会发生编译错误。

在这种规范下，每次提到 类或接口都隐含了相应的泛型类型，除非明确表示当前语境不考虑泛型。

如果以下两个条件之一成立就认为两个参数化类型是 *provably distinct*：

- 两个类型是不同泛型类型的参数化
- 这两个类型虽然是同一个泛型类型的参数化，但是类型参数中存在 *provably distinct* 的类型。

> Given the generic types in the examples of §8.1.2, here are some well-formed parameterized types:
>
> - `Seq<String>`
> - `Seq<Seq<String>>`
> - `Seq<String>.Zipper<Integer>`
> - `Pair<String,Integer>`
>
> Here are some incorrect parameterizations of those generic types:
>
> - `Seq<int>` is illegal, as primitive types cannot be type arguments.
> - `Pair<String>` is illegal, as there are not enough type arguments.
> - `Pair<String,String,String>` is illegal, as there are too many type arguments.
>
> A parameterized type may be an parameterization of a generic class or interface which is nested. For example, if a non-generic class `C` has a generic member class `D<T>`, then
> `C.D<Object>` is a parameterized type. And if a generic class `C<T>` has a non-generic member class D, then the member type `C<String>.D` is a parameterized type, even though
> the class `D` is not generic.



#### 泛型类型的类型参数

类型参数可以是引用类型或者通配符（wildcard, ?）。通配符用于在泛型声明中对类型参数的要求不完全明确的情况。

通配符像其他正常的类型变量声明一样可以给出显式的类型界限，使用 `extends` 指定上界、`super` 指定下界。使用通配符时，和其他声明的普通类型变量不同，不需要类型推断，因此允许使用 `super` 语法对通配符指定下界。上界为 *Object* 的通配符 *？ extends Object* 和没有类型界限的通配符 *？* 等价。

如果以下条件之一成立，就认为两个类型参数是 *provably distinct*：

- 两个类型参数都不是类型变量或通配符，而且它们不是相同类型
- 其中一个类型参数是类型变量或通配符，带有上界 *S*。另一个类型参数 *T* 既不是类型变量也不是通配符，而且 *|S| <: |T|* 和 *|S| >: |T|* 都不成立
- 每个类型参数都是类型变量或通配符，二者的上界分别是 *S* 和 *T*，同时*|S| <: |T|* 和 *|S| >: |T|* 都不成立

如果类型参数 *T2* 所表示的类型集合在如下规则的自反闭包和传递闭包下是 类型参数 *T1* 所表示类型集合的子集，就认为类型参数 *T1* 包含类型参数 *T2*，表示为 *T2 <= T1*：

- ? extends T <= ? extends S if T <: S
- ? extends T <= ?
- ? super T <= ? super S if S <: T
- ? super T <= ?
- ? super T <= ? extends Object
- T <= T
- T <= ? extends T
- T <= ? super T

The relationship of wildcards to established type theory is an interesting one, which we briefly allude to here. Wildcards are a restricted form of existential types. Given a generic type declaration `G<T extends B>`, `G<?>` is roughly analogous to Some `X` <: `B. G<X>`.

Historically, wildcards are a direct descendant of the work by Atsushi Igarashi and Mirko Viroli. Readers interested in a more comprehensive discussion should refer to On Variance- Based Subtyping for Parametric Types by Atsushi Igarashi and Mirko Viroli, in the Proceedings of the 16th European Conference on Object Oriented Programming (ECOOP 2002). This work itself builds upon earlier work by Kresten Thorup and Mads Torgersen (Unifying Genericity, ECOOP 99), as well as a long tradition of work on declaration based variance that goes back to Pierre America's work on POOL (OOPSLA 89).

Wildcards differ in certain details from the constructs described in the aforementioned paper, in particular in the use of capture conversion (§5.1.10) rather than the close operation described by Igarashi and Viroli. For a formal account of wildcards, see Wild FJ by Mads Torgersen, Erik Ernst and Christian Plesner Hansen, in the 12th workshop on Foundations of Object Oriented Programming (FOOL 2005).

Example 4.5.1-1. Unbounded Wildcards

```java
import java.util.Collection;
import java.util.ArrayList;
class Test {
	static void printCollection(Collection<?> c) {
	// a wildcard collection
		for (Object o : c) {
		System.out.println(o);
		}
	}
	public static void main(String[] args) {
		Collection<String> cs = new ArrayList<String>();
		cs.add("hello");
		cs.add("world");
		printCollection(cs);
	}
}
```

Note that using `Collection<Object>` as the type of the incoming parameter, `c`, would not be nearly as useful; the method could only be used with an argument expression that
had type `Collection<Object>`, which would be quite rare. In contrast, the use of an unbounded wildcard allows any kind of collection to be passed as an argument.

Here is an example where the element type of an array is parameterized by a wildcard:

```java
public Method getMethod(Class<?>[] parameterTypes) {
	...
}
```

Example 4.5.1-2. Bounded Wildcards

```java
	boolean addAll(Collection<? extends E> c)
```

Here, the method is declared within the interface `Collection<E>`, and is designed to add all the elements of its incoming argument to the collection upon which it is invoked. A natural tendency would be to use `Collection<E>` as the type of `c`, but this is unnecessarily restrictive. An alternative would be to declare the method itself to be generic:

```java
<T> boolean addAll(Collection<T> c)
```



This version is sufficiently flexible, but note that the type parameter is used only once in the signature. This reflects the fact that the type parameter is not being used to express any kind of interdependency between the type(s) of the argument(s), the return type and/or throws type. In the absence of such interdependency, generic methods are considered bad style, and wildcards are preferred.

```java
Reference(T referent, ReferenceQueue<? super T> queue)
```



Here, the referent can be inserted into any queue whose element type is a supertype of the type *T* of the referent; *T* is the lower bound for the wildcard.



#### 成员函数和构造函数中的参数化类型

如果 *C* 是泛型类或泛型接口，声明了类型参数 *A1, ..., An*，*C<T1, .., Tn>* 是 泛型类型 *C* 的一种参数化类型，其中 *T1, ... Tn* 都是实际的类型而不是通配符。那么：

- 如果 *m* 是 泛型类型 *C* 中声明的成员函数或构造函数，声明的返回类型是 *T*，那么 *m* 在参数化类型 *C<T1, ..., Tn>* 中的类型是 *T[A1:=T1, An:=Tn]*
- 如果 *m* 是在 *C* 的父类或 *C* 所实现的接口中声明的成员函数或者构造函数，泛型类 *D* 相应的参数化类型是 *D<U1, ..., Uk>*，那么 *m* 在 *C*  的参数化类型 *C<T1, ..., Tn>* 中的类型是 *m* 在 *D<U1, ..., Uk>* 中的类型。

如果 *C* 的参数化类型的类型参数中有通配符，那么：

- *C<T1, ..., Tn>* 中字段、方法、构造函数的类型是 *C<T1, ..., Tn>* 的捕获转换（ capture conversion $5.1.10 节 ）中相应字段、方法和构造函数 的类型。
- 如果 *D* 是 *C*  中声明的 泛型类、接口，那么 *C<T1, ..., Tn>* 中声明的 *D* 的类型就是参数列表中所有类型都是不带类型界限的通配符。

> This is of no consequence, as it is impossible to access a member of a parameterized type without performing capture conversion, and it is impossible to use a wildcard after the
> keyword new in a class instance creation expression (§15.9).
>
> The sole exception to the previous paragraph is when a nested parameterized type is used as the expression in an instanceof operator (§15.20.2), where capture conversion is not
> applied.



泛型类型中声明的静态成员必须使用泛型类型相应的费泛型类型来引用，否则会发生编译错误。换句话说，使用参数化类型来引用泛型类型中声明的静态成员是非法的。



### 类型擦除

类型擦除会把可能包含参数化类型和类型变量的类型映射为既不是参数化类型也不是类型变量的类型。这里用 *|T|* 来表示 类型 *T* 经过类型擦除得到的类型。类型擦除规则如下：

- 参数化类型 *G<T1, ..., Tn>* 擦除后的类型是 *|G|*
- 内部类 *T.C* 擦除后的类型是 *|T|.C*
- 数组类型 *T[]* 的擦除类型是 *|T|[]*
- 类型变量的擦除类型是该类型变量最左边界所对应类型的擦除类型
- 所有其他类型的擦除类型都是该类型本身

类型擦除也会把 构造函数或方法的格式（返回值、形参类型、异常的组合）映射为不包含参数化类型或类型变量的格式。构造函数和方法擦除后的结果是所有形参类型被擦除，泛型方法的返回值和类型参数、泛型构造函数的类型参数也会被擦除。泛型方法擦除后不会包含类型参数。





### 可具体化类型 Reifiable Type

因为在编译阶段有些类型信息被擦除，不是所有类型都是在运行时可用的。把在运行时可用的类型叫做 *reifiable type*。如果以下条件之一成立，该类型就是 *reifiable type*：

- 该类型指向一个非泛型类或非泛型接口的声明

- 该类型是一个参数化类型，所有类型参数都是不带类型界限的通配符

- 该类型是 *raw type* 或者 基本类型 （ primitive type ）

- 该类型是数组类型，其元素的类型是 *reifiable type*

- 该类型是内部类，而且每一层的外层类都是 *reifiable type*

  > For example, if a generic class `X<T>` has a generic member class `Y<U>`, then the
  > type `X<?>.Y<?>` is reifiable because `X<?>` is reifiable and `Y<?>` is reifiable. The type
  > `X<?>.Y<Object>` is not reifiable because `Y<Object>` is not reifiable.

- 交集类型不是 *reifiable type*

> The decision not to make all generic types reifiable is one of the most crucial, and controversial design decisions involving the type system of the Java programming
> language.
>
> Ultimately, the most important motivation for this decision is compatibility with existing code. In a naive sense, the addition of new constructs such as generics has no implications for pre-existing code. The Java programming language, per se, is compatible with earlier versions as long as every program written in the previous versions retains its meaning in the new version. However, this notion, which may be termed language compatibility, is of purely theoretical interest. Real programs (even trivial ones, such as "Hello World") are composed of several compilation units, some of which are provided by the Java SE platform (such as elements of java.lang or java.util). In practice, then, the minimum requirement is platform compatibility - that any program written for the prior version of the Java SE platform continues to function unchanged in the new version.
>
> One way to provide platform compatibility is to leave existing platform functionality unchanged, only adding new functionality. For example, rather than modify the existing
> Collections hierarchy in java.util, one might introduce a new library utilizing generics.
>
> The disadvantages of such a scheme is that it is extremely difficult for pre-existing clients of the Collection library to migrate to the new library. Collections are used to exchange
> data between independently developed modules; if a vendor decides to switch to the new, generic, library, that vendor must also distribute two versions of their code, to be compatible with their clients. Libraries that are dependent on other vendors code cannot be modified to use generics until the supplier's library is updated. If two modules are mutually dependent, the changes must be made simultaneously.
>
> Clearly, platform compatibility, as outlined above, does not provide a realistic path for adoption of a pervasive new feature such as generics. Therefore, the design of the generic type system seeks to support migration compatibility. Migration compatibiliy allows the evolution of existing code to take advantage of generics without imposing dependencies between independently developed software modules.
>
> The price of migration compatibility is that a full and sound reification of the generic type system is not possible, at least while the migration is taking place.





### 原始类型

为了在非泛型的遗留代码之上支持接口，可以把参数化类型的擦除类型作为类型，或把参数化数组类型的擦除类型用作类型。这种类型就是 *raw type*。

更简明地说，*raw type* 定义为如下三种情况之一：

- 一个只有泛型类型名称而不带响应类型参数列表的引用类型
- 元素类型是 *raw type* 的数组类型
- *raw type* *R* 中不是从 *R* 的父类或负接口继承而来的非静态成员类型
- 非泛型类或非泛型接口类型不是 *raw type*

To see why a non-static type member of a raw type is considered raw, consider the following example:

```java
class Outer<T>{
T t;
class Inner {
T setOuterT(T t1) { t = t1; return t; }
}
}
```



The type of the member(s) of Inner depends on the type parameter of Outer. If Outer israw, Inner must be treated as raw as well, as there is no valid binding for T.

This rule applies only to type members that are not inherited. Inherited type members that depend on type variables will be inherited as raw types as a consequence of the rule that the supertypes of a raw type are erased, described later in this section.

Another implication of the rules above is that a generic inner class of a raw type can itself only be used as a raw type:

```java
class Outer<T>{
class Inner<S> {
S s;
}
}
```

It is not possible to access Inner as a partially raw type (a "rare" type):

```java
Outer.Inner<Double> x = null; // illegal
Double d = x.s;
```

because Outer itself is raw, hence so are all its inner classes including Inner, and so it is not possible to pass any type arguments to Inner.

*raw type* 的父类或父接口的类型是相应泛型类的父类或父接口的擦除类型。

*raw type* 中不是从父类或父接口继承来的构造函数、实例方法或非静态字段的类型是在泛型声明中相应类型的擦除类型。静态方法或静态字段的类型和泛型声明中的类型一致。对 *raw type* 中不是从父类或父接口继承而来的非静态成员传递类型参数会发生编译错误。把参数化类型中的类型成员作为 *raw type* 也会引发编译错误。

This means that the ban on "rare" types extends to the case where the qualifying type is parameterized, but we attempt to use the inner class as a raw type:

```java
Outer<Integer>.Inner x = null; // illegal
```

This is the opposite of the case discussed above. There is no practical justification for this half-baked type. In legacy code, no type arguments are used. In non-legacy code, we should use the generic types correctly and pass all the required type arguments.

如果一个类 *C* 的父类是 *raw type*，那么类 *C* 的成员访问依然遵守正常的规则，而父类的成员访问被当做 *raw type* 的情形处理。在类 *C* 的构造函数中，调用 *super* 被当做 *raw type* 的方法调用来处理。

原始类型的使用只允许作为对遗留代码兼容性的让步（as a concession to compatibility of legacy code），强烈建议不要在 *Java* 语言引入泛型之后的代码中使用原始类型。在 *Java* 语言的未来版本中可能不再允许使用原始类型。

为了确保能够标示出可能违反类型规则的情况，有些对原始类型成员的访问会导致编译时产生 *unchecked warning*。在访问原始类型成员或构造函数时产生 *unchecked warning* 的规则如下：

- 在给原始类型的字段赋值时：如果字段访问表达式中 *Primary* 的类型是原始类型，而且字段的擦除类型和字段类型不同，就会发生编译时 *unchecked warning*
- 在调用方法或构造函数时：如果将要搜索的类或者接口的类型是原始类型，同时如果这个方法或构造函数经过类型擦除后有形参类型改变，就会发生编译时 *unchecked warning*
- 对于类型擦除后形参类型没有改变的方法（即使类型擦除后返回类型、thorws 语句的异常类型有改变），发生函数调用时不会产生 编译时 *unchecked warning*。对于原始类型的字段读取、类实例化，也不会产生 编译时 *unchecked warning*

注意区分这里的 *unchecked warnings* 和 未检查的转换所导致的 *unchecked warnings*。 Note that the unchecked warnings above are distinct from the unchecked warnings possible from unchecked conversion (§5.1.9), casts (§5.5.2), method declarations (§8.4.1, §8.4.8.3, §8.4.8.4, §9.4.1.2), and variable arity method invocations (§15.12.4.2).

The warnings here cover the case where a legacy consumer uses a generified library. For example, the library declares a generic class `Foo<T extends String>` that has a field `f` of type `Vector<T>`, but the consumer assigns a vector of integers to `e.f` where `e` has the raw type `Foo`. The legacy consumer receives a warning because it may have caused heap pollution (§4.12.2) for generified consumers of the generified library.

(Note that the legacy consumer can assign a `Vector<String>` from the library to its own `Vector` variable without receiving a warning. That is, the subtyping rules (§4.10.2) of the Java programming language make it possible for a variable of a raw type to be assigned a value of any of the type's parameterized instances.)

The warnings from unchecked conversion cover the dual case, where a generified consumer uses a legacy library. For example, a method of the library has the raw return type `Vector`, but the consumer assigns the result of the method invocation to a variable of type `Vector<String>`. This is unsafe, since the raw vector might have had a different element type than `String`, but is still permitted using unchecked conversion in order to enable interfacing with legacy code. The warning from unchecked conversion indicates that the generified consumer may experience problems from heap pollution at other points in the program.

**Example 4.8-1. Raw Types**

```java
class Cell<E> {
E value;
Cell(E v) { value = v; }
E get() { return value; }
void set(E v) { value = v; }
public static void main(String[] args) {
Cell x = new Cell<String>("abc");
System.out.println(x.value); // OK, has type Object
System.out.println(x.get()); // OK, has type Object
x.set("def"); // unchecked warning
}
}
```

**Example 4.8-2. Raw Types and Inheritance**

```java
import java.util.*;
class NonGeneric {
Collection<Number> myNumbers() { return null; }
}
abstract class RawMembers<T> extends NonGeneric implements Collection<String> {
static Collection<NonGeneric> cng = new ArrayList<NonGeneric>();
public static void main(String[] args) {
RawMembers rw = null;
Collection<Number> cn = rw.myNumbers();
// OK
Iterator<String> is = rw.iterator();
// Unchecked warning
Collection<NonGeneric> cnn = rw.cng;
// OK, static member
}
}
```

In this program (which is not meant to be run), `RawMembers<T>` inherits the method: 

```java
Iterator<String> iterator()
```

from the `Collection<String>` superinterface. The raw type `RawMembers` inherits `iterator()` from `Collection`, the erasure of `Collection<String>`, which means that the return type of `iterator()` in `RawMembers` is Iterator. As a result, the attempt to assign `rw.iterator()` to `Iterator<String>` requires an unchecked conversion, so a compile-time unchecked warning is issued.

In contrast, `RawMembers` inherits `myNumbers()` from the `NonGeneric` class whose erasure is also NonGeneric. Thus, the return type of `myNumbers()` in `RawMembers` is not erased, and the attempt to assign `rw.myNumbers()` to `Collection<Number>` requires no unchecked conversion, so no compile-time unchecked warning is issued.

Similarly, the `static` member `cng` retains its parameterized type even when accessed through a object of raw type. Note that access to a `static` member through an instance is considered bad style and is discouraged.

This example reveals that certain members of a raw type are not erased, namely `static` members whose types are parameterized, and members inherited from a non-generic supertype.

Raw types are closely related to wildcards. Both are based on existential types. Raw types can be thought of as wildcards whose type rules are deliberately unsound, to accommodate interaction with legacy code. Historically, raw types preceded wildcards; they were first introduced in GJ, and described in the paper *Making the future safe for the past: Adding Genericity to the Java Programming Language by Gilad Bracha, Martin Odersky, David Stoutamire, and Philip Wadler, in Proceedings of the ACM Conference on Object-Oriented Programming, Systems, Languages and Applications (OOPSLA 98), October 1998*.



### 交集类型，Intersection Types

交集类型形如 *T1 & ... & Tn*。交集类型可以从类型界限和类型转换表达式导出，也会在对 捕获转换 （ capture conversion ）的处理和最小类型上界的计算（ $ 4.10.4 ）中出现。

交集类型的值是同时为 *T1* 到 *Tn* 所有类型实例的对象。为了识别交际类型的成员，每个交集类型都会有一个假想的类或接口。

- 对每个 *Ti* ，让 *Ci* 作为满足 *Ti <: Ci* 的最具体的类或数组类型，那么一定有某个 *Ck* 对任意 *Ci* 满足 *Ck <: Ci* ，否则会出现编译错误。
- 对于 *Tj (1 <= j <= n)* ，如果 *Tj* 是类型变量，用 *Tjj* 表示一个成员集合与 *Tj* 的公有成员相同的接口；如果 *Tj* 不是类型变量而是接口，则 *Tjj = Tj*。
- 如果 *Ck* 是 `Object` 就引入一个假想接口，否则引入一个直接父类为 *Ck* 的类。这个类或者接口的直接父接口是 *T11, ..., Tnn*，被声明在交集类型所处的包中。

交集类型的成员就是其假想类或假想接口的成员。



这里有必要详细讨论交集类型和类型变量的类型界限之间的区别。每个类型界限都引入一个假想的交集类型，这个交集类型通常是平凡的，由一个普通类型组成。类型界限的形式是受限的，只有第一个类型可以是类型变量或类（其余类型只能是接口）。但是捕获转换有可能导致创建类型界限更广泛的类型变量，例如数组类型。

It is worth *dwelling upon* the distinction between intersection types and the bounds of type variables. Every type variable bound induces an intersection type. This intersection type is often trivial, consisting of a single type. The form of a bound is restricted (only the first element may be a class or type variable, and only one type variable may appear in the bound) to preclude certain awkward situations coming into existence. However, capture conversion can lead to the creation of type variables whose bounds are more general, such as array types).





### Type Contexts

类型在大多数声明和某些表达式中会使用。具体来说有 16 种使用类型的类型上下文。

在声明中使用类型：

1. 在类声明的 *extends* 或 *implements* 子句中的类型
2. 接口声明的 *extends* 子句中的类型
3. 方法返回值类型，包括注解类型中以方法形式定义的元素类型
4. 在方法或构造函数的 *throws* 子句中的类型
5. 泛型类、泛型接口、泛型方法、泛型构造函数的类型参数声明中 *extends* 子句的类型
6. 类或接口，以及 enum 常量声明中的字段类型
7. 方法、构造函数、匿名表达式声明中的形参类型
8. 方法的 *receiver* 类型 （ $ 8.4.1 ）
9. 局部变量声明中的类型
10. 异常参数声明中的类型

在表达式中使用的类型：

11. 显式构造函数调用语句、类实例创建表达式、方法调用表达式的显式类型参数列表的类型
12. 在非限定类实例创建表达式中，作为将要实例化的类的类型，或者将要实例化的匿名类的直接父类类型、直接父接口类型
13. 数组创建表达式中的元素类型
14. 类型转换表达式中，类型转换运算符的类型
15. *instanceof* 关系运算符 右侧的类型
16. 方法引用表达式中，作为用来搜索成员方法的类型，或者将要创建的类类型、数组类型

除此之外类型也可以用作：

- 上述任何上下文中数组的元素类型
- 上述任何上下文中，非通配符的类型参数、通配符类型参数的类型界限，或者参数化类型的类型界限

最后还有 *Java* 语言中用来表示类型使用的三种特殊术语：

- 不带类型边界的通配符：*?*
- 在变长参数列表中用来表示任意数组类型的 `...`
- 在构造函数声明中用来表明被构造对象类型的类型名称

The meaning of types in type contexts is given by:

- §4.2, for primitive types
- §4.4, for type parameters
- §4.5, for class and interface types that are parameterized, or appear either as type arguments in a parameterized type or as bounds of wildcard type arguments in a parameterized type
- §4.8, for class and interface types that are raw
- §4.9, for intersection types in the bounds of type parameters
- §6.5, for class and interface types in contexts where genericity is unimportant (§6.1)
- §10.1, for array types

// TODO $ 4.11 Page 78 

**有些类型上下文会限制引用类型参数化的方式**：（ $ 4.11 Page 78 ）

















## Java 面向对象: 运行时特性

### 类

Java 类继承规则是单继承，而且子类只能访问到超类的公共成员。

#### 成员方法

- 静态成员方法有隐藏( Hidden )
- 非静态成员方法有多态( MultiMorphosis )

### 接口

从Java 8起，`interface`定义内除了静态常量和抽象方法外，还可以定义静态方法和默认方法。




## Java 注解

Java 8 Language Specification的9.6节介绍了注解的语法形式和语义。

通过@interface来定义注解，注解内部定义字段必须以没有形式参数、不抛出异常、不带static或default关键字的方法来表示字段 (Modifier 只能是 public 或 abstract)。除了普通字段外注解内部还可以定义内部类、枚举类、接口和内部注解。

在注解字段末尾还可以通过default关键字指定注解字段的默认值。

注解定义的示例：

```java
@interface RequestForEnhancementDefault {
    int id(); // No default - must be specified in
    // each annotation
    String synopsis(); // No default - must be specified in
    // each annotation
    String engineer() default "[unassigned]";
    String date() default "[unimplemented]";
}

interface Formatter {}
// Designates a formatter to pretty-print the annotated class
@interface PrettyPrinter {
    Class<? extends Formatter> value();
}

/**
* Indicates the author of the annotated program element.
*/
@interface Author {
    Name value();
}
/**
* A person's name. This annotation type is not designed
* to be used directly to annotate program elements, but to
* define elements of other annotation types.
*/
@interface Name {
    String first();
    String last();
}

@interface Quality {
enum Level { BAD, INDIFFERENT, GOOD }
Level value();
}
```

### 元注解

| 注解类型             | 说明                                           |
| -------------------- | ---------------------------------------------- |
| @Target              | 设置注解的作用对象。                           |
| @Retention           | 设置注解的保留期。`RUNTIME`, `CLASS`, `SOURCE` |
| @Inherited           | 表明基类的注解可以被继承。                     |
| @Override            | 用来做方法重写检查。                           |
| @SuppressWarnings    |                                                |
| @Deprecated          |                                                |
| @SafeVarargs         |                                                |
| @Repeatable          |                                                |
| @FunctionalInterface |                                                |



### @Target

`java.lang.annotation.Target` 作用在注解类的定义上，指定注解可作用的上下文。`Target` 注解只有一个 `java.lang.annotation.ElementType[]` 类型的字段 `value` 保存注解可用的目标上下文。

注解可以用于 8 种 declaration context，或者 16 种 type context。在声明上下文中，注解作用于声明。在类型上下文中，注解作用于声明和表达式。

注解作用的**声明上下文（declaration context）**有 8 种，对应 `ElementType` 的枚举常量：

1. `ElementType.PACKAGE` 对应包声明。
2. `ElementType.TYPE` 对应类型声明（类、接口、枚举、注解的声明）。`ElementType.ANNOTATION_TYPE` 对应注解类声明。
3. `ElementType.METHOD` 对应方法声明（包括注解类的方法）。
4. `ElementType.CONSTRUCTOR` 对应构造函数声明。
5. `ElementType.TYPE_PARAMETER` 对应泛型类、泛型接口、泛型方法和泛型构造函数中的 泛型参数声明。`ElementType.TYPE_USE` 包括 类型声明（ `TYPE` ）和 类参数声明（ `TYPE_PARAMETER` ）。
6. `ElementType.FIELD` 对应字段声明（类和枚举的字段）。
7. `ElementType.PARAMETER` 对应形参和异常参数的声明。
8. `ElementType.LOCAL_VARIABLE` 对应局部变量声明，包括 `for` 语句中循环变量声明和 `try` 语句块中的局部变量声明。

有 16 种 **类型上下文 (type context)**（JLS $ 4.11），全部可以被 `TYPE_USE` 代表。

如果同一个枚举常量在 value 字段出现了多次会出现编译错误。如果注解的声明中没有出现 `@Target` ，那么该注解默认可以作用于除 `TYPE_PARAMETER` 之外的所有 declaration context，不能作用于 type context。

### 注解保留期：@Retention

注解可以仅出现在源码中，也可以使其能够出现在类或接口的二进制代码中。而即使注解被编译到二进制代码中也不一定能在运行时对反射操作可见。这些注解行为都是由叫做保留期 ( Retention )的概念决定的，@Retention则是用来设置注解保留期的元注解。对应上述三种情况，@Retention有三种值可选：`java.lang.annotation.RetentionPolicy.{RUNTIME,CLASS,SOURCE}`。

// TODO JLS $9.6.4.2 (page 306, 326)保留期的详细说明

### @Repeatable

如果注解T定义中包含了元注解@Repeatable并通过这个元注解指定了*containing annotation type* TC，那么T就是Repeatable注解。

而注解类型TC要满足6个条件才能成为注解T的*containing annotation type*：

1. 注解 TC 声明了 value() 方法且返回类型是 T[]。
2. TC 声明的除 value() 之外的其他字段都有默认值。
3. 注解类 TC 的保留期至少要和 T 的保留期一样长（保留期可以显式或隐式指定，`RUNTIME` > `CLASS` > `SOURCE`）。
4. 注解类 T 至少要能应用于和注解类 TC 一样广的程序元素范围。如果T的程序元素集合是 `m1` ，TC 的程序元素集合是 `m2`，`m2` 的每个元素都得出现在 `m1` 中，但是有三个例外条件：`m2` 有 `ANNOTATION_TYPE`，`m1` 必须有`ANNOTATION_TYPE` 或 `TYPE` 或 `TYPE_USE` 三者之一；`m2` 有 `TYPE` ，`m1` 必须有 `TYPE` 或 `TYPE_USE` 二者之一；`m2` 有 `TYPE_PARAMETER`，`m1` 必须有 `TYPE_PARAMETER` 或 `TYPE_USE` 两者之一；
5. 如果注解 T 的声明中包含对应于 `Documented` 的元注解，那么 TC 也要有对应于 `Documented` 的元注解。
6. 如果注解 T 的声明中包含对应于 `Inherited` 的元注解，那么 TC 也要有对应于 `Inherited` 的元注解。

根据上面6条规则，如果注解 T 通过 @Repeatable 元注解定义了不属于 T 的*containing annotation type* 的注解类，会引发编译错误。

// TODO JLS page 302: Repeatable注解更广泛的解释以及错误示例。

## 反射 Reflection

// TODO JLS 不介绍Java反射类库，可以参考 [Java SE platform API documentation](https://docs.oracle.com/javase/8/docs/api/)。







# JVM

- 自动内存管理
- 虚拟机执行子系统
- 程序编译与代码优化















