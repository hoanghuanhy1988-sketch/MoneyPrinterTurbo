"""Environment checks only: no AI requests, no model downloads, no publishing."""
import importlib
import json
import os
from pathlib import Path
import socket
import subprocess
import sys
import tempfile
import time
import urllib.error
import urllib.request

ROOT = Path(__file__).resolve().parents[2]


def run(command, **kwargs):
    return subprocess.run(command, check=True, timeout=120, **kwargs)


def main():
    if sys.version_info < (3, 11):
        raise RuntimeError("Python 3.11+ required")
    os.chdir(ROOT)
    for module in ("streamlit", "fastapi", "moviepy", "imageio_ffmpeg", "toml"):
        importlib.import_module(module)
    import imageio_ffmpeg
    from moviepy import ColorClip

    with tempfile.TemporaryDirectory(prefix="khanh-hiep-smoke-") as temporary:
        temp = Path(temporary)
        env = os.environ.copy()
        env["MPT_HOME"] = str(temp)
        env["PYTHONPATH"] = str(ROOT)
        env["PYTHONUTF8"] = "1"
        env["STREAMLIT_BROWSER_GATHER_USAGE_STATS"] = "false"
        # Isolated configuration: never read or change a user's runtime config.
        (temp / "config.toml").write_bytes(
            (ROOT / "khanh_hiep/config.local.example.toml").read_bytes()
        )
        run([sys.executable, "cli.py", "--help"], env=env, stdout=subprocess.DEVNULL)
        ffmpeg = imageio_ffmpeg.get_ffmpeg_exe()
        run([ffmpeg, "-version"], stdout=subprocess.DEVNULL)
        video = temp / "local-smoke.mp4"
        clip = ColorClip(size=(160, 90), color=(18, 35, 58), duration=1)
        try:
            clip.write_videofile(str(video), fps=12, codec="libx264", audio=False, logger=None)
        finally:
            clip.close()
        run([ffmpeg, "-v", "error", "-i", str(video), "-f", "null", "-"],
            stdout=subprocess.DEVNULL)
        with socket.socket() as listener:
            listener.bind(("127.0.0.1", 0))
            port = listener.getsockname()[1]
        with (temp / "streamlit.log").open("w", encoding="utf-8") as log:
            server = subprocess.Popen([
                sys.executable, "-m", "streamlit", "run", "webui/Main.py",
                "--server.address=127.0.0.1", f"--server.port={port}",
                "--server.headless=true", "--browser.gatherUsageStats=false",
            ], cwd=ROOT, env=env, stdout=log, stderr=subprocess.STDOUT)
            try:
                deadline = time.monotonic() + 40
                while time.monotonic() < deadline:
                    if server.poll() is not None:
                        raise RuntimeError("Streamlit exited before health check")
                    try:
                        with urllib.request.urlopen(
                            f"http://127.0.0.1:{port}/_stcore/health", timeout=2
                        ) as response:
                            if response.status == 200:
                                break
                    except (urllib.error.URLError, TimeoutError):
                        pass
                    time.sleep(0.5)
                else:
                    raise RuntimeError("Streamlit health timed out")
            finally:
                server.terminate()
                try:
                    server.wait(timeout=10)
                except subprocess.TimeoutExpired:
                    server.kill()
                    server.wait(timeout=10)
        print(json.dumps({
            "python": sys.version.split()[0], "platform": sys.platform,
            "imports": "passed", "cli_help": "passed",
            "local_mp4_encode_decode": "passed", "streamlit_http_health": "passed",
            "full_ui_interaction": "not_tested", "ai_generation": "not_tested",
            "paid_api_calls": 0,
        }, indent=2))


if __name__ == "__main__":
    main()
