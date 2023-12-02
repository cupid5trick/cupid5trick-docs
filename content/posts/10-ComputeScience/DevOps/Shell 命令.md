---
scope: learn
draft: true
---
# Linux 常用命令
[鸟哥的 Linux 私房菜 -- 程序管理与 SELinux 初探](http://cn.linux.vbird.org/linux_basic/0440processcontrol_3.php)
-   [1 Introduction](https://www.gnu.org/software/bash/manual/html_node/Introduction.html#Introduction)
    -   [1.1 What is Bash?](https://www.gnu.org/software/bash/manual/html_node/What-is-Bash_003f.html#What-is-Bash_003f)
    -   [1.2 What is a shell?](https://www.gnu.org/software/bash/manual/html_node/What-is-a-shell_003f.html#What-is-a-shell_003f)
-   [2 Definitions](https://www.gnu.org/software/bash/manual/html_node/Definitions.html#Definitions)
-   [3 Basic Shell Features](https://www.gnu.org/software/bash/manual/html_node/Basic-Shell-Features.html#Basic-Shell-Features)
    -   [3.1 Shell Syntax](https://www.gnu.org/software/bash/manual/html_node/Shell-Syntax.html#Shell-Syntax)
        -   [3.1.1 Shell Operation](https://www.gnu.org/software/bash/manual/html_node/Shell-Operation.html#Shell-Operation)
        -   [3.1.2 Quoting](https://www.gnu.org/software/bash/manual/html_node/Quoting.html#Quoting)
            -   [3.1.2.1 Escape Character](https://www.gnu.org/software/bash/manual/html_node/Escape-Character.html#Escape-Character)
            -   [3.1.2.2 Single Quotes](https://www.gnu.org/software/bash/manual/html_node/Single-Quotes.html#Single-Quotes)
            -   [3.1.2.3 Double Quotes](https://www.gnu.org/software/bash/manual/html_node/Double-Quotes.html#Double-Quotes)
            -   [3.1.2.4 ANSI-C Quoting](https://www.gnu.org/software/bash/manual/html_node/ANSI_002dC-Quoting.html#ANSI_002dC-Quoting)
            -   [3.1.2.5 Locale-Specific Translation](https://www.gnu.org/software/bash/manual/html_node/Locale-Translation.html#Locale-Translation)
        -   [3.1.3 Comments](https://www.gnu.org/software/bash/manual/html_node/Comments.html#Comments)
    -   [3.2 Shell Commands](https://www.gnu.org/software/bash/manual/html_node/Shell-Commands.html#Shell-Commands)
        -   [3.2.1 Reserved Words](https://www.gnu.org/software/bash/manual/html_node/Reserved-Words.html#Reserved-Words)
        -   [3.2.2 Simple Commands](https://www.gnu.org/software/bash/manual/html_node/Simple-Commands.html#Simple-Commands)
        -   [3.2.3 Pipelines](https://www.gnu.org/software/bash/manual/html_node/Pipelines.html#Pipelines)
        -   [3.2.4 Lists of Commands](https://www.gnu.org/software/bash/manual/html_node/Lists.html#Lists)
        -   [3.2.5 Compound Commands](https://www.gnu.org/software/bash/manual/html_node/Compound-Commands.html#Compound-Commands)
            -   [3.2.5.1 Looping Constructs](https://www.gnu.org/software/bash/manual/html_node/Looping-Constructs.html#Looping-Constructs)
            -   [3.2.5.2 Conditional Constructs](https://www.gnu.org/software/bash/manual/html_node/Conditional-Constructs.html#Conditional-Constructs)
            -   [3.2.5.3 Grouping Commands](https://www.gnu.org/software/bash/manual/html_node/Command-Grouping.html#Command-Grouping)
        -   [3.2.6 Coprocesses](https://www.gnu.org/software/bash/manual/html_node/Coprocesses.html#Coprocesses)
        -   [3.2.7 GNU Parallel](https://www.gnu.org/software/bash/manual/html_node/GNU-Parallel.html#GNU-Parallel)
    -   [3.3 Shell Functions](https://www.gnu.org/software/bash/manual/html_node/Shell-Functions.html#Shell-Functions)
    -   [3.4 Shell Parameters](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameters.html#Shell-Parameters)
        -   [3.4.1 Positional Parameters](https://www.gnu.org/software/bash/manual/html_node/Positional-Parameters.html#Positional-Parameters)
        -   [3.4.2 Special Parameters](https://www.gnu.org/software/bash/manual/html_node/Special-Parameters.html#Special-Parameters)
    -   [3.5 Shell Expansions](https://www.gnu.org/software/bash/manual/html_node/Shell-Expansions.html#Shell-Expansions)
        -   [3.5.1 Brace Expansion](https://www.gnu.org/software/bash/manual/html_node/Brace-Expansion.html#Brace-Expansion)
        -   [3.5.2 Tilde Expansion](https://www.gnu.org/software/bash/manual/html_node/Tilde-Expansion.html#Tilde-Expansion)
        -   [3.5.3 Shell Parameter Expansion](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html#Shell-Parameter-Expansion)
        -   [3.5.4 Command Substitution](https://www.gnu.org/software/bash/manual/html_node/Command-Substitution.html#Command-Substitution)
        -   [3.5.5 Arithmetic Expansion](https://www.gnu.org/software/bash/manual/html_node/Arithmetic-Expansion.html#Arithmetic-Expansion)
        -   [3.5.6 Process Substitution](https://www.gnu.org/software/bash/manual/html_node/Process-Substitution.html#Process-Substitution)
        -   [3.5.7 Word Splitting](https://www.gnu.org/software/bash/manual/html_node/Word-Splitting.html#Word-Splitting)
        -   [3.5.8 Filename Expansion](https://www.gnu.org/software/bash/manual/html_node/Filename-Expansion.html#Filename-Expansion)
            -   [3.5.8.1 Pattern Matching](https://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html#Pattern-Matching)
        -   [3.5.9 Quote Removal](https://www.gnu.org/software/bash/manual/html_node/Quote-Removal.html#Quote-Removal)
    -   [3.6 Redirections](https://www.gnu.org/software/bash/manual/html_node/Redirections.html#Redirections)
        -   [3.6.1 Redirecting Input](https://www.gnu.org/software/bash/manual/html_node/Redirections.html#Redirecting-Input)
        -   [3.6.2 Redirecting Output](https://www.gnu.org/software/bash/manual/html_node/Redirections.html#Redirecting-Output)
        -   [3.6.3 Appending Redirected Output](https://www.gnu.org/software/bash/manual/html_node/Redirections.html#Appending-Redirected-Output)
        -   [3.6.4 Redirecting Standard Output and Standard Error](https://www.gnu.org/software/bash/manual/html_node/Redirections.html#Redirecting-Standard-Output-and-Standard-Error)
        -   [3.6.5 Appending Standard Output and Standard Error](https://www.gnu.org/software/bash/manual/html_node/Redirections.html#Appending-Standard-Output-and-Standard-Error)
        -   [3.6.6 Here Documents](https://www.gnu.org/software/bash/manual/html_node/Redirections.html#Here-Documents)
        -   [3.6.7 Here Strings](https://www.gnu.org/software/bash/manual/html_node/Redirections.html#Here-Strings)
        -   [3.6.8 Duplicating File Descriptors](https://www.gnu.org/software/bash/manual/html_node/Redirections.html#Duplicating-File-Descriptors)
        -   [3.6.9 Moving File Descriptors](https://www.gnu.org/software/bash/manual/html_node/Redirections.html#Moving-File-Descriptors)
        -   [3.6.10 Opening File Descriptors for Reading and Writing](https://www.gnu.org/software/bash/manual/html_node/Redirections.html#Opening-File-Descriptors-for-Reading-and-Writing)
    -   [3.7 Executing Commands](https://www.gnu.org/software/bash/manual/html_node/Executing-Commands.html#Executing-Commands)
        -   [3.7.1 Simple Command Expansion](https://www.gnu.org/software/bash/manual/html_node/Simple-Command-Expansion.html#Simple-Command-Expansion)
        -   [3.7.2 Command Search and Execution](https://www.gnu.org/software/bash/manual/html_node/Command-Search-and-Execution.html#Command-Search-and-Execution)
        -   [3.7.3 Command Execution Environment](https://www.gnu.org/software/bash/manual/html_node/Command-Execution-Environment.html#Command-Execution-Environment)
        -   [3.7.4 Environment](https://www.gnu.org/software/bash/manual/html_node/Environment.html#Environment)
        -   [3.7.5 Exit Status](https://www.gnu.org/software/bash/manual/html_node/Exit-Status.html#Exit-Status)
        -   [3.7.6 Signals](https://www.gnu.org/software/bash/manual/html_node/Signals.html#Signals)
    -   [3.8 Shell Scripts](https://www.gnu.org/software/bash/manual/html_node/Shell-Scripts.html#Shell-Scripts)
-   [4 Shell Builtin Commands](https://www.gnu.org/software/bash/manual/html_node/Shell-Builtin-Commands.html#Shell-Builtin-Commands)
    -   [4.1 Bourne Shell Builtins](https://www.gnu.org/software/bash/manual/html_node/Bourne-Shell-Builtins.html#Bourne-Shell-Builtins)
    -   [4.2 Bash Builtin Commands](https://www.gnu.org/software/bash/manual/html_node/Bash-Builtins.html#Bash-Builtins)
    -   [4.3 Modifying Shell Behavior](https://www.gnu.org/software/bash/manual/html_node/Modifying-Shell-Behavior.html#Modifying-Shell-Behavior)
        -   [4.3.1 The Set Builtin](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html#The-Set-Builtin)
        -   [4.3.2 The Shopt Builtin](https://www.gnu.org/software/bash/manual/html_node/The-Shopt-Builtin.html#The-Shopt-Builtin)
    -   [4.4 Special Builtins](https://www.gnu.org/software/bash/manual/html_node/Special-Builtins.html#Special-Builtins)
-   [5 Shell Variables](https://www.gnu.org/software/bash/manual/html_node/Shell-Variables.html#Shell-Variables)
    -   [5.1 Bourne Shell Variables](https://www.gnu.org/software/bash/manual/html_node/Bourne-Shell-Variables.html#Bourne-Shell-Variables)
    -   [5.2 Bash Variables](https://www.gnu.org/software/bash/manual/html_node/Bash-Variables.html#Bash-Variables)
-   [6 Bash Features](https://www.gnu.org/software/bash/manual/html_node/Bash-Features.html#Bash-Features)
    -   [6.1 Invoking Bash](https://www.gnu.org/software/bash/manual/html_node/Invoking-Bash.html#Invoking-Bash)
    -   [6.2 Bash Startup Files](https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html#Bash-Startup-Files)
    -   [6.3 Interactive Shells](https://www.gnu.org/software/bash/manual/html_node/Interactive-Shells.html#Interactive-Shells)
        -   [6.3.1 What is an Interactive Shell?](https://www.gnu.org/software/bash/manual/html_node/What-is-an-Interactive-Shell_003f.html#What-is-an-Interactive-Shell_003f)
        -   [6.3.2 Is this Shell Interactive?](https://www.gnu.org/software/bash/manual/html_node/Is-this-Shell-Interactive_003f.html#Is-this-Shell-Interactive_003f)
        -   [6.3.3 Interactive Shell Behavior](https://www.gnu.org/software/bash/manual/html_node/Interactive-Shell-Behavior.html#Interactive-Shell-Behavior)
    -   [6.4 Bash Conditional Expressions](https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html#Bash-Conditional-Expressions)
    -   [6.5 Shell Arithmetic](https://www.gnu.org/software/bash/manual/html_node/Shell-Arithmetic.html#Shell-Arithmetic)
    -   [6.6 Aliases](https://www.gnu.org/software/bash/manual/html_node/Aliases.html#Aliases)
    -   [6.7 Arrays](https://www.gnu.org/software/bash/manual/html_node/Arrays.html#Arrays)
    -   [6.8 The Directory Stack](https://www.gnu.org/software/bash/manual/html_node/The-Directory-Stack.html#The-Directory-Stack)
        -   [6.8.1 Directory Stack Builtins](https://www.gnu.org/software/bash/manual/html_node/Directory-Stack-Builtins.html#Directory-Stack-Builtins)
    -   [6.9 Controlling the Prompt](https://www.gnu.org/software/bash/manual/html_node/Controlling-the-Prompt.html#Controlling-the-Prompt)
    -   [6.10 The Restricted Shell](https://www.gnu.org/software/bash/manual/html_node/The-Restricted-Shell.html#The-Restricted-Shell)
    -   [6.11 Bash POSIX Mode](https://www.gnu.org/software/bash/manual/html_node/Bash-POSIX-Mode.html#Bash-POSIX-Mode)
    -   [6.12 Shell Compatibility Mode](https://www.gnu.org/software/bash/manual/html_node/Shell-Compatibility-Mode.html#Shell-Compatibility-Mode)
-   [7 Job Control](https://www.gnu.org/software/bash/manual/html_node/Job-Control.html#Job-Control)
    -   [7.1 Job Control Basics](https://www.gnu.org/software/bash/manual/html_node/Job-Control-Basics.html#Job-Control-Basics)
    -   [7.2 Job Control Builtins](https://www.gnu.org/software/bash/manual/html_node/Job-Control-Builtins.html#Job-Control-Builtins)
    -   [7.3 Job Control Variables](https://www.gnu.org/software/bash/manual/html_node/Job-Control-Variables.html#Job-Control-Variables)
-   [8 Command Line Editing](https://www.gnu.org/software/bash/manual/html_node/Command-Line-Editing.html#Command-Line-Editing)
    -   [8.1 Introduction to Line Editing](https://www.gnu.org/software/bash/manual/html_node/Introduction-and-Notation.html#Introduction-and-Notation)
    -   [8.2 Readline Interaction](https://www.gnu.org/software/bash/manual/html_node/Readline-Interaction.html#Readline-Interaction)
        -   [8.2.1 Readline Bare Essentials](https://www.gnu.org/software/bash/manual/html_node/Readline-Bare-Essentials.html#Readline-Bare-Essentials)
        -   [8.2.2 Readline Movement Commands](https://www.gnu.org/software/bash/manual/html_node/Readline-Movement-Commands.html#Readline-Movement-Commands)
        -   [8.2.3 Readline Killing Commands](https://www.gnu.org/software/bash/manual/html_node/Readline-Killing-Commands.html#Readline-Killing-Commands)
        -   [8.2.4 Readline Arguments](https://www.gnu.org/software/bash/manual/html_node/Readline-Arguments.html#Readline-Arguments)
        -   [8.2.5 Searching for Commands in the History](https://www.gnu.org/software/bash/manual/html_node/Searching.html#Searching)
    -   [8.3 Readline Init File](https://www.gnu.org/software/bash/manual/html_node/Readline-Init-File.html#Readline-Init-File)
        -   [8.3.1 Readline Init File Syntax](https://www.gnu.org/software/bash/manual/html_node/Readline-Init-File-Syntax.html#Readline-Init-File-Syntax)
        -   [8.3.2 Conditional Init Constructs](https://www.gnu.org/software/bash/manual/html_node/Conditional-Init-Constructs.html#Conditional-Init-Constructs)
        -   [8.3.3 Sample Init File](https://www.gnu.org/software/bash/manual/html_node/Sample-Init-File.html#Sample-Init-File)
    -   [8.4 Bindable Readline Commands](https://www.gnu.org/software/bash/manual/html_node/Bindable-Readline-Commands.html#Bindable-Readline-Commands)
        -   [8.4.1 Commands For Moving](https://www.gnu.org/software/bash/manual/html_node/Commands-For-Moving.html#Commands-For-Moving)
        -   [8.4.2 Commands For Manipulating The History](https://www.gnu.org/software/bash/manual/html_node/Commands-For-History.html#Commands-For-History)
        -   [8.4.3 Commands For Changing Text](https://www.gnu.org/software/bash/manual/html_node/Commands-For-Text.html#Commands-For-Text)
        -   [8.4.4 Killing And Yanking](https://www.gnu.org/software/bash/manual/html_node/Commands-For-Killing.html#Commands-For-Killing)
        -   [8.4.5 Specifying Numeric Arguments](https://www.gnu.org/software/bash/manual/html_node/Numeric-Arguments.html#Numeric-Arguments)
        -   [8.4.6 Letting Readline Type For You](https://www.gnu.org/software/bash/manual/html_node/Commands-For-Completion.html#Commands-For-Completion)
        -   [8.4.7 Keyboard Macros](https://www.gnu.org/software/bash/manual/html_node/Keyboard-Macros.html#Keyboard-Macros)
        -   [8.4.8 Some Miscellaneous Commands](https://www.gnu.org/software/bash/manual/html_node/Miscellaneous-Commands.html#Miscellaneous-Commands)
    -   [8.5 Readline vi Mode](https://www.gnu.org/software/bash/manual/html_node/Readline-vi-Mode.html#Readline-vi-Mode)
    -   [8.6 Programmable Completion](https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion.html#Programmable-Completion)
    -   [8.7 Programmable Completion Builtins](https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html#Programmable-Completion-Builtins)
    -   [8.8 A Programmable Completion Example](https://www.gnu.org/software/bash/manual/html_node/A-Programmable-Completion-Example.html#A-Programmable-Completion-Example)
-   [9 Using History Interactively](https://www.gnu.org/software/bash/manual/html_node/Using-History-Interactively.html#Using-History-Interactively)
    -   [9.1 Bash History Facilities](https://www.gnu.org/software/bash/manual/html_node/Bash-History-Facilities.html#Bash-History-Facilities)
    -   [9.2 Bash History Builtins](https://www.gnu.org/software/bash/manual/html_node/Bash-History-Builtins.html#Bash-History-Builtins)
    -   [9.3 History Expansion](https://www.gnu.org/software/bash/manual/html_node/History-Interaction.html#History-Interaction)
        -   [9.3.1 Event Designators](https://www.gnu.org/software/bash/manual/html_node/Event-Designators.html#Event-Designators)
        -   [9.3.2 Word Designators](https://www.gnu.org/software/bash/manual/html_node/Word-Designators.html#Word-Designators)
        -   [9.3.3 Modifiers](https://www.gnu.org/software/bash/manual/html_node/Modifiers.html#Modifiers)
-   [10 Installing Bash](https://www.gnu.org/software/bash/manual/html_node/Installing-Bash.html#Installing-Bash)
    -   [10.1 Basic Installation](https://www.gnu.org/software/bash/manual/html_node/Basic-Installation.html#Basic-Installation)
    -   [10.2 Compilers and Options](https://www.gnu.org/software/bash/manual/html_node/Compilers-and-Options.html#Compilers-and-Options)
    -   [10.3 Compiling For Multiple Architectures](https://www.gnu.org/software/bash/manual/html_node/Compiling-For-Multiple-Architectures.html#Compiling-For-Multiple-Architectures)
    -   [10.4 Installation Names](https://www.gnu.org/software/bash/manual/html_node/Installation-Names.html#Installation-Names)
    -   [10.5 Specifying the System Type](https://www.gnu.org/software/bash/manual/html_node/Specifying-the-System-Type.html#Specifying-the-System-Type)
    -   [10.6 Sharing Defaults](https://www.gnu.org/software/bash/manual/html_node/Sharing-Defaults.html#Sharing-Defaults)
    -   [10.7 Operation Controls](https://www.gnu.org/software/bash/manual/html_node/Operation-Controls.html#Operation-Controls)
    -   [10.8 Optional Features](https://www.gnu.org/software/bash/manual/html_node/Optional-Features.html#Optional-Features)
-   [Appendix A Reporting Bugs](https://www.gnu.org/software/bash/manual/html_node/Reporting-Bugs.html#Reporting-Bugs)
-   [Appendix B Major Differences From The Bourne Shell](https://www.gnu.org/software/bash/manual/html_node/Major-Differences-From-The-Bourne-Shell.html#Major-Differences-From-The-Bourne-Shell)
    -   [B.1 Implementation Differences From The SVR4.2 Shell](https://www.gnu.org/software/bash/manual/html_node/Major-Differences-From-The-Bourne-Shell.html#Implementation-Differences-From-The-SVR4_002e2-Shell)
-   [Appendix C GNU Free Documentation License](https://www.gnu.org/software/bash/manual/html_node/GNU-Free-Documentation-License.html#GNU-Free-Documentation-License)
-   [Appendix D Indexes](https://www.gnu.org/software/bash/manual/html_node/Indexes.html#Indexes)
    -   [D.1 Index of Shell Builtin Commands](https://www.gnu.org/software/bash/manual/html_node/Builtin-Index.html#Builtin-Index)
    -   [D.2 Index of Shell Reserved Words](https://www.gnu.org/software/bash/manual/html_node/Reserved-Word-Index.html#Reserved-Word-Index)
    -   [D.3 Parameter and Variable Index](https://www.gnu.org/software/bash/manual/html_node/Variable-Index.html#Variable-Index)
    -   [D.4 Function Index](https://www.gnu.org/software/bash/manual/html_node/Function-Index.html#Function-Index)
    -   [D.5 Concept Index](https://www.gnu.org/software/bash/manual/html_node/Concept-Index.html#Concept-Index)

# Concept Index
### 以 A 开头的概念术语
| 中文翻译 | Index Entry | 说明 | URL |
|-|-------------|-|---------|
| | [alias expansion](https://www.gnu.org/software/bash/manual/html_node/Aliases.html#index-alias-expansion): | | [Aliases](https://www.gnu.org/software/bash/manual/html_node/Aliases.html) |
| | [arithmetic evaluation](https://www.gnu.org/software/bash/manual/html_node/Shell-Arithmetic.html#index-arithmetic-evaluation): | | [Shell Arithmetic](https://www.gnu.org/software/bash/manual/html_node/Shell-Arithmetic.html) |
| | [arithmetic expansion](https://www.gnu.org/software/bash/manual/html_node/Arithmetic-Expansion.html#index-arithmetic-expansion): | | [Arithmetic Expansion](https://www.gnu.org/software/bash/manual/html_node/Arithmetic-Expansion.html) |
| | [arithmetic, shell](https://www.gnu.org/software/bash/manual/html_node/Shell-Arithmetic.html#index-arithmetic_002c-shell): | | [Shell Arithmetic](https://www.gnu.org/software/bash/manual/html_node/Shell-Arithmetic.html) |
| | [arrays](https://www.gnu.org/software/bash/manual/html_node/Arrays.html#index-arrays): | | [Arrays](https://www.gnu.org/software/bash/manual/html_node/Arrays.html) |

### 以 B 开头的概念术语
| 中文翻译 | Index Entry | 说明 | URL |
|-|-------------|-|---------|
| | [background](https://www.gnu.org/software/bash/manual/html_node/Job-Control-Basics.html#index-background): | | [Job Control Basics](https://www.gnu.org/software/bash/manual/html_node/Job-Control-Basics.html) |
| | [Bash configuration](https://www.gnu.org/software/bash/manual/html_node/Basic-Installation.html#index-Bash-configuration): | | [Basic Installation](https://www.gnu.org/software/bash/manual/html_node/Basic-Installation.html) |
| | [Bash installation](https://www.gnu.org/software/bash/manual/html_node/Basic-Installation.html#index-Bash-installation): | | [Basic Installation](https://www.gnu.org/software/bash/manual/html_node/Basic-Installation.html) |
| | [Bourne shell](https://www.gnu.org/software/bash/manual/html_node/Basic-Shell-Features.html#index-Bourne-shell): | | [Basic Shell Features](https://www.gnu.org/software/bash/manual/html_node/Basic-Shell-Features.html) |
| | [brace expansion](https://www.gnu.org/software/bash/manual/html_node/Brace-Expansion.html#index-brace-expansion): | | [Brace Expansion](https://www.gnu.org/software/bash/manual/html_node/Brace-Expansion.html) |
| | [builtin](https://www.gnu.org/software/bash/manual/html_node/Definitions.html#index-builtin-1): | | [Definitions](https://www.gnu.org/software/bash/manual/html_node/Definitions.html) |

### 以 C 开头的概念术语
| 中文翻译 | Index Entry | 说明 | URL |
|-|-------------|-|---------|
| | [command editing](https://www.gnu.org/software/bash/manual/html_node/Readline-Bare-Essentials.html#index-command-editing): | | [Readline Bare Essentials](https://www.gnu.org/software/bash/manual/html_node/Readline-Bare-Essentials.html) |
| | [command execution](https://www.gnu.org/software/bash/manual/html_node/Command-Search-and-Execution.html#index-command-execution): | | [Command Search and Execution](https://www.gnu.org/software/bash/manual/html_node/Command-Search-and-Execution.html) |
| | [command expansion](https://www.gnu.org/software/bash/manual/html_node/Simple-Command-Expansion.html#index-command-expansion): | | [Simple Command Expansion](https://www.gnu.org/software/bash/manual/html_node/Simple-Command-Expansion.html) |
| | [command history](https://www.gnu.org/software/bash/manual/html_node/Bash-History-Facilities.html#index-command-history): | | [Bash History Facilities](https://www.gnu.org/software/bash/manual/html_node/Bash-History-Facilities.html) |
| | [command search](https://www.gnu.org/software/bash/manual/html_node/Command-Search-and-Execution.html#index-command-search): | | [Command Search and Execution](https://www.gnu.org/software/bash/manual/html_node/Command-Search-and-Execution.html) |
| | [command substitution](https://www.gnu.org/software/bash/manual/html_node/Command-Substitution.html#index-command-substitution): | | [Command Substitution](https://www.gnu.org/software/bash/manual/html_node/Command-Substitution.html) |
| | [command timing](https://www.gnu.org/software/bash/manual/html_node/Pipelines.html#index-command-timing): | | [Pipelines](https://www.gnu.org/software/bash/manual/html_node/Pipelines.html) |
| | [commands, compound](https://www.gnu.org/software/bash/manual/html_node/Compound-Commands.html#index-commands_002c-compound): | | [Compound Commands](https://www.gnu.org/software/bash/manual/html_node/Compound-Commands.html) |
| | [commands, conditional](https://www.gnu.org/software/bash/manual/html_node/Conditional-Constructs.html#index-commands_002c-conditional): | | [Conditional Constructs](https://www.gnu.org/software/bash/manual/html_node/Conditional-Constructs.html) |
| | [commands, grouping](https://www.gnu.org/software/bash/manual/html_node/Command-Grouping.html#index-commands_002c-grouping): | | [Command Grouping](https://www.gnu.org/software/bash/manual/html_node/Command-Grouping.html) |
| | [commands, lists](https://www.gnu.org/software/bash/manual/html_node/Lists.html#index-commands_002c-lists): | | [Lists](https://www.gnu.org/software/bash/manual/html_node/Lists.html) |
| | [commands, looping](https://www.gnu.org/software/bash/manual/html_node/Looping-Constructs.html#index-commands_002c-looping): | | [Looping Constructs](https://www.gnu.org/software/bash/manual/html_node/Looping-Constructs.html) |
| | [commands, pipelines](https://www.gnu.org/software/bash/manual/html_node/Pipelines.html#index-commands_002c-pipelines): | | [Pipelines](https://www.gnu.org/software/bash/manual/html_node/Pipelines.html) |
| | [commands, shell](https://www.gnu.org/software/bash/manual/html_node/Shell-Commands.html#index-commands_002c-shell): | | [Shell Commands](https://www.gnu.org/software/bash/manual/html_node/Shell-Commands.html) |
| | [commands, simple](https://www.gnu.org/software/bash/manual/html_node/Simple-Commands.html#index-commands_002c-simple): | | [Simple Commands](https://www.gnu.org/software/bash/manual/html_node/Simple-Commands.html) |
| | [comments, shell](https://www.gnu.org/software/bash/manual/html_node/Comments.html#index-comments_002c-shell): | | [Comments](https://www.gnu.org/software/bash/manual/html_node/Comments.html) |
| | [Compatibility Level](https://www.gnu.org/software/bash/manual/html_node/Shell-Compatibility-Mode.html#index-Compatibility-Level): | | [Shell Compatibility Mode](https://www.gnu.org/software/bash/manual/html_node/Shell-Compatibility-Mode.html) |
| | [Compatibility Mode](https://www.gnu.org/software/bash/manual/html_node/Shell-Compatibility-Mode.html#index-Compatibility-Mode): | | [Shell Compatibility Mode](https://www.gnu.org/software/bash/manual/html_node/Shell-Compatibility-Mode.html) |
| | [completion builtins](https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html#index-completion-builtins): | | [Programmable Completion Builtins](https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion-Builtins.html) |
| | [configuration](https://www.gnu.org/software/bash/manual/html_node/Basic-Installation.html#index-configuration): | | [Basic Installation](https://www.gnu.org/software/bash/manual/html_node/Basic-Installation.html) |
| | [control operator](https://www.gnu.org/software/bash/manual/html_node/Definitions.html#index-control-operator): | | [Definitions](https://www.gnu.org/software/bash/manual/html_node/Definitions.html) |
| | [coprocess](https://www.gnu.org/software/bash/manual/html_node/Coprocesses.html#index-coprocess): | | [Coprocesses](https://www.gnu.org/software/bash/manual/html_node/Coprocesses.html) |

### 以 D 开头的概念术语
| 中文翻译 | Index Entry | 说明 | URL |
|-|-------------|-|---------|
| | [directory stack](https://www.gnu.org/software/bash/manual/html_node/The-Directory-Stack.html#index-directory-stack): | | [The Directory Stack](https://www.gnu.org/software/bash/manual/html_node/The-Directory-Stack.html) |

### 以 E 开头的概念术语
| 中文翻译 | Index Entry | 说明 | URL |
|-|-------------|-|---------|
| | [editing command lines](https://www.gnu.org/software/bash/manual/html_node/Readline-Bare-Essentials.html#index-editing-command-lines): | | [Readline Bare Essentials](https://www.gnu.org/software/bash/manual/html_node/Readline-Bare-Essentials.html) |
| | [environment](https://www.gnu.org/software/bash/manual/html_node/Environment.html#index-environment): | | [Environment](https://www.gnu.org/software/bash/manual/html_node/Environment.html) |
| | [evaluation, arithmetic](https://www.gnu.org/software/bash/manual/html_node/Shell-Arithmetic.html#index-evaluation_002c-arithmetic): | | [Shell Arithmetic](https://www.gnu.org/software/bash/manual/html_node/Shell-Arithmetic.html) |
| | [event designators](https://www.gnu.org/software/bash/manual/html_node/Event-Designators.html#index-event-designators): | | [Event Designators](https://www.gnu.org/software/bash/manual/html_node/Event-Designators.html) |
| | [execution environment](https://www.gnu.org/software/bash/manual/html_node/Command-Execution-Environment.html#index-execution-environment): | | [Command Execution Environment](https://www.gnu.org/software/bash/manual/html_node/Command-Execution-Environment.html) |
| | [exit status](https://www.gnu.org/software/bash/manual/html_node/Definitions.html#index-exit-status): | | [Definitions](https://www.gnu.org/software/bash/manual/html_node/Definitions.html) |
| | [exit status](https://www.gnu.org/software/bash/manual/html_node/Exit-Status.html#index-exit-status-1): | | [Exit Status](https://www.gnu.org/software/bash/manual/html_node/Exit-Status.html) |
| | [expansion](https://www.gnu.org/software/bash/manual/html_node/Shell-Expansions.html#index-expansion): | | [Shell Expansions](https://www.gnu.org/software/bash/manual/html_node/Shell-Expansions.html) |
| | [expansion, arithmetic](https://www.gnu.org/software/bash/manual/html_node/Arithmetic-Expansion.html#index-expansion_002c-arithmetic): | | [Arithmetic Expansion](https://www.gnu.org/software/bash/manual/html_node/Arithmetic-Expansion.html) |
| | [expansion, brace](https://www.gnu.org/software/bash/manual/html_node/Brace-Expansion.html#index-expansion_002c-brace): | | [Brace Expansion](https://www.gnu.org/software/bash/manual/html_node/Brace-Expansion.html) |
| | [expansion, filename](https://www.gnu.org/software/bash/manual/html_node/Filename-Expansion.html#index-expansion_002c-filename): | | [Filename Expansion](https://www.gnu.org/software/bash/manual/html_node/Filename-Expansion.html) |
| | [expansion, parameter](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html#index-expansion_002c-parameter): | | [Shell Parameter Expansion](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html) |
| | [expansion, pathname](https://www.gnu.org/software/bash/manual/html_node/Filename-Expansion.html#index-expansion_002c-pathname): | | [Filename Expansion](https://www.gnu.org/software/bash/manual/html_node/Filename-Expansion.html) |
| | [expansion, tilde](https://www.gnu.org/software/bash/manual/html_node/Tilde-Expansion.html#index-expansion_002c-tilde): | | [Tilde Expansion](https://www.gnu.org/software/bash/manual/html_node/Tilde-Expansion.html) |
| | [expressions, arithmetic](https://www.gnu.org/software/bash/manual/html_node/Shell-Arithmetic.html#index-expressions_002c-arithmetic): | | [Shell Arithmetic](https://www.gnu.org/software/bash/manual/html_node/Shell-Arithmetic.html) |
| | [expressions, conditional](https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html#index-expressions_002c-conditional): | | [Bash Conditional Expressions](https://www.gnu.org/software/bash/manual/html_node/Bash-Conditional-Expressions.html) |

### 以 F 开头的概念术语
| 中文翻译 | Index Entry | 说明 | URL |
|-|-------------|-|---------|
| | [field](https://www.gnu.org/software/bash/manual/html_node/Definitions.html#index-field): | | [Definitions](https://www.gnu.org/software/bash/manual/html_node/Definitions.html) |
| | [filename](https://www.gnu.org/software/bash/manual/html_node/Definitions.html#index-filename): | | [Definitions](https://www.gnu.org/software/bash/manual/html_node/Definitions.html) |
| | [filename expansion](https://www.gnu.org/software/bash/manual/html_node/Filename-Expansion.html#index-filename-expansion): | | [Filename Expansion](https://www.gnu.org/software/bash/manual/html_node/Filename-Expansion.html) |
| | [foreground](https://www.gnu.org/software/bash/manual/html_node/Job-Control-Basics.html#index-foreground): | | [Job Control Basics](https://www.gnu.org/software/bash/manual/html_node/Job-Control-Basics.html) |
| | [functions, shell](https://www.gnu.org/software/bash/manual/html_node/Shell-Functions.html#index-functions_002c-shell): | | [Shell Functions](https://www.gnu.org/software/bash/manual/html_node/Shell-Functions.html) |

### 以 H 开头的概念术语
| 中文翻译 | Index Entry | 说明 | URL |
|-|-------------|-|---------|
| | [history builtins](https://www.gnu.org/software/bash/manual/html_node/Bash-History-Builtins.html#index-history-builtins): | | [Bash History Builtins](https://www.gnu.org/software/bash/manual/html_node/Bash-History-Builtins.html) |
| | [history events](https://www.gnu.org/software/bash/manual/html_node/Event-Designators.html#index-history-events): | | [Event Designators](https://www.gnu.org/software/bash/manual/html_node/Event-Designators.html) |
| | [history expansion](https://www.gnu.org/software/bash/manual/html_node/History-Interaction.html#index-history-expansion): | | [History Interaction](https://www.gnu.org/software/bash/manual/html_node/History-Interaction.html) |
| | [history list](https://www.gnu.org/software/bash/manual/html_node/Bash-History-Facilities.html#index-history-list): | | [Bash History Facilities](https://www.gnu.org/software/bash/manual/html_node/Bash-History-Facilities.html) |
| | [History, how to use](https://www.gnu.org/software/bash/manual/html_node/A-Programmable-Completion-Example.html#index-History_002c-how-to-use): | | [A Programmable Completion Example](https://www.gnu.org/software/bash/manual/html_node/A-Programmable-Completion-Example.html) |

### 以 I 开头的概念术语
| 中文翻译 | Index Entry | 说明 | URL |
|-|-------------|-|---------|
| | [identifier](https://www.gnu.org/software/bash/manual/html_node/Definitions.html#index-identifier): | | [Definitions](https://www.gnu.org/software/bash/manual/html_node/Definitions.html) |
| | [initialization file, readline](https://www.gnu.org/software/bash/manual/html_node/Readline-Init-File.html#index-initialization-file_002c-readline): | | [Readline Init File](https://www.gnu.org/software/bash/manual/html_node/Readline-Init-File.html) |
| | [installation](https://www.gnu.org/software/bash/manual/html_node/Basic-Installation.html#index-installation): | | [Basic Installation](https://www.gnu.org/software/bash/manual/html_node/Basic-Installation.html) |
| | [interaction, readline](https://www.gnu.org/software/bash/manual/html_node/Readline-Interaction.html#index-interaction_002c-readline): | | [Readline Interaction](https://www.gnu.org/software/bash/manual/html_node/Readline-Interaction.html) |
| | [interactive shell](https://www.gnu.org/software/bash/manual/html_node/Invoking-Bash.html#index-interactive-shell): | | [Invoking Bash](https://www.gnu.org/software/bash/manual/html_node/Invoking-Bash.html) |
| | [interactive shell](https://www.gnu.org/software/bash/manual/html_node/Interactive-Shells.html#index-interactive-shell-1): | | [Interactive Shells](https://www.gnu.org/software/bash/manual/html_node/Interactive-Shells.html) |
| | [internationalization](https://www.gnu.org/software/bash/manual/html_node/Locale-Translation.html#index-internationalization): | | [Locale Translation](https://www.gnu.org/software/bash/manual/html_node/Locale-Translation.html) |

### 以 J 开头的概念术语
| 中文翻译 | Index Entry | 说明 | URL |
|-|-------------|-|---------|
| | [job](https://www.gnu.org/software/bash/manual/html_node/Definitions.html#index-job): | | [Definitions](https://www.gnu.org/software/bash/manual/html_node/Definitions.html) |
| | [job control](https://www.gnu.org/software/bash/manual/html_node/Definitions.html#index-job-control): | | [Definitions](https://www.gnu.org/software/bash/manual/html_node/Definitions.html) |
| | [job control](https://www.gnu.org/software/bash/manual/html_node/Job-Control-Basics.html#index-job-control-1): | | [Job Control Basics](https://www.gnu.org/software/bash/manual/html_node/Job-Control-Basics.html) |

### 以 K 开头的概念术语
| 中文翻译 | Index Entry | 说明 | URL |
|-|-------------|-|---------|
| | [kill ring](https://www.gnu.org/software/bash/manual/html_node/Readline-Killing-Commands.html#index-kill-ring): | | [Readline Killing Commands](https://www.gnu.org/software/bash/manual/html_node/Readline-Killing-Commands.html) |
| | [killing text](https://www.gnu.org/software/bash/manual/html_node/Readline-Killing-Commands.html#index-killing-text): | | [Readline Killing Commands](https://www.gnu.org/software/bash/manual/html_node/Readline-Killing-Commands.html) |

### 以 L 开头的概念术语
| 中文翻译 | Index Entry | 说明 | URL |
|-|-------------|-|---------|
| | [localization](https://www.gnu.org/software/bash/manual/html_node/Locale-Translation.html#index-localization): | | [Locale Translation](https://www.gnu.org/software/bash/manual/html_node/Locale-Translation.html) |
| | [login shell](https://www.gnu.org/software/bash/manual/html_node/Invoking-Bash.html#index-login-shell): | | [Invoking Bash](https://www.gnu.org/software/bash/manual/html_node/Invoking-Bash.html) |

### 以 M 开头的概念术语
| 中文翻译 | Index Entry | 说明 | URL |
|-|-------------|-|---------|
| | [matching, pattern](https://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html#index-matching_002c-pattern): | | [Pattern Matching](https://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html) |
| | [metacharacter](https://www.gnu.org/software/bash/manual/html_node/Definitions.html#index-metacharacter): | | [Definitions](https://www.gnu.org/software/bash/manual/html_node/Definitions.html) |

### 以 N 开头的概念术语
| 中文翻译 | Index Entry | 说明 | URL |
|-|-------------|-|---------|
| | [name](https://www.gnu.org/software/bash/manual/html_node/Definitions.html#index-name): | | [Definitions](https://www.gnu.org/software/bash/manual/html_node/Definitions.html) |
| | [native languages](https://www.gnu.org/software/bash/manual/html_node/Locale-Translation.html#index-native-languages): | | [Locale Translation](https://www.gnu.org/software/bash/manual/html_node/Locale-Translation.html) |
| | [notation, readline](https://www.gnu.org/software/bash/manual/html_node/Readline-Bare-Essentials.html#index-notation_002c-readline): | | [Readline Bare Essentials](https://www.gnu.org/software/bash/manual/html_node/Readline-Bare-Essentials.html) |

### 以 O 开头的概念术语
| 中文翻译 | Index Entry | 说明 | URL |
|-|-------------|-|---------|
| | [operator, shell](https://www.gnu.org/software/bash/manual/html_node/Definitions.html#index-operator_002c-shell): | | [Definitions](https://www.gnu.org/software/bash/manual/html_node/Definitions.html) |

### 以 P 开头的概念术语
| 中文翻译 | Index Entry | 说明 | URL |
|-|-------------|-|---------|
| | [parameter expansion](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html#index-parameter-expansion): | | [Shell Parameter Expansion](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameter-Expansion.html) |
| | [parameters](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameters.html#index-parameters): | | [Shell Parameters](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameters.html) |
| | [parameters, positional](https://www.gnu.org/software/bash/manual/html_node/Positional-Parameters.html#index-parameters_002c-positional): | | [Positional Parameters](https://www.gnu.org/software/bash/manual/html_node/Positional-Parameters.html) |
| | [parameters, special](https://www.gnu.org/software/bash/manual/html_node/Special-Parameters.html#index-parameters_002c-special): | | [Special Parameters](https://www.gnu.org/software/bash/manual/html_node/Special-Parameters.html) |
| | [pathname expansion](https://www.gnu.org/software/bash/manual/html_node/Filename-Expansion.html#index-pathname-expansion): | | [Filename Expansion](https://www.gnu.org/software/bash/manual/html_node/Filename-Expansion.html) |
| | [pattern matching](https://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html#index-pattern-matching): | | [Pattern Matching](https://www.gnu.org/software/bash/manual/html_node/Pattern-Matching.html) |
| | [pipeline](https://www.gnu.org/software/bash/manual/html_node/Pipelines.html#index-pipeline): | | [Pipelines](https://www.gnu.org/software/bash/manual/html_node/Pipelines.html) |
| | [POSIX](https://www.gnu.org/software/bash/manual/html_node/Definitions.html#index-POSIX): | | [Definitions](https://www.gnu.org/software/bash/manual/html_node/Definitions.html) |
| | [POSIX Mode](https://www.gnu.org/software/bash/manual/html_node/Bash-POSIX-Mode.html#index-POSIX-Mode): | | [Bash POSIX Mode](https://www.gnu.org/software/bash/manual/html_node/Bash-POSIX-Mode.html) |
| | [process group](https://www.gnu.org/software/bash/manual/html_node/Definitions.html#index-process-group): | | [Definitions](https://www.gnu.org/software/bash/manual/html_node/Definitions.html) |
| | [process group ID](https://www.gnu.org/software/bash/manual/html_node/Definitions.html#index-process-group-ID): | | [Definitions](https://www.gnu.org/software/bash/manual/html_node/Definitions.html) |
| | [process substitution](https://www.gnu.org/software/bash/manual/html_node/Process-Substitution.html#index-process-substitution): | | [Process Substitution](https://www.gnu.org/software/bash/manual/html_node/Process-Substitution.html) |
| | [programmable completion](https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion.html#index-programmable-completion): | | [Programmable Completion](https://www.gnu.org/software/bash/manual/html_node/Programmable-Completion.html) |
| | [prompting](https://www.gnu.org/software/bash/manual/html_node/Controlling-the-Prompt.html#index-prompting): | | [Controlling the Prompt](https://www.gnu.org/software/bash/manual/html_node/Controlling-the-Prompt.html) |

### 以 Q 开头的概念术语
| 中文翻译 | Index Entry | 说明 | URL |
|-|-------------|-|---------|
| | [quoting](https://www.gnu.org/software/bash/manual/html_node/Quoting.html#index-quoting): | | [Quoting](https://www.gnu.org/software/bash/manual/html_node/Quoting.html) |
| | [quoting, ANSI](https://www.gnu.org/software/bash/manual/html_node/ANSI_002dC-Quoting.html#index-quoting_002c-ANSI): | | [ANSI-C Quoting](https://www.gnu.org/software/bash/manual/html_node/ANSI_002dC-Quoting.html) |

### 以 R 开头的概念术语
| 中文翻译 | Index Entry | 说明 | URL |
|-|-------------|-|---------|
| | [Readline, how to use](https://www.gnu.org/software/bash/manual/html_node/Job-Control-Variables.html#index-Readline_002c-how-to-use): | | [Job Control Variables](https://www.gnu.org/software/bash/manual/html_node/Job-Control-Variables.html) |
| | [redirection](https://www.gnu.org/software/bash/manual/html_node/Redirections.html#index-redirection): | | [Redirections](https://www.gnu.org/software/bash/manual/html_node/Redirections.html) |
| | [reserved word](https://www.gnu.org/software/bash/manual/html_node/Definitions.html#index-reserved-word): | | [Definitions](https://www.gnu.org/software/bash/manual/html_node/Definitions.html) |
| | [reserved words](https://www.gnu.org/software/bash/manual/html_node/Reserved-Words.html#index-reserved-words): | | [Reserved Words](https://www.gnu.org/software/bash/manual/html_node/Reserved-Words.html) |
| | [restricted shell](https://www.gnu.org/software/bash/manual/html_node/The-Restricted-Shell.html#index-restricted-shell): | | [The Restricted Shell](https://www.gnu.org/software/bash/manual/html_node/The-Restricted-Shell.html) |
| | [return status](https://www.gnu.org/software/bash/manual/html_node/Definitions.html#index-return-status): | | [Definitions](https://www.gnu.org/software/bash/manual/html_node/Definitions.html) |

### 以 S 开头的概念术语
| 中文翻译 | Index Entry | 说明 | URL |
|-|-------------|-|---------|
| | [shell arithmetic](https://www.gnu.org/software/bash/manual/html_node/Shell-Arithmetic.html#index-shell-arithmetic): | | [Shell Arithmetic](https://www.gnu.org/software/bash/manual/html_node/Shell-Arithmetic.html) |
| | [shell function](https://www.gnu.org/software/bash/manual/html_node/Shell-Functions.html#index-shell-function): | | [Shell Functions](https://www.gnu.org/software/bash/manual/html_node/Shell-Functions.html) |
| | [shell script](https://www.gnu.org/software/bash/manual/html_node/Shell-Scripts.html#index-shell-script): | | [Shell Scripts](https://www.gnu.org/software/bash/manual/html_node/Shell-Scripts.html) |
| | [shell variable](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameters.html#index-shell-variable): | | [Shell Parameters](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameters.html) |
| | [shell, interactive](https://www.gnu.org/software/bash/manual/html_node/Interactive-Shells.html#index-shell_002c-interactive): | | [Interactive Shells](https://www.gnu.org/software/bash/manual/html_node/Interactive-Shells.html) |
| | [signal](https://www.gnu.org/software/bash/manual/html_node/Definitions.html#index-signal): | | [Definitions](https://www.gnu.org/software/bash/manual/html_node/Definitions.html) |
| | [signal handling](https://www.gnu.org/software/bash/manual/html_node/Signals.html#index-signal-handling): | | [Signals](https://www.gnu.org/software/bash/manual/html_node/Signals.html) |
| | [special builtin](https://www.gnu.org/software/bash/manual/html_node/Definitions.html#index-special-builtin): | | [Definitions](https://www.gnu.org/software/bash/manual/html_node/Definitions.html) |
| | [special builtin](https://www.gnu.org/software/bash/manual/html_node/Special-Builtins.html#index-special-builtin-1): | | [Special Builtins](https://www.gnu.org/software/bash/manual/html_node/Special-Builtins.html) |
| | [startup files](https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html#index-startup-files): | | [Bash Startup Files](https://www.gnu.org/software/bash/manual/html_node/Bash-Startup-Files.html) |
| | [suspending jobs](https://www.gnu.org/software/bash/manual/html_node/Job-Control-Basics.html#index-suspending-jobs): | | [Job Control Basics](https://www.gnu.org/software/bash/manual/html_node/Job-Control-Basics.html) |

### 以 T 开头的概念术语
| 中文翻译 | Index Entry | 说明 | URL |
|-|-------------|-|---------|
| | [tilde expansion](https://www.gnu.org/software/bash/manual/html_node/Tilde-Expansion.html#index-tilde-expansion): | | [Tilde Expansion](https://www.gnu.org/software/bash/manual/html_node/Tilde-Expansion.html) |
| | [token](https://www.gnu.org/software/bash/manual/html_node/Definitions.html#index-token): | | [Definitions](https://www.gnu.org/software/bash/manual/html_node/Definitions.html) |
| | [translation, native languages](https://www.gnu.org/software/bash/manual/html_node/Locale-Translation.html#index-translation_002c-native-languages): | | [Locale Translation](https://www.gnu.org/software/bash/manual/html_node/Locale-Translation.html) |

### 以 V 开头的概念术语
| 中文翻译 | Index Entry | 说明 | URL |
|-|-------------|-|---------|
| | [variable, shell](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameters.html#index-variable_002c-shell): | | [Shell Parameters](https://www.gnu.org/software/bash/manual/html_node/Shell-Parameters.html) |
| | [variables, readline](https://www.gnu.org/software/bash/manual/html_node/Readline-Init-File-Syntax.html#index-variables_002c-readline): | | [Readline Init File Syntax](https://www.gnu.org/software/bash/manual/html_node/Readline-Init-File-Syntax.html) |

### 以 W 开头的概念术语
| 中文翻译 | Index Entry | 说明 | URL |
|-|-------------|-|---------|
| | [word](https://www.gnu.org/software/bash/manual/html_node/Definitions.html#index-word): | | [Definitions](https://www.gnu.org/software/bash/manual/html_node/Definitions.html) |
| | [word splitting](https://www.gnu.org/software/bash/manual/html_node/Word-Splitting.html#index-word-splitting): | | [Word Splitting](https://www.gnu.org/software/bash/manual/html_node/Word-Splitting.html) |

### 以 Y 开头的概念术语
| 中文翻译 | Index Entry | 说明 | URL |
|-|-------------|-|---------|
| | [yanking text](https://www.gnu.org/software/bash/manual/html_node/Readline-Killing-Commands.html#index-yanking-text): | | [Readline Killing Commands](https://www.gnu.org/software/bash/manual/html_node/Readline-Killing-Commands.html) |

# 内置 Bash 命令
[Bash Builtins (Bash Reference Manual)](https://www.gnu.org/software/bash/manual/html_node/Bash-Builtins.html#Bash-Builtins)
# 进程管理
[鸟哥的 Linux 私房菜 -- 程序管理与 SELinux 初探](http://cn.linux.vbird.org/linux_basic/0440processcontrol_3.php)
[0.1 电脑：辅助人脑的好工具 | 鸟哥的 Linux 私房菜：基础学习篇 第四版](http://shouce.jb51.net/vbird-linux-basic-4/3.html)

# Find 命令
[鸟哥的 Linux 私房菜 -- 文件与目录管理](http://cn.linux.vbird.org/linux_basic/0220filemanager_5.php#find)
# Curl

[linux下curl的用法_李如磊的技术博客_51CTO博客](https://blog.51cto.com/lee90/2045473) 
[Linux curl命令参数详解 - 爱E族](https://www.aiezu.com/a/linux_curl_syntax.html)

```bash

--user-agent <string> 设置用户代理发送给服务器
-basic 使用HTTP基本认证
--tcp-nodelay 使用TCP_NODELAY选项
--referer <URL> 来源网址
--cacert <file> CA证书  (SSL) 
--compressed 要求返回是压缩的格式
--header <line>自定义头信息传递给服务器
-I     只显示响应报文首部信息
--limit-rate <rate> 设置传输速度
-u/--user <user[:password]>设置服务器的用户和密码
-0/--http1.0 使用HTTP 1.0	
-x 接代理服务器的IP 表示使用这个代理IP去请求其他的网页
-s 静默模式，不显示返回的一大堆页面内容
-d 带参数请求。这样就可以post用户名和密码之类的参数了，模拟登录非常有用。
-c 接文件名，表示将curl时候的服务器返回的cookie存到本地文件中
-b 接cookie文件路径， 表示请求的时候将cookie文件中的信息带上
-L 表示如果在response header中如果有location的话就直接转向到location的地址(redirect地址)
	(HTTP/HTTPS)追随http响应头“Location：”定向到跳转后的页面，(在http响应码为3XX时使用，如301跳转、302跳转)

用法：curl [options] [URL...]

	例：curl -e www.baidu.com/index.html 192.168.2.11/index.html

	get方式提交数据：
		curl -G -d "name=value&name2=value2" http://www.baidu.com 

	post方式提交数据：
		curl -d "name=value&name2=value2" http://www.baidu.com #post数据
		curl -d a=b&c=d&txt@/tmp/txt http://www.baidu.com  #post文件

	表单方式提交数据：
		curl -F file=@/tmp/me.txt http://www.aiezu.com

	#将http header保存到文件
		curl -D /tmp/header http://www.aiezu.com 

	# 查看是否跳转正常
		curl -I "http://pc.demo.com/" -L

例如：负载均衡中检测服务器存活命令
curl -I -s  http://172.16.20.13|head -1|awk -F " " '{print $2}'

检测网址访问情况：
curl -I -s 'http://api.demo.com/User/Register'|sed -n '1p'|grep '200 OK'


# post提交参数检测是否可以网站登录
if [ ! `curl -s -d 'UserName=xxxxxx&&UserPass=xxxxxx' http://www.demo.com/User/Login |wc -l` -eq 0 ] ; then
  echo -e "账号出现无法登陆，请关注"
fi

```

**Linux curl使用代理：**

linux curl使用http代理抓取页面：

```bash
curl -x 111.95.243.36:80 http://iframe.ip138.com/ic.asp|iconv -fgb2312
curl -x 111.95.243.36:80 -U aiezu:password http://www.baidu.com
```

使用socks代理抓取页面：

```bash
curl --socks4 202.113.65.229:443 http://iframe.ip138.com/ic.asp|iconv -fgb2312
curl --socks5 202.113.65.229:443 http://iframe.ip138.com/ic.asp|iconv -fgb2312
```

代理[服务器](https://www.fastadmin.net/go/aliyun)地址可以从[爬虫代理](http://pachong.org/)上获取。
#  SSH
## 端口转发

```bash
ssh -R <remoteListenHost>:<remoteListenPort>:<localListenHost>:<localListenPort> <user>@<remoteHost>

ssh -R <remoteListenHost>:<remoteListenPort>:<localListenHost>:<localListenPort> <user>@<remoteHost>
```

# tar
```bash

-c ：建立一个压缩文件的参数指令(create 的意思)。
-x ：解开一个压缩文件的参数指令。
-t ：查看 tarfile 里面的文件。特别注意，在参数的下达中，c/x/t 仅能存在一个，不可同时存在， 因为不可能同时压缩与解压缩。
-z ：使用gzip进行压缩打包文档。
-j ：使用bzip2进行压缩打包文档。
-v ：压缩的过程中显示文件。这个常用，但不建议用在背景执行过程。
-f ：使用档名。请留意，在 f 之后要立即接档名，不要再加参数。
例如使用“tar -zcvfP tfile sfile”就是错误的写法，要写成“tar -zcvPf tfile sfile”才对。
(关于这点我保留意见，因为平时我解压，都是-xvfz….没见有神马不对的….也许是改进了？)
-p ：使用原文件的原来属性（属性不会依据使用者而变）。
-P ：可以使用绝对路径来压缩。
-N ：比后面接的日期(yyyy/mm/dd)还要新的才会被打包进新建的文件中。
–exclude FILE：在压缩的过程中，不要将 FILE 打包。

## 打包普通文件夹，压缩带参数z，创建tar.gz

tar -cvf ./tmp/SK_Aug_camera.tar ./gap_40_5

## 但是文件夹里含有[软连接](https://so.csdn.net/so/search?q=%E8%BD%AF%E8%BF%9E%E6%8E%A5&spm=1001.2101.3001.7020)，带参数 h

tar -cvhf ./tmp/SK_Aug_camera.tar ./gap_40_5

```

# set
`set`命令用来修改 Shell 环境的运行参数，也就是可以定制环境。一共有十几个参数可以定制，[官方手册](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)有完整清单，本文介绍其中最常用的四个。

顺便提一下，如果命令行下不带任何参数，直接运行`set`，会显示所有的环境变量和 Shell 函数。

> ```bash
> 
> $ set
> ```

## set -u

执行脚本的时候，如果遇到不存在的变量，Bash 默认忽略它。

> ```bash
> 
> #!/usr/bin/env bash
> 
> echo $a
> echo bar
> ```

上面代码中，`$a`是一个不存在的变量。执行结果如下。

> ```bash
> 
> $ bash script.sh
> 
> bar
> ```

可以看到，`echo $a`输出了一个空行，Bash 忽略了不存在的`$a`，然后继续执行`echo bar`。大多数情况下，这不是开发者想要的行为，遇到变量不存在，脚本应该报错，而不是一声不响地往下执行。

`set -u`就用来改变这种行为。脚本在头部加上它，遇到不存在的变量就会报错，并停止执行。

> ```bash
> 
> #!/usr/bin/env bash
> set -u
> 
> echo $a
> echo bar
> ```

运行结果如下。

> ```bash
> 
> $ bash script.sh
> bash: script.sh:行4: a: 未绑定的变量
> ```

可以看到，脚本报错了，并且不再执行后面的语句。

`-u`还有另一种写法`-o nounset`，两者是等价的。

> ```bash
> 
> set -o nounset
> ```

## set -x

默认情况下，脚本执行后，屏幕只显示运行结果，没有其他内容。如果多个命令连续执行，它们的运行结果就会连续输出。有时会分不清，某一段内容是什么命令产生的。

`set -x`用来在运行结果之前，先输出执行的那一行命令。

> ```bash
> 
> #!/usr/bin/env bash
> set -x
> 
> echo bar
> ```

执行上面的脚本，结果如下。

```bash

$ bash script.sh
+ echo bar
bar
```

可以看到，执行`echo bar`之前，该命令会先打印出来，行首以`+`表示。这对于调试复杂的脚本是很有用的。

`-x`还有另一种写法`-o xtrace`。

```bash

set -o xtrace
```

## Bash 的错误处理

如果脚本里面有运行失败的命令（返回值非0），Bash 默认会继续执行后面的命令。

```bash

#!/usr/bin/env bash

foo
echo bar
```

上面脚本中，`foo`是一个不存在的命令，执行时会报错。但是，Bash 会忽略这个错误，继续往下执行。

> ```bash
> 
> $ bash script.sh
> script.sh:行3: foo: 未找到命令
> bar
> ```

可以看到，Bash 只是显示有错误，并没有终止执行。

这种行为很不利于脚本安全和除错。实际开发中，如果某个命令失败，往往需要脚本停止执行，防止错误累积。这时，一般采用下面的写法。

> ```bash
> 
> command || exit 1
> ```

上面的写法表示只要`command`有非零返回值，脚本就会停止执行。

如果停止执行之前需要完成多个操作，就要采用下面三种写法。

> ```bash
> 
> # 写法一
> command || { echo "command failed"; exit 1; }
> 
> # 写法二
> if ! command; then echo "command failed"; exit 1; fi
> 
> # 写法三
> command
> if [ "$?" -ne 0 ]; then echo "command failed"; exit 1; fi
> ```

另外，除了停止执行，还有一种情况。如果两个命令有继承关系，只有第一个命令成功了，才能继续执行第二个命令，那么就要采用下面的写法。

> ```bash
> 
> command1 && command2
> ```

## set -e

上面这些写法多少有些麻烦，容易疏忽。`set -e`从根本上解决了这个问题，它使得脚本只要发生错误，就终止执行。

> ```bash
> 
> #!/usr/bin/env bash
> set -e
> 
> foo
> echo bar
> ```

执行结果如下。

> ```bash
> 
> $ bash script.sh
> script.sh:行4: foo: 未找到命令
> ```

可以看到，第4行执行失败以后，脚本就终止执行了。

`set -e`根据返回值来判断，一个命令是否运行失败。但是，某些命令的非零返回值可能不表示失败，或者开发者希望在命令失败的情况下，脚本继续执行下去。这时可以暂时关闭`set -e`，该命令执行结束后，再重新打开`set -e`。

> ```bash
> 
> set +e
> command1
> command2
> set -e
> ```

上面代码中，`set +e`表示关闭`-e`选项，`set -e`表示重新打开`-e`选项。

还有一种方法是使用`command || true`，使得该命令即使执行失败，脚本也不会终止执行。

> ```bash
> 
> #!/bin/bash
> set -e
> 
> foo || true
> echo bar
> ```

上面代码中，`true`使得这一行语句总是会执行成功，后面的`echo bar`会执行。

`-e`还有另一种写法`-o errexit`。

> ```bash
> 
> set -o errexit
> ```

## set -o pipefail

`set -e`有一个例外情况，就是不适用于管道命令。

所谓管道命令，就是多个子命令通过管道运算符（`|`）组合成为一个大的命令。Bash 会把最后一个子命令的返回值，作为整个命令的返回值。也就是说，只要最后一个子命令不失败，管道命令总是会执行成功，因此它后面命令依然会执行，`set -e`就失效了。

请看下面这个例子。

> ```bash
> 
> #!/usr/bin/env bash
> set -e
> 
> foo | echo a
> echo bar
> ```

执行结果如下。

> ```bash
> 
> $ bash script.sh
> a
> script.sh:行4: foo: 未找到命令
> bar
> ```

上面代码中，`foo`是一个不存在的命令，但是`foo | echo a`这个管道命令会执行成功，导致后面的`echo bar`会继续执行。

`set -o pipefail`用来解决这种情况，只要一个子命令失败，整个管道命令就失败，脚本就会终止执行。

> ```bash
> 
> #!/usr/bin/env bash
> set -eo pipefail
> 
> foo | echo a
> echo bar
> ```

运行后，结果如下。

> ```bash
> 
> $ bash script.sh
> a
> script.sh:行4: foo: 未找到命令
> ```

可以看到，`echo bar`没有执行。

## 总结

`set`命令的上面这四个参数，一般都放在一起使用。

> ```bash
> 
> # 写法一
> set -euxo pipefail
> 
> # 写法二
> set -eux
> set -o pipefail
> ```

这两种写法建议放在所有 Bash 脚本的头部。

另一种办法是在执行 Bash 脚本的时候，从命令行传入这些参数。

> ```bash
> 
> $ bash -euxo pipefail script.sh
> ```

## 参考链接

-   [The Set Builtin](https://www.gnu.org/software/bash/manual/html_node/The-Set-Builtin.html)
-   [Safer bash scripts with 'set -euxo pipefail'](https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/)
-   [Writing Robust Bash Shell Scripts](http://www.davidpashley.com/articles/writing-robust-shell-scripts/)

# Shell 组命令与子进程

 [shell组命令与子进程](https://www.cnblogs.com/ting152/p/12554480.html)

## 组命令

组命令，就是将多个命令划分为一组，或者看成一个整体。Shell 组命令的写法有两种，也就是使用花括号作为定界符和使用圆括号作为定界符。由花括号`{}`包围起来的组命名在当前 Shell 进程中执行，而由小括号`()`包围起来的组命令会创建一个子 Shell，所有命令都在**子 Shell** 中执行。

```bash
# 使用花括号作为定界符
{ command1; command2;. . .; }
# 使用圆括号作为定界符
(command1; command2;. . . )
```

使用花括号{}时，花括号与命令之间必须要有一个空格，并且最后一个命令必须用一个分号或一个换行符结束。组命令可以将多条命令的输出结果合并在一起，在使用重定向和管道时会特别方便。 

两种写法的重要不同：**由`{}`包围的组命令在当前 Shell 进程中执行，由`()`包围的组命令会创建一个子Shell，所有命令都会在这个子 Shell 中执行**。 在子 Shell 中执行意味着，运行环境被复制给了一个新的 shell 进程，当这个子 Shell 退出时，新的进程也会被销毁，环境副本也会消失，所以在子 Shell 环境中的任何更改都会消失（包括给变量赋值）。因此，在大多数情况下，除非脚本要求一个子 Shell，否则**使用`{}`比使用`()`更受欢迎，并且`{}`的进行速度更快，占用的内存更少**。

| 用法                                | 区别                                                         |
| ----------------------------------- | ------------------------------------------------------------ |
|                                     |                                                              |
| 举栗                                |                                                              |
| 将多条命令的输出重定向到out.txt文件 | 1.普通模式ls -l > out.txt #>表示覆盖echo "test432" >> out.txt #>>表示追加cat test.txt >> out.txt2.使用组命令{ ls -l ;echo "test432";cat test.txt; }>out.txt(ls -l ;echo "test432";cat test.txt)>out.txt |
| 组命令与管道结合                    | (ls -l ;echo "test432";cat ../test.txt)\|wc -l               |

## 2.子进程

### 2.1 什么是子进程

 

子进程的概念是由父进程的概念引申而来的。在 Linux 系统中，系统运行的应用程序几乎都是从 init（pid为 1 的进程）进程派生而来的，所有这些应用程序都可以视为 init 进程的子进程，而 init 则为它们的父进程。

 

Shell 脚本是从上至下、从左至右依次执行的，即执行完一个命令之后再执行下一个。**如果在 Shell 脚本中遇到子脚本（即脚本嵌套，但是必须以新进程的方式运行）或者外部命令，就会向系统内核申请创建一个新的进程，以便在该进程中执行子脚本或者外部命令，这个新的进程就是子进程**。子进程执行完毕后才能回到父进程，才能继续执行父脚本中后续的命令及语句。

 

使用`pstree -p`命令就可以看到 init 及系统中其他进程的进程树信息（包括 pid）：

 

```bash
systemd(1)─┬─ModemManager(796)─┬─{ModemManager}(821)
            │                     └─{ModemManager}(882)
            ├─NetworkManager(975)─┬─{NetworkManager}(1061)
            │                       └─{NetworkManager}(1077)
            ├─abrt-watch-log(774)
            ├─abrt-watch-log(776)
            ├─abrtd(773)
            ├─accounts-daemon(806)─┬─{accounts-daemon}(839)
            │                        └─{accounts-daemon}(883)
            ├─alsactl(768)
            ├─at-spi-bus-laun(1954)─┬─dbus-daemon(1958)───{dbus-daemon}(1960)
            │                         ├─{at-spi-bus-laun}(1955)
            │                         ├─{at-spi-bus-laun}(1957)
            │                         └─{at-spi-bus-laun}(1959)
            ├─at-spi2-registr(1962)───{at-spi2-registr}(1965)
            ├─atd(842)
            ├─auditd(739)─┬─audispd(753)─┬─sedispatch(757)
            │               │                └─{audispd}(759)
            │               └─{auditd}(752)
```

 

### 2.2 创建子进程

| 创建子进程的方式                                             | 说明                                                         |                                                              |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 第一种只使用 fork() 函数，子进程和父进程几乎是一模一样的，父进程中的函数、变量(全局变量、局部变量)、文件描述符、别名等在子进程中仍然有效。我们将这种子进程称为**子 Shell（sub shell）** | 使用 fork() 函数创建一个子进程相当于对父进程进行了克隆，除了 PID（进程ID）等极少的参数不同外，子进程的一切都来自父进程，包括代码、数据、堆栈、打开的文件等，就连代码的执行位置（状态）都是一样的。但是，后期随着各自的发展轨迹不同，两者会变得不一样，但是在 fork() 出来的那一刻，两者都是一样的。 | **组命令、命令替换、管道**                                   |
| 第二种使用 fork() 和 exec() 函数，即使用 fork()创建子进程后立即调用 exec() 函数加载新的可执行文件，而不使用从父进程继承来的一切，子进程和父进程之间除了硬生生地维持一种“父子关系”外，再也没有任何联系了，它们就是两个完全不同的程序。 | 举栗： 在 ~/bin 目录下有两个可执行文件分别叫 a.out 和 b.out。现在运行 a.out，就会产生一个进程，比如叫做 A。在进程 A 中我又调用 fork() 函数创建了一个进程 B，那么 B 就是 A 的子进程，此时它们是一模一样的。但是，我调用 fork() 后立即又调用 exec() 去加载 b.out，这可就坏事了，B 进程中的一切（包括代码、数据、堆栈等）都会被销毁，然后再根据 b.out 重建建立一切。这样一折腾，B 进程除了 ID 没有变，其它的都变了，再也没有属于 A 的东西了。 | 以新进程的方式运行脚本文件，比如`bash ./test.sh;``chmod +x ./test.sh; ./test.sh`在当前 Shell 中使用 bash 命令启动新的 Shell |

### 2.3 子进程总结

子 Shell 虽然能使用父 Shell 的的一切，但是如果子 Shell 对数据做了修改，比如修改了全局变量，这种修改也只能停留在子 Shell，无法传递给父 Shell。**不管是子进程还是子 Shell，都是“传子不传父”。**

子 Shell 才是真正继承了父进程的一切，这才像“一个模子刻出来的”；普通子进程和父进程是完全不同的两个程序，只是维持着父子关系而已。

## 3.如何检测子shell与子进程

### PID

**echo ``$$``输出当前进程ID，echo ``$PPID``输出父shell ID**

|                             | 命令                                       | 结果        | 结论                                                         |
| --------------------------- | ------------------------------------------ | ----------- | ------------------------------------------------------------ |
| 输出当前进程与父进程ID      | echo `$$`;echo `$PPID`                     | 3445134450  |                                                              |
| 子进程形式输出进程ID子进程  | bashecho `$$`;echo `$PPID`exit             | 5288634451  | **在普通的子进程中，$ 被展开为子进程的 ID**                  |
| 组命令形式输出进程ID子shell | (echo `$$`;echo `$PPID`)                   | 3445134450  | 子shell和父shell中的ID是一样的这是因为$ 变量在子 Shell 中无效！Base 官方文档说，在普通的子进程中，$ 确实被展开为子进程的 ID；但是在**子 Shell 中，$ 却被展开成父进程的 ID** |
| 管道形式输出进程ID子shell   | echo "test" \| { echo `$$`;echo `$PPID`; } | 3445134450  |                                                              |
| 进程替换形式输出进程ID      | read < <(echo `$$` `$PPID`)$ echo $REPLY   | 34451 34450 |                                                              |

### Shell 嵌套

除了 `$`，Bash 还提供了另外两个环境变量——`SHLVL` 和 `BASH_SUBSHELL`，用它们来检测子 Shell 非常方便。

`SHLVL` 是记录多个 Bash 进程实例嵌套深度的累加器，每次进入一层普通的子进程，`SHLVL` 的值就加 1。而 `BASH_SUBSHELL` 是记录一个 Bash 进程实例中多个子 Shell（sub shell）嵌套深度的累加器，每次进入一层子 Shell，`BASH_SUBSHELL` 的值就加 1。



示例代码：

```bash
#### 输出变量 ####
echo "$SHLVL $BASH_SUBSHELL"
# 结果：1 0

#### 子进程形式输出变量子进程 ####
#!/bin/bash echo "$SHLVL $BASH_SUBSHELL"
*****************************************
bash
echo "$SHLVL $BASH_SUBSHELL"#2 0
bash ./test.sh #3 0
echo "$SHLVL $BASH_SUBSHELL"#2 0
chmod +x ./test.sh;./test.sh #3 0
echo "$SHLVL $BASH_SUBSHELL"#2 0
exit #退出内层Shell
echo "$SHLVL $BASH_SUBSHELL"#1 0

# `bash ./test.sh`和`./test.sh`这两种运行脚本的方式，在脚本运行期间会开启一个子进程，运行结束后立即退出子进程产生新进程时，SHLVL的值加1

#### 组命令形式输出变量子shell #####
(echo "$SHLVL $BASH_SUBSHELL")
# 结果：1 1
# 组命令、管道、命令替换这几种方式都会产生子 Shell

#### 管道形式输出变量子shell ####
echo "test" \| { echo "$SHLVL $BASH_SUBSHELL"; }
# 结果：1 1

#### 命令替换形式输出变量子shell ####
var=$(echo "$SHLVL $BASH_SUBSHELL")echo $var
# 结果：1 1

#### 四层组命令形式输出变量子shell ####
( ( ( (echo "$SHLVL $BASH_SUBSHELL") ) ) )
# 结果： 1 4

#### 进程替换形式输出变量 ####
read < <(echo "$SHLVL $BASH_SUBSHELL")
echo $REPLY
echo "hello" > >(echo "$SHLVL $BASH_SUBSHELL")
# 结果：1 0 1 0
# 进程替换只是借助文件在（）内部和外部命令之间传递数据，并没有创建子shell，`()`内部和外部的命令是在一个进程（也就是当前进程）中执行的
```

# Shell 中的特殊变量说明

[Linux后台运行命令nohub输出pid到文件（转） - EasonJim - 博客园](https://www.cnblogs.com/EasonJim/p/7750298.html): <https://www.cnblogs.com/EasonJim/p/7750298.html>

| 变量 | 说明 |
| --- | --- |
| `$$` | Shell本身的PID（ProcessID） |
| $! | Shell最后运行的后台Process的PID |
| $? | 最后运行的命令的结束代码（返回值） |
| $- | 使用Set命令设定的Flag一览 |
| `$*` | 所有参数列表。如"`$*`"用「"」括起来的情况、以"`$1 $2 … $n`"的形式输出所有参数。 |
| `$@` | 所有参数列表。如"$@"用「"」括起来的情况、以 " `$1 $2 … $n` " 的形式输出所有参数。 |
| $# | 添加到Shell的参数个数 |
| $0 | Shell本身的文件名 |
| `$1,$n` | 添加到 Shell 的各参数值。$1 是第 1 参数、$2 是第 2 参数…。 |

