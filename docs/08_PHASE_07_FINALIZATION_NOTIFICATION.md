# Phase 07 — Finalization, Manual Posting & Notifications

## Goal

Sau khi approve, tạo package cuối cùng để owner tự đăng TikTok và xác nhận trạng thái thủ công.

## Workflow

```text
APPROVED
   ↓
Final render
   ↓
Final validation
   ↓
Generate posting package
   ↓
Telegram notification
   ↓
Owner uploads TikTok manually
```

## Posting package

Tạo một package chứa:

```text
final.mp4
metadata.json
caption.txt
hashtags.txt
sources.txt
```

Ví dụ `metadata.json`:

```json
{
  "content_id": "123",
  "title": "...",
  "caption": "...",
  "hashtags": ["#..."],
  "duration_sec": 41,
  "template": "developer_dark",
  "script_version": 2
}
```

## Tasks

### Final render

- [ ] Render final video từ version đã approve.
- [ ] Validate lại output.
- [ ] Đổi status `APPROVED` → `FINALIZING`.
- [ ] Đổi status `FINALIZING` → `READY_TO_POST`.

### Package

- [ ] Upload final video.
- [ ] Generate caption text.
- [ ] Generate hashtags text.
- [ ] Generate source list.
- [ ] Lưu các URL/storage keys.

### Notification

- [ ] Gửi Telegram notification.
- [ ] Gửi email notification nếu cần.
- [ ] Có direct link tới video.
- [ ] Có caption copy-ready.
- [ ] Có hashtags copy-ready.

### Manual posting tracking

Ban đầu có thể dùng:

```text
READY_TO_POST
MANUALLY_POSTED
```

Owner có thể đánh dấu `MANUALLY_POSTED` bằng Telegram command/button.

- [ ] Tạo action `MARK_POSTED`.
- [ ] Lưu `posted_at`.
- [ ] Không cần TikTok API.

## Definition of Done

Sau khi approve:

1. Final video tồn tại.
2. Caption/hashtags đầy đủ.
3. Telegram gửi package.
4. Owner tự đăng TikTok.
5. Owner có thể mark content là `MANUALLY_POSTED`.
