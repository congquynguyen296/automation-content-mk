# Phase 02 — Idea Engine

## Goal

Từ lịch chạy tự động, hệ thống tạo và lưu các ý tưởng content có cấu trúc.

## Output

Mỗi idea có:

- topic
- title
- hook
- target audience
- reason
- novelty score
- usefulness score
- curiosity score
- production cost score
- total score
- status

## Workflow

```text
Schedule
  ↓
Collect trend/source signals
  ↓
LLM generate ideas
  ↓
Validate JSON
  ↓
Score
  ↓
Deduplicate
  ↓
PostgreSQL
  ↓
Telegram summary
```

## Tasks

### Research input

- [ ] Chọn nguồn trend/research cho niche đầu tiên.
- [ ] Chọn provider tìm kiếm/web phù hợp.
- [ ] Tạo credential.
- [ ] Tạo node thu thập dữ liệu.
- [ ] Chuẩn hóa dữ liệu đầu vào.

### Idea generation

- [ ] Viết prompt `idea-generator.v1`.
- [ ] Yêu cầu JSON structured output.
- [ ] Validate output.
- [ ] Reject malformed response.

### Scoring

Tạm thời dùng:

```text
score =
  trend * 0.30 +
  curiosity * 0.25 +
  usefulness * 0.20 +
  novelty * 0.15 +
  production_cost * 0.10
```

- [ ] Xác định thang điểm 0-100.
- [ ] Viết node tính score.
- [ ] Lưu breakdown từng score.

### Deduplication

- [ ] Normalize title.
- [ ] Kiểm tra exact duplicate.
- [ ] Kiểm tra duplicate gần nghĩa bằng LLM hoặc embedding ở phase sau.
- [ ] Không tạo nhiều content từ cùng một topic trong khoảng thời gian ngắn.

### Persistence

- [ ] Insert ideas vào database.
- [ ] Tạo unique/index phù hợp.
- [ ] Trạng thái ban đầu `IDEA`.

### Notification

- [ ] Gửi top N ideas qua Telegram.
- [ ] Hiển thị score.
- [ ] Có content/idea ID.

## Definition of Done

Chạy workflow một lần và nhận được ít nhất 5 ideas hợp lệ trong database, không có JSON lỗi hoặc duplicate obvious.
