# Hướng dẫn tạo Workflow Idea Engine trên n8n

Do hệ thống n8n quản lý các node AI (Gemini) khá phức tạp với nhiều tham số nội bộ, việc Import file JSON đôi khi gây lỗi cấu trúc. Do đó, bạn hãy thiết lập trực tiếp trên giao diện kéo thả theo thứ tự sau. Các đoạn hội thoại (Prompt) mình đã chuẩn bị sẵn ở thư mục `n8n/prompts/` cho bạn rồi!

## Bước 1: Thêm Schedule Trigger
- Tìm node **Schedule Trigger**, chọn Rule: `Every Day` lúc `08:00`.

## Bước 2: Nguồn RSS News
- Thêm 2 node **RSS Read**.
- Điền 2 URL tin tức công nghệ: 
  - `https://viblo.asia/rss/posts/newest.rss`
  - `https://dev.to/feed`

## Bước 3: Merge & Lọc trùng
- Thêm node **Merge**, nối 2 node RSS vào nó. Mode: `Append` (Gộp lại thành 1 mảng lớn).
- Thêm node **Remove Duplicates**:
  - Chọn Action: `Remove items repeated within current input` (Để dễ dàng Test nhiều lần).
  - Compare: `Fields`
  - Fields to Compare: Nhập `title` hoặc `link`.

## Bước 4: Chuỗi Google Gemini
Thêm 3 node **Google Gemini Chat Model** (nhớ Add Credential bằng API Key bạn đã cấp).

**1. LLM - Analyze News:**
- Chọn Model: `models/gemini-3-flash-preview` (hoặc model mặc định nào có sẵn).
- Copy nội dung file `n8n/prompts/analyze-news.v1.md` dán vào phần System Message hoặc Prompt.
- Truyền output của bước lọc trùng vào đây.

**2. LLM - Generate Ideas:**
- Nối sau node Analyze News.
- Copy nội dung file `n8n/prompts/idea-generator.v1.md` dán vào Prompt.
- Yêu cầu output format là `JSON`.

**3. LLM - Score Ideas:**
- Nối sau node Generate Ideas.
- Copy nội dung file `n8n/prompts/score-ideas.v1.md` dán vào Prompt.
- Yêu cầu output format là `JSON`.

## Bước 5: Lưu Database
- Thêm node **PostgreSQL**, chọn Action `Insert`.
- Chọn Table `content`. 
- Mapping Column Mode: `Map Each Column Manually`.
- Gắn các cột từ JSON (`topic`, `title`, `hook`, `idea_type`, `novelty_score`...) vào các cột tương ứng. Riêng cột `status` gõ chữ `IDEA`. Cột `id` nhập biểu thức `={{ $execution.id }}_{{ $itemIndex }}`.

## Bước 5.5: Lọc Top Ý Tưởng Xuất Sắc Nhất
Để tránh bị spam Telegram, chúng ta chỉ gửi top 3 ý tưởng điểm cao nhất.
- Nối tiếp node Postgres vào node **Sort**.
- Cài đặt Sort: Chọn `Fields to Sort By`, nhập chữ `total_score`, chọn thứ tự `Descending` (Giảm dần - từ cao xuống thấp).
- Nối node Sort vào node **Limit**.
- Cài đặt Limit: `Max Items` nhập số `3` (Hoặc số lượng tin nhắn bạn muốn nhận mỗi ngày).

## Bước 6: Thông báo qua Telegram kèm Nút bấm
- Nối node Limit vào node **Telegram**.
- Action: `Send Message`.
- Mở mục **Add Options** -> Chọn **Parse Mode** -> Chọn `Markdown`.
- **Text**: Copy dán mẫu văn bản sau:
- Mở mục **Add Options** (dưới cùng node Telegram) -> Chọn **Reply Markup** -> Chọn **Inline Keyboard**.
- Thêm 1 nút: 
  - Text: `✅ Chốt Idea này`
  - Callback Data: `approve_{{ $json.topic }}` (Để sau này hệ thống nhận diện bạn bấm duyệt bài nào).

---
*Lưu ý: Bạn mở các file trong thư mục `n8n/prompts/` để copy chính xác Prompt mình đã tối ưu riêng cho ngách Technical của bạn nhé!*
