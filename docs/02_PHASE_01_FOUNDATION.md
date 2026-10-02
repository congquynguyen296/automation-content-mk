# Phase 01 — Foundation: Docker, n8n, PostgreSQL, Secrets

## Goal

Có môi trường chạy ổn định cho n8n và database trước khi xây AI workflow.

## Deliverables

- Docker Compose chạy được.
- n8n truy cập được qua browser.
- PostgreSQL hoạt động.
- n8n kết nối PostgreSQL.
- Telegram bot tạo được.
- Secrets được tách khỏi workflow.
- Git repository có cấu trúc project.

## Tasks

### 1. Repository

- [ ] Tạo repository cho project.
- [ ] Tạo `README.md`.
- [ ] Tạo `.gitignore`.
- [ ] Tạo `.env.example`.
- [ ] Không commit `.env` thật.

### 2. Docker

- [ ] Tạo `docker-compose.yml`.
- [ ] Tạo service `n8n`.
- [ ] Tạo service `postgres`.
- [ ] Tạo persistent volume cho n8n.
- [ ] Tạo persistent volume cho PostgreSQL.
- [ ] Kiểm tra restart policy.
- [ ] Kiểm tra timezone `Asia/Ho_Chi_Minh`.

### 3. n8n

- [ ] Đăng nhập được.
- [ ] Tạo credential PostgreSQL.
- [ ] Tạo workflow test.
- [ ] Test Cron/Schedule trigger.
- [ ] Test Manual Trigger.
- [ ] Test HTTP Request node.
- [ ] Test Code node ở mức tối thiểu.
- [ ] Hiểu expression syntax của n8n.

### 4. Database

- [ ] Tạo database.
- [ ] Tạo migration đầu tiên.
- [ ] Tạo bảng `content`.
- [ ] Tạo bảng `content_version`.
- [ ] Tạo bảng `scene`.
- [ ] Tạo bảng `asset`.
- [ ] Tạo bảng `review`.
- [ ] Tạo bảng `render_job`.
- [ ] Tạo bảng `workflow_error`.

### 5. Telegram

- [ ] Tạo Telegram bot.
- [ ] Lưu bot token trong secret/credential.
- [ ] Lấy chat ID.
- [ ] Test gửi text.
- [ ] Test gửi file.
- [ ] Test inline keyboard/callback theo khả năng node/API được dùng.

### 6. Health check

- [ ] Tạo workflow `system-health-check`.
- [ ] Kiểm tra PostgreSQL.
- [ ] Kiểm tra Telegram.
- [ ] Gửi kết quả về Telegram.

## Definition of Done

```text
Docker Compose up
        ↓
n8n online
        ↓
Postgres connected
        ↓
Telegram message received
```

Nếu một trong các bước trên chưa ổn định thì chưa chuyển phase.
