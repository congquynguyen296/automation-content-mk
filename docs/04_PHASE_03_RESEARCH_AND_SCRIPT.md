# Phase 03 — Research & Script Engine

## Goal

Từ một idea đã chọn, tạo research package đáng tin cậy và script TikTok theo scene.

## Workflow

```text
IDEA
 ↓
Research sources
 ↓
Extract facts
 ↓
Summarize
 ↓
Generate script
 ↓
Validate script
 ↓
Persist version
```

## Tasks

### Research

- [ ] Xây workflow nhận `content_id`.
- [ ] Lấy topic/title/hook từ PostgreSQL.
- [ ] Tìm nguồn liên quan.
- [ ] Lưu source URL/title/domain.
- [ ] Trích xuất facts.
- [ ] Tạo research summary.
- [ ] Yêu cầu AI phân biệt fact và inference.

### Script

- [ ] Viết `script-generator.v1`.
- [ ] Đặt duration target, ví dụ 30-45 giây.
- [ ] Yêu cầu hook trong 1-3 giây đầu.
- [ ] Yêu cầu scene-by-scene.
- [ ] Yêu cầu narration.
- [ ] Yêu cầu visual description.
- [ ] Yêu cầu image prompt.
- [ ] Yêu cầu CTA.
- [ ] Yêu cầu caption.
- [ ] Yêu cầu hashtag.

### Validation

- [ ] Validate JSON schema.
- [ ] Kiểm tra scene count.
- [ ] Kiểm tra duration tổng.
- [ ] Kiểm tra scene order.
- [ ] Kiểm tra narration không rỗng.
- [ ] Kiểm tra caption/hashtags.

### Versioning

- [ ] Tạo `content_version`.
- [ ] Lưu prompt version.
- [ ] Lưu model/provider.
- [ ] Lưu research references.

### Quality rules

- [ ] Không chấp nhận claim không có source nếu content thuộc nhóm factual.
- [ ] Không cho AI tự bịa số liệu.
- [ ] Không sao chép nguyên văn nguồn dài.
- [ ] Có thể regenerate script mà không làm mất research.

## Definition of Done

Một content có script JSON hoàn chỉnh, scene timestamps hợp lệ, source list và metadata. Có thể chuyển status từ `RESEARCHING` → `SCRIPT_GENERATED`.
