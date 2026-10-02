# Hướng Dẫn Ráp Node Phase 03: Research & Script Engine

Phase này sẽ xây dựng một **Workflow (Luồng) hoàn toàn mới** trong n8n. Hãy bấm "Add Workflow" để tạo một luồng trắng mới nhé.

Mục tiêu của luồng này: Chờ bạn bấm nút "Chốt Idea" trên điện thoại ➔ Lấy Idea từ DB ➔ Research ➔ Viết kịch bản chi tiết ➔ Lưu vào DB.

---

## Bước 1: Bắt tín hiệu từ Telegram
1. Bấm `+` thêm node **Telegram Trigger**.
2. Chọn Credential Telegram mà bạn đã tạo ở Phase 2.
3. Ô **Updates**, chọn `Callback Query` (Đây là sự kiện xảy ra khi bạn bấm vào nút Inline Keyboard).
4. Bạn hãy ra điện thoại, bấm vào một cái nút "✅ Chốt Bài X" bất kỳ hôm nọ. Sau đó quay lại n8n bấm **Listen for Event** để n8n bắt được tín hiệu mẫu. (Bạn sẽ thấy nó trả về chuỗi `approve_12345_0`).

## Bước 2: Tách lấy ID của bài viết
Tín hiệu gửi về là `approve_12345_0`, ta cần tách chữ `approve_` ra để lấy đúng cái ID `12345_0`.
1. Thêm node **Code** ngay sau Telegram Trigger.
2. Dán đoạn code sau vào:
   ```javascript
   const callbackData = $json.callback_query.data; // Ví dụ: "approve_12345_0"
   const contentId = callbackData.replace("approve_", ""); // Lấy ra: "12345_0"
   
   return [{ json: { content_id: contentId } }];
   ```

## Bước 3: Lấy thông tin Idea từ Database
1. Thêm node **PostgreSQL**, Action chọn **Execute Query**.
2. Dán câu lệnh SQL này vào ô Query:
   ```sql
   SELECT id, topic, title, hook, idea_type 
   FROM content 
   WHERE id = '{{ $json.content_id }}';
   ```
   *(Nhớ thay bằng biểu thức kéo thả chính xác từ node Code nhé).*
3. Bấm Execute để nó lôi cái Topic và Title từ DB lên.

## Bước 4: AI Research (Nghiên cứu chuyên sâu)
1. Thêm node **Google Gemini** (Giống hệt node LLM ở Phase 2, chọn Action **Generate Text**).
2. Chọn Model: `models/gemini-3.1-pro-preview` (Nên dùng Pro để nó có tư duy đào sâu kiến thức nhất).
3. Mở file `n8n/prompts/research-extractor.v1.md`, copy nội dung dán vào ô **Prompt**.
4. Xống dòng ở ô Prompt, kéo thả dữ liệu bài viết vào để AI biết cần nghiên cứu cái gì:
   ```text
   ---
   TOPIC TO RESEARCH:
   Topic: {{ $json.topic }}
   Title: {{ $json.title }}
   Hook: {{ $json.hook }}
   ```
5. Đừng bật JSON, để nguyên cho nó trả về Text. Bấm Execute.

## Bước 5: AI Viết Kịch Bản (Script Generation)
1. Nối tiếp thêm 1 node **Google Gemini** nữa.
2. Lại chọn Model xịn nhất (`models/gemini-3.1-pro-preview`).
3. Mở file `n8n/prompts/script-generator.v1.md`, copy dán vào ô **Prompt**.
4. Xuống dòng ở ô Prompt, truyền nguyên liệu (bản Research của node trước) vào:
   ```text
   ---
   RESEARCH SUMMARY:
   {{ $json.text }}
   ```
5. **QUAN TRỌNG:** Bật xanh 2 công tắc **"Output Content as JSON"** và **"Simplify Output"**. 
6. Bấm Execute. Đợi khoảng 10s, nó sẽ nhả ra 1 mảng JSON chứa 5-6 phân cảnh (scenes) cực kỳ chi tiết!

## Bước 6: Tách Kịch Bản thành các Phân Cảnh Rời (Code)
Vì Output là 1 cục Text JSON chứa mảng các Scene, ta phải tách nó ra.
1. Thêm node **Code**, chọn Mode `Run Once for All Items`.
2. Dán đoạn này vào:
   ```javascript
   const scenes = JSON.parse($json.text);
   const contentId = $('PostgreSQL').item.json.id; // Lấy ID bài gốc

   // Tạo ID ngẫu nhiên cho từng Scene và gắn Content ID vào
   return scenes.map((scene, index) => {
     scene.id = contentId + "_scene_" + (index + 1);
     scene.content_id = contentId;
     return { json: scene };
   });
   ```

## Bước 7: Lưu Kịch Bản vào bảng `scene`
1. Nối tiếp node **PostgreSQL**, chọn Action **Insert**.
2. Table: `scene`.
3. Mapping Column Mode: **Map Automatically**. 
*(Vì file Prompt mình đã ép AI trả về tên biến chuẩn khớp 100% với tên cột trong DB rồi, n8n sẽ tự động map hết từ `scene_order`, `start_sec`, `narration`, `visual_description`, `image_prompt`... vào DB).*
4. Riêng cột `version` bạn chọn *Map Each Column Manually* bổ sung thêm và điền cứng số **1**.

## Bước 8: Báo tin vui về Telegram
1. Thêm node **Telegram**, Action **Send Message**.
2. Text: `✅ Đã viết xong kịch bản cho Idea: {{ $('PostgreSQL').item.json.title }}!`

Done! Bật công tắc **Active** (Góc trên cùng bên phải) của Workflow này lên. Từ giờ, cứ lướt Telegram bấm nút là kịch bản sẽ tự động được viết và lưu vào DB!
