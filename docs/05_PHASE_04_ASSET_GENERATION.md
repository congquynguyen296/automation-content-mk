# Phase 04 — Asset Generation: Images, Voice, Subtitles, Music

## Goal

Tạo đầy đủ media assets theo script trước khi render.

## Input

`content_id` + `content_version` + scenes.

## Outputs

```text
scene images
voice.mp3
subtitle timeline
optional background music
```

## Tasks

### Image generation

- [ ] Chọn image provider đầu tiên.
- [ ] Tạo credential.
- [ ] Tạo image generation workflow.
- [ ] Mỗi scene có một image asset.
- [ ] Lưu prompt.
- [ ] Lưu provider/model.
- [ ] Lưu asset URL/storage key.
- [ ] Retry transient failures.
- [ ] Không tạo duplicate khi retry nếu asset đã READY.

### Voice generation

- [ ] Chọn TTS provider.
- [ ] Chọn voice cố định cho channel.
- [ ] Test pronunciation tiếng Việt.
- [ ] Generate narration.
- [ ] Lưu audio.
- [ ] Validate audio duration.

### Subtitle

Có thể chọn một trong hai cách:

1. TTS response/timeline có timestamp.
2. Speech-to-text lại audio để tạo timestamp.

- [ ] Chọn strategy.
- [ ] Tạo SRT/ASS.
- [ ] Validate timestamp.
- [ ] Kiểm tra text không tràn quá dài trên màn hình.

### Background music

- [ ] Tạo music library riêng.
- [ ] Chỉ dùng file có quyền sử dụng phù hợp.
- [ ] Metadata: title/source/license.
- [ ] Chọn music theo template hoặc rule.
- [ ] Không lấy nhạc TikTok bất kỳ rồi nhúng vào video mặc định.

### Storage

- [ ] Chọn S3/R2/MinIO.
- [ ] Tạo bucket/container.
- [ ] Tạo naming convention.
- [ ] Lưu storage key trong DB.
- [ ] Validate object tồn tại trước render.

## Definition of Done

Một content có đầy đủ:

```text
N scenes images
+ voice
+ subtitles
+ optional licensed BGM
```

và tất cả asset đều được lưu với trạng thái `READY`.
