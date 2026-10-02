# AI TikTok Content Automation — Detailed System Specification

## 1. Scope

### In scope for current version

- Idea generation
- Trend/source research
- Script generation
- Scene breakdown
- Image generation
- Voice generation
- Subtitle generation
- Background music mixing using owned/licensed assets
- Video rendering
- Telegram review
- Approve/reject/regenerate
- Final metadata generation
- Manual TikTok posting
- Success/failure notification

### Out of scope for current version

- Automatic TikTok publishing
- TikTok analytics ingestion
- Multi-account publishing
- Automatic trend scraping from restricted/private sources
- Fully autonomous content approval

## 2. Content object

A content item is the unit of work.

Example logical structure:

```json
{
  "id": "content-001",
  "status": "READY_FOR_REVIEW",
  "topic": "Why Redis is fast",
  "title": "Why Redis is so fast",
  "hook": "Bạn có bao giờ thắc mắc...",
  "script_version": 1,
  "template": "developer_dark",
  "duration_target_sec": 40,
  "caption": "...",
  "hashtags": ["#redis", "#backend", "#developer"],
  "sources": [],
  "scenes": [],
  "assets": [],
  "video": null
}
```

## 3. Database model

Recommended tables:

### content

```text
id
status
topic
title
hook
script
caption
hashtags
template_key
target_duration_sec
created_at
updated_at
approved_at
finalized_at
posted_at
```

### content_version

```text
id
content_id
version
script
caption
hashtags
created_at
created_by
reason
```

### scene

```text
id
content_id
scene_order
start_sec
end_sec
narration
visual_description
image_prompt
subtitle_text
version
created_at
```

### asset

```text
id
content_id
scene_id
asset_type
provider
provider_asset_id
storage_key
public_url
version
status
created_at
```

### review

```text
id
content_id
version
status
reviewer
comment
telegram_message_id
created_at
```

### render_job

```text
id
content_id
version
template_key
status
input_manifest
output_storage_key
error_message
started_at
finished_at
```

### workflow_error

```text
id
content_id
workflow_name
node_name
error_code
error_message
execution_id
created_at
resolved_at
```

## 4. Status contract

Each workflow must receive the expected current status and only move to known next states.

Example:

```text
RESEARCHING -> SCRIPT_GENERATED
```

is valid.

```text
RESEARCHING -> APPROVED
```

is invalid.

## 5. AI contracts

Every AI node should use structured JSON, not free-form prose, whenever downstream automation consumes the result.

Example script contract:

```json
{
  "title": "string",
  "hook": "string",
  "scenes": [
    {
      "scene_order": 1,
      "duration_sec": 5,
      "narration": "string",
      "visual_description": "string",
      "image_prompt": "string",
      "subtitle_text": "string"
    }
  ],
  "cta": "string",
  "caption": "string",
  "hashtags": ["string"]
}
```

The workflow validates this structure before persisting it.

## 6. Prompt versioning

Prompts should live outside scattered n8n nodes whenever possible.

Recommended structure:

```text
prompts/
├── idea-generator.v1.md
├── researcher.v1.md
├── script-generator.v1.md
├── image-prompt.v1.md
├── metadata-generator.v1.md
└── reviewer.v1.md
```

Store the prompt version in the database with the generated content.

## 7. Asset naming

Recommended deterministic convention:

```text
content/{content_id}/v{version}/
├── scenes/
│   ├── 001.png
│   ├── 002.png
│   └── 003.png
├── audio/
│   └── voice.mp3
├── subtitles/
│   └── captions.ass
├── music/
│   └── bgm.mp3
├── renders/
│   └── preview.mp4
└── final/
    └── final.mp4
```

## 8. Review protocol

Telegram message must contain:

- content ID
- title
- hook
- duration
- preview video
- caption
- hashtags
- approval buttons

Actions:

```text
APPROVE
REGENERATE_SCRIPT
REGENERATE_VISUAL
RENDER_AGAIN
REJECT
```

The callback must contain a content ID and version.

## 9. Regeneration rules

### Regenerate script

Keep:

- topic
- research
- existing content ID

Replace:

- hook
- script
- scenes
- caption
- hashtags

### Regenerate visual

Keep:

- topic
- script
- narration

Replace:

- image prompt
- image asset

### Render again

Keep all assets and regenerate only the video output.

## 10. Error handling

Every external API call should have:

- timeout
- retry
- retry limit
- error logging
- human notification for terminal failure

Recommended retry policy:

```text
Attempt 1 -> immediate
Attempt 2 -> 5s
Attempt 3 -> 30s
Then -> FAILED
```

Do not blindly retry validation/business errors.

## 11. Observability

Each execution should be traceable by:

```text
content_id
workflow_name
workflow_execution_id
node_name
asset_id
render_job_id
```

## 12. Security

Secrets must be stored in n8n credentials/environment variables/secrets management, never in prompts or workflow source.

Protect:

- AI API keys
- Telegram bot token
- database credentials
- object storage credentials
- future TikTok OAuth credentials

## 13. Quality gates

Before review, automated validation should check:

- video exists
- file is readable
- vertical 9:16 format
- target resolution
- audio exists
- duration within allowed range
- subtitle file exists if required
- no missing scene assets
- caption is present
- hashtags exist

## 14. Human workflow

The owner should only need to make decisions at meaningful checkpoints:

```text
AI generates
     ↓
Review
     ↓
Approve or regenerate
     ↓
Final video ready
     ↓
Manual TikTok upload
```

The system should avoid asking for human input between ordinary deterministic steps.
