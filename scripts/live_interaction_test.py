"""Temporary live UI smoke test: Registry tab, Healthcare seal, Hub mapping, SAL VERIFIED stamp.

Requires: pip install playwright && playwright install chromium
Target app: http://127.0.0.1:8501 (run `python -m streamlit run app.py --server.port 8501` from repo root).
"""

from __future__ import annotations

import sys


def _pass(name: str) -> None:
    print(f"[PASS] {name}", flush=True)


def _fail(name: str, detail: str = "") -> None:
    msg = f"[FAIL] {name}"
    if detail:
        msg += f" — {detail}"
    print(msg, flush=True)


def main() -> int:
    base = "http://127.0.0.1:8501"
    try:
        from playwright.sync_api import sync_playwright
    except ImportError:
        _fail("playwright import", "run: pip install playwright && playwright install chromium")
        return 3

    exit_code = 0
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        context = browser.new_context(viewport={"width": 1400, "height": 900})
        page = context.new_page()
        page.set_default_timeout(60000)
        try:
            page.goto(base, wait_until="domcontentloaded")
            page.wait_for_timeout(3000)
            _pass("Page loads (Streamlit shell)")
        except Exception as exc:  # noqa: BLE001
            _fail("Page loads", str(exc))
            browser.close()
            return 1

        try:
            page.get_by_text("Library scope").first.wait_for(state="visible", timeout=20000)
            _pass("Vocabulary: Library scope label visible")
        except Exception as exc:  # noqa: BLE001
            _fail("Library scope label", str(exc))
            exit_code = 2

        try:
            page.get_by_text("Global Registry").first.wait_for(state="visible", timeout=10000)
            _pass("Vocabulary: Global Registry visible")
        except Exception as exc:  # noqa: BLE001
            _fail("Global Registry", str(exc))
            exit_code = 2

        # Instant Deployment lives in Registry tab (default)
        try:
            btn = page.get_by_role("button", name="Deploy [29] · Bureau")
            btn.scroll_into_view_if_needed()
            btn.click(timeout=15000)
            page.wait_for_timeout(2000)
            _pass("Healthcare sector seal: Deploy [29] · Bureau clicked")
        except Exception as exc:  # noqa: BLE001
            _fail("Healthcare sector seal click", str(exc))
            exit_code = 2

        placeholder = "Describe the project, domain, or logic standard you need to operationalize"
        try:
            hub = page.get_by_placeholder(placeholder)
            if hub.count() == 0:
                hub = page.locator('input[type="text"]').first
            hub.scroll_into_view_if_needed()
            hub.fill("Secure Data Pipeline")
            _pass("Hub: typed 'Secure Data Pipeline'")
        except Exception as exc:  # noqa: BLE001
            _fail("Hub text input", str(exc))
            exit_code = 2

        try:
            page.get_by_role("button", name="Execute Mapping").click()
            page.wait_for_timeout(4000)
            _pass("Hub: Execute Mapping clicked")
        except Exception as exc:  # noqa: BLE001
            _fail("Execute Mapping", str(exc))
            exit_code = 2

        try:
            html = page.content()
            # Markup uses <br> between SAL and VERIFIED inside .sal-notary-seal
            if "sal-notary-seal" in html and "VERIFIED" in html and "SAL" in html:
                _pass("Logic card: SAL VERIFIED stamp found in DOM (notary seal + text)")
            else:
                _fail("SAL VERIFIED stamp", "substring not in page.content()")
                exit_code = 2
        except Exception as exc:  # noqa: BLE001
            _fail("DOM read", str(exc))
            exit_code = 2

        browser.close()
    return exit_code


if __name__ == "__main__":
    raise SystemExit(main())
