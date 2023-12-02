---
scope: learn
draft: true
---
[Can newer JRE versions run Java programs compiled with older JDK versions? - Stack Overflow](https://stackoverflow.com/questions/10895969/can-newer-jre-versions-run-java-programs-compiled-with-older-jdk-versions)
[Compatibility Guide for JDK 8](https://www.oracle.com/java/technologies/javase/8-compatibility-guide.html)
[Java SE 7 and JDK 7 Compatibility](https://www.oracle.com/java/technologies/compatibility.html#incompatibilities)

# 二进制兼容性
## Official list of Oracle Java incompatibilities between versions:

-   [in Java SE 9 since Java SE 8](https://docs.oracle.com/javase/9/migrate/toc.htm#JSMIG-GUID-F7696E02-A1FB-4D5A-B1F2-89E7007D4096)
-   [in Java SE 8 since Java SE 7](http://www.oracle.com/technetwork/java/javase/8-compatibility-guide-2156366.html#A999198)
-   [in Java SE 7 since Java SE 6](http://www.oracle.com/technetwork/java/javase/compatibility-417013.html#incompatibilities "official list of incompatibilities")
-   [in Java SE 6 since Java SE 5.0](http://www.oracle.com/technetwork/java/javase/compatibility-137541.html#incompatibilities)
-   [in Java SE 5.0 since Java SE 1.4.2](http://www.oracle.com/technetwork/java/javase/compatibility-137462.html#incompatibilities)

## Compatibility tool

Packaged with **JDK 9**, there is a tool called [jdeprscan](https://docs.oracle.com/javase/9/tools/jdeprscan.htm) which will verify the compatibility, list no longer used APIs within your code and suggest alternatives(!). You can specify the target **JDK version** (works for **JDK 9**, **8**, **7** and **6**) and it will list incompatibilities specific to your target version.

## Additional comment in case of libraries:

A reasonable rule of thumb is to use latest stable release version of library for the JRE version your software targets. Obviously you will find many exceptions from this rule, but in general stability of publicly available libraries **usually** increases with time.

Naturally **API compatibility** and **versioning** have to be considered when changing versions of dependencies.

Again most popular dependencies will have web pages where such information should be available.

If however you are using something a bit more obscure, you can discern which JRE were the classes within your dependency compiled for.

[Here is a great answer on how to find out class version](https://stackoverflow.com/a/1096159/76237). You might need to unzip the JAR file first.

# 源码兼容性


