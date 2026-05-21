 
验收检查任务清单，与计划验证点比对，从 git 历史反推任务完成状态；区别于code-review,不分析具体代码，仅对齐文档和git 历史完成状态

1. 获取待审查的更改：
```bash
git diff        # 或指定提交范围
git log     # 反推任务完成状态
```
2. 定位文档：
是否存在现有规范,如：
```
docs/specs/YYYY-MM-DD-<topic>/
├── 01-color-extraction.md
├── 02-palette-rendering.md
├── 03-export-formats.md
└── ...
```
计划文档,如：
```
docs/plans/<date>_<id>_<Feature>/
├── design.md
├── plan.md 
├── plan-<N>.md 
```
3. 确认：
   - 更改了哪些文件
   - 计划/规范的要求是什么
   - 任务是否完成`[ ]/[x]` 状态标记
   - 变更引用的文档相对路径
4. 将已完成的功能目录归档：docs/archive/
5. 更新全局 Spec 索引
读取 `docs/global/index.md`（第一次没有则新建），执行三项更新：

**5.1 追加归档行至 `## 已归档 Feature` 表格**

在表格开头新增一行：

```
| [<目录名>](../archive/<目录名>/) | <一句话摘要> | <领域> | <今日日期> |
```
- 摘要：从 `design.md` 标题/概述 或 `plan.md` 目标字段提取，一句话
- 领域：从 Feature ID 主题段推断（如 `tool-search` → tool-search）
- 日期：当天 ISO 格式

如不存在 `## 已归档 Feature` 章节，在 `## 领域索引` 之前创建该章节和表格。


**5.2 更新页脚时间戳**

找到或创建 `*最后更新:*` 行，更新为：
```
*最后更新: YYYY-MM-DD — 由 <目录名> 归档时更新*
```
 