# FastGPT Codex Skills

一组面向 FastGPT 管理操作的 Codex skills，重点解决“登录、应用管理、工作流导入导出、API Key 管理、知识库管理”这几类重复后台操作。

这套 skills 适合把原来需要反复点 FastGPT 后台页面的动作，收敛成可复用、可脚本化、可交给 Codex 执行的操作能力。

## 核心能力

- 登录态复用：复用 Firefox / Playwright profile，减少手工复制 cookie
- 工作流管理：支持创建应用、导出工作流、查看应用详情和权限
- API Key 管理：支持应用 key 的查看、创建、更新、删除
- 数据集管理：支持知识库列表、创建、collection 查看、本地文件上传
- 后台联调：内置验证脚本，可快速确认当前管理链路是否可用

## 适用场景

- 让 Codex 接管 FastGPT 后台的重复操作
- 把工作流导入导出、发布、备份收成固定动作
- 为合同审查、制度库、风险库这类业务流准备 FastGPT 管理能力
- 在 WSL 环境下保留 PowerShell fallback，绕过部分管理接口网络兼容问题

## Skills 说明

### 1. FastGPT 登录与登录态复用

对应 skill：

- `fastgpt-login`

提供能力：

- 复用 Firefox / Playwright 浏览器 profile 中的登录态
- 用环境变量注入账号密码，执行自动化登录
- 登录后直接衔接管理端命令验证

适用场景：

- 需要让 Codex 接管 FastGPT 后台操作
- 不希望手工复制 cookie
- 不希望把账号密码写进仓库

### 2. FastGPT 应用与工作流管理

对应 skill：

- `fastgpt-admin`

提供能力：

- 查看应用列表
- 查看应用详情和权限
- 从本地工作流 JSON 创建应用
- 导出已有应用的工作流 JSON
- 快速验证当前管理链路是否可用

适用场景：

- 批量管理工作流应用
- 迁移工作流
- 备份工作流配置
- 做发布前核查

### 3. FastGPT 应用 API Key 管理

对应 skill：

- `fastgpt-api-key-manager`

提供能力：

- 查看应用 API Key 列表
- 创建 API Key
- 更新 API Key
- 删除 API Key

适用场景：

- 为后端服务生成专属调用 key
- 统一管理应用访问凭证
- 调整 key 名称、有效期和使用限制

### 4. FastGPT 数据集与文件上传管理

对应 skill：

- `fastgpt-dataset-manager`

提供能力：

- 查看数据集列表
- 创建数据集
- 查看 collection 列表
- 上传本地文件到知识库

适用场景：

- 建制度库、合同库、风险库
- 上传制度文档、模板、规则文件
- 为工作流准备知识库数据

## 设计特点

- 账号密码不写入 skill 文件，统一走环境变量
- 不绑定某台机器的私有目录
- 支持浏览器 profile 复用，也支持显式 cookie / bearer token
- 保留 Windows PowerShell 网络 fallback，适合 WSL 下 FastGPT 管理接口不稳定的场景
- 发布目录自带脱敏检查脚本，便于公开上传 GitHub

## 目录结构

- `fastgpt-login`
  负责登录、登录态准备、环境变量登录脚本
- `fastgpt-admin`
  负责应用、工作流、管理接口验证
- `fastgpt-api-key-manager`
  负责应用 key 管理
- `fastgpt-dataset-manager`
  负责数据集和文件上传

## 依赖

这套 skills 默认依赖一个本地可用的 FastGPT harness，也就是：

- `FASTGPT_HARNESS_DIR=/path/to/fastgpt/agent-harness`

skills 本身负责“如何调用”和“如何编排”，不直接替代底层 harness。

## 快速开始

先把本目录安装到 Codex 的 skills 目录：

```bash
export CODEX_HOME="${CODEX_HOME:-$HOME/.codex}"
bash ./install.sh
```

再配置运行环境：

```bash
export FASTGPT_HARNESS_DIR="/path/to/fastgpt/agent-harness"
export FASTGPT_FIREFOX_PROFILE="/path/to/playwright-or-firefox-profile"
export FASTGPT_BASE_URL="https://cloud.fastgpt.cn/api"
```

如果需要自动化登录，再补：

```bash
export FASTGPT_LOGIN_URL="https://cloud.fastgpt.cn/login"
export FASTGPT_LOGIN_USERNAME="__SET_AT_RUNTIME__"
export FASTGPT_LOGIN_PASSWORD="__SET_AT_RUNTIME__"
```

## 发布前检查

公开上传 GitHub 前执行：

```bash
bash ./scripts/prepublish_check.sh
```

会检查：

- 是否含有账号密码、cookie、token 明文
- 是否残留项目私有路径
- shell 脚本是否有语法错误

## 不要提交

- 真实账号和密码
- `FASTGPT_COOKIE`
- `FASTGPT_ADMIN_BEARER_TOKEN`
- 浏览器 profile 目录
- `.playwright-cli/` 调试文件
- 本机配置文件、日志、导出结果
