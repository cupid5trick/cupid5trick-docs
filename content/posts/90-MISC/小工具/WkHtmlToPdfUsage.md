---
draft: true
categories: ["misc"]
---

```bash
## with a toc page
C:\"Program Files"\wkhtmltopdf\bin\wkhtmltopdf.exe --enable-local-file-access toc page C:\Users\18488\Desktop\Current_Learning\bdilab\web-backend-learning\spring-framework-docs\spring-framework\docs\current\reference\html\core.html C:\Users\18488\Desktop\Current_Learning\bdilab\web-backend-learning\spring-framework-docs\spring-framework\docs\current\reference\html\core_with-toc.pdf

## without toc page
C:\"Program Files"\wkhtmltopdf\bin\wkhtmltopdf.exe --enable-local-file-access page C:\Users\18488\Desktop\Current_Learning\bdilab\web-backend-learning\spring-framework-docs\spring-framework\docs\current\reference\html\core.html C:\Users\18488\Desktop\Current_Learning\bdilab\web-backend-learning\spring-framework-docs\spring-framework\docs\current\reference\html\core.pdf
wkhtmltopdf.exe --enable-local-file-access page "https://docs.spring.io/spring-framework/docs/current/reference/html/core.html" core_from_url.pdf
## convert html from a url
C:\"Program Files"\wkhtmltopdf\bin\wkhtmltopdf.exe page https://docs.spring.io/spring-framework/docs/current/reference/html/core.html C:\Users\18488\Desktop\Current_Learning\bdilab\web-backend-learning\spring-framework-docs\spring-framework\docs\current\reference\html\core_from-url.pdf
```



# links resources

- [wkhtmltopdf on github](https://github.com/wkhtmltopdf/wkhtmltopdf/)
- [wkhtmltopdf project homepage](https://wkhtmltopdf.org/)
- [auto generated documentation for wkhtmltopdf](https://wkhtmltopdf.org/usage/wkhtmltopdf.txt)



# trouble shots

- [The html convert pdf triggerred the error: Warning: Blocked access to file](https://github.com/wkhtmltopdf/wkhtmltopdf/issues/5021#)
- 