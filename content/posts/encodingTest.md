---
author: gyq@22031212512
categories:
- misc
draft: true
Export:
  hugo: |
    pandoc -f markdown --resource-path="D:`\LearnProgramming`{=tex}`\javascript`{=tex}`\code`{=tex}`\obsidian`{=tex}`\documents`{=tex}\90-MISC`\TEMP`{=tex}" --resource-path="D:`\LearnProgramming`{=tex}`\javascript`{=tex}`\code`{=tex}`\obsidian`{=tex}`\documents`{=tex}\90-MISC`\TEMP`{=tex}\_attachments`\算法2`{=tex}-报告" --lua-filter="D:`\software`{=tex}`\pandoc`{=tex}`\filter`{=tex}`\lua`{=tex}-filters`\src`{=tex}`\markdown`{=tex}.lua" -s -o "D:`\LearnProgramming`{=tex}`\javascript`{=tex}`\code`{=tex}`\obsidian`{=tex}`\documents`{=tex}.output`\pandoc`{=tex}`\hugo`{=tex}`\算法2`{=tex}-报告.md" -t commonmark_x-attributes --log="D:`\LearnProgramming`{=tex}`\javascript`{=tex}`\code`{=tex}`\obsidian`{=tex}`\documents`{=tex}.output`\pandoc`{=tex}`\hugo`{=tex}`\算法2`{=tex}-报告.md.log" --verbose --extract-media="D:`\LearnProgramming`{=tex}`\javascript`{=tex}`\code`{=tex}`\obsidian`{=tex}`\documents`{=tex}.output`\pandoc`{=tex}`\hugo`{=tex}`\算法2`{=tex}-报告" "D:`\LearnProgramming`{=tex}`\javascript`{=tex}`\code`{=tex}`\obsidian`{=tex}`\documents`{=tex}\90-MISC`\TEMP`{=tex}`\算法2`{=tex}-报告.md"
  lua_ast_debug: |
    pandoc -f markdown --resource-path="D:`\LearnProgramming`{=tex}`\javascript`{=tex}`\code`{=tex}`\obsidian`{=tex}`\documents`{=tex}\90-MISC`\TEMP`{=tex}" --resource-path="D:`\LearnProgramming`{=tex}`\javascript`{=tex}`\code`{=tex}`\obsidian`{=tex}`\documents`{=tex}\90-MISC`\TEMP`{=tex}\_attachments`\算法2`{=tex}-报告" --lua-filter="D:`\software`{=tex}`\pandoc`{=tex}`\filter`{=tex}`\lua`{=tex}-filters`\src`{=tex}`\markdown`{=tex}.lua" -o "D:`\LearnProgramming`{=tex}`\javascript`{=tex}`\code`{=tex}`\obsidian`{=tex}`\documents`{=tex}.output`\pandoc`{=tex}`\hugo`{=tex}`\encodingTest`{=tex}.json" -t json --log="D:`\LearnProgramming`{=tex}`\javascript`{=tex}`\code`{=tex}`\obsidian`{=tex}`\documents`{=tex}.output`\pandoc`{=tex}`\hugo`{=tex}`\encodingTest`{=tex}.json.log" --verbose --extract-media="D:`\LearnProgramming`{=tex}`\javascript`{=tex}`\code`{=tex}`\obsidian`{=tex}`\documents`{=tex}.output`\pandoc`{=tex}`\hugo`{=tex}" "D:`\software`{=tex}`\pandoc`{=tex}`\filter`{=tex}`\python`{=tex}-filters`\test`{=tex}`\encodingTest`{=tex}.md"
  lua_debug: |
    pandoc -f markdown --resource-path="D:`\LearnProgramming`{=tex}`\javascript`{=tex}`\code`{=tex}`\obsidian`{=tex}`\documents`{=tex}\90-MISC`\TEMP`{=tex}" --resource-path="D:`\LearnProgramming`{=tex}`\javascript`{=tex}`\code`{=tex}`\obsidian`{=tex}`\documents`{=tex}\90-MISC`\TEMP`{=tex}\_attachments`\算法2`{=tex}-报告" --lua-filter="D:`\software`{=tex}`\pandoc`{=tex}`\filter`{=tex}`\lua`{=tex}-filters`\src`{=tex}`\markdown`{=tex}.lua" -s -o "D:`\LearnProgramming`{=tex}`\javascript`{=tex}`\code`{=tex}`\obsidian`{=tex}`\documents`{=tex}.output`\pandoc`{=tex}`\hugo`{=tex}`\encodingTest`{=tex}.md" -t commonmark_x-attributes+yaml_metadata_block --log="D:`\LearnProgramming`{=tex}`\javascript`{=tex}`\code`{=tex}`\obsidian`{=tex}`\documents`{=tex}.output`\pandoc`{=tex}`\hugo`{=tex}`\encodingTest`{=tex}.md.log" --verbose --extract-media="D:`\LearnProgramming`{=tex}`\javascript`{=tex}`\code`{=tex}`\obsidian`{=tex}`\documents`{=tex}.output`\pandoc`{=tex}`\hugo`{=tex}" "D:`\software`{=tex}`\pandoc`{=tex}`\filter`{=tex}`\python`{=tex}-filters`\test`{=tex}`\encodingTest`{=tex}.md"
  pdf: |
    pandoc -f markdown --embed-resources --standalone --metadata title="算法 2 练习题目及技术报告" -s -o ".`\算法`{=tex}-报告.pdf" -t pdf --pdf-engine xelatex --template "D:`\LearnProgramming`{=tex}`\javascript`{=tex}`\code`{=tex}`\obsidian`{=tex}`\documents`{=tex}`\template`{=tex}`\pandoc`{=tex}`\default`{=tex}.latex" --defaults "D:`\LearnProgramming`{=tex}`\javascript`{=tex}`\code`{=tex}`\obsidian`{=tex}`\documents`{=tex}`\template`{=tex}`\pandoc`{=tex}`\option`{=tex}\_files`\latex`{=tex}.yaml" "D:`\XduStudy`{=tex}`\硕`{=tex}2022秋课程`\算法2`{=tex}`\报告`{=tex}`\算法2`{=tex}-报告.md"
  python_debug: |
    pandoc -t json --resource-path="D:`\LearnProgramming`{=tex}`\javascript`{=tex}`\code`{=tex}`\obsidian`{=tex}`\documents`{=tex}\90-MISC`\TEMP`{=tex}" --resource-path="D:`\LearnProgramming`{=tex}`\javascript`{=tex}`\code`{=tex}`\obsidian`{=tex}`\documents`{=tex}\90-MISC`\TEMP`{=tex}\_attachments`\算法2`{=tex}-报告" -s --extract-media="D:`\LearnProgramming`{=tex}`\javascript`{=tex}`\code`{=tex}`\obsidian`{=tex}`\documents`{=tex}.output`\pandoc`{=tex}`\hugo`{=tex}" D:`\software`{=tex}`\pandoc`{=tex}`\filter`{=tex}`\python`{=tex}-filters`\test`{=tex}`\encodingTest`{=tex}.md -o "D:`\LearnProgramming`{=tex}`\javascript`{=tex}`\code`{=tex}`\obsidian`{=tex}`\documents`{=tex}.output`\pandoc`{=tex}`\hugo`{=tex}`\encodingTest`{=tex}.json" --filter ./filter.py
  test-json: |
    pandoc -t json "D:`\LearnProgramming`{=tex}`\javascript`{=tex}`\code`{=tex}`\obsidian`{=tex}-plugins`\internetPlugins`{=tex}`\obsimian`{=tex}`\test`{=tex}`\vault`{=tex}`\encodingTest`{=tex}.md"
