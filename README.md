# HarmonyOS-NoteBook

简账是一款面向 HarmonyOS NEXT 的智能记账本示例应用。项目以“轻量、智能、美学”为核心，围绕个人收支记录、消费统计、预算挑战和动态主题构建一个可运行的 ArkUI MVP。

## 功能亮点

- 快捷记账：支持支出/收入切换、金额键盘、分类选择、备注录入。
- AI 文本识别：输入类似“今天午饭花了35块”的自然语言，可自动识别金额和分类。
- 账单管理：内置最近账单列表，支持编辑和删除。
- 统计报表：提供消费趋势、分类排行、消费热力图和 AI 月报摘要。
- 预算中心：支持月度预算调整、预算进度和挑战勋章展示。
- 个人中心：支持动态主题切换、隐私与备份状态展示。

## 技术栈

- HarmonyOS NEXT
- Stage 模型
- ArkTS
- ArkUI 声明式 UI
- Hvigor 构建体系

## 环境要求

- DevEco Studio 5.x
- HarmonyOS SDK 5.0.2 / API 14
- Windows 开发环境
- 可用的 HarmonyOS 模拟器或真机

## 快速开始

1. 克隆仓库：

   ```bash
   git clone git@github.com:Magic181/HarmonyOS-NoteBook.git
   ```

2. 使用 DevEco Studio 打开项目根目录。

3. 等待工程同步完成，确认 SDK 为 HarmonyOS 5.0.2/API 14。

4. 选择 `entry` 模块，运行到模拟器或真机。

## 命令行构建

如果 DevEco Studio 的工具链已经安装，可以使用 hvigor 构建 HAP：

```powershell
$env:NODE_HOME='D:\Sandbox\DevEco Studio\tools\node'
$env:DEVECO_SDK_HOME='D:\Sandbox\DevEco Studio\sdk'
$env:PATH='D:\Sandbox\DevEco Studio\tools\node;' + $env:PATH
& 'D:\Sandbox\DevEco Studio\tools\hvigor\bin\hvigorw.bat' assembleHap --mode module -p module=entry@default -p product=default
```

构建产物默认位于：

```text
entry/build/default/outputs/default/entry-default-unsigned.hap
```

## 项目结构

```text
.
├── AppScope/                         # 应用级配置与资源
├── entry/
│   ├── src/main/ets/entryability/    # EntryAbility
│   ├── src/main/ets/pages/           # ArkUI 页面
│   └── src/main/resources/           # 模块资源
├── hvigor/                           # Hvigor 配置
├── 需求.md                           # 产品需求文档
└── README.md
```

## 测试记录

当前版本已在 HarmonyOS 模拟器中完成基础验证：

- `assembleHap` 构建成功。
- HAP 安装成功。
- 应用启动成功。
- 首页、统计、预算、我的四个 Tab 可切换。
- 未发现启动阶段 `JS_ERROR`。

## 后续计划

- 接入 ArkData 关系型数据库，实现账单持久化。
- 完善截图识别、语音识别和短信/通知解析。
- 引入图表组件，替换当前自绘统计原型。
- 增加单元测试和端到端 UI 自动化测试。
- 配置正式签名与发布构建流程。

## License

当前项目未指定开源许可证。正式发布前请根据使用场景补充 LICENSE。
