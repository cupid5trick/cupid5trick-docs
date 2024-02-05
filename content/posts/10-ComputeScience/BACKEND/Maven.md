---
scope: learn
draft: true
---
---
created: 2022-07-20T15:57:45 (UTC +08:00)
tags: []
source: https://maven.apache.org/guides/getting-started/index.html
author: Jason van Zyl
Vincent Siveton
---
# Getting Started Guide
> ## Excerpt
> At first glance Maven can appear to be many things, but in a nutshell Maven is an attempt to apply patterns to a project's build infrastructure in order to promote comprehension and productivity by providing a clear path in the use of best practices. Maven is essentially a project management and comprehension tool and as such provides a way to help with managing:
---
## Sections
[Sections](https://maven.apache.org/guides/getting-started/index.html#sections)
-   [What is Maven?](https://maven.apache.org/guides/getting-started/index.html#What_is_Maven)
-   [How can Maven benefit my development process?](https://maven.apache.org/guides/getting-started/index.html#How_can_Maven_benefit_my_development_process)
-   [How do I setup Maven?](https://maven.apache.org/guides/getting-started/index.html#How_do_I_setup_Maven)
-   [How do I make my first Maven project?](https://maven.apache.org/guides/getting-started/index.html#How_do_I_make_my_first_Maven_project)
-   [How do I compile my application sources?](https://maven.apache.org/guides/getting-started/index.html#How_do_I_compile_my_application_sources)
-   [How do I compile my test sources and run my unit tests?](https://maven.apache.org/guides/getting-started/index.html#How_do_I_compile_my_test_sources_and_run_my_unit_tests)
-   [How do I create a JAR and install it in my local repository?](https://maven.apache.org/guides/getting-started/index.html#How_do_I_create_a_JAR_and_install_it_in_my_local_repository)
-   [What is a SNAPSHOT version?](https://maven.apache.org/guides/getting-started/index.html#What_is_a_SNAPSHOT_version)
-   [How do I use plugins?](https://maven.apache.org/guides/getting-started/index.html#How_do_I_use_plugins)
-   [How do I add resources to my JAR?](https://maven.apache.org/guides/getting-started/index.html#How_do_I_add_resources_to_my_JAR)
-   [How do I filter resource files?](https://maven.apache.org/guides/getting-started/index.html#How_do_I_filter_resource_files)
-   [How do I use external dependencies?](https://maven.apache.org/guides/getting-started/index.html#How_do_I_use_external_dependencies)
-   [How do I deploy my jar in my remote repository?](https://maven.apache.org/guides/getting-started/index.html#How_do_I_deploy_my_jar_in_my_remote_repository)
-   [How do I create documentation?](https://maven.apache.org/guides/getting-started/index.html#How_do_I_create_documentation)
-   [How do I build other types of projects?](https://maven.apache.org/guides/getting-started/index.html#How_do_I_build_other_types_of_projects)
-   [How do I build more than one project at once?](https://maven.apache.org/guides/getting-started/index.html#How_do_I_build_more_than_one_project_at_once)
### What is Maven?
[What is Maven?](https://maven.apache.org/guides/getting-started/index.html#what-is-maven)
At first glance Maven can appear to be many things, but in a nutshell Maven is an attempt _to apply patterns to a project's build infrastructure in order to promote comprehension and productivity by providing a clear path in the use of best practices_. Maven is essentially a project management and comprehension tool and as such provides a way to help with managing:
-   Builds
-   Documentation
-   Reporting
-   Dependencies
-   SCMs
-   Releases
-   Distribution
If you want more background information on Maven you can check out [The Philosophy of Maven](https://maven.apache.org/background/philosophy-of-maven.html) and [The History of Maven](https://maven.apache.org/background/history-of-maven.html). Now let's move on to how you, the user, can benefit from using Maven.
### How can Maven benefit my development process?
[How can Maven benefit my development process?](https://maven.apache.org/guides/getting-started/index.html#how-can-maven-benefit-my-development-process)
Maven can provide benefits for your build process by employing standard conventions and practices to accelerate your development cycle while at the same time helping you achieve a higher rate of success.
Now that we have covered a little bit of the history and purpose of Maven let's get into some real examples to get you up and running with Maven!
### How do I setup Maven?
[How do I setup Maven?](https://maven.apache.org/guides/getting-started/index.html#how-do-i-setup-maven)
The defaults for Maven are often sufficient, but if you need to change the cache location or are behind a HTTP proxy, you will need to create configuration. See the [Guide to Configuring Maven](https://maven.apache.org/guides/mini/guide-configuring-maven.html) for more information.
### How do I make my first Maven project?
[How do I make my first Maven project?](https://maven.apache.org/guides/getting-started/index.html#how-do-i-make-my-first-maven-project)
We are going to jump headlong into creating your first Maven project! To create our first Maven project we are going to use Maven's archetype mechanism. An archetype is defined as _an original pattern or model from which all other things of the same kind are made_. In Maven, an archetype is a template of a project which is combined with some user input to produce a working Maven project that has been tailored to the user's requirements. We are going to show you how the archetype mechanism works now, but if you would like to know more about archetypes please refer to our [Introduction to Archetypes](https://maven.apache.org/guides/introduction/introduction-to-archetypes.html).
On to creating your first project! In order to create the simplest of Maven projects, execute the following from the command line:
```
mvn -B archetype:generate -DgroupId=com.mycompany.app -DartifactId=my-app -DarchetypeArtifactId=maven-archetype-quickstart -DarchetypeVersion=1.4
```
Once you have executed this command, you will notice a few things have happened. First, you will notice that a directory named `my-app` has been created for the new project, and this directory contains a file named `pom.xml` that should look like this:
```
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">  <modelVersion>4.0.0</modelVersion>   <groupId>com.mycompany.app</groupId>  <artifactId>my-app</artifactId>  <version>1.0-SNAPSHOT</version>   <name>my-app</name>  <!-- FIXME change it to the project's website -->  <url>http://www.example.com</url>   <properties>    <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>    <maven.compiler.source>1.7</maven.compiler.source>    <maven.compiler.target>1.7</maven.compiler.target>  </properties>   <dependencies>    <dependency>      <groupId>junit</groupId>      <artifactId>junit</artifactId>      <version>4.11</version>      <scope>test</scope>    </dependency>  </dependencies>   <build>    <pluginManagement><!-- lock down plugins versions to avoid using Maven defaults (may be moved to parent pom) -->       ... lots of helpful plugins    </pluginManagement>  </build></project>
```
`pom.xml` contains the Project Object Model (POM) for this project. The POM is the basic unit of work in Maven. This is important to remember because Maven is inherently project-centric in that everything revolves around the notion of a project. In short, the POM contains every important piece of information about your project and is essentially one-stop-shopping for finding anything related to your project. Understanding the POM is important and new users are encouraged to refer to the [Introduction to the POM](https://maven.apache.org/guides/introduction/introduction-to-the-pom.html).
This is a very simple POM but still displays the key elements every POM contains, so let's walk through each of them to familiarize you with the POM essentials:
-   **project** This is the top-level element in all Maven pom.xml files.
-   **modelVersion** This element indicates what version of the object model this POM is using. The version of the model itself changes very infrequently but it is mandatory in order to ensure stability of use if and when the Maven developers deem it necessary to change the model.
-   **groupId** This element indicates the unique identifier of the organization or group that created the project. The groupId is one of the key identifiers of a project and is typically based on the fully qualified domain name of your organization. For example `org.apache.maven.plugins` is the designated groupId for all Maven plugins.
-   **artifactId** This element indicates the unique base name of the primary artifact being generated by this project. The primary artifact for a project is typically a JAR file. Secondary artifacts like source bundles also use the artifactId as part of their final name. A typical artifact produced by Maven would have the form `<artifactId>-<version>.<extension>` (for example, `myapp-1.0.jar`).
-   **version** This element indicates the version of the artifact generated by the project. Maven goes a long way to help you with version management and you will often see the `SNAPSHOT` designator in a version, which indicates that a project is in a state of development. We will discuss the use of [snapshots](https://maven.apache.org/guides/getting-started/index.html#What_is_a_SNAPSHOT_version) and how they work further on in this guide.
-   **name** This element indicates the display name used for the project. This is often used in Maven's generated documentation.
-   **url** This element indicates where the project's site can be found. This is often used in Maven's generated documentation.
-   **properties** This element contains value placeholders accessible anywhere within a POM.
-   **dependencies** This element's children list [dependencies](https://maven.apache.org/pom.html#dependencies). The cornerstone of the POM.
-   **build** This element handles things like declaring your project's directory structure and managing plugins.
For a complete reference of what elements are available for use in the POM please refer to our [POM Reference](https://maven.apache.org/ref/current/maven-model/maven.html). Now let's get back to the project at hand.
After the archetype generation of your first project you will also notice that the following directory structure has been created:
```
my-app
|-- pom.xml
-- src
    |-- main
    |   `-- java
    |       `-- com
    |           `-- mycompany
    |               `-- app
    |                   `-- App.java
    -- test
        -- java
            -- com
                -- mycompany
                    -- app
                        -- AppTest.java
```
As you can see, the project created from the archetype has a POM, a source tree for your application's sources and a source tree for your test sources. This is the standard layout for Maven projects (the application sources reside in `${basedir}/src/main/java` and test sources reside in `${basedir}/src/test/java`, where ${basedir} represents the directory containing `pom.xml`).
If you were to create a Maven project by hand this is the directory structure that we recommend using. This is a Maven convention and to learn more about it you can read our [Introduction to the Standard Directory Layout](https://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html).
Now that we have a POM, some application sources, and some test sources you are probably asking...
### How do I compile my application sources?
[How do I compile my application sources?](https://maven.apache.org/guides/getting-started/index.html#how-do-i-compile-my-application-sources)
Change to the directory where pom.xml is created by archetype:generate and execute the following command to compile your application sources:
Upon executing this command you should see output like the following:
```
[INFO] Scanning for projects...
[INFO] 
[INFO] ----------------------< com.mycompany.app:my-app >----------------------
[INFO] Building my-app 1.0-SNAPSHOT
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- maven-resources-plugin:3.0.2:resources (default-resources) @ my-app ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] skip non existing resourceDirectory <dir>/my-app/src/main/resources
[INFO] 
[INFO] --- maven-compiler-plugin:3.8.0:compile (default-compile) @ my-app ---
[INFO] Changes detected - recompiling the module!
[INFO] Compiling 1 source file to <dir>/my-app/target/classes
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  0.899 s
[INFO] Finished at: 2020-07-12T11:31:54+01:00
[INFO] ------------------------------------------------------------------------
```
The first time you execute this (or any other) command, Maven will need to download all the plugins and related dependencies it needs to fulfill the command. From a clean installation of Maven, this can take quite a while (in the output above, it took almost 4 minutes). If you execute the command again, Maven will now have what it needs, so it won't need to download anything new and will be able to execute the command much more quickly.
As you can see from the output, the compiled classes were placed in `${basedir}/target/classes`, which is another standard convention employed by Maven. So, if you're a keen observer, you'll notice that by using the standard conventions, the POM above is very small and you haven't had to tell Maven explicitly where any of your sources are or where the output should go. By following the standard Maven conventions, you can get a lot done with very little effort! Just as a casual comparison, let's take a look at what you might have had to do in [Ant](http://ant.apache.org/) to accomplish the same [thing](https://maven.apache.org/ant/build-a1.xml).
Now, this is simply to compile a single tree of application sources and the Ant script shown is pretty much the same size as the POM shown above. But we'll see how much more we can do with just that simple POM!
### How do I compile my test sources and run my unit tests?
[How do I compile my test sources and run my unit tests?](https://maven.apache.org/guides/getting-started/index.html#how-do-i-compile-my-test-sources-and-run-my-unit-tests)
Now you're successfully compiling your application's sources and now you've got some unit tests that you want to compile and execute (because every programmer always writes and executes their unit tests \*nudge nudge wink wink\*).
Execute the following command:
Upon executing this command you should see output like the following:
```
[INFO] Scanning for projects...
[INFO] 
[INFO] ----------------------< com.mycompany.app:my-app >----------------------
[INFO] Building my-app 1.0-SNAPSHOT
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- maven-resources-plugin:3.0.2:resources (default-resources) @ my-app ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] skip non existing resourceDirectory <dir>/my-app/src/main/resources
[INFO] 
[INFO] --- maven-compiler-plugin:3.8.0:compile (default-compile) @ my-app ---
[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] --- maven-resources-plugin:3.0.2:testResources (default-testResources) @ my-app ---
[INFO] Using 'UTF-8' encoding to copy filtered resources.
[INFO] skip non existing resourceDirectory <dir>/my-app/src/test/resources
[INFO] 
[INFO] --- maven-compiler-plugin:3.8.0:testCompile (default-testCompile) @ my-app ---
[INFO] Changes detected - recompiling the module!
[INFO] Compiling 1 source file to <dir>/my-app/target/test-classes
[INFO] 
[INFO] --- maven-surefire-plugin:2.22.1:test (default-test) @ my-app ---
[INFO] 
[INFO] -------------------------------------------------------
[INFO]  T E S T S
[INFO] -------------------------------------------------------
[INFO] Running com.mycompany.app.AppTest
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.025 s - in com.mycompany.app.AppTest
[INFO] 
[INFO] Results:
[INFO] 
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
[INFO] 
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  1.881 s
[INFO] Finished at: 2020-07-12T12:00:33+01:00
[INFO] ------------------------------------------------------------------------
```
Some things to notice about the output:
-   Maven downloads more dependencies this time. These are the dependencies and plugins necessary for executing the tests (it already has the dependencies it needs for compiling and won't download them again).
-   Before compiling and executing the tests Maven compiles the main code (all these classes are up to date because we haven't changed anything since we compiled last).
If you simply want to compile your test sources (but not execute the tests), you can execute the following:
Now that you can compile your application sources, compile your tests, and execute the tests, you'll want to move on to the next logical step so you'll be asking ...
### How do I create a JAR and install it in my local repository?
[How do I create a JAR and install it in my local repository?](https://maven.apache.org/guides/getting-started/index.html#how-do-i-create-a-jar-and-install-it-in-my-local-repository)
Making a JAR file is straight forward enough and can be accomplished by executing the following command:
You can now take a look in the `${basedir}/target` directory and you will see the generated JAR file.
Now you'll want to install the artifact you've generated (the JAR file) in your local repository (`${user.home}/.m2/repository` is the default location). For more information on repositories you can refer to our [Introduction to Repositories](https://maven.apache.org/guides/introduction/introduction-to-repositories.html) but let's move on to installing our artifact! To do so execute the following command:
Upon executing this command you should see the following output:
```
[INFO] Scanning for projects...
[INFO] 
[INFO] ----------------------< com.mycompany.app:my-app >----------------------
[INFO] Building my-app 1.0-SNAPSHOT
[INFO] --------------------------------[ jar ]---------------------------------
[INFO] 
[INFO] --- maven-resources-plugin:3.0.2:resources (default-resources) @ my-app ---
...
[INFO] --- maven-compiler-plugin:3.8.0:compile (default-compile) @ my-app ---
[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] --- maven-resources-plugin:3.0.2:testResources (default-testResources) @ my-app ---
...
[INFO] --- maven-compiler-plugin:3.8.0:testCompile (default-testCompile) @ my-app ---
[INFO] Nothing to compile - all classes are up to date
[INFO] 
[INFO] --- maven-surefire-plugin:2.22.1:test (default-test) @ my-app ---
[INFO] 
[INFO] -------------------------------------------------------
[INFO]  T E S T S
[INFO] -------------------------------------------------------
[INFO] Running com.mycompany.app.AppTest
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0, Time elapsed: 0.025 s - in com.mycompany.app.AppTest
[INFO] 
[INFO] Results:
[INFO] 
[INFO] Tests run: 1, Failures: 0, Errors: 0, Skipped: 0
[INFO] 
[INFO] 
[INFO] --- maven-jar-plugin:3.0.2:jar (default-jar) @ my-app ---
[INFO] Building jar: <dir>/my-app/target/my-app-1.0-SNAPSHOT.jar
[INFO] 
[INFO] --- maven-install-plugin:2.5.2:install (default-install) @ my-app ---
[INFO] Installing <dir>/my-app/target/my-app-1.0-SNAPSHOT.jar to <local-repository>/com/mycompany/app/my-app/1.0-SNAPSHOT/my-app-1.0-SNAPSHOT.jar
[INFO] Installing <dir>/my-app/pom.xml to <local-repository>/com/mycompany/app/my-app/1.0-SNAPSHOT/my-app-1.0-SNAPSHOT.pom
[INFO] ------------------------------------------------------------------------
[INFO] BUILD SUCCESS
[INFO] ------------------------------------------------------------------------
[INFO] Total time:  1.678 s
[INFO] Finished at: 2020-07-12T12:04:45+01:00
[INFO] ------------------------------------------------------------------------
```
Note that the surefire plugin (which executes the test) looks for tests contained in files with a particular naming convention. By default the tests included are:
-   `**/*Test.java`
-   `**/Test*.java`
-   `**/*TestCase.java`
And the default excludes are:
-   `**/Abstract*Test.java`
-   `**/Abstract*TestCase.java`
You have walked through the process for setting up, building, testing, packaging, and installing a typical Maven project. This is likely the vast majority of what projects will be doing with Maven and if you've noticed, everything you've been able to do up to this point has been driven by an 18-line file, namely the project's model or POM. If you look at a typical Ant [build file](https://maven.apache.org/ant/build-a1.xml) that provides the same functionality that we've achieved thus far you'll notice it's already twice the size of the POM and we're just getting started! There is far more functionality available to you from Maven without requiring any additions to our POM as it currently stands. To get any more functionality out of our example Ant build file you must keep making error-prone additions.
So what else can you get for free? There are a great number of Maven plugins that work out of the box with even a simple POM like we have above. We'll mention one here specifically as it is one of the highly prized features of Maven: without any work on your part this POM has enough information to generate a web site for your project! You will most likely want to customize your Maven site but if you're pressed for time all you need to do to provide basic information about your project is execute the following command:
There are plenty of other standalone goals that can be executed as well, for example:
This will remove the `target` directory with all the build data before starting so that it is fresh.
### What is a SNAPSHOT version?
[What is a SNAPSHOT version?](https://maven.apache.org/guides/getting-started/index.html#what-is-a-snapshot-version)
Notice the value of the **version** tag in the `pom.xml` file shown below has the suffix: `-SNAPSHOT`.
```
<project xmlns="http://maven.apache.org/POM/4.0.0"  ...  <groupId>...</groupId>  <artifactId>my-app</artifactId>  ...  <version>1.0-SNAPSHOT</version>  <name>Maven Quick Start Archetype</name>  ...
```
The `SNAPSHOT` value refers to the 'latest' code along a development branch, and provides no guarantee the code is stable or unchanging. Conversely, the code in a 'release' version (any version value without the suffix `SNAPSHOT`) is unchanging.
In other words, a SNAPSHOT version is the 'development' version before the final 'release' version. The SNAPSHOT is "older" than its release.
During the [release](https://maven.apache.org/plugins/maven-release-plugin/) process, a version of **x.y-SNAPSHOT** changes to **x.y**. The release process also increments the development version to **x.(y+1)-SNAPSHOT**. For example, version **1.0-SNAPSHOT** is released as version **1.0**, and the new development version is version **1.1-SNAPSHOT**.
### How do I use plugins?
[How do I use plugins?](https://maven.apache.org/guides/getting-started/index.html#how-do-i-use-plugins)
Whenever you want to customise the build for a Maven project, this is done by adding or reconfiguring plugins.
For this example, we will configure the Java compiler to allow JDK 5.0 sources. This is as simple as adding this to your POM:
```
...<build>  <plugins>    <plugin>      <groupId>org.apache.maven.plugins</groupId>      <artifactId>maven-compiler-plugin</artifactId>      <version>3.3</version>      <configuration>        <source>1.5</source>        <target>1.5</target>      </configuration>    </plugin>  </plugins></build>...
```
You'll notice that all plugins in Maven look much like a dependency - and in some ways they are. This plugin will be automatically downloaded and used - including a specific version if you request it (the default is to use the latest available).
The `configuration` element applies the given parameters to every goal from the compiler plugin. In the above case, the compiler plugin is already used as part of the build process and this just changes the configuration. It is also possible to add new goals to the process, and configure specific goals. For information on this, see the [Introduction to the Build Lifecycle](https://maven.apache.org/guides/introduction/introduction-to-the-lifecycle.html).
To find out what configuration is available for a plugin, you can see the [Plugins List](https://maven.apache.org/plugins/) and navigate to the plugin and goal you are using. For general information about how to configure the available parameters of a plugin, have a look at the [Guide to Configuring Plugins](https://maven.apache.org/guides/mini/guide-configuring-plugins.html).
### How do I add resources to my JAR?
[How do I add resources to my JAR?](https://maven.apache.org/guides/getting-started/index.html#how-do-i-add-resources-to-my-jar)
Another common use case that can be satisfied which requires no changes to the POM that we have above is packaging resources in the JAR file. For this common task, Maven again relies on the [Standard Directory Layout](https://maven.apache.org/guides/introduction/introduction-to-the-standard-directory-layout.html), which means by using standard Maven conventions you can package resources within JARs simply by placing those resources in a standard directory structure.
You see below in our example we have added the directory `${basedir}/src/main/resources` into which we place any resources we wish to package in our JAR. The simple rule employed by Maven is this: any directories or files placed within the `${basedir}/src/main/resources` directory are packaged in your JAR with the exact same structure starting at the base of the JAR.
```
my-app
|-- pom.xml
-- src
    |-- main
    |   |-- java
    |   |   `-- com
    |   |       `-- mycompany
    |   |           `-- app
    |   |               `-- App.java
    |   `-- resources
    |       `-- META-INF
    |           `-- application.properties
    -- test
        -- java
            -- com
                -- mycompany
                    -- app
                        -- AppTest.java
```
So you can see in our example that we have a `META-INF` directory with an `application.properties` file within that directory. If you unpacked the JAR that Maven created for you and took a look at it you would see the following:
```
|-- META-INF
|   |-- MANIFEST.MF
|   |-- application.properties
|   `-- maven
|       `-- com.mycompany.app
|           `-- my-app
|               |-- pom.properties
|               `-- pom.xml
-- com
    -- mycompany
        -- app
            -- App.class
```
As you can see, the contents of `${basedir}/src/main/resources` can be found starting at the base of the JAR and our `application.properties` file is there in the `META-INF` directory. You will also notice some other files there like `META-INF/MANIFEST.MF` as well as a `pom.xml` and `pom.properties` file. These come standard with generation of a JAR in Maven. You can create your own manifest if you choose, but Maven will generate one by default if you don't. (You can also modify the entries in the default manifest. We will touch on this later.) The `pom.xml` and `pom.properties` files are packaged up in the JAR so that each artifact produced by Maven is self-describing and also allows you to utilize the metadata in your own application if the need arises. One simple use might be to retrieve the version of your application. Operating on the POM file would require you to use some Maven utilities but the properties can be utilized using the standard Java API and look like the following:
```
#Generated by Maven
#Tue Oct 04 15:43:21 GMT-05:00 2005
version=1.0-SNAPSHOT
groupId=com.mycompany.app
artifactId=my-app
```
To add resources to the classpath for your unit tests, you follow the same pattern as you do for adding resources to the JAR except the directory you place resources in is ${basedir}/src/test/resources. At this point you would have a project directory structure that would look like the following:
```
my-app
|-- pom.xml
-- src
    |-- main
    |   |-- java
    |   |   `-- com
    |   |       `-- mycompany
    |   |           `-- app
    |   |               `-- App.java
    |   `-- resources
    |       `-- META-INF
    |           |-- application.properties
    -- test
        |-- java
        |   `-- com
        |       `-- mycompany
        |           `-- app
        |               `-- AppTest.java
        -- resources
            -- test.properties
```
In a unit test you could use a simple snippet of code like the following to access the resource required for testing:
```
... // Retrieve resourceInputStream is = getClass().getResourceAsStream( "/test.properties" ); // Do something with the resource ...
```
### How do I filter resource files?
[How do I filter resource files?](https://maven.apache.org/guides/getting-started/index.html#how-do-i-filter-resource-files)
Sometimes a resource file will need to contain a value that can only be supplied at build time. To accomplish this in Maven, put a reference to the property that will contain the value into your resource file using the syntax `${<property name>}`. The property can be one of the values defined in your pom.xml, a value defined in the user's settings.xml, a property defined in an external properties file, or a system property.
To have Maven filter resources when copying, simply set `filtering` to true for the resource directory in your `pom.xml`:
```
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">  <modelVersion>4.0.0</modelVersion>   <groupId>com.mycompany.app</groupId>  <artifactId>my-app</artifactId>  <version>1.0-SNAPSHOT</version>  <packaging>jar</packaging>   <name>Maven Quick Start Archetype</name>  <url>http://maven.apache.org</url>   <dependencies>    <dependency>      <groupId>junit</groupId>      <artifactId>junit</artifactId>      <version>4.11</version>      <scope>test</scope>    </dependency>  </dependencies>   <build>    <resources>      <resource>        <directory>src/main/resources</directory>        <filtering>true</filtering>      </resource>    </resources>  </build></project>
```
You'll notice that we had to add the `build`, `resources`, and `resource` elements which weren't there before. In addition, we had to explicitly state that the resources are located in the src/main/resources directory. All of this information was provided as default values previously, but because the default value for `filtering` is false, we had to add this to our pom.xml in order to override that default value and set `filtering` to true.
To reference a property defined in your pom.xml, the property name uses the names of the XML elements that define the value, with "pom" being allowed as an alias for the project (root) element. So `${project.name}` refers to the name of the project, `${project.version}` refers to the version of the project, `${project.build.finalName}` refers to the final name of the file created when the built project is packaged, etc. Note that some elements of the POM have default values, so don't need to be explicitly defined in your `pom.xml` for the values to be available here. Similarly, values in the user's `settings.xml` can be referenced using property names beginning with "settings" (for example, `${settings.localRepository}` refers to the path of the user's local repository).
To continue our example, let's add a couple of properties to the `application.properties` file (which we put in the `src/main/resources` directory) whose values will be supplied when the resource is filtered:
```
# application.propertiesapplication.name=${project.name}application.version=${project.version}
```
With that in place, you can execute the following command (process-resources is the build lifecycle phase where the resources are copied and filtered):
and the `application.properties` file under `target/classes` (and will eventually go into the jar) looks like this:
```
# application.propertiesapplication.name=Maven Quick Start Archetypeapplication.version=1.0-SNAPSHOT
```
To reference a property defined in an external file, all you need to do is add a reference to this external file in your pom.xml. First, let's create our external properties file and call it `src/main/filters/filter.properties`:
```
# filter.propertiesmy.filter.value=hello!
```
Next, we'll add a reference to this new file in the `pom.xml`:
```
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">  <modelVersion>4.0.0</modelVersion>   <groupId>com.mycompany.app</groupId>  <artifactId>my-app</artifactId>  <version>1.0-SNAPSHOT</version>  <packaging>jar</packaging>   <name>Maven Quick Start Archetype</name>  <url>http://maven.apache.org</url>   <dependencies>    <dependency>      <groupId>junit</groupId>      <artifactId>junit</artifactId>      <version>4.11</version>      <scope>test</scope>    </dependency>  </dependencies>   <build>    <filters>      <filter>src/main/filters/filter.properties</filter>    </filters>    <resources>      <resource>        <directory>src/main/resources</directory>        <filtering>true</filtering>      </resource>    </resources>  </build></project>
```
Then, if we add a reference to this property in the `application.properties` file:
```
# application.propertiesapplication.name=${project.name}application.version=${project.version}message=${my.filter.value}
```
the next execution of the `mvn process-resources` command will put our new property value into `application.properties`. As an alternative to defining the my.filter.value property in an external file, you could also have defined it in the `properties` section of your `pom.xml` and you'd get the same effect (notice I don't need the references to `src/main/filters/filter.properties` either):
```
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">  <modelVersion>4.0.0</modelVersion>   <groupId>com.mycompany.app</groupId>  <artifactId>my-app</artifactId>  <version>1.0-SNAPSHOT</version>  <packaging>jar</packaging>   <name>Maven Quick Start Archetype</name>  <url>http://maven.apache.org</url>   <dependencies>    <dependency>      <groupId>junit</groupId>      <artifactId>junit</artifactId>      <version>4.11</version>      <scope>test</scope>    </dependency>  </dependencies>   <build>    <resources>      <resource>        <directory>src/main/resources</directory>        <filtering>true</filtering>      </resource>    </resources>  </build>   <properties>    <my.filter.value>hello</my.filter.value>  </properties></project>
```
Filtering resources can also get values from system properties; either the system properties built into Java (like `java.version` or `user.home`) or properties defined on the command line using the standard Java -D parameter. To continue the example, let's change our `application.properties` file to look like this:
```
# application.propertiesjava.version=${java.version}command.line.prop=${command.line.prop}
```
Now, when you execute the following command (note the definition of the command.line.prop property on the command line), the `application.properties` file will contain the values from the system properties.
```
mvn process-resources "-Dcommand.line.prop=hello again"
```
### How do I use external dependencies?
[How do I use external dependencies?](https://maven.apache.org/guides/getting-started/index.html#how-do-i-use-external-dependencies)
You've probably already noticed a `dependencies` element in the POM we've been using as an example. You have, in fact, been using an external dependency all this time, but here we'll talk about how this works in a bit more detail. For a more thorough introduction, please refer to our [Introduction to Dependency Mechanism](https://maven.apache.org/guides/introduction/introduction-to-dependency-mechanism.html).
The `dependencies` section of the pom.xml lists all of the external dependencies that our project needs in order to build (whether it needs that dependency at compile time, test time, run time, or whatever). Right now, our project is depending on JUnit only (I took out all of the resource filtering stuff for clarity):
```
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">  <modelVersion>4.0.0</modelVersion>   <groupId>com.mycompany.app</groupId>  <artifactId>my-app</artifactId>  <version>1.0-SNAPSHOT</version>  <packaging>jar</packaging>   <name>Maven Quick Start Archetype</name>  <url>http://maven.apache.org</url>   <dependencies>    <dependency>      <groupId>junit</groupId>      <artifactId>junit</artifactId>      <version>4.11</version>      <scope>test</scope>    </dependency>  </dependencies></project>
```
For each external dependency, you'll need to define at least 4 things: groupId, artifactId, version, and scope. The groupId, artifactId, and version are the same as those given in the `pom.xml` for the project that built that dependency. The scope element indicates how your project uses that dependency, and can be values like `compile`, `test`, and `runtime`. For more information on everything you can specify for a dependency, see the [Project Descriptor Reference](https://maven.apache.org/ref/current/maven-model/maven.html).
For more information about the dependency mechanism as a whole, see [Introduction to Dependency Mechanism](https://maven.apache.org/guides/introduction/introduction-to-dependency-mechanism.html).
With this information about a dependency, Maven will be able to reference the dependency when it builds the project. Where does Maven reference the dependency from? Maven looks in your local repository (`${user.home}/.m2/repository` is the default location) to find all dependencies. In a [previous section](https://maven.apache.org/guides/getting-started/index.html#How_do_I_create_a_JAR_and_install_it_in_my_local_repository), we installed the artifact from our project (my-app-1.0-SNAPSHOT.jar) into the local repository. Once it's installed there, another project can reference that jar as a dependency simply by adding the dependency information to its pom.xml:
```
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">  <groupId>com.mycompany.app</groupId>  <artifactId>my-other-app</artifactId>  ...  <dependencies>    ...    <dependency>      <groupId>com.mycompany.app</groupId>      <artifactId>my-app</artifactId>      <version>1.0-SNAPSHOT</version>      <scope>compile</scope>    </dependency>  </dependencies></project>
```
What about dependencies built somewhere else? How do they get into my local repository? Whenever a project references a dependency that isn't available in the local repository, Maven will download the dependency from a remote repository into the local repository. You probably noticed Maven downloading a lot of things when you built your very first project (these downloads were dependencies for the various plugins used to build the project). By default, the remote repository Maven uses can be found (and browsed) at [https://repo.maven.apache.org/maven2/](https://repo.maven.apache.org/maven2/). You can also set up your own remote repository (maybe a central repository for your company) to use instead of or in addition to the default remote repository. For more information on repositories you can refer to the [Introduction to Repositories](https://maven.apache.org/guides/introduction/introduction-to-repositories.html).
Let's add another dependency to our project. Let's say we've added some logging to the code and need to add log4j as a dependency. First, we need to know what the groupId, artifactId, and version are for log4j. The appropriate directory on Maven Central is called [/maven2/log4j/log4j](https://repo.maven.apache.org/maven2/log4j/log4j/). In that directory is a file called maven-metadata.xml. Here's what the maven-metadata.xml for log4j looks like:
```
<metadata>  <groupId>log4j</groupId>  <artifactId>log4j</artifactId>  <version>1.1.3</version>  <versioning>    <versions>      <version>1.1.3</version>      <version>1.2.4</version>      <version>1.2.5</version>      <version>1.2.6</version>      <version>1.2.7</version>      <version>1.2.8</version>      <version>1.2.11</version>      <version>1.2.9</version>      <version>1.2.12</version>    </versions>  </versioning></metadata>
```
From this file, we can see that the groupId we want is "log4j" and the artifactId is "log4j". We see lots of different version values to choose from; for now, we'll just use the latest version, 1.2.12 (some maven-metadata.xml files may also specify which version is the current release version: see [repository metadata reference](https://maven.apache.org/ref/current/maven-repository-metadata/repository-metadata.html)). Alongside the maven-metadata.xml file, we can see a directory corresponding to each version of the log4j library. Inside each of these, we'll find the actual jar file (e.g. log4j-1.2.12.jar) as well as a pom file (this is the pom.xml for the dependency, indicating any further dependencies it might have and other information) and another maven-metadata.xml file. There's also an md5 file corresponding to each of these, which contains an MD5 hash for these files. You can use this to authenticate the library or to figure out which version of a particular library you may be using already.
Now that we know the information we need, we can add the dependency to our pom.xml:
```
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">  <modelVersion>4.0.0</modelVersion>   <groupId>com.mycompany.app</groupId>  <artifactId>my-app</artifactId>  <version>1.0-SNAPSHOT</version>  <packaging>jar</packaging>   <name>Maven Quick Start Archetype</name>  <url>http://maven.apache.org</url>   <dependencies>    <dependency>      <groupId>junit</groupId>      <artifactId>junit</artifactId>      <version>4.11</version>      <scope>test</scope>    </dependency>    <dependency>      <groupId>log4j</groupId>      <artifactId>log4j</artifactId>      <version>1.2.12</version>      <scope>compile</scope>    </dependency>  </dependencies></project>
```
Now, when we compile the project (`mvn compile`), we'll see Maven download the log4j dependency for us.
### How do I deploy my jar in my remote repository?
[How do I deploy my jar in my remote repository?](https://maven.apache.org/guides/getting-started/index.html#how-do-i-deploy-my-jar-in-my-remote-repository)
For deploying jars to an external repository, you have to configure the repository url in the pom.xml and the authentication information for connectiong to the repository in the settings.xml.
Here is an example using scp and username/password authentication:
```
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">  <modelVersion>4.0.0</modelVersion>   <groupId>com.mycompany.app</groupId>  <artifactId>my-app</artifactId>  <version>1.0-SNAPSHOT</version>  <packaging>jar</packaging>   <name>Maven Quick Start Archetype</name>  <url>http://maven.apache.org</url>   <dependencies>    <dependency>      <groupId>junit</groupId>      <artifactId>junit</artifactId>      <version>4.11</version>      <scope>test</scope>    </dependency>    <dependency>      <groupId>org.apache.codehaus.plexus</groupId>      <artifactId>plexus-utils</artifactId>      <version>1.0.4</version>    </dependency>  </dependencies>   <build>    <filters>      <filter>src/main/filters/filters.properties</filter>    </filters>    <resources>      <resource>        <directory>src/main/resources</directory>        <filtering>true</filtering>      </resource>    </resources>  </build>  <!--   |   |   |   -->  <distributionManagement>    <repository>      <id>mycompany-repository</id>      <name>MyCompany Repository</name>      <url>scp://repository.mycompany.com/repository/maven2</url>    </repository>  </distributionManagement></project>
```
```
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0 https://maven.apache.org/xsd/settings-1.0.0.xsd">  ...  <servers>    <server>      <id>mycompany-repository</id>      <username>jvanzyl</username>      <!-- Default value is ~/.ssh/id_dsa -->      <privateKey>/path/to/identity</privateKey> (default is ~/.ssh/id_dsa)      <passphrase>my_key_passphrase</passphrase>    </server>  </servers>  ...</settings>
```
Note that if you are connecting to an openssh ssh server which has the parameter "PasswordAuthentication" set to "no" in the sshd\_confing, you will have to type your password each time for username/password authentication (although you can log in using another ssh client by typing in the username and password). You might want to switch to public key authentication in this case.
Care should be taken if using passwords in `settings.xml`. For more information, see [Password Encryption](https://maven.apache.org/guides/mini/guide-encryption.html).
### How do I create documentation?
[How do I create documentation?](https://maven.apache.org/guides/getting-started/index.html#how-do-i-create-documentation)
To get you jump started with Maven's documentation system you can use the archetype mechanism to generate a site for your existing project using the following command:
```
mvn archetype:generate \  -DarchetypeGroupId=org.apache.maven.archetypes \  -DarchetypeArtifactId=maven-archetype-site \  -DgroupId=com.mycompany.app \  -DartifactId=my-app-site
```
Now head on over to the [Guide to creating a site](https://maven.apache.org/guides/mini/guide-site.html) to learn how to create the documentation for your project.
### How do I build other types of projects?
[How do I build other types of projects?](https://maven.apache.org/guides/getting-started/index.html#how-do-i-build-other-types-of-projects)
Note that the lifecycle applies to any project type. For example, back in the base directory we can create a simple web application:
```
mvn archetype:generate \    -DarchetypeGroupId=org.apache.maven.archetypes \    -DarchetypeArtifactId=maven-archetype-webapp \    -DgroupId=com.mycompany.app \    -DartifactId=my-webapp
```
Note that these must all be on a single line. This will create a directory called `my-webapp` containing the following project descriptor:
```
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">  <modelVersion>4.0.0</modelVersion>   <groupId>com.mycompany.app</groupId>  <artifactId>my-webapp</artifactId>  <version>1.0-SNAPSHOT</version>  <packaging>war</packaging>   <dependencies>    <dependency>      <groupId>junit</groupId>      <artifactId>junit</artifactId>      <version>4.11</version>      <scope>test</scope>    </dependency>  </dependencies>   <build>    <finalName>my-webapp</finalName>  </build></project>
```
Note the `<packaging>` element - this tells Maven to build as a WAR. Change into the webapp project's directory and try:
You'll see `target/my-webapp.war` is built, and that all the normal steps were executed.
### How do I build more than one project at once?
[How do I build more than one project at once?](https://maven.apache.org/guides/getting-started/index.html#how-do-i-build-more-than-one-project-at-once)
The concept of dealing with multiple modules is built in to Maven. In this section, we will show how to build the WAR above, and include the previous JAR as well in one step.
Firstly, we need to add a parent `pom.xml` file in the directory above the other two, so it should look like this:
```
+- pom.xml
+- my-app
| +- pom.xml
| +- src
|   +- main
|     +- java
+- my-webapp
| +- pom.xml
| +- src
|   +- main
|     +- webapp
```
The POM file you'll create should contain the following:
```
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">  <modelVersion>4.0.0</modelVersion>   <groupId>com.mycompany.app</groupId>  <artifactId>app</artifactId>  <version>1.0-SNAPSHOT</version>  <packaging>pom</packaging>   <modules>    <module>my-app</module>    <module>my-webapp</module>  </modules></project>
```
We'll need a dependency on the JAR from the webapp, so add this to `my-webapp/pom.xml`:
```
  ...  <dependencies>    <dependency>      <groupId>com.mycompany.app</groupId>      <artifactId>my-app</artifactId>      <version>1.0-SNAPSHOT</version>    </dependency>    ...  </dependencies>
```
Finally, add the following `<parent>` element to both of the other `pom.xml` files in the subdirectories:
```
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 https://maven.apache.org/xsd/maven-4.0.0.xsd">  <parent>    <groupId>com.mycompany.app</groupId>    <artifactId>app</artifactId>    <version>1.0-SNAPSHOT</version>  </parent>  ...
```
Now, try it... from the top level directory, run:
The WAR has now been created in `my-webapp/target/my-webapp.war`, and the JAR is included:
```
$ jar tvf my-webapp/target/my-webapp-1.0-SNAPSHOT.war
   0 Fri Jun 24 10:59:56 EST 2005 META-INF/
 222 Fri Jun 24 10:59:54 EST 2005 META-INF/MANIFEST.MF
   0 Fri Jun 24 10:59:56 EST 2005 META-INF/maven/
   0 Fri Jun 24 10:59:56 EST 2005 META-INF/maven/com.mycompany.app/
   0 Fri Jun 24 10:59:56 EST 2005 META-INF/maven/com.mycompany.app/my-webapp/
3239 Fri Jun 24 10:59:56 EST 2005 META-INF/maven/com.mycompany.app/my-webapp/pom.xml
   0 Fri Jun 24 10:59:56 EST 2005 WEB-INF/
 215 Fri Jun 24 10:59:56 EST 2005 WEB-INF/web.xml
 123 Fri Jun 24 10:59:56 EST 2005 META-INF/maven/com.mycompany.app/my-webapp/pom.properties
  52 Fri Jun 24 10:59:56 EST 2005 index.jsp
   0 Fri Jun 24 10:59:56 EST 2005 WEB-INF/lib/
2713 Fri Jun 24 10:59:56 EST 2005 WEB-INF/lib/my-app-1.0-SNAPSHOT.jar
```
How does this work? Firstly, the parent POM created (called `app`), has a packaging of `pom` and a list of modules defined. This tells Maven to run all operations over the set of projects instead of just the current one (to override this behaviour, you can use the `--non-recursive` command line option).
Next, we tell the WAR that it requires the `my-app` JAR. This does a few things: it makes it available on the classpath to any code in the WAR (none in this case), it makes sure the JAR is always built before the WAR, and it indicates to the WAR plugin to include the JAR in its library directory.
You may have noticed that `junit-4.11.jar` was a dependency, but didn't end up in the WAR. The reason for this is the `<scope>test</scope>` element - it is only required for testing, and so is not included in the web application as the compile time dependency `my-app` is.

The final step was to include a parent definition. This ensures that the POM can always be located even if the project is distributed separately from its parent by looking it up in the repository.

---
# 依赖传递, 排除依赖和可选依赖
[Maven依赖传递,排除依赖和可选依赖 - Chen洋 - 博客园](https://www.cnblogs.com/cy0628/p/15034450.html)
> ## Excerpt
> Maven 依赖传递是 Maven 的核心机制之一，它能够一定程度上简化 Maven 的依赖配置。本节我们将详细介绍依赖传递及其相关概念。
## 依赖传递
如下图所示，项目 A 依赖于项目 B，B 又依赖于项目 C，此时 B 是 A 的直接依赖，C 是 A 的间接依赖。  
![](2174081-20210720132653362-1731135572.png)
Maven 的依赖传递机制是指：不管 Maven 项目存在多少间接依赖，POM 中都只需要定义其直接依赖，不必定义任何间接依赖，Maven 会动读取当前项目各个直接依赖的 POM，将那些必要的间接依赖以传递性依赖的形式引入到当前项目中。Maven 的依赖传递机制能够帮助用户一定程度上简化 POM 的配置。
基于 A、B、C  三者的依赖关系，根据 Maven 的依赖传递机制，我们只需要在项目 A 的 POM 中定义其直接依赖 B，在项目 B 的 POM 中定义其直接依赖 C，Maven 会解析 A 的直接依赖 B的 POM ，将间接依赖 C 以传递性依赖的形式引入到项目 A 中。
通过这种依赖传递关系，可以使依赖关系树迅速增长到一个很大的量级，很有可能会出现依赖重复，依赖冲突等情况，Maven 针对这些情况提供了如下功能进行处理。
-   依赖范围（Dependency scope）
-   依赖调解（Dependency mediation）
-   可选依赖（Optional dependencies）
-   排除依赖（Excluded dependencies）
-   依赖管理（Dependency management）
## 依赖范围
首先，我们要知道 Maven 在对项目进行编译、测试和运行时，会分别使用三套不同的 classpath。Maven 项目构建时，在不同阶段引入到 classpath 中的依赖时不同的。例如编译时，Maven 会将与编译相关的依赖引入到编译 classpath 中；测试时，Maven 会将与测试相关的的依赖引入到测试 classpath 中；运行时，Maven 会将与运行相关的依赖引入到运行 classpath 中。
我们可以在 POM 的依赖声明使用 scope 元素来控制依赖与三种 classpath（编译 classpath、测试 classpath、运行 classpath ）之间的关系，这就是依赖范围。
Maven 具有以下 6 中常见的依赖范围，如下表所示。
| 依赖范围 | 描述 |
| --- | --- |
| compile | 编译依赖范围，scope 元素的缺省值。使用此依赖范围的 Maven 依赖，对于三种 classpath 均有效，即该 Maven 依赖在上述三种 classpath 均会被引入。例如，log4j 在编译、测试、运行过程都是必须的。 |
| test | 测试依赖范围。使用此依赖范围的 Maven 依赖，只对测试 classpath 有效。例如，Junit 依赖只有在测试阶段才需要。 |
| provided  | 已提供依赖范围。使用此依赖范围的 Maven 依赖，只对编译 classpath 和测试 classpath 有效。例如，servlet-api 依赖对于编译、测试阶段而言是需要的，但是运行阶段，由于外部容器已经提供，故不需要 Maven 重复引入该依赖。 |
| runtime  | 运行时依赖范围。使用此依赖范围的 Maven 依赖，只对测试 classpath、运行 classpath 有效。例如，JDBC 驱动实现依赖，其在编译时只需 JDK 提供的 JDBC 接口即可，只有测试、运行阶段才需要实现了 JDBC 接口的驱动。 |
| system | 系统依赖范围，其效果与 provided 的依赖范围一致。其用于添加非 Maven 仓库的本地依赖，通过依赖元素 dependency 中的 systemPath 元素指定本地依赖的路径。鉴于使用其会导致项目的可移植性降低，一般不推荐使用。 |
| import | 导入依赖范围，该依赖范围只能与 dependencyManagement 元素配合使用，其功能是将目标 pom.xml 文件中 dependencyManagement 的配置导入合并到当前 pom.xml 的 dependencyManagement 中。 |
依赖范围与三种 classpath 的关系一览表，如下所示。
| 依赖范围 | 编译 classpath | 测试 classpath | 运行 classpath | 例子 |
| --- | --- | --- | --- | --- |
| compile | √ | √ | √ | log4j |
| test | \- | √ | \- | junit |
| provided | √ | √ | \- | servlet-api |
| runtime | \- | \- | √ | JDBC-driver |
| system | √ | √ | \- | 非 Maven 仓库的本地依赖 |
## 依赖范围对传递依赖的影响
项目 A 依赖于项目 B，B 又依赖于项目 C，此时我们可以将 A 对于 B 的依赖称之为第一直接依赖，B 对于 C 的依赖称之为第二直接依赖。
B 是 A 的直接依赖，C 是 A 的间接依赖，根据 Maven 的依赖传递机制，间接依赖 C 会以传递性依赖的形式引入到 A 中，但这种引入并不是无条件的，它会受到依赖范围的影响。
传递性依赖的依赖范围受第一直接依赖和第二直接依赖的范围影响，如下表所示。
|   | compile | test | provided | runtime |
| --- | --- | --- | --- | --- |
| compile | compile | \- | \- | runtime |
| test | test | \- | \- | test |
| provided | provided | \- | provided | provided |
| runtime | runtime | \- | \- | runtime |
注：上表中，左边第一列表示第一直接依赖的依赖范围，上边第一行表示第二直接依赖的依赖范围。交叉部分的单元格的取值为传递性依赖的依赖范围，若交叉单元格取值为“-”，则表示该传递性依赖不能被传递。
通过上表，可以总结出以下规律(\*)：
-   当第二直接依赖的范围是 compile 时，传递性依赖的范围与第一直接依赖的范围一致；
-   当第二直接依赖的范围是 test 时，传递性依赖不会被传递；
-   当第二直接依赖的范围是 provided 时，只传递第一直接依赖的范围也为 provided 的依赖，且传递性依赖的范围也为 provided；
-   当第二直接依赖的范围是 runtime 时，传递性依赖的范围与第一直接依赖的范围一致，但 compile 例外，此时传递性依赖的范围为 runtime。
## 依赖调节
Maven 的依赖传递机制可以简化依赖的声明，用户只需要关心项目的直接依赖，而不必关心这些直接依赖会引入哪些间接依赖。但当一个间接依赖存在多条引入路径时，为了避免出现依赖重复的问题，Maven 通过依赖调节来确定间接依赖的引入路径。
依赖调节遵循以下两条原则：
1.  引入路径短者优先
2.  先声明者优先
  
以上两条原则，优先使用第一条原则解决，第一条原则无法解决，再使用第二条原则解决。
#### 引入路径短者优先
引入路径短者优先，顾名思义，当一个间接依赖存在多条引入路径时，引入路径短的会被解析使用。
例如，A 存在这样的依赖关系：  
A->B->C->D(1.0)  
A->X->D(2.0)
D 是 A 的间接依赖，但两条引入路径上有两个不同的版本，很显然不能同时引入，否则造成重复依赖的问题。根据 Maven 依赖调节的第一个原则：引入路径短者优先，D（1.0）的路径长度为 3，D（2.0）的路径长度为 2，因此间接依赖 D（2.0）将从 A->X->D(2.0) 路径引入到 A 中。
#### 先声明者优先
先声明者优先，顾名思义，在引入路径长度相同的前提下，POM 文件中依赖声明的顺序决定了间接依赖会不会被解析使用，顺序靠前的优先使用。
例如，A 存在以下依赖关系：  
A->B->D(1.0)  
A->X->D(2.0)
D 是 A 的间接依赖，其两条引入路径的长度都是 2，此时 Maven 依赖调节的第一原则已经无法解决，需要使用第二原则：先声明者优先。
A 的 POM 文件中配置如下。

```
<dependencies>
    ...      
    <dependency>
        ...
        <artifactId>B</artifactId>       
        ...
    </dependency>
    ...
    <dependency>
        ...
        <artifactId>X</artifactId>
        ...
    </dependency>
    ...
</dependencies>
```

有以上配置可以看出，由于 B 的依赖声明比 X 靠前，所以间接依赖 D（1.0）将从 A->B->D(1.0) 路径引入到 A 中。
## Maven 排除依赖和可选依赖
我们知道 Maven 依赖具有传递性，例如 A 依赖于 B，B 依赖于 C，在不考虑依赖范围等因素的情况下，Maven 会根据依赖传递机制，将间接依赖 C 引入到 A 中。但如果 A 出于某种原因，希望将间接依赖 C 排除，那该怎么办呢？Maven 为用户提供了两种解决方式：排除依赖（Dependency Exclusions）和可选依赖（Optional Dependencies）。
## 排除依赖
假设存在这样的依赖关系，A 依赖于 B，B 依赖于 X，B 又依赖于 Y。B 实现了两个特性，其中一个特性依赖于 X，另一个特性依赖于 Y，且两个特性是互斥的关系，用户无法同时使用两个特性，所以 A 需要排除 X，此时就可以在 A 中将间接依赖 X 排除。
排除依赖是通过在 A 中使用 exclusions 元素实现的，该元素下可以包含若干个 exclusion 子元素，用于排除若干个间接依赖，示例代码如下。

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>net.biancheng.www</groupId>
    <artifactId>A</artifactId>
    <version>1.0-SNAPSHOT</version>
    <dependencies>
        <dependency>
            <groupId>net.biancheng.www</groupId>
            <artifactId>B</artifactId>
            <version>1.0-SNAPSHOT</version>
            <exclusions>
                <!-- 设置排除 -->
                <!-- 排除依赖必须基于直接依赖中的间接依赖设置为可以依赖为 false-->
                <!-- 设置当前依赖中是否使用间接依赖 -->
                <exclusion>
                    <!--设置具体排除-->
                    <groupId>net.biancheng.www</groupId>
                    <artifactId>X</artifactId>
                </exclusion>
            </exclusions>
        </dependency>
    </dependencies>
</project>
```

关于 exclusions 元素及排除依赖说明如下：
-   排除依赖是控制当前项目是否使用其直接依赖传递下来的间接依赖；
-   exclusions 元素下可以包含若干个 exclusion 子元素，用于排除若干个间接依赖；
-   exclusion 元素用来设置具体排除的间接依赖，该元素包含两个子元素：groupId 和 artifactId，用来确定需要排除的间接依赖的坐标信息；
-   exclusion 元素中只需要设置 groupId 和 artifactId 就可以确定需要排除的依赖，无需指定版本 version。
## 可选依赖
与上文的应用场景相同，也是 A 希望排除间接依赖 X，除了在 B 中设置可选依赖外，我们还可以在 B 中将 X 设置为可选依赖。
#### 设置可选依赖
在 B 的 POM 关于 X 的依赖声明中使用 optional 元素，将其设置成可选依赖，示例配置如下。

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/maven-v4_0_0.xsd">
    <modelVersion>4.0.0</modelVersion>
    <groupId>net.biancheng.www</groupId>
    <artifactId>B</artifactId>
    <packaging>jar</packaging>
    <version>1.0-SNAPSHOT</version>
    <dependencies>
        <dependency>
            <groupId>net.biancheng.www</groupId>
            <artifactId>X</artifactId>
            <version>1.0-SNAPSHOT</version>
            <!--设置可选依赖  -->
            <optional>true</optional>
        </dependency>
    </dependencies>
</project>
```

关于 optional 元素及可选依赖说明如下：
-   可选依赖用来控制当前依赖是否向下传递成为间接依赖；
-   optional 默认值为 false，表示可以向下传递称为间接依赖；
-   若 optional 元素取值为 true，则表示当前依赖不能向下传递成为间接依赖。
## 排除依赖 VS 可选依赖 
排除依赖和可选依赖都能在项目中将间接依赖排除在外，但两者实现机制却完全不一样。
-   排除依赖是控制当前项目是否使用其直接依赖传递下来的接间依赖；
-   可选依赖是控制当前项目的依赖是否向下传递；
-   可选依赖的优先级高于排除依赖；
-   若对于同一个间接依赖同时使用排除依赖和可选依赖进行设置，那么可选依赖的取值必须为 false，否则排除依赖无法生效。
# HowTo
## 使用 maven 管理项目 版本
[(171条消息) Maven学习之批量修改项目版本号_Charles Yan的博客-CSDN博客_maven 批量修改版本号](https://blog.csdn.net/weixin_42586723/article/details/123109804)
## SpringBoot 配置项目打包
[(171条消息) Spring Boot Maven Plugin插件解析_此人太懒的博客-CSDN博客_springbootmavenplugin配置](https://blog.csdn.net/dahaiaixiaohai/article/details/118785186)
[(171条消息) maven 自动部署 自动打包上传重启系统应用_Dachao_lpc的博客-CSDN博客_maven 自动打包上传](https://blog.csdn.net/qq_15285457/article/details/114079525)
[(171条消息) maven构建使用自定义参数_捣师的博客-CSDN博客_maven定义参数](https://blog.csdn.net/julywind1/article/details/88574824)
[(171条消息) mvn(Maven）命令行参数含义_kingmax54212008的博客-CSDN博客_mvn 参数](https://blog.csdn.net/kingmax54212008/article/details/103458624)
## Maven 打包引用当天日期时间
maven自动获取的 UTC 时间戳：
[Maven打包时自动增加时间戳 - 腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/1613443)
build helper maven plugin 的自定义时间戳
[java - How to have Maven show local timezone in maven.build.timestamp? - Stack Overflow](https://stackoverflow.com/questions/28281988/how-to-have-maven-show-local-timezone-in-maven-build-timestamp)

# Password Encryption
[Maven – Password Encryption](https://maven.apache.org/guides/mini/guide-encryption.html)
# Maven Wrapper
[Apache Maven Wrapper – Maven Wrapper](https://maven.apache.org/wrapper/)
[使用mvnw - 廖雪峰的官方网站](https://www.liaoxuefeng.com/wiki/1252599548343744/1305148057976866)
