# Phase 05 — Video Rendering with FFmpeg

## Goal

Biến script + assets thành video TikTok dọc hoàn chỉnh.

## Architecture

n8n không thực hiện toàn bộ xử lý video.

```text
n8n
 ↓
Render Job
 ↓
Render Worker
 ↓
FFmpeg
 ↓
MP4
 ↓
Storage
 ↓
DB
```

## Render Worker

Có thể implement bằng Python FastAPI hoặc một CLI service.

Recommended API:

```http
POST /render
```

Request:

```json
{
  "content_id": "123",
  "version": 1,
  "template": "developer_dark",
  "scenes": [
    {
      "image": "...",
      "start": 0,
      "end": 5,
      "subtitle": "..."
    }
  ],
  "voice": "...",
  "music": "..."
}
```

## Tasks

### Render worker

- [ ] Tạo Docker image có FFmpeg.
- [ ] Tạo `/health` endpoint.
- [ ] Tạo `/render` endpoint.
- [ ] Tạo work directory theo job ID.
- [ ] Download/read assets.
- [ ] Build FFmpeg command/config.
- [ ] Render video.
- [ ] Validate output.
- [ ] Upload output.
- [ ] Trả metadata.

### Video format

Giai đoạn đầu target:

```text
Aspect ratio: 9:16
Resolution: 1080x1920
Format: MP4
Video codec: H.264
Audio: AAC
```

### Scene rendering

- [ ] Hiển thị image theo duration.
- [ ] Crop/scale đúng 9:16.
- [ ] Thêm motion effect nhẹ nếu template yêu cầu.
- [ ] Mix voice + background music.
- [ ] Normalize audio.
- [ ] Burn subtitle.
- [ ] Add CTA/end card.

### Templates

Tạo template system:

```text
templates/
├── developer_dark
├── developer_light
└── simple_news
```

Mỗi template định nghĩa:

- font
- colors
- subtitle position
- transition
- image animation
- CTA
- audio levels

### Validation

- [ ] File tồn tại.
- [ ] Có thể decode.
- [ ] Resolution chính xác.
- [ ] Duration đúng khoảng target.
- [ ] Có audio.
- [ ] Có subtitle nếu required.
- [ ] Không có scene missing.

## Definition of Done

Từ một content đã có assets, hệ thống tạo được `preview.mp4`/`final.mp4` hoàn chỉnh và lưu trạng thái `READY_FOR_REVIEW`.