title: 算法 2 练习题目及技术报告
---

![](/media/9de51ebe16ab8057302807b7403a367e5f3bba74.png)

[![image](/media/d83986a42802999661b9488dc69568480633c555.png)](/media/d83986a42802999661b9488dc69568480633c555.png)

[![image](/media/30b33ac96f8b9bd8811db7ebc40f034dc0937df0.png)](/media/30b33ac96f8b9bd8811db7ebc40f034dc0937df0.png)

根据图中形成的线路，我们可以选择一条路径看看它的效果

[![image](/media/9c9a43ea3401827cd44f717430c3102716b08bb0.png)](/media/9c9a43ea3401827cd44f717430c3102716b08bb0.png)

[![image](/media/f83a728f76e1d11cd3a759720877789a52a896b3.png)](/media/f83a728f76e1d11cd3a759720877789a52a896b3.png)

[![image](/media/0dcf136c34cabfd5dd7f96a0e022dbf9fa4218f1.png)](/media/0dcf136c34cabfd5dd7f96a0e022dbf9fa4218f1.png)

[![image](/media/733f2c437bd9f28553d287adcf9ec2744c30af56.png)](/media/733f2c437bd9f28553d287adcf9ec2744c30af56.png)
[![image](/media/0b7917650812d906206e8e07b4f546c63033dec8.png)](/media/0b7917650812d906206e8e07b4f546c63033dec8.png)
[![image](/media/70a2519c1df60e3fc4a75ac4c83b96905c855712.png)](/media/70a2519c1df60e3fc4a75ac4c83b96905c855712.png)
[![image](/media/78a360bbc28674e92a357961b5f6c36594ac3d48.png)](/media/78a360bbc28674e92a357961b5f6c36594ac3d48.png)
[![image](/media/01f3071d7dad7dd63409fd6c421dd0a61461516e.png)](/media/01f3071d7dad7dd63409fd6c421dd0a61461516e.png)

- [Git是怎样生成diff的：Myers算法](https://cjting.me/misc/how-git-generate-diff/): https://cjting.me/misc/how-git-generate-diff/
- [Myers论文](http://xmailserver.org/diff2.pdf): http://xmailserver.org/diff2.pdf
- [Myers 差分算法 (Myers Difference Algorithm)](https://blog.csdn.net/Coo123_/article/details/87280401): https://blog.csdn.net/Coo123\_/article/details/87280401
- [Myers Diff Algorithm - Code & Interactive Visualization](http://blog.robertelder.org/diff-algorithm/): http://blog.robertelder.org/diff-algorithm/
- [github-google开源工具：java-diff-utils](https://github.com/dnaumenko/java-diff-utils): https://github.com/dnaumenko/java-diff-utils
- [demo](https://github.com/chenshinan/csn-java-exercises/blob/master/src/main/java/com/chenshinan/exercises/javaDiffUtils/mydiff/MyersDiff.java): https://github.com/chenshinan/csn-java-exercises/blob/master/src/main/java/com/chenshinan/exercises/javaDiffUtils/mydiff/MyersDiff.java
