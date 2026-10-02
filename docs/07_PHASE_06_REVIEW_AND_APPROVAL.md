# Phase 06 — Telegram Review & Approval

## Goal

Tạo human approval gate để owner review video trước khi đăng TikTok.

## Workflow

```text
READY_FOR_REVIEW
       ↓
Send Telegram message
       ↓
WAIT
       ↓
┌──────┼─────────────┐
↓      ↓             ↓
APPROVE REGENERATE   REJECT
↓      ↓             ↓
READY  regenerate   REJECTED
TO_POST
```

## Review message

Tin nhắn nên có:

```text
🎬 Content #123

Title: ...
Hook: ...
Duration: 41s

[VIDEO]

Caption:
...

Hashtags:
#...
```

Buttons:

```text
✅ APPROVE
🔄 SCRIPT
🖼 VISUAL
🎞 RENDER
❌ REJECT
```

## Tasks

### Telegram integration

- [ ] Tạo send-review workflow.
- [ ] Gửi video preview.
- [ ] Gửi caption/hashtags.
- [ ] Gắn content ID vào callback data.
- [ ] Gắn version vào callback data.

### Approval

- [ ] Nhận callback.
- [ ] Validate content/version.
- [ ] Kiểm tra status hiện tại.
- [ ] Update review record.
- [ ] Update content status.
- [ ] Trigger finalize workflow.

### Regeneration

#### Script

- [ ] Gửi lại script workflow.
- [ ] Tạo version mới.
- [ ] Generate assets cần thiết.
- [ ] Render lại.
- [ ] Gửi preview mới.

#### Visual

- [ ] Giữ script.
- [ ] Chỉ regenerate images được chọn hoặc toàn bộ.
- [ ] Render lại.

#### Render

- [ ] Giữ tất cả asset.
- [ ] Chỉ render lại video.

### Reject

- [ ] Nhập lý do reject.
- [ ] Lưu comment.
- [ ] Không tiếp tục publish/finalize.

## Race conditions

Phải xử lý trường hợp user bấm 2 lần.

Ví dụ:

```text
APPROVE
APPROVE
```

Chỉ callback đầu tiên hợp lệ; callback sau phải nhận trạng thái "already processed".

## Definition of Done

Owner có thể xem video trên Telegram, bấm Approve, và hệ thống chuyển đúng sang trạng thái `READY_TO_POST` mà không cần sửa database thủ công.
