---
scope: learn
draft: true
---

# Matlab Runtime MCR

[MATLAB Runtime - MATLAB Compiler - MATLAB](https://ww2.mathworks.cn/en/products/compiler/matlab-runtime.html)

[Matlab Compiler Runtime与tomcat应用于matlab和java混编及网站开发_bluer的专栏-程序员宅基地 - 程序员宅基地](https://www.cxyzjd.com/article/bluer411945935/76422340)

[Install and Configure MATLAB Runtime - MATLAB & Simulink - MathWorks China](https://ww2.mathworks.cn/help/compiler/install-the-matlab-runtime.html)

# Java 调用

[Call MATLAB from Java - MATLAB & Simulink - MathWorks China](https://ww2.mathworks.cn/help/matlab/matlab-engine-api-for-java.html)

[Java Engine API Summary - MATLAB & Simulink - MathWorks China](https://ww2.mathworks.cn/help/matlab/matlab_external/java-api-summary.html)

## Functions

### MATLAB Functions

| [`matlab.engine.shareEngine`](https://ww2.mathworks.cn/help/matlab/ref/matlab.engine.shareengine.html) | Convert running MATLAB session to shared session |
| ------------------------------------------------------------ | ------------------------------------------------ |
| [`matlab.engine.engineName`](https://ww2.mathworks.cn/help/matlab/ref/matlab.engine.enginename.html) | Return name of shared MATLAB session             |
| [`matlab.engine.isEngineShared`](https://ww2.mathworks.cn/help/matlab/ref/matlab.engine.isengineshared.html) | Determine if MATLAB session is shared            |

## Classes

### Java com.mathworks.engine Package

| [`com.mathworks.engine.MatlabEngine`](https://ww2.mathworks.cn/help/matlab/apiref/com.mathworks.engine.matlabengine.html) | Java class using MATLAB as a computational engine |
| ------------------------------------------------------------ | ------------------------------------------------- |
|                                                              |                                                   |

### Java com.mathworks.matlab.types Package

| [`com.mathworks.matlab.types.Complex`](https://ww2.mathworks.cn/help/matlab/apiref/com.mathworks.matlab.types.complex.html) | Java class to pass complex data to and from MATLAB          |
| ------------------------------------------------------------ | ----------------------------------------------------------- |
| [`com.mathworks.matlab.types.Struct`](https://ww2.mathworks.cn/help/matlab/apiref/com.mathworks.matlab.types.struct.html) | Java class to pass MATLAB `struct` to and from MATLAB       |
| [`com.mathworks.matlab.types.CellStr`](https://ww2.mathworks.cn/help/matlab/apiref/com.mathworks.matlab.types.cellstr.html) | Java class to represent MATLAB cell array of `char` vectors |
| [`com.mathworks.matlab.types.HandleObject`](https://ww2.mathworks.cn/help/matlab/apiref/com.mathworks.matlab.types.handleobject.html) | Abstract Java class to represent MATLAB handle objects      |
| [`com.mathworks.matlab.types.ValueObject`](https://ww2.mathworks.cn/help/matlab/apiref/com.mathworks.matlab.types.valueobject.html) | Abstract Java class to represent MATLAB value objects       |

### `MatlabEngine` Methods

| Static methods                                               | Purpose                                                      |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| [startMatlab](https://ww2.mathworks.cn/help/matlab/apiref/com.mathworks.engine.matlabengine.html#bvaqa6o) | Start MATLAB synchronously                                   |
| [startMatlabAsync](https://ww2.mathworks.cn/help/matlab/apiref/com.mathworks.engine.matlabengine.html#bvaqi3p-1) | Start MATLAB asynchronously                                  |
| [findMatlab](https://ww2.mathworks.cn/help/matlab/apiref/com.mathworks.engine.matlabengine.html#bvarl8w-1) | Find all available shared MATLAB sessions running on the local machine synchronously |
| [findMatlabAsync](https://ww2.mathworks.cn/help/matlab/apiref/com.mathworks.engine.matlabengine.html#bvarmag-1) | Find all available shared MATLAB sessions from local machine asynchronously |
| [connectMatlab](https://ww2.mathworks.cn/help/matlab/apiref/com.mathworks.engine.matlabengine.html#bvarmb3-1) | Connect to a shared MATLAB session on local machine synchronously |
| [connectMatlabAsync](https://ww2.mathworks.cn/help/matlab/apiref/com.mathworks.engine.matlabengine.html#bvarmdr-1) | Connect to a shared MATLAB session on local machine asynchronously |

| Member Methods                                               | Purpose                                                      |
| :----------------------------------------------------------- | :----------------------------------------------------------- |
| [feval](https://ww2.mathworks.cn/help/matlab/apiref/com.mathworks.engine.matlabengine.html#bvarmi5-1) | Evaluate a MATLAB function with arguments synchronously      |
| [fevalAsync](https://ww2.mathworks.cn/help/matlab/apiref/com.mathworks.engine.matlabengine.html#bvarmj3-1) | Evaluate a MATLAB function with arguments asynchronously     |
| [eval](https://ww2.mathworks.cn/help/matlab/apiref/com.mathworks.engine.matlabengine.html#bvarmmm-1) | Evaluate a MATLAB statement as a string synchronously        |
| [evalAsync](https://ww2.mathworks.cn/help/matlab/apiref/com.mathworks.engine.matlabengine.html#bvarzs2-1) | Evaluate a MATLAB statement as a string asynchronously       |
| [getVariable](https://ww2.mathworks.cn/help/matlab/apiref/com.mathworks.engine.matlabengine.html#bvar0qe-1) | Get a variable from the MATLAB base workspace synchronously  |
| [getVariableAsync](https://ww2.mathworks.cn/help/matlab/apiref/com.mathworks.engine.matlabengine.html#bvar3om-1) | Get a variable from the MATLAB base workspace asynchronously |
| [putVariable](https://ww2.mathworks.cn/help/matlab/apiref/com.mathworks.engine.matlabengine.html#bvar3r2-1) | Put a variable in the MATLAB base workspace synchronously    |
| [putVariableAsync](https://ww2.mathworks.cn/help/matlab/apiref/com.mathworks.engine.matlabengine.html#bvar3q2-1) | Put a variable in the MATLAB base workspace asynchronously   |
| [disconnect](https://ww2.mathworks.cn/help/matlab/apiref/com.mathworks.engine.matlabengine.html#bvar30f-1) | Explicitly disconnect from the current MATLAB session synchronously |
| [disconnectAsync](https://ww2.mathworks.cn/help/matlab/apiref/com.mathworks.engine.matlabengine.html#bvar314-1) | Explicitly disconnect from the current MATLAB session asynchronously |
| [quit](https://ww2.mathworks.cn/help/matlab/apiref/com.mathworks.engine.matlabengine.html#bvar33g-1) | Force the shutdown of the current MATLAB session synchronously |
| [quitAsync](https://ww2.mathworks.cn/help/matlab/apiref/com.mathworks.engine.matlabengine.html#bvar34m-1) | Force the shutdown of the current MATLAB session asynchronously |
| [close](https://ww2.mathworks.cn/help/matlab/apiref/com.mathworks.engine.matlabengine.html#bvar4ns-1) | Disconnect or terminate current MATLAB session               |

### java.util.concurrent.Future Interface

| Member Methods | Purpose                                                      |
| :------------- | :----------------------------------------------------------- |
| `get`          | Wait for the computation to complete and then return the result |
| `cancel`       | Attempt to cancel execution of this task                     |
| `isCancelled`  | Return `true` if this task was cancelled before it completed |
| `isDone`       | Return `true` if this task completes                         |

For more information, see the Java documentation for [java.util.concurrent.Future](https://docs.oracle.com/javase/7/docs/api/java/util/concurrent/Future.html).

## 示例代码

Matlab 引擎的 Java API 附带了一些用来测试环境和熟悉使用的示例代码，这些代码位于 /

[Java Example Source Code - MATLAB & Simulink - MathWorks China](https://ww2.mathworks.cn/help/matlab/matlab_external/java-example-source-code.html)
