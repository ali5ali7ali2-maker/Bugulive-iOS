"""
Fix non-ASCII directory name mismatches between what Git checked out (garbled,
mojibake names) and what Xcode expects (correct Chinese names).

On macOS/APFS, git may check out filenames with NFD decomposition applied to the
mojibake bytes. We use startswith() on the ASCII prefix before the first
non-ASCII char, which is stable under NFD.
"""

import os
import sys
import unicodedata


def log(msg):
    print(msg, flush=True)


def show_dir(path):
    """Diagnostically list a directory, printing each name with its hex bytes."""
    if not os.path.isdir(path):
        log(f"  DIR NOT FOUND: {path!r}")
        return []
    entries = os.listdir(path)
    log(f"  Contents of {path!r} ({len(entries)} entries):")
    for e in sorted(entries):
        full = os.path.join(path, e)
        non_ascii = any(ord(c) > 127 for c in e)
        hex_str = e.encode("utf-8").hex()
        nfc = unicodedata.normalize("NFC", e)
        log(
            f"    {e!r}  non_ascii={non_ascii}  hex={hex_str}"
            f"  isdir={os.path.isdir(full)}  nfc_eq={e == nfc}"
        )
    return entries


def link_garbled(parent, correct_name, ascii_pfx):
    """
    Find a directory under *parent* whose name starts with *ascii_pfx* but is
    NOT *correct_name*, then create a symlink correct_name -> that directory.

    ascii_pfx is the pure-ASCII prefix before the first non-ASCII character in
    the correct name (e.g. 'DT_Controller(' for 'DT_Controller(动态)').
    For purely-Chinese names pass ascii_pfx=''.
    """
    expected = os.path.join(parent, correct_name)
    if os.path.lexists(expected):
        log(f"  ALREADY EXISTS: {expected!r}")
        return True
    if not os.path.isdir(parent):
        log(f"  NO PARENT: {parent!r}")
        return False

    matches = []
    for d in os.listdir(parent):
        full = os.path.join(parent, d)
        if not os.path.isdir(full):
            continue
        # Skip if it's already the correct name (NFC-compare)
        if unicodedata.normalize("NFC", d) == unicodedata.normalize("NFC", correct_name):
            log(f"  SKIP (same NFC): {d!r}")
            continue
        # Require at least one non-ASCII char (it's a garbled entry)
        if not any(ord(c) > 127 for c in d):
            continue
        if ascii_pfx == "" or d.startswith(ascii_pfx):
            matches.append(d)

    log(f"  Searching {parent!r} for prefix={ascii_pfx!r}: found {matches!r}")

    if len(matches) == 1:
        target = os.path.realpath(os.path.join(parent, matches[0]))
        try:
            os.symlink(target, expected)
            log(f"  OK: {expected!r} -> {target!r}")
            return True
        except Exception as exc:
            log(f"  FAIL symlink: {exc}")
            return False
    elif len(matches) > 1:
        log(f"  AMBIGUOUS matches: {matches!r}")
    else:
        log(f"  NOMATCH for correct_name={correct_name!r}")
    return False


def link_by_children(parent, correct_name, known_child_file):
    """
    For purely-Chinese directory names with no ASCII prefix, find the garbled
    directory by checking that *known_child_file* exists inside it.
    """
    expected = os.path.join(parent, correct_name)
    if os.path.lexists(expected):
        log(f"  ALREADY EXISTS: {expected!r}")
        return
    if not os.path.isdir(parent):
        log(f"  NO PARENT: {parent!r}")
        return
    for d in os.listdir(parent):
        if not any(ord(c) > 127 for c in d):
            continue
        full = os.path.join(parent, d)
        if not os.path.isdir(full):
            continue
        try:
            children = os.listdir(full)
        except OSError:
            continue
        if known_child_file in children:
            target = os.path.realpath(full)
            try:
                os.symlink(target, expected)
                log(f"  OK (child-match): {expected!r} -> {d!r}")
            except Exception as exc:
                log(f"  FAIL (child-match): {exc}")
            return
    log(f"  NOMATCH (child-match): {correct_name!r} in {parent!r}")


# ── main ─────────────────────────────────────────────────────────────────────

log("=== fix_symlinks.py ===")
log(f"CWD: {os.getcwd()}")
log(f"Python: {sys.version}")

SECTIONS   = "BuguLive/Class/Sections"
CLASS      = "BuguLive/Class"
HOME_V3    = "BuguLive/Class/Sections/Home/V3NewUIController"
LOGIN      = "BuguLive/Class/Sections/Login"
LIVE_VIEW  = "BuguLive/Class/Live/LiveUI/View"
LIVE_OTHER = "BuguLive/Class/Live/LiveUI/View/OtherView"

log("\n--- SECTIONS directory ---")
show_dir(SECTIONS)

# 1. DT_Controller(动态)
log("\n--- 1. DT_Controller(动态) ---")
link_garbled(SECTIONS, "DT_Controller(\u52a8\u6001)", "DT_Controller(")
dt_path = os.path.join(SECTIONS, "DT_Controller(\u52a8\u6001)")
log(f"DT path isdir: {os.path.isdir(dt_path)}")
if os.path.isdir(dt_path):
    show_dir(dt_path)

# 2. BogoTimeLine(新版动态) inside DT_Controller
log("\n--- 2. BogoTimeLine(新版动态) ---")
if os.path.isdir(dt_path):
    link_garbled(dt_path, "BogoTimeLine(\u65b0\u7248\u52a8\u6001)", "BogoTimeLine(")

# 3. Other garbled sections
log("\n--- 3. Other sections ---")
link_garbled(HOME_V3,    "BogoNewNoble(\u8d35\u65cf)",            "BogoNewNoble(")
link_garbled(HOME_V3,    "BogoSquare(\u5e7f\u573a)",              "BogoSquare(")
link_garbled(LOGIN,      "Register(\u6ce8\u518c)",                "Register(")
link_garbled(LIVE_OTHER, "Shop(\u8d2d\u7269\u8f66)",              "Shop(")
link_garbled(LIVE_OTHER, "VIP(\u8d35\u65cf\u5217\u8868)",         "VIP(")
link_garbled(LIVE_OTHER, "Wish(\u5fc3\u613f\u5355)",              "Wish(")
link_garbled(SECTIONS,   "YounthMode(\u9752\u5c11\u5e74\u6a21\u5f0f)", "YounthMode(")

# 4. Purely-Chinese dirs — use child-file fallback
log("\n--- 4. Chinese-only dirs ---")
link_by_children(LIVE_VIEW, "\u8bed\u97f3\u8fde\u9ea6", "BogoConnMicViewController.h")  # 语音连麦
link_by_children(LIVE_VIEW, "\u8868\u60c5",              "BogoLiveEmojiView.h")           # 表情
link_by_children(CLASS,     "\u8bed\u97f3\u623f\u95f4",  "BogoAudioRoomViewController.h") # 语音房间

log("\n=== Done ===")
