---
draft: true
categories: ["misc"]
lang: en
title: Pandoc - Demos
viewport: width=device-width, initial-scale=1.0
---

# Homepage

**[Pandoc Homepage](https://pandoc.org)** :   **a universal document converter**

-   [About](https://pandoc.org/index.html)

-   [Installing](https://pandoc.org/installing.html)

-   [Demos](https://pandoc.org/demos.html)

-   [Documentation](#)
    -   [Getting started](https://pandoc.org/getting-started.html)
    -   [User\'s Guide](https://pandoc.org/MANUAL.html)
    -   [User\'s Guide (PDF)](https://pandoc.org/MANUAL.pdf)
    -   [Contributing](https://pandoc.org/CONTRIBUTING.html)
    -   [FAQ](https://pandoc.org/faqs.html)
    -   [Press](https://pandoc.org/press.html)
    -   [Filters](https://pandoc.org/filters.html)
    -   [Lua filters](https://pandoc.org/lua-filters.html)
    -   [Custom readers](https://pandoc.org/custom-readers.html)
    -   [Custom writers](https://pandoc.org/custom-writers.html)
    -   [Making an ebook](https://pandoc.org/epub.html)
    -   [Emacs Org mode support](https://pandoc.org/org.html)
    -   [JATS support](https://pandoc.org/jats.html)
    -   [Using the Pandoc API](https://pandoc.org/using-the-pandoc-api.html)
    -   [API documentation](http://hackage.haskell.org/package/pandoc)
    
-   [Help](https://pandoc.org/help.html)

-   [Extras](https://pandoc.org/extras.html)

-   [Releases](https://pandoc.org/releases.html)

    

# Try pandoc online

You can try pandoc online [here](http://johnmacfarlane.net/pandoc/try)https://pandoc.org/.

# Examples

To see the output created by each of the commands below, click on the
name of the output file:

1.  HTML fragment:
```

pandoc MANUAL.txt -o example1.html

```
2.  Standalone HTML file:
```

pandoc -s MANUAL.txt -o example2.html

```
3.  HTML with table of contents, CSS, and custom footer:
```

pandoc -s --toc -c pandoc.css -A footer.html MANUAL.txt -o example3.html

```
4.  LaTeX:
```

pandoc -s MANUAL.txt -o example4.tex

```
5.  From LaTeX to markdown:
```

pandoc -s example4.tex -o example5.text

```
6.  reStructuredText:
```

pandoc -s -t rst --toc MANUAL.txt -o example6.text

```
7.  Rich text format (RTF)https://pandoc.org/:
```

pandoc -s MANUAL.txt -o example7.rtf

```
8.  Beamer slide show:
```

pandoc -t beamer SLIDES -o example8.pdf

```
9.  DocBook XML:
```

pandoc -s -t docbook MANUAL.txt -o example9.db

```
10. Man page:
```

pandoc -s -t man pandoc.1.md -o example10.1

```
11. ConTeXt:
```

pandoc -s -t context MANUAL.txt -o example11.tex

```
12. Converting a web page to markdown:
```

pandoc -s -r html http://www.gnu.org/software/make/ -o example12.text

pandoc -s -r html -t pdf --pdf-engine "C:\Program Files\wkhtmltopdf\bin\wkhtmltopdf" http://localhost:3000/latex-studio -o "C:\Users\18488\Desktop\coder equipment\pandoc\latex-studio-examples.pdf"

```
13. From markdown to PDF:
```

pandoc MANUAL.txt --pdf-engine=xelatex -o example13.pdf

```
14. PDF with numbered sections and a custom LaTeX header:

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

15. ipynb (Jupyter notebook)https://pandoc.org/:

```bash
pandoc example15.md -o example15.ipynb
```

16. HTML slide shows:
```

pandoc -s --mathml -i -t dzslides SLIDES -o example16a.html

pandoc -s --webtex -i -t slidy SLIDES -o example16b.html

pandoc -s --mathjax -i -t revealjs SLIDES -o example16d.html

```
17. TeX math in HTML:

```
pandoc math.text -s -o mathDefault.html

pandoc math.text -s --mathml  -o mathMathML.html

pandoc math.text -s --webtex  -o mathWebTeX.html

pandoc math.text -s --mathjax -o mathMathJax.html

pandoc math.text -s --katex   -o mathKaTeX.html

```
18. Syntax highlighting of delimited code blocks:
```

pandoc code.text -s --highlight-style pygments -o example18a.html

pandoc code.text -s --highlight-style kate -o example18b.html

pandoc code.text -s --highlight-style monochrome -o example18c.html

pandoc code.text -s --highlight-style espresso -o example18d.html

pandoc code.text -s --highlight-style haddock -o example18e.html

pandoc code.text -s --highlight-style tango -o example18f.html

pandoc code.text -s --highlight-style zenburn -o example18g.html

```
19. GNU Texinfo, converted to info and HTML formats:

```
pandoc MANUAL.txt -s -o example19.texi

makeinfo --no-validate --force example19.texi -o example19.info

makeinfo --no-validate --force example19.texi --html -o example19

```
20. OpenDocument XML:
```

pandoc MANUAL.txt -s -t opendocument -o example20.xml

```
21. ODT (OpenDocument Text, readable by OpenOffice)https://pandoc.org/:
```

pandoc MANUAL.txt -o example21.odt

```
22. MediaWiki markup:
```

pandoc -s -t mediawiki --toc MANUAL.txt -o example22.wiki

```
23. EPUB ebook:
```

pandoc MANUAL.txt -o MANUAL.epub

```
24. Markdown citations:
```

pandoc -s --bibliography biblio.bib --citeproc CITATIONS -o example24a.html

pandoc -s --bibliography biblio.json --citeproc --csl chicago-fullnote-bibliography.csl CITATIONS -o example24b.html

pandoc -s --bibliography biblio.yaml --citeproc --csl ieee.csl CITATIONS -t man -o example24c.1

```
25. Textile writer:
```

pandoc -s MANUAL.txt -t textile -o example25.textile

```
26. Textile reader:
```

pandoc -s example25.textile -f textile -t html -o example26.html

```
27. Org-mode:
```

pandoc -s MANUAL.txt -o example27.org

```
28. AsciiDoc:
```

pandoc -s MANUAL.txt -t asciidoc -o example28.txt

```
29. Word docx:
```

pandoc -s MANUAL.txt -o example29.docx

```
30. LaTeX math to docx:
```

pandoc -s math.tex -o example30.docx

```
31. DocBook to markdown:
```

pandoc -f docbook -t markdown -s howto.xml -o example31.text

```
32. MediaWiki to html5:
```

pandoc -f mediawiki -t html5 -s haskell.wiki -o example32.html

```
33. Custom writer:
```

pandoc -t sample.lua example33.text -o example33.html

```
34. Docx with a reference docx:
```

pandoc --reference-doc twocolumns.docx -o UsersGuide.docx MANUAL.txt

```
35. Docx to markdown, including math:
```

pandoc -s example30.docx -t markdown -o example35.md

```
36. EPUB to plain text:
```

pandoc MANUAL.epub -t plain -o example36.text

```
37. Using a template to produce a table from structured data:
```

pandoc fishwatch.yaml -t rst --template fishtable.rst -o fish.rst # see also the partial species.rst

```
38. Converting a bibliography from BibTeX to CSL JSON:
```

pandoc biblio.bib -t csljson -o biblio2.json

```
39. Producing a formatted version of a bibliography:
```

pandoc biblio.bib --citeproc --csl ieee.csl -s -o biblio.html


```

# 网络教程



[citeproc: Generates citations and bibliography from CSL styles.](https://hackage.haskell.org/package/citeproc)

[如何使用Pandoc将文档转化为docx - 知乎](https://zhuanlan.zhihu.com/p/49530707)

[利用pandoc将markdown转换为word文档 - kofyou - 博客园](https://pandoc.org/https://www.cnblogs.com/kofyou/p/14932700.html)

[用pandoc生成大型中文文档的痛点与解决方案 | Chunyu Ge](https://ge-chunyu.github.io/posts/2019-11-pandoc-large-document/)

