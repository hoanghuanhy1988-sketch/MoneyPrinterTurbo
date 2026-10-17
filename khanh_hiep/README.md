# KH�NH HI?P AI VIDEO STUDIO � chu?n b? ph�t tri?n

��y l� b? thi?t l?p m�i tr�?ng, ch�a ph?i ?ng d?ng KH�NH HI?P ho�n ch?nh.

- Repository: https://github.com/hoanghuanhy1988-sketch/MoneyPrinterTurbo
- Nh�nh ph�t tri?n: `dev/khanh-hiep-ai-video-studio`.
- M? g?c: `harry0703/MoneyPrinterTurbo`, commit `9e7d8b7efa6b912058156943906542b53b945f0a`.
- Gi? nguy�n t?t c? t?p g?c, LICENSE v� nh�nh main. Ch? b? sung th� m?c `khanh_hiep` v� workflow ki?m tra ri�ng.
- Ch? MASTER PROMPT tr�?c khi ph�t tri?n t�nh n�ng, thay giao di?n ho?c t�ch h?p model.
- Kh�ng g?i API tr? ph�, kh�ng th�m kh�a API, kh�ng xu?t b?n ?ng d?ng ho?c g�i PyPI.

## Windows

Sau khi clone repository v� chuy?n sang nh�nh ph�t tri?n, ch?y t? th� m?c g?c:

```powershell
powershell -NoProfile -File khanh_hiep/scripts/setup-windows.ps1
```

Script d�ng uv c� s?n; n?u ch�a c� uv nh�ng c� Python 3.11+, n� c�i uv v�o m�i tr�?ng bootstrap ri�ng trong `storage`. N?u ch�a c� c? Python v� uv, script d?ng v?i h�?ng d?n r? r�ng. Kh�ng t? �?i ch�nh s�ch PowerShell, firewall, TLS ho?c c�i ph?n m?m to�n h? th?ng.

Script c�i dependencies theo `uv.lock`, t?o config local khi ch�a t?n t?i, r?i ki?m tra import, CLI, m? h�a/gi?i m? MP4 v� HTTP health c?a Streamlit. N� kh�ng g?i nh� cung c?p AI, kh�ng t?i model, kh�ng kh?i �?ng t�c v? t?o video t? �?ng. K?t n?i m?ng v?n c?n �? t?i Python/dependencies.

Ki?m tra l?i v� build g�i g?c:

```powershell
.venv\Scripts\python.exe khanh_hiep/scripts/smoke.py
uv build --out-dir storage/khanh-hiep-build
```

Build n�y t?o wheel/sdist c?a MoneyPrinterTurbo, kh�ng t?o EXE ho?c APK. Ch�a c� b? c�i ?ng d?ng KH�NH HI?P.

M? giao di?n g?c sau khi ki?m tra th�nh c�ng:

```powershell
.venv\Scripts\python.exe -m streamlit run webui/Main.py --server.address=127.0.0.1 --browser.gatherUsageStats=false
```

## Codex Cloud

Ch?n repository tr�n v� nh�nh ph�t tri?n. Setup command �? xu?t:

```bash
bash khanh_hiep/scripts/setup-cloud.sh
```

��y l� script �? chu?n b?; vi?c c� script trong GitHub kh�ng ch?ng minh Codex Cloud �? k?t n?i ho?c setup �? ch?y. C?n ho�n t?t ��ng nh?p/MFA, ch?n repository trong Codex v� ki?m tra log setup. Codex Cloud v� Windows l� hai m�i tr�?ng kh�c nhau.

## C?u tr�c m? r?ng

`planning/`: ph?m vi v� �i?m b?t �?u nh?n MASTER PROMPT.
`scripts/`: thi?t l?p v� ki?m tra m�i tr�?ng.
`config.local.example.toml`: c?u h?nh kh?i �?u kh�ng ch?a kh�a, ch?n nguy�n li?u local v� Ollama t?i localhost.

?nh s?n ph?m, ?nh nh�n v?t, video, kh�a v� d? li?u ri�ng ph?i l�u trong `storage/` ho?c n�i ngo�i repository. Fork hi?n l� PUBLIC. Kh�ng ��a d? li?u ri�ng v�o commit.

## Gi?i h?n ch? �? mi?n ph�

Setup v� smoke test kh�ng s? d?ng API AI. C?u h?nh m?u ch?n local/Ollama nh�ng ch�a c�i Ollama ho?c model. Vi?c t?o ?nh/video AI m?i mi?n ph� tr�n m�y c?n ph? thu?c ph?n c?ng v� model; ch�a ��?c tri?n khai. M? upstream v?n c� c�c nh� cung c?p tr? ph� v� t�y ch?n �?i provider; b? chu?n b? n�y ch�a x�y d?ng c� ch? ch?n API tr? ph� to�n ?ng d?ng. Kh�ng nh?p kh�a ho?c ch?n provider tr? ph�.

Ki?m tra HTTP health ch? x�c nh?n m�y ch? Streamlit ��p ?ng, kh�ng thay th? ki?m th? thao t�c giao di?n ho?c quy tr?nh t?o video ho�n ch?nh.
