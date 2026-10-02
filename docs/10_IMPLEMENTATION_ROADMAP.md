# Implementation Roadmap

## Recommended order

```text
Phase 01  Foundation
   ↓
Phase 02  Idea Engine
   ↓
Phase 03  Research + Script
   ↓
Phase 04  Asset Generation
   ↓
Phase 05  Video Rendering
   ↓
Phase 06  Review + Approval
   ↓
Phase 07  Finalization + Manual Posting
   ↓
Phase 08  Monitoring + Improvement
```

## Milestones

### Milestone A — Infrastructure

Done when Docker + n8n + PostgreSQL + Telegram work.

### Milestone B — Content intelligence

Done when a topic becomes a validated script with sources.

### Milestone C — Media generation

Done when the script becomes images + voice + subtitles.

### Milestone D — Video factory

Done when one topic becomes a valid 9:16 MP4 automatically.

### Milestone E — Human review

Done when Telegram approval can control regeneration/finalization.

### Milestone F — Production loop

Done when the system can repeatedly produce ready-to-post videos and notify the owner.

## MVP acceptance criteria

A single manual topic should be able to go through:

```text
Topic
 → research
 → script
 → images
 → voice
 → subtitles
 → render
 → Telegram review
 → approve
 → final.mp4
 → caption + hashtags
```

without manually editing the video or database.

## What NOT to build initially

- TikTok API publishing
- Admin dashboard
- Multi-user support
- Vector database
- Complex agent architecture
- Kubernetes
- Microservice explosion
- Automatic analytics ingestion
- Fully autonomous approval

## Suggested project structure

```text
tiktok-ai-factory/
├── README.md
├── docker-compose.yml
├── .env.example
├── n8n/
│   ├── workflows/
│   └── prompts/
├── database/
│   ├── migrations/
│   └── seeds/
├── render-worker/
│   ├── app/
│   ├── templates/
│   └── Dockerfile
├── storage/
│   └── .gitkeep
├── docs/
│   ├── 00_ARCHITECTURE.md
│   ├── 01_SYSTEM_SPEC.md
│   └── phases/
└── scripts/
    ├── init.sh
    └── backup.sh
```

## Final design rule

Build the smallest vertical slice first:

```text
1 topic
 → 1 script
 → 3-6 images
 → 1 voice
 → 1 video
 → 1 Telegram review
 → 1 final video
```

Once this works end-to-end, scale the number of ideas, scenes, templates and providers.
