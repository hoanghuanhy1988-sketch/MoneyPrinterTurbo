# KHÁNH HIỆP AI VIDEO STUDIO — chuẩn bị phát triển

Đây là bộ thiết lập môi trường, chưa phải ứng dụng KHÁNH HIỆP hoàn chỉnh.

- Repository: https://github.com/hoanghuanhy1988-sketch/MoneyPrinterTurbo
- Nhánh phát triển: `dev/khanh-hiep-ai-video-studio`.
- Mã gốc: `harry0703/MoneyPrinterTurbo`, commit `9e7d8b7efa6b912058156943906542b53b945f0a`.
- Giữ nguyên tất cả tệp gốc, LICENSE và nhánh main. Chỉ bổ sung thư mục `khanh_hiep` và workflow kiểm tra riêng.
- Chờ MASTER PROMPT trước khi phát triển tính năng, thay giao diện hoặc tích hợp model.
- Không gọi API trả phí, không thêm khóa API, không xuất bản ứng dụng hoặc gói PyPI.

## Windows

Sau khi clone repository và chuyển sang nhánh phát triển, chạy từ thư mục gốc:

```powershell
powershell -NoProfile -File khanh_hiep/scripts/setup-windows.ps1
```

Script dùng uv có sẵn; nếu chưa có uv nhưng có Python 3.11+, nó cài uv vào môi trường bootstrap riêng trong `storage`. Nếu chưa có cả Python và uv, script dừng với hướng dẫn rõ ràng. Không tự đổi chính sách PowerShell, firewall, TLS hoặc cài phần mềm toàn hệ thống.

Script cài dependencies theo `uv.lock`, tạo config local khi chưa tồn tại, rồi kiểm tra import, CLI, mã hóa/giải mã MP4 và HTTP health của Streamlit. Nó không gọi nhà cung cấp AI, không tải model, không khởi động tác vụ tạo video tự động. Kết nối mạng vẫn cần để tải Python/dependencies.

Kiểm tra lại và build gói gốc:

```powershell
.venv\Scripts\python.exe khanh_hiep/scripts/smoke.py
uv build --out-dir storage/khanh-hiep-build
```

Build này tạo wheel/sdist của MoneyPrinterTurbo, không tạo EXE hoặc APK. Chưa có bộ cài ứng dụng KHÁNH HIỆP.

Mở giao diện gốc sau khi kiểm tra thành công:

```powershell
.venv\Scripts\python.exe -m streamlit run webui/Main.py --server.address=127.0.0.1 --browser.gatherUsageStats=false
```

## Codex Cloud

Chọn repository trên và nhánh phát triển. Setup command đề xuất:

```bash
bash khanh_hiep/scripts/setup-cloud.sh
```

Đây là script đã chuẩn bị; việc có script trong GitHub không chứng minh Codex Cloud đã kết nối hoặc setup đã chạy. Cần hoàn tất đăng nhập/MFA, chọn repository trong Codex và kiểm tra log setup. Codex Cloud và Windows là hai môi trường khác nhau.

## Cấu trúc mở rộng

`planning/`: phạm vi và điểm bắt đầu nhận MASTER PROMPT.
`scripts/`: thiết lập và kiểm tra môi trường.
`config.local.example.toml`: cấu hình khởi đầu không chứa khóa, chọn nguyên liệu local và Ollama tại localhost.

Ảnh sản phẩm, ảnh nhân vật, video, khóa và dữ liệu riêng phải lưu trong `storage/` hoặc nơi ngoài repository. Fork hiện là PUBLIC. Không đưa dữ liệu riêng vào commit.

## Giới hạn chế độ miễn phí

Setup và smoke test không sử dụng API AI. Cấu hình mẫu chọn local/Ollama nhưng chưa cài Ollama hoặc model. Việc tạo ảnh/video AI mới miễn phí trên máy còn phụ thuộc phần cứng và model; chưa được triển khai. Mã upstream vẫn có các nhà cung cấp trả phí và tùy chọn đổi provider; bộ chuẩn bị này chưa xây dựng cơ chế chặn API trả phí toàn ứng dụng. Không nhập khóa hoặc chọn provider trả phí.

Kiểm tra HTTP health chỉ xác nhận máy chủ Streamlit đáp ứng, không thay thế kiểm thử thao tác giao diện hoặc quy trình tạo video hoàn chỉnh.
