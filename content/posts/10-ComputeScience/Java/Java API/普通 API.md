---
scope: learn
draft: true
---
## Java 函数式编程：流操作
[java.util.stream (Java Platform SE 8 )](https://docs.oracle.com/javase/8/docs/api/java/util/stream/package-summary.html#Reduction)
[Collector (Java Platform SE 8 )](https://docs.oracle.com/javase/8/docs/api/java/util/stream/Collector.html)
函数式编程中的流操作就是把输入流 S1 经过一定的计算，可能会生成中间结果 A，最后把这些可能的中间结果收集起来映射到新的输出流 S2。
### Collector
Collector 完成的是可变规约操作，也就是如何把计算结果放到一个容器中。它定义了三个类型 `Collector<T,A,R>`：
- `T` 是输入流中元素的类型
- `A` 是流计算的中间结果类型
- `R` 是输出结果的元素类型
通过 `Collector.of()` 使用。

### Optional
[Optional (Java Platform SE 8 )](https://docs.oracle.com/javase/8/docs/api/java/util/Optional.html)

### 函数式接口
在 `java.util.function` 包，分成没有参数的 `Supplier` 系列、有返回值的 `Function` 系列和没有返回值的 `Consumer` 系列。他们都是使用了 `@FunctionalInterface` 这个注解。
[FunctionalInterface (Java Platform SE 8 )](https://docs.oracle.com/javase/8/docs/api/java/lang/FunctionalInterface.html)

[java.util.function (Java Platform SE 8 )](https://docs.oracle.com/javase/8/docs/api/java/util/function/package-summary.html)
# Java Util 工具包
[java.util (Java Platform SE 8 )](https://docs.oracle.com/javase/8/docs/api/java/util/package-summary.html)
## 参考链接
[集合 - 廖雪峰的官方网站](https://www.liaoxuefeng.com/wiki/1252599548343744/1255943629175808)
[List集合去重的一些方法（常规遍历、Set去重、java8 stream去重、重写equals和hashCode方法） - 雪山上的蒲公英 - 博客园](https://www.cnblogs.com/zjfjava/p/9897650.html)
[Outline of the Collections Framework](https://docs.oracle.com/javase/8/docs/technotes/guides/collections/reference.html)
[Collections Framework Overview](https://docs.oracle.com/javase/8/docs/technotes/guides/collections/overview.html)
[Collections Framework Tutorial](http://www.java.sun.com/docs/books/tutorial/collections/)
[Collections Framework Design FAQ](https://docs.oracle.com/javase/8/docs/technotes/guides/collections/designfaq.html)

## Java 基本容器类型
[Collections Framework Overview](https://docs.oracle.com/javase/8/docs/technotes/guides/collections/overview.html)
###  Outline
[Outline of the Collections Framework](https://docs.oracle.com/javase/8/docs/technotes/guides/collections/reference.html)
### 容器接口
各种容器接口实现：
| Interface | Hash Table | Resizable Array | Balanced Tree | Linked List | Hash Table + Linked List |
|-----------|------------|-----------------|---------------|-------------|--------------------------|
| Set       | HashSet    |                 | TreeSet       |             | LinkedHashSet            |
| List      |            | ArrayList       |               | LinkedList  |                          |
| Deque     |            | ArrayDeque      |               | LinkedList  |                          |
| Map       | HashMap    |                 | TreeMap       |             | LinkedHashMap            |

-   **Collection interfaces** - The primary means by which collections are manipulated.
    -   [**Collection**](https://docs.oracle.com/javase/8/docs/api/java/util/Collection.html) - A group of objects. No assumptions are made about the order of the collection (if any) or whether it can contain duplicate elements.
    -   [**Set**](https://docs.oracle.com/javase/8/docs/api/java/util/Set.html) - The familiar set abstraction. No duplicate elements permitted. May or may not be ordered. Extends the Collection interface.
    -   [**List**](https://docs.oracle.com/javase/8/docs/api/java/util/List.html) - Ordered collection, also known as a *sequence*. Duplicates are generally permitted. Allows positional access. Extends the Collection interface.
    -   [**Queue**](https://docs.oracle.com/javase/8/docs/api/java/util/Queue.html) - A collection designed for holding elements before processing. Besides basic Collection operations, queues provide additional insertion, extraction, and inspection operations.
    -   [**Deque**](https://docs.oracle.com/javase/8/docs/api/java/util/Deque.html) - A *double ended queue*, supporting element insertion and removal at both ends. Extends the Queue interface.
    -   [**Map**](https://docs.oracle.com/javase/8/docs/api/java/util/Map.html) - A mapping from keys to values. Each key can map to one value.
    -   [**SortedSet**](https://docs.oracle.com/javase/8/docs/api/java/util/SortedSet.html) - A set whose elements are automatically sorted, either in their *natural ordering* (see the [Comparable](https://docs.oracle.com/javase/8/docs/api/java/lang/Comparable.html) interface) or by a [Comparator](https://docs.oracle.com/javase/8/docs/api/java/util/Comparator.html) object provided when a SortedSet instance is created. Extends the Set interface.
    -   [**SortedMap**](https://docs.oracle.com/javase/8/docs/api/java/util/SortedMap.html) - A map whose mappings are automatically sorted by key, either using the *natural ordering* of the keys or by a comparator provided when a SortedMap instance is created. Extends the Map interface.
    -   [**NavigableSet**](https://docs.oracle.com/javase/8/docs/api/java/util/NavigableSet.html) - A SortedSet extended with navigation methods reporting closest matches for given search targets. A NavigableSet may be accessed and traversed in either ascending or descending order.
    -   [**NavigableMap**](https://docs.oracle.com/javase/8/docs/api/java/util/NavigableMap.html) - A SortedMap extended with navigation methods returning the closest matches for given search targets. A NavigableMap can be accessed and traversed in either ascending or descending key order.
    -   [**BlockingQueue**](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/BlockingQueue.html) - A Queue with operations that wait for the queue to become nonempty when retrieving an element and that wait for space to become available in the queue when storing an element. (This interface is part of the [java.util.concurrent](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/package-summary.html) package.)
    -   [**TransferQueue**](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/TransferQueue.html) - A BlockingQueue in which producers can wait for consumers to receive elements. (This interface is part of the [java.util.concurrent](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/package-summary.html) package.)
    -   [**BlockingDeque**](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/BlockingDeque.html) - A Deque with operations that wait for the deque to become nonempty when retrieving an element and wait for space to become available in the deque when storing an element. Extends both the Deque and BlockingQueue interfaces. (This interface is part of the [java.util.concurrent](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/package-summary.html) package.)
    -   [**ConcurrentMap**](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ConcurrentMap.html) - A Map with atomic putIfAbsent, remove, and replace methods. (This interface is part of the java.util.concurrent package.)
    -   [**ConcurrentNavigableMap**](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ConcurrentNavigableMap.html) - A ConcurrentMap that is also a NavigableMap.
### 通用的容器接口实现
-   **General-purpose implementations** - The primary implementations of the collection interfaces.
    -   **[HashSet](https://docs.oracle.com/javase/8/docs/api/java/util/HashSet.html)** - Hash table implementation of the Set interface. The best all-around implementation of the Set interface.
    -   [**TreeSet**](https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html) - Red-black tree implementation of the NavigableSet interface.
    -   **[LinkedHashSet](https://docs.oracle.com/javase/8/docs/api/java/util/LinkedHashSet.html)** - Hash table and linked list implementation of the Set interface. An insertion-ordered Set implementation that runs nearly as fast as HashSet.
    -   **[ArrayList](https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html)** - Resizable array implementation of the List interface (an unsynchronized Vector). The best all-around implementation of the List interface.
    -   **[ArrayDeque](https://docs.oracle.com/javase/8/docs/api/java/util/ArrayDeque.html)** - Efficient, resizable array implementation of the Deque interface.
    -   [**LinkedList**](https://docs.oracle.com/javase/8/docs/api/java/util/LinkedList.html) - Doubly-linked list implementation of the List interface. Provides better performance than the ArrayList implementation if elements are frequently inserted or deleted within the list. Also implements the Deque interface. When accessed through the Queue interface, LinkedList acts as a FIFO queue.
    -   **[PriorityQueue](https://docs.oracle.com/javase/8/docs/api/java/util/PriorityQueue.html)** - Heap implementation of an unbounded priority queue.
    -   **[HashMap](https://docs.oracle.com/javase/8/docs/api/java/util/HashMap.html)** - Hash table implementation of the Map interface (an unsynchronized Hashtable that supports null keys and values). The best all-around implementation of the Map interface.
    -   [**TreeMap**](https://docs.oracle.com/javase/8/docs/api/java/util/TreeMap.html) Red-black tree implementation of the NavigableMap interface.
    -   **[LinkedHashMap](https://docs.oracle.com/javase/8/docs/api/java/util/LinkedHashMap.html)** - Hash table and linked list implementation of the Map interface. An insertion-ordered Map implementation that runs nearly as fast as HashMap. Also useful for building caches (see [removeEldestEntry(Map.Entry)](https://docs.oracle.com/javase/8/docs/api/java/util/LinkedHashMap.html#removeEldestEntry-java.util.Map.Entry-) ).
### 包装器实现
-   **Wrapper implementations** - Functionality-enhancing implementations for use with other implementations. Accessed solely through static factory methods.
    -   [**Collections.unmodifiable*Interface***](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#unmodifiableCollection-java.util.Collection-) - Returns an unmodifiable view of a specified collection that throws an UnsupportedOperationException if the user attempts to modify it.
    -   [**Collections.synchronized*Interface***](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#synchronizedCollection-java.util.Collection-) - Returns a synchronized collection that is backed by the specified (typically unsynchronized) collection. As long as all accesses to the backing collection are through the returned collection, thread safety is guaranteed.
    -   [**Collections.checked*Interface***](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#checkedCollection-java.util.Collection-java.lang.Class-) - Returns a dynamically type-safe view of the specified collection, which throws a ClassCastException if a client attempts to add an element of the wrong type. The generics mechanism in the language provides compile-time (static) type checking, but it is possible to bypass this mechanism. Dynamically type-safe views eliminate this possibility.
### 适配器实现
-   **Adapter implementations** - Implementations that adapt one collections interface to another:
    -   **[newSetFromMap(Map)](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#newSetFromMap-java.util.Map-)** - Creates a general-purpose Set implementation from a general-purpose Map implementation.
    -   **[asLifoQueue(Deque)](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#asLifoQueue-java.util.Deque-)** - Returns a view of a Deque as a Last In First Out (LIFO) Queue.
### 创建容器对象的便捷实现
-   **Convenience implementations** - High-performance "mini-implementations" of the collection interfaces.
    -   [**Arrays.asList**](https://docs.oracle.com/javase/8/docs/api/java/util/Arrays.html#asList-T...-) - Enables an array to be viewed as a list.
    -   **[emptySet](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#emptySet--), [emptyList](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#emptyList--) and [emptyMap](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#emptyMap--)** - Return an immutable empty set, list, or map.
    -   **[singleton](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#singleton-java.lang.Object-), [singletonList](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#singletonList-java.lang.Object-), and [singletonMap](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#singletonMap-K-V-)** - Return an immutable singleton set, list, or map, containing only the specified object (or key-value mapping).
    -   [**nCopies**](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#nCopies-int-T-) - Returns an immutable list consisting of n copies of a specified object.
### 过时的陈旧实现类
-   **Legacy implementations** - Older collection classes were retrofitted to implement the collection interfaces.
    -   [**Vector**](https://docs.oracle.com/javase/8/docs/api/java/util/Vector.html) - Synchronized resizable array implementation of the List interface with additional legacy methods.
    -   [**Hashtable**](https://docs.oracle.com/javase/8/docs/api/java/util/Hashtable.html) - Synchronized hash table implementation of the Map interface that does not allow null keys or values, plus additional legacy methods.
### 专用实现类
-   **Special-purpose implementations**
    -   **[WeakHashMap](https://docs.oracle.com/javase/8/docs/api/java/util/WeakHashMap.html)** - An implementation of the Map interface that stores only [*weak references*](https://docs.oracle.com/javase/8/docs/api/java/lang/ref/WeakReference.html) to its keys. Storing only weak references enables key-value pairs to be garbage collected when the key is no longer referenced outside of the WeakHashMap. This class is the easiest way to use the power of weak references. It is useful for implementing registry-like data structures, where the utility of an entry vanishes when its key is no longer reachable by any thread.
    -   **[IdentityHashMap](https://docs.oracle.com/javase/8/docs/api/java/util/IdentityHashMap.html)** - Identity-based Map implementation based on a hash table. This class is useful for topology-preserving object graph transformations (such as serialization or deep copying). To perform these transformations, you must maintain an identity-based "node table" that keeps track of which objects have already been seen. Identity-based maps are also used to maintain object-to-meta-information mappings in dynamic debuggers and similar systems. Finally, identity-based maps are useful in preventing "spoof attacks" resulting from intentionally perverse equals methods. (IdentityHashMap never invokes the equals method on its keys.) An added benefit of this implementation is that it is fast.
    -   **[CopyOnWriteArrayList](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/CopyOnWriteArrayList.html)** - A List implementation backed by an copy-on-write array. All mutative operations (such as add, set, and remove) are implemented by making a new copy of the array. No synchronization is necessary, even during iteration, and iterators are guaranteed never to throw ConcurrentModificationException. This implementation is well-suited to maintaining event-handler lists (where change is infrequent, and traversal is frequent and potentially time-consuming).
    -   **[CopyOnWriteArraySet](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/CopyOnWriteArraySet.html)** - A Set implementation backed by a copy-on-write array. This implementation is similar to CopyOnWriteArrayList. Unlike most Set implementations, the add, remove, and contains methods require time proportional to the size of the set. This implementation is well suited to maintaining event-handler lists that must prevent duplicates.
    -   **[EnumSet](https://docs.oracle.com/javase/8/docs/api/java/util/EnumSet.html)** - A high-performance Set implementation backed by a bit vector. All elements of each EnumSet instance must be elements of a single enum type.
    -   **[EnumMap](https://docs.oracle.com/javase/8/docs/api/java/util/EnumMap.html)** - A high-performance Map implementation backed by an array. All keys in each EnumMap instance must be elements of a single enum type.
### 用于同步的容器类
-   **Concurrent implementations** - These implementations are part of java.util.concurrent.
    -   **[ConcurrentLinkedQueue](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ConcurrentLinkedQueue.html)** - An unbounded first in, first out (FIFO) queue based on linked nodes.
    -   [**LinkedBlockingQueue**](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/LinkedBlockingQueue.html) - An optionally bounded FIFO blocking queue backed by linked nodes.
    -   [**ArrayBlockingQueue**](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ArrayBlockingQueue.html) - A bounded FIFO blocking queue backed by an array.
    -   [**PriorityBlockingQueue**](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/PriorityBlockingQueue.html) - An unbounded blocking priority queue backed by a priority heap.
    -   [**DelayQueue**](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/DelayQueue.html) - A time-based scheduling queue backed by a priority heap.
    -   [**SynchronousQueue**](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/SynchronousQueue.html) - A simple rendezvous mechanism that uses the BlockingQueue interface.
    -   [**LinkedBlockingDeque**](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/LinkedBlockingDeque.html) - An optionally bounded FIFO blocking deque backed by linked nodes.
    -   [**LinkedTransferQueue**](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/LinkedTransferQueue.html) - An unbounded TransferQueue backed by linked nodes.
    -   [**ConcurrentHashMap**](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ConcurrentHashMap.html) - A highly concurrent, high-performance ConcurrentMap implementation based on a hash table. This implementation never blocks when performing retrievals and enables the client to select the concurrency level for updates. It is intended as a drop-in replacement for [Hashtable](https://docs.oracle.com/javase/8/docs/api/java/util/Hashtable.html). In addition to implementing ConcurrentMap, it supports all of the legacy methods of Hashtable.
    -   [**ConcurrentSkipListSet**](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ConcurrentSkipListSet.html) - Skips list implementation of the NavigableSet interface.
    -   [**ConcurrentSkipListMap**](https://docs.oracle.com/javase/8/docs/api/java/util/concurrent/ConcurrentSkipListMap.html) - Skips list implementation of the ConcurrentNavigableMap interface.
### 抽象实现类
-   **Abstract implementations** - Skeletal implementations of the collection interfaces to facilitate custom implementations.
    -   [**AbstractCollection**](https://docs.oracle.com/javase/8/docs/api/java/util/AbstractCollection.html) - Skeletal Collection implementation that is neither a set nor a list (such as a "bag" or multiset).
    -   [**AbstractSet**](https://docs.oracle.com/javase/8/docs/api/java/util/AbstractSet.html) - Skeletal Set implementation.
    -   [**AbstractList**](https://docs.oracle.com/javase/8/docs/api/java/util/AbstractList.html) - Skeletal List implementation backed by a random access data store (such as an array).
    -   [**AbstractSequentialList**](https://docs.oracle.com/javase/8/docs/api/java/util/AbstractSequentialList.html) - Skeletal List implementation backed by a sequential access data store (such as a linked list).
    -   [**AbstractQueue**](https://docs.oracle.com/javase/8/docs/api/java/util/AbstractQueue.html) - Skeletal Queue implementation.
    -   [**AbstractMap**](https://docs.oracle.com/javase/8/docs/api/java/util/AbstractMap.html) - Skeletal Map implementation.
### 算法实现类
-   **Algorithms** - The [**Collections**](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html) class contains these useful static methods.
    -   **[sort(List)](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#sort-java.util.List-)** - Sorts a list using a merge sort algorithm, which provides average case performance comparable to a high quality quicksort, guaranteed O(n\*log n) performance (unlike quicksort), and *stability* (unlike quicksort). A stable sort is one that does not reorder equal elements.
    -   **[binarySearch(List, Object)](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#binarySearch-java.util.List-T-)** - Searches for an element in an ordered list using the binary search algorithm.
    -   **[reverse(List)](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#reverse-java.util.List-)** - Reverses the order of the elements in a list.
    -   **[shuffle(List)](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#shuffle-java.util.List-)** - Randomly changes the order of the elements in a list.
    -   **[fill(List, Object)](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#fill-java.util.List-T-)** - Overwrites every element in a list with the specified value.
    -   **[copy(List dest, List src)](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#copy-java.util.List-java.util.List-)** - Copies the source list into the destination list.
    -   **[min(Collection)](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#min-java.util.Collection-)** - Returns the minimum element in a collection.
    -   **[max(Collection)](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#max-java.util.Collection-)** - Returns the maximum element in a collection.
    -   **[rotate(List list, int distance)](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#rotate-java.util.List-int-)** - Rotates all of the elements in the list by the specified distance.
    -   **[replaceAll(List list, Object oldVal, Object newVal)](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#replaceAll-java.util.List-T-T-)** - Replaces all occurrences of one specified value with another.
    -   **[indexOfSubList(List source, List target)](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#indexOfSubList-java.util.List-java.util.List-)** - Returns the index of the first sublist of source that is equal to target.
    -   **[lastIndexOfSubList(List source, List target)](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#lastIndexOfSubList-java.util.List-java.util.List-)** - Returns the index of the last sublist of source that is equal to target.
    -   **[swap(List, int, int)](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#swap-java.util.List-int-int-)** - Swaps the elements at the specified positions in the specified list.
    -   **[frequency(Collection, Object)](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#frequency-java.util.Collection-java.lang.Object-)** - Counts the number of times the specified element occurs in the specified collection.
    -   **[disjoint(Collection, Collection)](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#disjoint-java.util.Collection-java.util.Collection-)** - Determines whether two collections are disjoint, in other words, whether they contain no elements in common.
    -   **[`addAll(Collection<? super T>, T...)`](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html#addAll-java.util.Collection-T...-)** - Adds all of the elements in the specified array to the specified collection.
### 迭代器、异常等基本工具
-   **Infrastructure**
    -   **Iterators** - Similar to the familiar [Enumeration](https://docs.oracle.com/javase/8/docs/api/java/util/Enumeration.html) interface, but more powerful, and with improved method names.
        -   [**Iterator**](https://docs.oracle.com/javase/8/docs/api/java/util/Iterator.html) - In addition to the functionality of the Enumeration interface, enables the user to remove elements from the backing collection with well-defined, useful semantics.
        -   [**ListIterator**](https://docs.oracle.com/javase/8/docs/api/java/util/ListIterator.html) - Iterator for use with lists. In addition to the functionality of the Iterator interface, supports bidirectional iteration, element replacement, element insertion, and index retrieval.
    -   **Ordering**
        -   [**Comparable**](https://docs.oracle.com/javase/8/docs/api/java/lang/Comparable.html) - Imparts a *natural ordering* to classes that implement it. The natural ordering can be used to sort a list or maintain order in a sorted set or map. Many classes were retrofitted to implement this interface.
        -   [**Comparator**](https://docs.oracle.com/javase/8/docs/api/java/util/Comparator.html) - Represents an order relation, which can be used to sort a list or maintain order in a sorted set or map. Can override a type's natural ordering or order objects of a type that does not implement the Comparable interface.
    -   **Runtime exceptions**
        -   [**UnsupportedOperationException**](https://docs.oracle.com/javase/8/docs/api/java/lang/UnsupportedOperationException.html) - Thrown by collections if an unsupported optional operation is called.
        -   [**ConcurrentModificationException**](https://docs.oracle.com/javase/8/docs/api/java/util/ConcurrentModificationException.html) - Thrown by iterators and list iterators if the backing collection is changed unexpectedly while the iteration is in progress. Also thrown by *sublist* views of lists if the backing list is changed unexpectedly.
    -   **Performance**
        -   **[RandomAccess](https://docs.oracle.com/javase/8/docs/api/java/util/RandomAccess.html)** - Marker interface that lets List implementations indicate that they support fast (generally constant time) random access. This lets generic algorithms change their behavior to provide good performance when applied to either random or sequential access lists.
### 数组工具
-   **Array Utilities**
    -   [**Arrays**](https://docs.oracle.com/javase/8/docs/api/java/util/Arrays.html) - Contains static methods to sort, search, compare, hash, copy, resize, convert to String, and fill arrays of primitives and objects.




### WeakHashMap
[WeakHashMap (Java Platform SE 8 )](https://docs.oracle.com/javase/8/docs/api/java/util/WeakHashMap.html)


# Java 反射
[java.lang.reflect (Java Platform SE 8 )](https://docs.oracle.com/javase/8/docs/api/index.html)
[Class (Java Platform SE 8 )](https://docs.oracle.com/javase/8/docs/api/index.html)
[反射 - 廖雪峰的官方网站](https://www.liaoxuefeng.com/wiki/1252599548343744/1255945147512512)

## `getMethods` 和 `getDeclaredMethods`
前者返回的是目标类中修饰符为 public 的方法，包括从父类继承来的方法。
后者只返回目标类自己声明的方法，但不限制修饰符为 public，也包括 private 和 protected 方法。
# 文法结构
## 运算符

```
// >>> 无符号右移运算符
= > < ! ~ ? : ->
== >= <= != && || ++ --
+ - * / & | ^ % << >> >>>
// 扩展赋值运算符
+= -= *= /= &= |= ^= %= <<= >>= >>>=
```

## 关键字

```
// strictfp 严格浮点数精度
// transient
// valatile 
abstract continue for new switch
assert default if package synchronized
boolean do goto private this
break double implements protected throw
byte else import public throws
case enum instanceof return transient
catch extends int short try
char final interface static void
class finally long strictfp volatile
const float native super while
```
# Enum
[Java using enum with switch statement - Stack Overflow](https://stackoverflow.com/questions/8108980/java-using-enum-with-switch-statement)

# 字符串
StringBuilder 与 StringBuffer

[String、StringBuffer和StringBuilder的区别 - 简书](https://www.jianshu.com/p/8c724dd28fa4): <https://www.jianshu.com/p/8c724dd28fa4>

# Java 日期时间
[基本概念 - 廖雪峰的官方网站](https://www.liaoxuefeng.com/wiki/1252599548343744/1298613246361634)
[Date和Calendar - 廖雪峰的官方网站](https://www.liaoxuefeng.com/wiki/1252599548343744/1303791989162017)
[LocalDateTime - 廖雪峰的官方网站](https://www.liaoxuefeng.com/wiki/1252599548343744/1303871087444002)
[ZonedDateTime - 廖雪峰的官方网站](https://www.liaoxuefeng.com/wiki/1252599548343744/1303904694304801)
[DateTimeFormatter - 廖雪峰的官方网站](https://www.liaoxuefeng.com/wiki/1252599548343744/1303985694703650)
[Instant - 廖雪峰的官方网站](https://www.liaoxuefeng.com/wiki/1252599548343744/1303905346519074)
日期格式化时，yyyy 表示当天所在的年，而大写的 YYYY 代表是 week in which year（JDK7 之后引入的概念）， 意思是当天所在的周属于的年份，一周从周日开始，周六结束，只要本周跨年，返回的 YYYY 就是下一年。
反例：某程序员因使用 YYYY/MM/dd 进行日期格式化，2017/12/31 执行结果为 2018/12/31，造成线上故障。

在日期格式中分清楚大写的 M 和小写的 m，大写的 H 和小写的 h 分别指代的意义。 说明：日期格式中的这两对字母表意如下： 1）表示月份是大写的 M 2）表示分钟则是小写的 m 3）24 小时制的是大写的 H 4）12 小时制的则是小写的 h。

MySQL 中 Date、DateTime 和 TimeStamp 的区别
[MySQL :: MySQL 8.0 Reference Manual :: 11.2.2 The DATE, DATETIME, and TIMESTAMP Types](https://dev.mysql.com/doc/refman/8.0/en/datetime.html)
The DATETIME type is used for values that contain both date and time parts. MySQL retrieves and displays DATETIME values in 'YYYY-MM-DD HH:MM:SS' format. The supported range is '1000-01-01 00:00:00' to '9999-12-31 23:59:59'.

The TIMESTAMP data type is used for values that contain both date and time parts. TIMESTAMP has a range of '1970-01-01 00:00:01' UTC to '2038-01-19 03:14:07' UTC.

在MyBatis 中配置 MySQL 数据库创建、更新时间的自动填充策略时，使用 MetaObjectHandler.strictUpdateFill 方法，避免参数类型不一致抛出异常。


# 加密与安全
[加密与安全 - 廖雪峰的官方网站](https://www.liaoxuefeng.com/wiki/1252599548343744/1255943717668160)
[BouncyCastle - 廖雪峰的官方网站](https://www.liaoxuefeng.com/wiki/1252599548343744/1305362418368545)

# 自动装拆箱
[java - Why does int num = Integer.getInteger("123") throw NullPointerException? - Stack Overflow](https://stackoverflow.com/questions/3123349/why-does-int-num-integer-getinteger123-throw-nullpointerexception)
[Autoboxing](https://docs.oracle.com/javase/1.5.0/docs/guide/language/autoboxing.html)

# Java 断言
Java 断言语句是 `assert`，可以断言是否满足某个条件，如果不满足就抛出 `AssertionError` 和提示信息，程序将直接退出。
```Java
assert x > 0;
assert x >= 0 : "x must >= 0";
```
因为断言失败会导致程序直接退出，所以一般很少直接使用断言。
JVM 默认关闭断言，通过 `-ea` 或 `-enableassertions` 可以让 JVM 开启断言。所以在一般的 Java 项目中业务代码的运行配置都是关闭断言的，而在测试代码的运行配置中就可以看到 `-ea` 参数。
[使用断言 - 廖雪峰的官方网站](https://www.liaoxuefeng.com/wiki/1252599548343744/1264740093521088)

# Unsafe 解析

[Java魔法类：Unsafe应用解析 - 美团技术团队](https://tech.meituan.com/2019/02/14/talk-about-java-magic-class-unsafe.html): <https://tech.meituan.com/2019/02/14/talk-about-java-magic-class-unsafe.html>
