---
draft: true
---
## Obsidian Pandoc
Obsidian-pandoc
[GitHub - OliverBalfour/obsidian-pandoc](https://github.com/OliverBalfour/obsidian-pandoc): https://github.com/OliverBalfour/obsidian-pandoc
Obsidian-pandoc-reference-list
[GitHub - mgmeyers/obsidian-pandoc-reference-list](https://github.com/mgmeyers/obsidian-pandoc-reference-list): https://github.com/mgmeyers/obsidian-pandoc-reference-list
Obsidian-enhancing-export
[Obsidian Enhancing Export](https://github.com/mokeyish/obsidian-enhancing-export): https://github.com/mokeyish/obsidian-enhancing-export

### Installation

1.  First install the latest `pandoc` (2.19+), and then add `pandoc` path to environment variable `PATH` or set absolute path of `pandoc` in the plugin setting view.
    
    See more details in [installing | pandoc](https://pandoc.org/installing.html)
    
2.  Search `obsidian-enhancing-export` in the community plugin of obsidian, and install it.
    

### Customize export commands
[Customize export commands](https://github.com/mokeyish/obsidian-enhancing-export#customize-export-commands)

You can customize your export command by yourself, click `add` in the plugin setting view and then choose template `custom` to add new custom configuration.

### Variables
[Variables](https://github.com/mokeyish/obsidian-enhancing-export#variables)

You can use `${variables}` in custom export command, their values are:

| Key | Value |
| --- | --- |
| `${outputPath}` | Output file path after export. For example， if your export to location `/User/aaa/Documents/test.pdf` , then `${outputDir}` will be replace that path. |
| `${outputDir}` | Output directory of saved exported file，It will be `/User/aaa/Documents` in above case. |
| `${outputFileName}` | File name (without extension) of the saved exported file. It will be `test` in above case. |
| `${outputFileFullName}` | File name (with extension) of the saved exported file. It will be `test.pdf` in above case. |
| `${currentPath}` | Path of currently edited file. For example, if your are editing `/User/aaa/Documents/readme.md` , the the value will be `/User/aaa/Documents/readme.md` . |
| `${currentDir}` | Current directory of currently edited file, It will be `/User/aaa/Documents` in above case. |
| `${currentFileName}` | Filename without extension of currently edited file, It will be `readme` in above case. |
| `${currentFileFullName}` | Filename with extension of currently edited file. It will be `readme.md` in above case. |
| `${vaultDir}` | The obsidian current vaultDir. |

### Finally
[Finally](https://github.com/mokeyish/obsidian-enhancing-export#finally)

-   Welcome to provide more command templates to . [.](https://github.com/mokeyish/obsidian-enhancing-export/blob/master/src/export_command_templates.ts)
-   Feel free to file an issue for any questions.