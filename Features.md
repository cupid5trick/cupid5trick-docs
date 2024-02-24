---
title: Features
date: 2024-02-24T02:45:11+08:00
lastmod: 2024-02-24T02:49:08+08:00
license: CC BY-NC 4.0
---

# Overview

// TODO update this part

This hugo site is built with a ported [DPSG Hugo](https://github.com/pfadfinder-konstanz/hugo-dpsg) theme. Some more rendering features are added to the base theme.

- Comments: Giscus is used to enable site visitors to comment and view comment list.
- Equation rendering: Eventually take katex as a solution for markdown equation rendering. Although the original mathjax method behaves badly, the code used to setup mathjax equation rendering is kept.
- RSS: I used the default rss template of hugo. See:
- Table of content: The default toc from [DPSG Hugo](https://github.com/pfadfinder-konstanz/hugo-dpsg) is used, which is kind of poor. Hopefully a much better toc template can be found.

To serve this site locally, just run

```bash
hugo server --config .\config-loveit.yaml -e production -wDF
```

# Roadmap

## TODO

- "See also" section at the end of a post
- LICENSE claim template
- Quick share to weixin, juejin, csdn …etc.
