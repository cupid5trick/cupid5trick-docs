---
scope: learn
draft: true
---
# 版本控制

[Semantic Versioning 2.0.0 | Semantic Versioning](https://semver.org/)

# Github Workflow
- [使用 Github Actions 做持续集成 - 非正常人类研究中心](https://jiangbao.github.io/%E4%BD%BF%E7%94%A8githubactions%E5%81%9A%E6%8C%81%E7%BB%AD%E9%9B%86%E6%88%90/)

- [使用 GitHub Actions 实现博客自动化部署 | Frost's Blog](https://frostming.com/2020/04-26/github-actions-deploy/): https://frostming.com/2020/04-26/github-actions-deploy/

- [Workflow syntax for GitHub Actions - GitHub Docs](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions): https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions

- [Contexts - GitHub Docs](https://docs.github.com/en/actions/learn-github-actions/contexts): <https://docs.github.com/en/actions/learn-github-actions/contexts>

- [使用 Maven 构建和测试 Java - GitHub Docs](https://docs.github.com/zh/actions/automating-builds-and-tests/building-and-testing-java-with-maven): <https://docs.github.com/zh/actions/automating-builds-and-tests/building-and-testing-java-with-maven>

# 使用 Github 发布软件

- [GitHub Action 自动构建 并release - 腾讯云开发者社区-腾讯云](https://cloud.tencent.com/developer/article/1970730): <https://cloud.tencent.com/developer/article/1970730>

- [Github 之 Actions 自动发布 GitHub Release | 小康博客](https://www.antmoe.com/posts/18c087cf/): <https://www.antmoe.com/posts/18c087cf/>
- 
# 关于 Deploy Key

// TODO

- [Managing deploy keys - GitHub Docs](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/managing-deploy-keys#deploy-keys): <https://docs.github.com/en/authentication/connecting-to-github-with-ssh/managing-deploy-keys#deploy-keys>

You can launch projects from a repository on GitHub.com to your server by using a deploy key, which is an SSH key that grants access to a single repository. GitHub attaches the public part of the key directly to your repository instead of a personal account, and the private part of the key remains on your server. For more information, see "[Delivering deployments](https://docs.github.com/en/rest/guides/delivering-deployments)."

Deploy keys with write access can perform the same actions as an organization member with admin access, or a collaborator on a personal repository. For more information, see "[Repository roles for an organization](https://docs.github.com/en/organizations/managing-user-access-to-your-organizations-repositories/repository-roles-for-an-organization)" and "[Permission levels for a personal account repository](https://docs.github.com/en/account-and-profile/setting-up-and-managing-your-personal-account-on-github/managing-personal-account-settings/permission-levels-for-a-personal-account-repository)."