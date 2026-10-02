# Phase 08 — Monitoring, Retry, Metrics & Improvement

## Goal

Làm hệ thống đủ ổn định để chạy định kỳ mà không cần liên tục mở n8n kiểm tra.

## Monitoring

- [ ] Tạo global Error Trigger workflow.
- [ ] Lưu workflow errors vào PostgreSQL.
- [ ] Gửi Telegram alert cho terminal failures.
- [ ] Gửi error có content ID và execution ID.
- [ ] Có severity: INFO/WARN/ERROR/CRITICAL.

## Retry

Các lỗi nên retry:

- timeout
- HTTP 429
- transient 5xx
- network error

Các lỗi không nên retry vô hạn:

- invalid API key
- invalid request
- schema validation failed
- moderation/policy rejection
- missing source data

## Idempotency

Mỗi external operation nên có idempotency key khi provider hỗ trợ.

Internal example:

```text
content:{id}:version:{version}:scene:{scene}:asset:{type}
```

## Metrics

Tối thiểu theo dõi:

```text
ideas_generated
ideas_selected
scripts_generated
assets_generated
videos_rendered
reviews
approvals
rejections
regenerations
manual_posts
failure_count
average_render_time
average_generation_time
```

## Content quality metrics

Khi bắt đầu có dữ liệu TikTok thủ công, nhập một số metric vào database:

- views
- likes
- comments
- shares
- saves
- watch time nếu có
- completion rate nếu có

Sau đó phân tích theo:

- topic
- hook
- template
- duration
- voice
- CTA

## Improvement loop

```text
Published videos
       ↓
Performance data
       ↓
Analyze patterns
       ↓
Update scoring rules
       ↓
Update prompts/templates
       ↓
Generate next ideas
```

## Definition of Done

Hệ thống có thể chạy nhiều ngày liên tục; lỗi terminal được báo ngay, retry có kiểm soát, và có số liệu đủ để biết bottleneck nằm ở research, AI generation, rendering hay review.
