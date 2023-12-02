---
scope: learn
draft: true
---
# Apifox
[帮助中心 | Apifox 使用文档](https://www.apifox.cn/help/)

## 变量
[环境变量 / 全局变量 / 临时变量 | Apifox 使用文档](https://www.apifox.cn/help/app/api-manage/variables/#%E5%BF%AB%E9%80%9F%E4%B8%8A%E6%89%8B)
[动态变量 / 随机参数 | Apifox 使用文档](https://www.apifox.cn/help/app/api-manage/dynamic-variables/#%E6%93%8D%E4%BD%9C%E8%AF%B4%E6%98%8E)


## 登录态（Auth）如何处理
[登录态（Auth）如何处理 | Apifox 使用文档](https://www.apifox.cn/help/app/best-practices/auth/#%E5%B8%B8%E8%A7%81%E5%A4%84%E7%90%86%E6%96%B9%E5%BC%8F)

## 测试管理

[测试用例 | Apifox 使用文档](https://www.apifox.cn/help/app/test-manage/test-case/#%E6%96%B0%E5%BB%BA%E6%B5%8B%E8%AF%95%E7%94%A8%E4%BE%8B)
[测试套件 | Apifox 使用文档](https://www.apifox.cn/help/app/test-manage/test-suite/)
[测试数据 | Apifox 使用文档](https://www.apifox.cn/help/app/test-manage/test-data/)
[性能测试 | Apifox 使用文档](https://www.apifox.cn/help/app/test-manage/performance-test/)
[对比测试 (todo) | Apifox 使用文档](https://www.apifox.cn/help/app/test-manage/compare-test/)

## 脚本 API
[pm 对象 API | Apifox 使用文档](https://www.apifox.cn/help/app/scripts/api-references/pm-reference/#pm-sendrequest)

### `pm` 对象
-   [pm.sendRequest](https://www.apifox.cn/help/app/scripts/api-references/pm-reference/#pm-sendrequest)
-   [pm.variables](https://www.apifox.cn/help/app/scripts/api-references/pm-reference/#pm-variables)
-   [pm.iterationData](https://www.apifox.cn/help/app/scripts/api-references/pm-reference/#pm-iterationdata)
-   [pm.environment](https://www.apifox.cn/help/app/scripts/api-references/pm-reference/#pm-environment)
-   [pm.globals](https://www.apifox.cn/help/app/scripts/api-references/pm-reference/#pm-globals)
-   [pm.request](https://www.apifox.cn/help/app/scripts/api-references/pm-reference/#pm-request)
-   [pm.response](https://www.apifox.cn/help/app/scripts/api-references/pm-reference/#pm-response)
-   [pm.cookies](https://www.apifox.cn/help/app/scripts/api-references/pm-reference/#pm-cookies)
-   [pm.test](https://www.apifox.cn/help/app/scripts/api-references/pm-reference/#pm-test)
-   [pm.expect](https://www.apifox.cn/help/app/scripts/api-references/pm-reference/#pm-expect)
-   [Response 对象可用的断言 API 列表](https://www.apifox.cn/help/app/scripts/api-references/pm-reference/#response-%E5%AF%B9%E8%B1%A1%E5%8F%AF%E7%94%A8%E7%9A%84%E6%96%AD%E8%A8%80-api-%E5%88%97%E8%A1%A8)
-   [pm.response.to.be.*](https://www.apifox.cn/help/app/scripts/api-references/pm-reference/#pm-response-to-be)


### 前置脚本：读取、修改请求
[脚本读取/修改接口请求信息 | Apifox 使用文档](https://www.apifox.cn/help/app/scripts/examples/request-handle/#url-%E7%9B%B8%E5%85%B3%E4%BF%A1%E6%81%AF)

### 后置脚本：验证请求结果
[断言 (测试请求结果) | Apifox 使用文档](https://www.apifox.cn/help/app/scripts/examples/tests/#%E4%BD%BF%E7%94%A8%E7%A4%BA%E4%BE%8B)

### 使用 Js 类库
[使用 JS 类库 | Apifox 使用文档](https://www.apifox.cn/help/app/scripts/api-references/library-reference/#%E4%BD%BF%E7%94%A8%E6%96%B9%E5%BC%8F)
#### 内置的 JS 类库

通过 `require`方法可以直接使用 Apifox 内置的 JS 类库。
**注意：只能 require 整个模块，不能单独 require 类库里的某个子模块，具体看本文档末尾说明。**

```
var cryptoJs = require("crypto-js");
console.log(cryptoJs.SHA256("Message"));
```

#### 非内置的 JS 类库`

通过`fox.liveRequire`方法可以动态引入未内置的但是在 npm 上已发布的其他各种库（仅支持纯 js 库，最好是写明了支持浏览器端运行的 browser 字样的库，含 C/C++等语言扩展之类的库是不支持加载的，会运行超时或异常）。

liveRequire 的回调函数体内调用 console 不起作用。

```
// 使用非内置的 JS 类库示例

// 引入单个 npm 库：camelcase
fox.liveRequire("camelcase", (camelCase) => {
  camelCase("foo-bar"); // => 'fooBar'
});

// 引入多个 npm 库：camelcase，
fox.liveRequire(["camelcase", "md5"], (camelCase, md5) => {
  camelCase("foo-bar"); // => 'fooBar'
  md5("message"); // => '78e731027d8fd50ed642340b7c9a63b3'
});
```
#### 内置类库列表

**Encode、Decode 库**
-   [atob](https://www.npmjs.com/package/atob)（v2.1.2）：Base64 解码
-   [btoa](https://www.npmjs.com/package/btoa)（v1.2.1）：Base64 编码
-   [crypto-js](https://www.npmjs.com/package/crypto-js)（v3.1.9-1）：编码 / 解码库，常用的编码解码方式基本都有，如 Base64、MD5、SHA、HMAC、AES 等等。
-   [jsrsasign](https://www.npmjs.com/package/jsrsasign)（10.3.0）：RSA 加密 / 解密 （Apifox 版本号 >= 1.4.5 才支持，老版本不支持）
**断言**
-   [chai](http://chaijs.com/) （v4.2.0）：BDD / TDD 断言库
**实用工具**
-   [postman-collection](http://www.postmanlabs.com/postman-collection/)（ v3.4.0）：Postman Collection 库
-   [cheerio](https://cheerio.js.org/)（v0.22.0）：jQuery 的一个子集
-   [lodash](https://lodash.com/) （v4.17.11）：JS 实用工具库
-   [moment](http://momentjs.com/docs/)（v2.22.2）：日期处理库 (不含 locales)
-   [uuid](https://www.npmjs.com/package/uuid) ：生成 UUID
-   [xml2js](https://www.npmjs.com/package/xml2js)（v0.4.19）：XML 转 JSON
-   [csv-parse/lib/sync](https://csv.js.org/parse/api/sync/)（ v1.2.4）：CSV 格式数据处理
**JSONSchema 校验库**
-   [tv4](https://github.com/geraintluff/tv4)（v1.3.0）：JSONSchema 校验库
-   [ajv](https://www.npmjs.com/package/ajv)（v6.6.2）：JSONSchema 校验库
**内置 NodeJS 模块**
-   [path](https://nodejs.org/api/path.html)
-   [assert](https://nodejs.org/api/assert.html)
-   [buffer](https://nodejs.org/api/buffer.html)
-   [util](https://nodejs.org/api/util.html)
-   [url](https://nodejs.org/api/url.html)
-   [punycode](https://nodejs.org/api/punycode.html)
-   [querystring](https://nodejs.org/api/querystring.html)
-   [string-decoder](https://nodejs.org/api/string_decoder.html)
-   [stream](https://nodejs.org/api/stream.html)
-   [timers](https://nodejs.org/api/timers.html)
-   [events](https://nodejs.org/api/events.html)
### 调用其他语言
通过 `pm` 对象的 `execute` 方法调用，本质是一个命令行进程，例如 `java -jar package.jar ...`、`node script.js a b c` 。调用时以阻塞的方式执行相应的命令，最后把 `stdout` 返回。

`execute` 方法本身也没有做系统换行符的处理，所以文档里说"引用外部程序输出结果时不同系统返回的字符串可能带有不同换行符号"，需要自己处理输出结果的文本。

[脚本调用其他语言（ java、python、php 等） | Apifox 使用文档](https://www.apifox.cn/help/app/scripts/api-references/external-programs/#%E4%BD%BF%E7%94%A8%E6%96%B9%E6%B3%95)

