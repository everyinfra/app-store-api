# App Store API

[English](#english) · [中文](#中文)

## English

This repo reads public App Store data with Python or curl. You can search apps by keyword and read an app's details and user reviews. You need one EveryInfra API key. You do not need an Apple account or cookie. The same API also works as an MCP tool in Claude and Cursor. Billing is per call: these 3 capabilities cost $1.39 per 1,000 calls (about $0.0014 per call). Failed calls and empty results are not charged. The EveryInfra App Store API has 7 capabilities, all listed on the platform page: <https://everyinfra.com/en/app-store-api?utm_source=github&utm_medium=example_repo&utm_campaign=app-store-api>

### Quick start

```bash
git clone https://github.com/everyinfra/app-store-api.git
cd app-store-api
pip install -r requirements.txt
export EVERYINFRA_API_KEY=<your API key>
python main.py search "habit tracker" --out apps.csv
python main.py app <app id> --out app.json
python main.py reviews <app id> --out reviews.csv
```

- For `app` and `reviews`, pass the numeric app ID: the `app_id` from a `search` result, the digits after id in an app link. It is not a Bundle ID like com.example.app.
- `--country` picks the storefront (lowercase, such as us or jp), default us. An app listed in one storefront may not be in another.
- Without `--out`, the command prints the first 3 rows as JSON. With `--out`, it saves a .csv or .json file. The CSV has a BOM, so Excel opens it without garbled text.
- Register at everyinfra.com, then create the API key in the console. Steps: <https://everyinfra.com/en/docs?utm_source=github&utm_medium=example_repo&utm_campaign=app-store-api#quickstart>

### curl

```bash
curl -X POST https://api.everyinfra.com/api/v1/social \
  -H "Authorization: Bearer $EVERYINFRA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"platform":"app_store","action":"search","params":{"keyword":"habit tracker"}}'
```

All capabilities use the same URL. Change `action` and `params` to call another one. Examples for `profile` and `reviews` are in [examples/curl.sh](examples/curl.sh).

### Claude and Cursor (MCP)

The remote MCP URL is <https://api.everyinfra.com/mcp>. Add the `Authorization: Bearer` header with your API key. EveryInfra runs the server, so you install no local program.

Claude Code:

```bash
claude mcp add --transport http everyinfra https://api.everyinfra.com/mcp --header "Authorization: Bearer <API Key>"
```

Cursor and other clients that read `mcp.json` ([examples/mcp.json](examples/mcp.json)):

```json
{
  "mcpServers": {
    "everyinfra": {
      "url": "https://api.everyinfra.com/mcp",
      "headers": {
        "Authorization": "Bearer <API Key>"
      }
    }
  }
}
```

Custom connectors in Claude on the web and desktop, and ChatGPT, accept only a URL. Enter <https://api.everyinfra.com/mcp/all>, sign in to EveryInfra when asked, and allow access. You do not need to enter a key. Full steps: <https://everyinfra.com/en/mcp-server?utm_source=github&utm_medium=example_repo&utm_campaign=app-store-api>

### Price

| `action` | Per 1,000 calls |
|---|---|
| `search` | $1.39 |
| `profile` | $1.39 |
| `reviews` | $1.39 |

- Billing is per call, about $0.0014 each. Failed calls, empty results, parameter errors, and authentication failures are not charged.
- A new account gets a $1 trial allowance, valid for 24 hours. No credit card is needed. How to claim it: <https://everyinfra.com/en/pricing?utm_source=github&utm_medium=example_repo&utm_campaign=app-store-api>
- Prices for the other 4 App Store capabilities are on the platform page: <https://everyinfra.com/en/app-store-api?utm_source=github&utm_medium=example_repo&utm_campaign=app-store-api>

### Fields

These are the fields that the 3 capabilities returned in our test. Each meaning is the first sentence of the field's entry in the API documentation. The link under each table has the full text.

#### `search` (keyword search)

| Field | Meaning |
|---|---|
| `app_id` | Numeric App Store ID. |
| `name` | Name of the object itself, for account, product and business capabilities. |
| `url` | Link to the record on the platform. |
| `bundle_id` | App bundle ID (com.xxx.yyy), the unique identifier on the development side. |
| `developer` | Developer name. |
| `developer_url` | Link to the developer page. |
| `description` | Summary or description, usually shorter than text. |
| `release_notes` | Update notes. |
| `version` | Version number. |
| `price` | Price as a number without a currency symbol; see currency. |
| `currency` | Currency code of the price (for example CNY, USD). |
| `formatted_price` | Price display text (such as Free, or an amount with a currency symbol). |
| `rating` | Rating. **The scale varies by platform**: rating_scale on the same row gives the maximum (usually 5; Booking, Douban, iQIYI and NAVER use 10). |
| `rating_count` | Number of people who rated. null means not disclosed, not 0. |
| `current_version_rating` | Rating of the current version. |
| `current_version_rating_count` | Number of ratings for the current version. |
| `content_rating` | Age rating. |
| `category` | Category name in the platform's own taxonomy, not normalized across platforms. |
| `icon_url` | App icon. |
| `min_os` | Minimum operating system version required. |
| `file_size_bytes` | Size of the installation package, in bytes. |
| `released_at` | Time of first release on the store. |
| `updated_at` | Time of the latest update. |
| `platform` | Source platform identifier, the same as platform in the request (for example xiaohongshu, tiktok). |
| `genres` | Categories the app belongs to, as written in the App Store; the field is absent when there are none. |
| `languages` | List of languages the app supports, as written in the App Store; the field is absent when there are none. |
| `screenshot_urls` | Array of app screenshot links, in the order the store shows them; the field is absent when there are none. |
| `rating_scale` | Maximum of rating in the same row: 5 for five-star scales, 10 for ten-point scales. |

All parameters and fields: <https://everyinfra.com/en/app-store-api/search?utm_source=github&utm_medium=example_repo&utm_campaign=app-store-api>

#### `profile` (profile or object details)

| Field | Meaning |
|---|---|
| `app_id` | Numeric App Store ID. |
| `name` | Name of the object itself, for account, product and business capabilities. |
| `url` | Link to the record on the platform. |
| `bundle_id` | App bundle ID (com.xxx.yyy), the unique identifier on the development side. |
| `developer` | Developer name. |
| `developer_url` | Link to the developer page. |
| `description` | Summary or description, usually shorter than text. |
| `release_notes` | Update notes. |
| `version` | Version number. |
| `price` | Price as a number without a currency symbol; see currency. |
| `currency` | Currency code of the price (for example CNY, USD). |
| `formatted_price` | Price display text (such as Free, or an amount with a currency symbol). |
| `rating` | Rating. **The scale varies by platform**: rating_scale on the same row gives the maximum (usually 5; Booking, Douban, iQIYI and NAVER use 10). |
| `rating_count` | Number of people who rated. null means not disclosed, not 0. |
| `current_version_rating` | Rating of the current version. |
| `current_version_rating_count` | Number of ratings for the current version. |
| `content_rating` | Age rating. |
| `category` | Category name in the platform's own taxonomy, not normalized across platforms. |
| `icon_url` | App icon. |
| `min_os` | Minimum operating system version required. |
| `file_size_bytes` | Size of the installation package, in bytes. |
| `released_at` | Time of first release on the store. |
| `updated_at` | Time of the latest update. |
| `platform` | Source platform identifier, the same as platform in the request (for example xiaohongshu, tiktok). |
| `genres` | Categories the app belongs to, as written in the App Store; the field is absent when there are none. |
| `languages` | List of languages the app supports, as written in the App Store; the field is absent when there are none. |
| `screenshot_urls` | Array of app screenshot links, in the order the store shows them; the field is absent when there are none. |
| `rating_scale` | Maximum of rating in the same row: 5 for five-star scales, 10 for ten-point scales. |

All parameters and fields: <https://everyinfra.com/en/app-store-api/profile?utm_source=github&utm_medium=example_repo&utm_campaign=app-store-api>

#### `reviews` (reviews)

| Field | Meaning |
|---|---|
| `id` | The record's unique ID on the platform. |
| `title` | Title. null when the platform has no titles (for example text-only posts). |
| `text` | Body text with HTML removed, returned in full and never cut short (on a few platforms the list results themselves carry only an excerpt; the platform's field notes say so). |
| `rating` | Rating. **The scale varies by platform**: rating_scale on the same row gives the maximum (usually 5; Booking, Douban, iQIYI and NAVER use 10). |
| `author` | Review author. |
| `app_version` | Version number. |
| `helpful_count` | Number of times the review was marked helpful. |
| `posted_at` | Publish time in ISO 8601, UTC (for example 2026-08-07T12:34:56+00:00). |
| `app_id` | Numeric App Store ID. |
| `app_name` | App name. |
| `platform` | Source platform identifier, the same as platform in the request (for example xiaohongshu, tiktok). |
| `rating_scale` | Maximum of rating in the same row: 5 for five-star scales, 10 for ten-point scales. |

All parameters and fields: <https://everyinfra.com/en/app-store-api/reviews?utm_source=github&utm_medium=example_repo&utm_campaign=app-store-api>

### FAQ

**Do I need an Apple account or cookie to call the API?**

No. Send the `Authorization: Bearer` header with your API key. The request body holds `platform`, `action`, and the capability parameters. You do not scan a QR code, keep a login session, or open a browser.

**How much does it cost? Are failed calls charged? Is there a free allowance?**

Billing is per call, from $1.39 per 1,000 calls. Failed calls, empty results, parameter errors, and authentication failures are not charged. A new account gets a $1 trial allowance, valid for 24 hours. No credit card is needed. How to claim it: <https://everyinfra.com/en/pricing?utm_source=github&utm_medium=example_repo&utm_campaign=app-store-api>

**Can I connect the App Store API to Claude or Cursor?**

Yes. The remote MCP URL is <https://api.everyinfra.com/mcp>. Add the `Authorization: Bearer` header with your API key. You install no local program. Setup for Claude, Cursor, ChatGPT, and Claude Code: <https://everyinfra.com/en/mcp-server?utm_source=github&utm_medium=example_repo&utm_campaign=app-store-api>.

**What legal points apply when I use App Store data?**

The EveryInfra Terms of Service require you to make sure your use of the data follows applicable law and the terms of the relevant platform. Do not use the data for anything illegal or anything that violates privacy or intellectual property rights. Do not use bulk scraping for harassment, fraud, or other abuse. When you use personal information such as nicknames and avatars, keep only the fields your business needs.

**Which App Store data can I get?**

The EveryInfra App Store API has 7 capabilities:

- keyword search
- profile or object details
- reviews
- app keyword rankings
- bulk metrics
- competitors
- keyword intersection

Parameters and return fields for each capability are on the platform page: <https://everyinfra.com/en/app-store-api?utm_source=github&utm_medium=example_repo&utm_campaign=app-store-api>

### Tested

Before release, we ran the 3 commands in Quick start against the live API with this repo's code.

| Command | Time (Singapore, UTC+8) | Rows | Charged |
|---|---|---|---|
| `python main.py search "habit tracker" --out apps.csv` | 2026-11-25 13:19 | 20 | $0.001389 |
| `python main.py app <app id> --out app.json` | 2026-11-25 13:19 | 1 | $0.001389 |
| `python main.py reviews <app id> --out reviews.csv` | 2026-11-25 13:20 | 30 | $0.001389 |

## 中文

本仓库用 Python 或 curl 读 App Store 公开数据：按关键词搜应用，读应用详情和用户评价。只需一把 EveryInfra API Key，不用 Apple 账号和 Cookie，也能作为 MCP 工具接进 Claude、Cursor。按调用次数计费，这 3 个能力每千次 $1.39（每次约 $0.0014），失败和空结果不收费。App Store 共 7 个能力：<https://everyinfra.com/app-store-api?utm_source=github&utm_medium=example_repo&utm_campaign=app-store-api>

### 快速开始

```bash
git clone https://github.com/everyinfra/app-store-api.git
cd app-store-api
pip install -r requirements.txt
export EVERYINFRA_API_KEY=<你的 API Key>
python main.py search "habit tracker" --out apps.csv
python main.py app <应用 ID> --out app.json
python main.py reviews <应用 ID> --out reviews.csv
```

- `app` 和 `reviews` 传数字应用 ID，用 `search` 结果里的 `app_id`，即应用链接里 id 后面的数字；不是 com.example.app 这种 Bundle ID。
- `--country` 选店面国家（小写，如 us、jp），默认 us；同一应用在别的店面不一定上架。
- 不加 `--out` 时打印前 3 条 JSON；加 `--out` 存成 .csv 或 .json。CSV 带 BOM，Excel 直接打开不乱码。
- API Key 在 everyinfra.com 注册后到控制台创建，步骤见 <https://everyinfra.com/docs?utm_source=github&utm_medium=example_repo&utm_campaign=app-store-api#quickstart>

### 用 curl 调

```bash
curl -X POST https://api.everyinfra.com/api/v1/social \
  -H "Authorization: Bearer $EVERYINFRA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"platform":"app_store","action":"search","params":{"keyword":"habit tracker"}}'
```

所有能力都发到同一个地址，换 `action` 和 `params` 就行；`profile`、`reviews` 的写法见 [examples/curl.sh](examples/curl.sh)。

### 接进 Claude、Cursor（MCP）

远程 MCP 地址是 <https://api.everyinfra.com/mcp>，请求头加 `Authorization: Bearer` 和 API Key；服务器由 EveryInfra 运行，不用装本地程序。

Claude Code：

```bash
claude mcp add --transport http everyinfra https://api.everyinfra.com/mcp --header "Authorization: Bearer <API Key>"
```

Cursor 等读 `mcp.json` 的客户端（[examples/mcp.json](examples/mcp.json)）：

```json
{
  "mcpServers": {
    "everyinfra": {
      "url": "https://api.everyinfra.com/mcp",
      "headers": {
        "Authorization": "Bearer <API Key>"
      }
    }
  }
}
```

Claude 网页版和桌面版的自定义连接器、ChatGPT 只能填网址：填 <https://api.everyinfra.com/mcp/all>，连接时登录 EveryInfra 并允许，不用填 Key。完整步骤见 <https://everyinfra.com/mcp-server?utm_source=github&utm_medium=example_repo&utm_campaign=app-store-api>

### 价格

| 能力 | `action` | 每千次 |
|---|---|---|
| 关键词搜索 | `search` | $1.39 |
| 主页或对象详情 | `profile` | $1.39 |
| 评价 | `reviews` | $1.39 |

- 按调用次数计费，每次约 $0.0014；失败、空结果、参数错误和鉴权失败都不收费。
- 新账号有 $1 试用额度，24 小时内有效，不用信用卡，领取方式见 <https://everyinfra.com/pricing?utm_source=github&utm_medium=example_repo&utm_campaign=app-store-api>
- App Store 其他 4 个能力的单价见平台页 <https://everyinfra.com/app-store-api?utm_source=github&utm_medium=example_repo&utm_campaign=app-store-api>

### 返回字段

下面是这 3 个能力实测返回的字段，含义取自接口文档每条说明的第一句，完整说明在每张表下面的链接里。

#### `search`（关键词搜索）

| 字段 | 含义 |
|---|---|
| `app_id` | App Store 数字 ID。 |
| `name` | 名称。 |
| `url` | 该记录在原平台上的可访问链接。 |
| `bundle_id` | 应用包名（com.xxx.yyy），开发侧唯一标识。 |
| `developer` | 开发者名称。 |
| `developer_url` | 开发者页链接。 |
| `description` | 简介或描述，通常比 text 短。 |
| `release_notes` | 更新说明。 |
| `version` | 版本号。 |
| `price` | 价格数值，不含货币符号；币种见 currency。 |
| `currency` | 价格币种代码（如 CNY、USD）。 |
| `formatted_price` | 价格展示文本（如「免费」或带币种符号的金额）。 |
| `rating` | 评分。 |
| `rating_count` | 参与评分的人数。 |
| `current_version_rating` | 当前版本的评分。 |
| `current_version_rating_count` | 当前版本的评分人数。 |
| `content_rating` | 年龄分级。 |
| `category` | 分类名称，取值为原平台的分类体系，未做跨平台归一。 |
| `icon_url` | 应用图标。 |
| `min_os` | 最低系统版本要求。 |
| `file_size_bytes` | 安装包大小，字节。 |
| `released_at` | 首次上架时间。 |
| `updated_at` | 最近更新时间。 |
| `platform` | 数据来源平台标识，与请求里的 platform 一致（如 xiaohongshu、tiktok）。 |
| `genres` | 应用所属的分类，按 App Store 原文；没有时不出现这个字段。 |
| `languages` | 应用支持的语言列表，按 App Store 原文；没有时不出现这个字段。 |
| `screenshot_urls` | 应用截图链接数组，按商店展示顺序；没有时不出现这个字段。 |
| `rating_scale` | 上一列 `rating` 的满分。 |

完整参数和字段：<https://everyinfra.com/app-store-api/search?utm_source=github&utm_medium=example_repo&utm_campaign=app-store-api>

#### `profile`（主页或对象详情）

| 字段 | 含义 |
|---|---|
| `app_id` | App Store 数字 ID。 |
| `name` | 名称。 |
| `url` | 该记录在原平台上的可访问链接。 |
| `bundle_id` | 应用包名（com.xxx.yyy），开发侧唯一标识。 |
| `developer` | 开发者名称。 |
| `developer_url` | 开发者页链接。 |
| `description` | 简介或描述，通常比 text 短。 |
| `release_notes` | 更新说明。 |
| `version` | 版本号。 |
| `price` | 价格数值，不含货币符号；币种见 currency。 |
| `currency` | 价格币种代码（如 CNY、USD）。 |
| `formatted_price` | 价格展示文本（如「免费」或带币种符号的金额）。 |
| `rating` | 评分。 |
| `rating_count` | 参与评分的人数。 |
| `current_version_rating` | 当前版本的评分。 |
| `current_version_rating_count` | 当前版本的评分人数。 |
| `content_rating` | 年龄分级。 |
| `category` | 分类名称，取值为原平台的分类体系，未做跨平台归一。 |
| `icon_url` | 应用图标。 |
| `min_os` | 最低系统版本要求。 |
| `file_size_bytes` | 安装包大小，字节。 |
| `released_at` | 首次上架时间。 |
| `updated_at` | 最近更新时间。 |
| `platform` | 数据来源平台标识，与请求里的 platform 一致（如 xiaohongshu、tiktok）。 |
| `genres` | 应用所属的分类，按 App Store 原文；没有时不出现这个字段。 |
| `languages` | 应用支持的语言列表，按 App Store 原文；没有时不出现这个字段。 |
| `screenshot_urls` | 应用截图链接数组，按商店展示顺序；没有时不出现这个字段。 |
| `rating_scale` | 上一列 `rating` 的满分。 |

完整参数和字段：<https://everyinfra.com/app-store-api/profile?utm_source=github&utm_medium=example_repo&utm_campaign=app-store-api>

#### `reviews`（评价）

| 字段 | 含义 |
|---|---|
| `id` | 该记录在原平台上的唯一标识。 |
| `title` | 标题。 |
| `text` | 正文内容，已去除 HTML 标签，全文返回、不截断（个别平台的列表结果本身只有摘要，以该平台的字段说明为准）。 |
| `rating` | 评分。 |
| `author` | 评价作者。 |
| `app_version` | 版本号。 |
| `helpful_count` | 评价被标「有帮助」次数。 |
| `posted_at` | 发布时间，ISO 8601 格式、UTC 时区（如 2026-08-07T12:34:56+00:00）。 |
| `app_id` | App Store 数字 ID。 |
| `app_name` | 应用名称。 |
| `platform` | 数据来源平台标识，与请求里的 platform 一致（如 xiaohongshu、tiktok）。 |
| `rating_scale` | 上一列 `rating` 的满分。 |

完整参数和字段：<https://everyinfra.com/app-store-api/reviews?utm_source=github&utm_medium=example_repo&utm_campaign=app-store-api>

### 常见问题

**调用时要不要提供 Apple 账号或 Cookie？**

不用，请求头带 `Authorization: Bearer` 和 API Key 就能调，请求体写 `platform`、`action` 和能力参数。不用扫码、维护登录状态，也不用开浏览器。

**怎么收费？失败了收不收钱？有免费额度吗？**

按调用次数计费，每千次 $1.39 起。失败、空结果、参数错误和鉴权失败都不收费。新账号有 $1 试用额度，24 小时内有效，不用信用卡，领取方式见定价页 <https://everyinfra.com/pricing?utm_source=github&utm_medium=example_repo&utm_campaign=app-store-api>

**能把 App Store 接口接进 Claude、Cursor 吗？**

能，远程 MCP 地址是 <https://api.everyinfra.com/mcp>，请求头加 `Authorization: Bearer` 和 API Key，不用装本地程序。Claude、Cursor、ChatGPT、Claude Code 配置见 <https://everyinfra.com/mcp-server?utm_source=github&utm_medium=example_repo&utm_campaign=app-store-api>。

**用 App Store 数据要注意哪些合规问题？**

EveryInfra 服务条款要求你自行确保数据用法符合适用法律和相关平台条款，禁止用于违法、侵犯隐私或知识产权，或批量抓取用于骚扰、欺诈等恶意用途。用到昵称、头像等个人信息时，只留业务用得上的字段。

**可以拿到 App Store 的哪些数据？**

App Store 有 7 个能力：关键词搜索、主页或对象详情、评价、App 关键词排名、批量 App 排名指标、竞品应用、多个 App 共同关键词。每个能力的参数和返回字段见平台页 <https://everyinfra.com/app-store-api?utm_source=github&utm_medium=example_repo&utm_campaign=app-store-api>

### 实测记录

发布前用本仓的代码对线上接口跑过一遍，命令就是「快速开始」里的 3 条。

| 命令 | 时间（新加坡时间） | 返回条数 | 扣费 |
|---|---|---|---|
| `python main.py search "habit tracker" --out apps.csv` | 2026-11-25 13:19 | 20 | $0.001389 |
| `python main.py app <应用 ID> --out app.json` | 2026-11-25 13:19 | 1 | $0.001389 |
| `python main.py reviews <应用 ID> --out reviews.csv` | 2026-11-25 13:20 | 30 | $0.001389 |

`profile` 返回的一条（正文截到 60 字，作者字段没放进来）：

```json
{
  "description": "Meet your new self-care best friend! Finch is a self-care pe…",
  "price": 0,
  "currency": "USD",
  "rating": 4.95,
  "rating_count": 779086,
  "current_version_rating_count": 779086,
  "category": "Health & Fitness",
  "updated_at": "2026-11-20T18:04:01+00:00",
  "rating_scale": 5
}
```

## License

MIT
