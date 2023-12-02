---
title: PandocOverview
author: cupid5trick
created: 2022-07-20 15:01
tags: 
categories: ["misc"]
access: private
draft: true
lang:
- zh-cn
- en-us
abstract:
keywords:
---


# About pandoc

If you need to convert files from one markup format into another, pandoc is your swiss-army knife. Pandoc can convert between the following formats:

( ← = conversion from; → = conversion to; ↔︎  = conversion from and to)

## Lightweight markup formats



## HTML formats


- ↔︎  (X)HTML 4 
- ↔︎  HTML5

## Ebooks


- ↔︎  [EPUB](http://en.wikipedia.org/wiki/EPUB) version 2 or 3 
- ↔︎  [FictionBook2](http://www.fictionbook.org/index.php/Eng:XML_Schema_Fictionbook_2.1)

## Documentation formats


- → [GNU TexInfo](http://www.gnu.org/software/texinfo/) 
- ↔︎  [Haddock markup](http://www.haskell.org/haddock/doc/html/ch03s08.html)

## Roff formats


- ↔︎  [roff man](http://www.gnu.org/software/groff/groff.html) 
- → [roff ms](http://www.gnu.org/software/groff/groff.html)

## TeX formats


- ↔︎  [LaTeX](http://www.latex-project.org/) 
- → [ConTeXt](http://www.pragma-ade.nl/)

## XML formats


- ↔︎  [DocBook](http://www.docbook.org/) version 4 or 5 
- ↔︎  [JATS](https://jats.nlm.nih.gov/publishing/) 
- → [TEI Simple](https://github.com/TEIC/TEI-Simple) 
- → [OpenDocument XML](http://opendocument.xml.org/)

## Outline formats


- ↔︎  [OPML](http://dev.opml.org/spec2.html)

## Bibliography formats


- ↔︎  [BibTeX](http://tug.org/bibtex/) 
- ↔︎  [BibLaTeX](https://github.com/plk/biblatex) 
- ↔︎  [CSL JSON](https://citeproc-js.readthedocs.io/en/latest/csl-json/markup.html) 
- ↔︎  CSL YAML

## Word processor formats


- ↔︎  Microsoft Word [docx](https://en.wikipedia.org/wiki/Office_Open_XML) 
- ↔︎  Rich Text Format [RTF](http://en.wikipedia.org/wiki/Rich_Text_Format) 
- ↔︎  OpenOffice/LibreOffice [ODT](http://en.wikipedia.org/wiki/OpenDocument)

## Interactive notebook formats


- ↔︎  Jupyter notebook ([ipynb](https://nbformat.readthedocs.io/en/latest/))

## Page layout formats


- → [InDesign ICML](http://wwwimages.adobe.com/content/dam/acom/en/devnet/indesign/sdk/cs6/idml/idml-specification.pdf)

## Wiki markup formats


- ↔︎  [MediaWiki markup](http://www.mediawiki.org/wiki/Help:Formatting) 
- ↔︎  [DokuWiki markup](https://www.dokuwiki.org/wiki:syntax) 
- ← [TikiWiki markup](https://doc.tiki.org/Wiki-Syntax-Text#The_Markup_Language_Wiki-Syntax) 
- ← [TWiki markup](http://twiki.org/cgi-bin/view/TWiki/TextFormattingRules) 
- ← [Vimwiki markup](https://vimwiki.github.io/) 
- → [XWiki markup](https://www.xwiki.org/xwiki/bin/view/Documentation/UserGuide/Features/XWikiSyntax/) 
- → [ZimWiki markup](http://zim-wiki.org/manual/Help/Wiki_Syntax.html) 
- ↔︎  [Jira wiki markup](https://jira.atlassian.com/secure/WikiRendererHelpAction.jspa?section=all) 
- ← [Creole](http://www.wikicreole.org/)

## Slide show formats


- → [LaTeX Beamer](https://ctan.org/pkg/beamer) 
- → Microsoft [PowerPoint](https://en.wikipedia.org/wiki/Microsoft_PowerPoint) 
- → [Slidy](http://www.w3.org/Talks/Tools/Slidy) 
- → [reveal.js](http://lab.hakim.se/reveal-js/) 
- → [Slideous](http://goessner.net/articles/slideous/) 
- → [S5](http://meyerweb.com/eric/tools/s5/) 
- → [DZSlides](http://paulrouget.com/dzslides/)

## Data formats


- ← [CSV](https://tools.ietf.org/html/rfc4180) tables

## Custom formats


- ↔︎  [custom readers](https://pandoc.org/custom-readers.html) and [writers](https://pandoc.org/custom-writers.html) can be written in [Lua](http://www.lua.org/)

## PDF


- → via `pdflatex`, `lualatex`, `xelatex`, `latexmk`, `tectonic`, `wkhtmltopdf`, `weasyprint`, `prince`, `context`, or `pdfroff`.

Pandoc understands a number of useful markdown syntax extensions, including document metadata (title, author, date); footnotes; tables; definition lists; superscript and subscript; strikeout; enhanced ordered lists (start number and numbering style are significant); running example lists; delimited code blocks with syntax highlighting; smart quotes, dashes, and ellipses; markdown inside HTML blocks; and inline LaTeX. If strict markdown compatibility is desired, all of these extensions can be turned off.

LaTeX math (and even macros) can be used in markdown documents. Several different methods of rendering math in HTML are provided, including MathJax and translation to MathML. LaTeX math is converted (as needed by the output format) to unicode, native Word equation objects, MathML, or roff eqn.

Pandoc includes a powerful system for automatic citations and bibliographies. This means that you can write a citation like

```
[see @doe99, pp. 33-35; also @smith04, ch. 1]
```

and pandoc will convert it into a properly formatted citation using any of hundreds of [CSL](http://citationstyles.org/) styles (including footnote styles, numerical styles, and author-date styles), and add a properly formatted bibliography at the end of the document. The bibliographic data may be in [BibTeX](http://tug.org/bibtex/), [BibLaTeX](https://github.com/plk/biblatex), [CSL JSON](https://citeproc-js.readthedocs.io/en/latest/csl-json/markup.html), or CSL YAML format. Citations work in every output format.

There are many ways to customize pandoc to fit your needs, including a template system and a powerful system for writing filters.

Pandoc includes a Haskell library and a standalone command-line program. The library includes separate modules for each input and output format, so adding a new input or output format just requires adding a new module.

Pandoc is free software, released under the [GPL](http://www.gnu.org/copyleft/gpl.html). Copyright 2006–2021 [John MacFarlane](http://johnmacfarlane.net/).
# Creating a PDF

To produce a PDF, specify an output file with a `.pdf` extension:

```
pandoc test.txt -o test.pdf
```

By default, pandoc will use LaTeX to create the PDF, which requires that a LaTeX engine be installed (see [`--pdf-engine`](https://pandoc.org/MANUAL.html#typography#option--pdf-engine) below). Alternatively, pandoc can use ConTeXt, roff ms, or HTML as an intermediate format. To do this, specify an output file with a `.pdf` extension, as before, but add the [`--pdf-engine`](https://pandoc.org/MANUAL.html#typography#option--pdf-engine) option or [`-t context`](https://pandoc.org/MANUAL.html#typography#option--to), [`-t html`](https://pandoc.org/MANUAL.html#typography#option--to), or [`-t ms`](https://pandoc.org/MANUAL.html#typography#option--to) to the command line. The tool used to generate the PDF from the intermediate format may be specified using [`--pdf-engine`](https://pandoc.org/MANUAL.html#typography#option--pdf-engine).

You can control the PDF style using variables, depending on the intermediate format used: see [variables for LaTeX](https://pandoc.org/MANUAL.html#typography#variables-for-latex), [variables for ConTeXt](https://pandoc.org/MANUAL.html#typography#variables-for-context), [variables for `wkhtmltopdf`](https://pandoc.org/MANUAL.html#typography#variables-for-wkhtmltopdf), [variables for ms](https://pandoc.org/MANUAL.html#typography#variables-for-ms). When HTML is used as an intermediate format, the output can be styled using [`--css`](https://pandoc.org/MANUAL.html#typography#option--css).

To debug the PDF creation, it can be useful to look at the intermediate representation: instead of [`-o test.pdf`](https://pandoc.org/MANUAL.html#typography#option--output), use for example [`-s -o test.tex`](https://pandoc.org/MANUAL.html#typography#option--standalone) to output the generated LaTeX. You can then test it with `pdflatex test.tex` .

When using LaTeX, the following packages need to be available (they are included with all recent versions of [TeX Live](https://www.tug.org/texlive/)): [`amsfonts`](https://ctan.org/pkg/amsfonts), [`amsmath`](https://ctan.org/pkg/amsmath), [`lm`](https://ctan.org/pkg/lm), [`unicode-math`](https://ctan.org/pkg/unicode-math), [`iftex`](https://ctan.org/pkg/iftex), [`listings`](https://ctan.org/pkg/listings) (if the [`--listings`](https://pandoc.org/MANUAL.html#typography#option--listings) option is used), [`fancyvrb`](https://ctan.org/pkg/fancyvrb), [`longtable`](https://ctan.org/pkg/longtable), [`booktabs`](https://ctan.org/pkg/booktabs), [`graphicx`](https://ctan.org/pkg/graphicx) (if the document contains images), [`hyperref`](https://ctan.org/pkg/hyperref), [`xcolor`](https://ctan.org/pkg/xcolor), [`ulem`](https://ctan.org/pkg/ulem), [`geometry`](https://ctan.org/pkg/geometry) (with the `geometry` variable set), [`setspace`](https://ctan.org/pkg/setspace) (with `linestretch` ), and [`babel`](https://ctan.org/pkg/babel) (with `lang` ). If `CJKmainfont` is set, [`xeCJK`](https://ctan.org/pkg/xecjk) is needed. The use of `xelatex` or `lualatex` as the PDF engine requires [`fontspec`](https://ctan.org/pkg/fontspec). `lualatex` uses [`selnolig`](https://ctan.org/pkg/selnolig). `xelatex` uses [`bidi`](https://ctan.org/pkg/bidi) (with the `dir` variable set). If the `mathspec` variable is set, `xelatex` will use [`mathspec`](https://ctan.org/pkg/mathspec) instead of [`unicode-math`](https://ctan.org/pkg/unicode-math). The [`upquote`](https://ctan.org/pkg/upquote) and [`microtype`](https://ctan.org/pkg/microtype) packages are used if available, and [`csquotes`](https://ctan.org/pkg/csquotes) will be used for [typography](https://pandoc.org/MANUAL.html#typography#typography) if the `csquotes` variable or metadata field is set to a true value. The [`natbib`](https://ctan.org/pkg/natbib), [`biblatex`](https://ctan.org/pkg/biblatex), [`bibtex`](https://ctan.org/pkg/bibtex), and [`biber`](https://ctan.org/pkg/biber) packages can optionally be used for [citation rendering](https://pandoc.org/MANUAL.html#typography#citation-rendering-1). The following packages will be used to improve output quality if present, but pandoc does not require them to be present: [`upquote`](https://ctan.org/pkg/upquote) (for straight quotes in verbatim environments), [`microtype`](https://ctan.org/pkg/microtype) (for better spacing adjustments), [`parskip`](https://ctan.org/pkg/parskip) (for better inter-paragraph spaces), [`xurl`](https://ctan.org/pkg/xurl) (for better line breaks in URLs), [`bookmark`](https://ctan.org/pkg/bookmark) (for better PDF bookmarks), and [`footnotehyper`](https://ctan.org/pkg/footnotehyper) or [`footnote`](https://ctan.org/pkg/footnote) (to allow footnotes in tables).

# Word
`--reference-doc=` *FILE*

Use the specified file as a style reference in producing a docx or ODT file.

Docx

For best results, the reference docx should be a modified version of a docx file produced using pandoc. The contents of the reference docx are ignored, but its stylesheets and document properties (including margins, page size, header, and footer) are used in the new docx. If no reference docx is specified on the command line, pandoc will look for a file `reference.docx` in the user data directory (see [`--data-dir`](https://pandoc.org/MANUAL.html#variables-for-wkhtmltopdf#option--data-dir)). If this is not found either, sensible defaults will be used.

To produce a custom `reference.docx` , first get a copy of the default `reference.docx` : `pandoc -o custom-reference.docx --print-default-data-file reference.docx` . Then open `custom-reference.docx` in Word, modify the styles as you wish, and save the file. For best results, do not make changes to this file other than modifying the styles used by pandoc:

Paragraph styles:

-   Normal
-   Body Text
-   First Paragraph
-   Compact
-   Title
-   Subtitle
-   Author
-   Date
-   Abstract
-   Bibliography
-   Heading 1
-   Heading 2
-   Heading 3
-   Heading 4
-   Heading 5
-   Heading 6
-   Heading 7
-   Heading 8
-   Heading 9
-   Block Text
-   Source Code
-   Footnote Text
-   Definition Term
-   Definition
-   Caption
-   Table Caption
-   Image Caption
-   Figure
-   Captioned Figure
-   TOC Heading

Character styles:

-   Default Paragraph Font
-   Body Text Char
-   Verbatim Char
-   Footnote Reference
-   Hyperlink
-   Section Number

Table style:

-   Table
# Pandoc Filter
[Pandoc - Pandoc Lua Filters](https://pandoc.org/lua-filters.html): <https://pandoc.org/lua-filters.html>
[Pandoc - Pandoc filters](https://pandoc.org/filters.html): <https://pandoc.org/filters.html>
Debug lua filter:
[Pandoc - Pandoc Lua Filters](https://pandoc.org/lua-filters.html#debugging-lua-filters): <https://pandoc.org/lua-filters.html#debugging-lua-filters>
[Text.Pandoc.Definition](https://hackage.haskell.org/package/pandoc-types-1.22.2.1/docs/Text-Pandoc-Definition.html): <https://hackage.haskell.org/package/pandoc-types-1.22.2.1/docs/Text-Pandoc-Definition.html>
第三方 pandoc filter:
[Pandoc Filters · jgm/pandoc Wiki](https://github.com/jgm/pandoc/wiki/Pandoc-Filters): <https://github.com/jgm/pandoc/wiki/Pandoc-Filters>

Pandoc 在调用 filter 之前会设置一些环境变量：

[Pandoc - Pandoc filters](https://pandoc.org/filters.html#environment-variables): <https://pandoc.org/filters.html#environment-variables>
Pandoc 对 lua filter 的支持更好一些，lua filter 可以通过全局变量获取到很多 pandoc 状态信息
[Pandoc - Pandoc Lua Filters](https://pandoc.org/lua-filters.html#global-variables): <https://pandoc.org/lua-filters.html#global-variables>
这些全局变量可以分为三类。
- 通过类似环境变量的模式传递的状态信息（lua filter 通过全局变量的方式把 pandoc 状态暴露给 lua 脚本，其他语言都是通过环境变量来传递）。主要包括 writer 的输出格式、READER_OPTIONS、WRITER_OPTIONS、reader 和 writer 共享的一些状态信息 ( PANDOC_STATE )
- Pandoc 内置 api。包括 pandoc、lpeg、re。
- Pandoc 版本和 pandoc API 版本。
环境变量类

`FORMAT`

代表 pandoc writer 的输出格式。

`PANDOC_READER_OPTIONS`

传递给 pandoc 解析器的选项，数据格式是一个 ReaderOptions 类型： ([ReaderOptions](https://pandoc.org/lua-filters.html#type-readeroptions))

`PANDOC_WRITER_OPTIONS`

传递给 pandoc writer 的选项，数据结构是一个 WriterOptions 类型。因为这些全局变量是 pandoc 通过跨语言机制传递到 lua 的，修改这些全局变量不会起作用。 ([WriterOptions](https://pandoc.org/lua-filters.html#type-writeroptions))

This variable is also set in custom writers.

_Since: pandoc 2.17_


`PANDOC_SCRIPT_FILE`

The name used to involve the filter. This value can be used to find files relative to the script file. This variable is also set in custom writers.

`PANDOC_STATE`

Reader 和 writer 之间共享的状态，pandoc 用 state 对象收集和传递信息。它的数据结构是 CommonState，同样是不可变的。[CommonState](https://pandoc.org/lua-filters.html#type-commonstate) and is read-only.

API 类
`pandoc`

The _pandoc_ module, described in the next section, is available through the global `pandoc`. The other modules described herein are loaded as subfields under their respective name.

`lpeg`

This variable holds the `lpeg` module, a package based on Parsing Expression Grammars (PEG). It provides excellent parsing utilities and is documented on the official [LPeg homepage](http://www.inf.puc-rio.br/~roberto/lpeg/). Pandoc uses a built-in version of the library, unless it has been configured by the package maintainer to rely on a system-wide installation.

Note that the result of `require 'lpeg'` is not necessarily equal to this value; the `require` mechanism prefers the system’s lpeg library over the built-in version.

`re`

Contains the LPeg.re module, which is built on top of LPeg and offers an implementation of a [regex engine](http://www.inf.puc-rio.br/~roberto/lpeg/re.html). Pandoc uses a built-in version of the library, unless it has been configured by the package maintainer to rely on a system-wide installation.

Note that the result of `require 're` is not necessarily equal to this value; the `require` mechanism prefers the system’s lpeg library over the built-in version.

版本类

`PANDOC_VERSION`

Contains the pandoc version as a [Version](https://pandoc.org/lua-filters.html#type-version) object which behaves like a numerically indexed table, most significant number first. E.g., for pandoc 2.7.3, the value of the variable is equivalent to a table `{2, 7, 3}` . Use `tostring(PANDOC_VERSION)` to produce a version string. This variable is also set in custom writers.

`PANDOC_API_VERSION`

Contains the version of the pandoc-types API against which pandoc was compiled. It is given as a numerically indexed table, most significant number first. E.g., if pandoc was compiled against pandoc-types 1.17.3, then the value of the variable will behave like the table `{1, 17, 3}` . Use `tostring(PANDOC_API_VERSION)` to produce a version string. This variable is also set in custom writers.

Pandoc 2.19.2 通过默认命令设置的环境变量:

```json
{
  "PANDOC_VERSION": "2.19.2",
  "PANDOC_READER_OPTIONS": {
    "extensions": [
      "all_symbols_escapable",
      "auto_identifiers",
      "backtick_code_blocks",
      "blank_before_blockquote",
      "blank_before_header",
      "bracketed_spans",
      "citations",
      "definition_lists",
      "es\ncaped_line_breaks",
      "example_lists",
      "fancy_lists",
      "fenced_code_attributes",
      "fenced_code_blocks",
      "fenced_divs",
      "footnotes",
      "grid_tables",
      "header_attributes",
      "implicit_figures",
      "implicit_header_references",
      "inline_code_attributes",
      "inline_notes",
      "intrawor\nd_underscores",
      "latex_macros",
      "line_blocks",
      "link_attributes",
      "markdown_in_html_blocks",
      "multiline_tables",
      "native_divs",
      "native_spans",
      "pandoc_title_block",
      "pipe_tables",
      "raw_attribute",
      "raw_html",
      "raw_tex",
      "shortcut_reference_links",
      "simple_tables",
      "smart",
      "space_in_atx_header",
      "startnum",
      "strikeout",
      "subscript",
      "superscript",
      "task_lists",
      "table_captions",
      "tex_math_dollars",
      "yaml_metadata_block"
    ],
    "standalone": false,
    "columns": 72,
    "tab-stop": 4,
    "indented-code-classes": [],
    "abbreviations": [
      "Apr.\n",
      "Aug.",
      "Bros.",
      "Capt.",
      "Co.",
      "Corp.",
      "Dec.",
      "Dr.",
      "Feb.",
      "Fr.",
      "Gen.",
      "Gov.",
      "Hon.",
      "Inc.",
      "Jan.",
      "Jr.",
      "Jul.",
      "Jun.",
      "Ltd.",
      "M.A.",
      "M.D.",
      "Mar.",
      "Mr.",
      "Mrs.",
      "Ms.",
      "No.",
      "Nov.",
      "Oct.",
      "Ph.D.",
      "Pres.",
      "Prof.",
      "Rep.",
      "Rev.",
      "Sen.",
      "Sep.",
      "Sept.",
      "Sgt.",
      "Sr.",
      "St.",
      "aet.",
      "aetat.",
      "al.",
      "bk.",
      "c.",
      "cf.",
      "ch.",
      "chap.",
      "chs.",
      "col.",
      "cp.",
      "d.",
      "e.g.",
      "ed.",
      "eds.",
      "esp.",
      "f.",
      "fasc.",
      "ff.",
      "fig.",
      "fl.",
      "fol.",
      "fols.",
      "i.e.",
      "ill.",
      "incl.",
      "n.",
      "n.b.",
      "nn.",
      "p.",
      "pp.",
      "pt.",
      "q.v.",
      "s.v.",
      "s.vv.",
      "saec.",
      "sec.",
      "univ.",
      "viz.",
      "vol.",
      "vs."
    ],
    "default-image-extension": "",
    "track-changes": "accept-changes",
    "strip-comments": false
  },
  "PANDOC_WRITER_OPTIONS": {}
}
```
# 个人案例

Markdown 论文转 word

```bash
pandoc -s --bibliography D:\software\pandoc\test\zotero-bib-csl1.json --citeproc --csl D:\XduStudy\毕设\数据采样\论文\templates\csl\styles\china-national-standard-gb-t-7714-2015-numeric-en.csl --from=markdown --to=docx D:\software\pandoc\test\essay.md -o D:\software\pandoc\test\essay.docx --reference-doc=D:\software\pandoc\test\template.docx
```


```bash
    pandoc -N --template=template.tex --variable mainfont="Palatino" --variable sansfont="Helvetica" --variable monofont="Menlo" --variable fontsize=12pt --variable version=2.0 MANUAL.txt --pdf-engine=xelatex --toc -o example14.pdf
    
    ## macos
    # Helvetica: the default font on macos
    # Palatino: the name of windows font "Palatino Linotype" on macos 
    pandoc -N --template=C:\Users\18488\AppData\Roaming\pandoc\templates\default.latex --variable mainfont="Palatino" --variable sansfont="Helvetica" --variable monofont="Menlo" --variable fontsize=12pt --variable version=2.0 --variable CJKmainfont=SimSun C:\Users\18488\Desktop\Current_Learning\java\language_learning\lang\jvm\自动内存管理.md --pdf-engine=xelatex --toc -o C:\Users\18488\Desktop\Current_Learning\java\language_learning\lang\jvm\自动内存管理.pdf
    
    ## windows
    pandoc --from=markdown --to=pdf -N --template=D:\software\pandoc\templates\default.latex --variable mainfont="Palatino Linotype" --variable sansfont="Arial" --variable monofont="Consolas" --variable mathfont="Asana Math" --variable fontsize=11pt --variable version=2.0 --variable CJKmainfont="Source Han Serif SC" --variable CJKoptions="ItalicFont=KaiTi,BoldFont=Source Han Sans SC" --variable geometry="left=.7in,right=.7in,top=1in,bottom=1in" --variable documentclass="book" --variable papersize=a4 --variable secnumdepth=4 --variable block-headings=true --toc-depth 6 C:\Users\18488\Desktop\Current_Learning\java\language_learning\lang\jvm\自动内存管理.md --pdf-engine=xelatex --toc -o C:\Users\18488\Desktop\Current_Learning\java\language_learning\lang\jvm\自动内存管理.pdf
    
    pandoc --from=markdown --to docx  交互式数据分析采样算法的设计与实现.-o my-template.docx --reference-doc=lwj-essay.docx
```

## 处理交叉引用

[tomduck/pandoc-fignos: A pandoc filter for numbering figures and figure references.](https://github.com/tomduck/pandoc-fignos): <https://github.com/tomduck/pandoc-fignos>

[tomduck/pandoc-eqnos: A pandoc filter for numbering equations and equation references.](https://github.com/tomduck/pandoc-eqnos): <https://github.com/tomduck/pandoc-eqnos>

[tomduck/pandoc-secnos: A pandoc filter for numbering section references.](https://github.com/tomduck/pandoc-secnos): <https://github.com/tomduck/pandoc-secnos>

[tomduck/pandoc-tablenos: A pandoc filter for numbering tables and table references.](https://github.com/tomduck/pandoc-tablenos): <https://github.com/tomduck/pandoc-tablenos>

[tomduck/pandoc-xnos: Library code for pandoc-fignos/eqnos/tablenos/secnos.](https://github.com/tomduck/pandoc-xnos): <https://github.com/tomduck/pandoc-xnos>

##  元数据与变量

前面涉及到了很多 `yaml` 文件里的参数。这里将常见的 `yaml` 参数条列如下，并简单说明各自的作用。

```yaml
title: 标题                     # 指定标题
author: 作者                    # 指定作者
numbersections: true           # true 表示给文中的部分编号，默认值为 false
subparagraph: yes             # 要在 LaTeX head 里用 titlesec 这个包，必须加这一行
fontsize: 12pt                # 指定字号大小，默认接受10pt、11pt、12pt
toc: true                     # 生成目录
toc-title: "目录"             # 指定目录标题
lot: true                     # 生成表格目录
lof: true                     # 生成图片目录
abstract-title: 摘要
toc-title: 目录
biblio-title: 参考文献
# 图列表的标题, Latex: \renewcommand{\listfigurename}{List of plots}
lof-title: |
	List of Plots
# 表格列表的标题, Latex: \renewcommand{\listtablename}{Tables}
lot-title: |
	List of Tables
tableTitle: "表"      # 表格标题的前缀，pandoc-crossref 与 pandoc-tablenos 中可用
figureTitle: "图"     # 图片标题的前缀，pandoc-crossref 与 pandoc-fignos 中可用
tabPrefix: "表"       # 文中对表格引用的前缀，pandoc-crossref 可用
figPrefix: "表"       # 文中对图片引用的前缀，pandoc-crossref 可用
header-includes:      # 要加进 LaTeX文件的命令，建议放在一个单独的 preamble 文件里
```

# Trouble Shot
## 导出 markdown 时更新媒体文件路径
