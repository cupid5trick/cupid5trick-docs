---
scope: learn
draft: true
---
[HotSpot Virtual Machine Garbage Collection Tuning Guide](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning)

**[1 Introduction](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/introduction.html#sthref3)**

**[2 Ergonomics](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/ergonomics.html#ergonomics)**

- [Garbage Collector, Heap, and Runtime Compiler Default Selections](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/ergonomics.html#sthref5)
- Behavior-Based Tuning
  - [Maximum Pause Time Goal](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/ergonomics.html#sthref12)
  - [Throughput Goal](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/ergonomics.html#sthref13)
  - [Footprint Goal](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/ergonomics.html#sthref14)
- [Tuning Strategy](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/ergonomics.html#sthref15)

**[3 Generations](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/generations.html#sthref16)**

- [Performance Considerations](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/generations.html#sthref19)
- [Measurement](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/generations.html#sthref20)

**[4 Sizing the Generations](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/sizing.html#sizing_generations)**

- [Total Heap](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/sizing.html#sthref22)
- The Young Generation
  - [Survivor Space Sizing](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/sizing.html#sthref25)

**[5 Available Collectors](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/collectors.html#sthref27)**

- [Selecting a Collector](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/collectors.html#sthref28)

**[6 The Parallel Collector](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/parallel.html#parallel_collector)**

- [Generations](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/parallel.html#parallel_collector_generations)
- Parallel Collector Ergonomics
  - [Priority of Goals](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/parallel.html#parallel_collector_priority)
  - [Generation Size Adjustments](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/parallel.html#parallel_collector_gen_size)
  - Default Heap Size
    - [Client JVM Default Initial and Maximum Heap Sizes](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/parallel.html#sthref30)
    - [Server JVM Default Initial and Maximum Heap Sizes](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/parallel.html#sthref31)
    - [Specifying Initial and Maximum Heap Sizes](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/parallel.html#sthref32)
- [Excessive GC Time and OutOfMemoryError](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/parallel.html#parallel_collector_excessive_gc)
- [Measurements](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/parallel.html#parallel_collector_measurements)

**[7 The Mostly Concurrent Collectors](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/concurrent.html#mostly_concurrent)**

- [Overhead of Concurrency](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/concurrent.html#sthref33)
- [Additional References](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/concurrent.html#sthref34)

**[8 Concurrent Mark Sweep (CMS) Collector](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/cms.html#concurrent_mark_sweep_cms_collector)**

- [Concurrent Mode Failure](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/cms.html#concurrent_mode_failure)
- [Excessive GC Time and OutOfMemoryError](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/cms.html#sthref35)
- [Floating Garbage](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/cms.html#sthref36)
- [Pauses](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/cms.html#sthref37)
- [Concurrent Phases](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/cms.html#sthref38)
- [Starting a Concurrent Collection Cycle](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/cms.html#sthref39)
- [Scheduling Pauses](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/cms.html#sthref40)
- Incremental Mode
  - [Command-Line Options](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/cms.html#sthref41)
  - [Recommended Options](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/cms.html#i_cms_recommended_options)
  - [Basic Troubleshooting](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/cms.html#sthref43)
- [Measurements](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/cms.html#sthref45)

**[9 Garbage-First Garbage Collector](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/g1_gc.html#garbage_first_garbage_collection)**

- [Allocation (Evacuation) Failure](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/g1_gc.html#allocation_evacuation_failure)
- [Floating Garbage](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/g1_gc.html#sthref47)
- [Pauses](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/g1_gc.html#pauses)
- [Card Tables and Concurrent Phases](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/g1_gc.html#sthref48)
- [Starting a Concurrent Collection Cycle](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/g1_gc.html#sthref49)
- [Pause Time Goal](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/g1_gc.html#pause_time_goal)

**[10 Garbage-First Garbage Collector Tuning](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/g1_gc_tuning.html#g1_gc_tuning)**

- [Garbage Collection Phases](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/g1_gc_tuning.html#sthref50)
- [Young Garbage Collections](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/g1_gc_tuning.html#sthref51)
- [Mixed Garbage Collections](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/g1_gc_tuning.html#sthref52)
- [Phases of the Marking Cycle](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/g1_gc_tuning.html#sthref53)
- [Important Defaults](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/g1_gc_tuning.html#important_defaults)
- [How to Unlock Experimental VM Flags](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/g1_gc_tuning.html#how_to_unlock_experimental_vm_flags)
- [Recommendations](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/g1_gc_tuning.html#recommendations)
- [Overflow and Exhausted Log Messages](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/g1_gc_tuning.html#sthref61)
- [Humongous Objects and Humongous Allocations](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/g1_gc_tuning.html#humongous)

**[11 Other Considerations](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/considerations.html#sthref62)**

- [Finalization and Weak, Soft, and Phantom References](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/considerations.html#sthref63)
- [Explicit Garbage Collection](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/considerations.html#sthref64)
- [Soft References](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/considerations.html#sthref65)
- [Class Metadata](https://docs.oracle.com/javase/8/docs/technotes/guides/vm/gctuning/considerations.html#sthref66)