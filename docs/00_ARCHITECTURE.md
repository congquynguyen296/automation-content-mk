# AI TikTok Content Automation — Architecture

## 1. Mục tiêu

Xây dựng một hệ thống tự động hóa quy trình sản xuất video TikTok bằng AI, trong đó n8n đóng vai trò orchestration layer.

Giai đoạn đầu **không tự động đăng TikTok**. Hệ thống tạo ra video hoàn chỉnh, gửi sang Telegram để review/approve, sau đó gửi notification chứa video/các asset để người dùng tự upload TikTok.

## 2. Mục tiêu kiến trúc

- Tự động hóa từ idea → research → script → visual → voice → subtitle → render → review.
- Có human-in-the-loop trước khi video trở thành nội dung chính thức.
- Có thể regenerate từng phần thay vì tạo lại toàn bộ video.
- Dữ liệu content/asset/status nằm trong PostgreSQL, không phụ thuộc vào execution history của n8n.
- n8n chỉ orchestration; xử lý video nên nằm ở worker/service riêng.
- Dễ thay thế AI provider.
- Có retry, error handling, logging và notification.
- Có thể mở rộng về sau sang auto publishing, analytics, A/B testing.

## 3. High-level architecture

```text
                          ┌────────────────────┐
                          │      Scheduler     │
                          │       n8n          │
                          └─────────┬──────────┘
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │    Idea Engine      │
                         │ Trend + AI scoring  │
                         └──────────┬──────────┘
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │  Research Engine    │
                         │ Sources + facts     │
                         └──────────┬──────────┘
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │  Content Engine     │
                         │ Script + scene JSON │
                         └──────────┬──────────┘
                                    │
                         ┌──────────┴──────────┐
                         ▼                     ▼
                ┌─────────────────┐   ┌─────────────────┐
                │ Image Generator │   │   TTS Engine    │
                └────────┬────────┘   └────────┬────────┘
                         │                     │
                         └──────────┬──────────┘
                                    ▼
                         ┌─────────────────────┐
                         │    Asset Storage    │
                         │       S3/R2         │
                         └──────────┬──────────┘
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │   Render Worker     │
                         │       FFmpeg        │
                         └──────────┬──────────┘
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │    Review Gate      │
                         │      Telegram       │
                         └───────┬─────┬───────┘
                                 │     │
                             APPROVE  REJECT
                                 │     │
                                 │     └──────► Regenerate
                                 ▼
                         ┌─────────────────────┐
                         │     Finalize        │
                         │ Video + caption     │
                         └──────────┬──────────┘
                                    │
                                    ▼
                         ┌─────────────────────┐
                         │ Manual TikTok Post  │
                         │      by owner       │
                         └─────────────────────┘

        PostgreSQL = source of truth for content, state, assets and execution metadata.
```

## 4. Components

| Component | Responsibility | Phase |
|---|---|---|
| n8n | Workflow orchestration | 1 |
| PostgreSQL | Persistent state/data | 1 |
| Telegram Bot | Review + notifications | 1/6 |
| LLM | Research synthesis, scripting, metadata | 2/3 |
| Search/Research provider | Source discovery | 3 |
| Image generation API | Scene visuals | 4 |
| TTS API | Voice-over | 4 |
| Object Storage | Images/audio/video | 4/5 |
| Render Worker | FFmpeg video assembly | 5 |
| Error Handler | Failure notification | 1/7 |
| TikTok API | Future auto publishing | Future |

## 5. Source of truth

PostgreSQL is authoritative for:

- content records
- content status
- versions
- script
- scenes
- generated assets
- review result
- render result
- errors
- timestamps

n8n execution history is used for operational debugging, not as application state.

## 6. State machine

```text
IDEA
  ↓
RESEARCHING
  ↓
SCRIPT_GENERATED
  ↓
ASSETS_GENERATING
  ↓
ASSETS_READY
  ↓
RENDERING
  ↓
READY_FOR_REVIEW
  ├── REGENERATING ──► ASSETS_GENERATING / RENDERING
  └── APPROVED
           ↓
       FINALIZED
           ↓
     READY_TO_POST
           ↓
     MANUALLY_POSTED
```

Failure states:

```text
GENERATION_FAILED
RENDER_FAILED
REVIEW_REJECTED
```

## 7. Design principles

### 7.1 n8n is orchestration, not the entire application

Avoid putting large amounts of business logic into Code nodes. Complex operations such as video rendering, subtitle generation, media manipulation or validation should be isolated behind services/scripts.

### 7.2 Every long-running step is idempotent

Examples:

- Generating an image for `scene_id=123` should not create duplicates when retried unless explicitly requested.
- Rendering `content_id=100` with `version=3` should generate a deterministic artifact path.
- Telegram notifications should store a message ID so duplicate sends can be detected.

### 7.3 Version everything that can change

At minimum:

- script version
- scene version
- prompt version
- template version
- render version

### 7.4 Human approval is a first-class state

Do not treat approval as a side effect of a Telegram message. Store it in PostgreSQL.

## 8. Initial deployment topology

For development/small scale:

```text
Docker Compose
├── n8n
├── postgres
├── render-worker
└── optional minio
```

For production/small scale:

```text
Server
├── reverse proxy
├── n8n
├── postgres
├── render-worker
└── object storage (S3/R2/MinIO)
```

Redis is optional initially and should be added when queueing/concurrency requires it.

## 9. Future expansion

After the system is stable:

1. Auto publishing abstraction.
2. TikTok API integration where eligible.
3. Analytics ingestion.
4. Performance scoring per hook/template/topic.
5. AI-assisted iteration based on historical results.
6. Multiple channels/platforms.
