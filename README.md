# claude-bell 🔔

As a developer and student, I find myself using a lot of Claude. But I tend to get distrcted - and sometimes I only remember that I had a prompt running several minutes after it's finished! I created claude-bell to give you a visual cue when Claude finishes up a prompt. (In the form of a cutesy pixel-art ringing bell!)

## Requirements 📝

- macOS 13+
- Swift 6.3+ (Xcode 16+ or the Swift toolchain)

## Running it

```bash
swift run
```

This builds and launches the widget. You're able to click and drag it around so it doesn't get in the way of your work. Leave it running in the background - it has no Dock icon or menu bar item (it's an accessory app), so quit it with:

```bash
pkill -x OverlayWidget
```
or by pressing Ctrl + C in the terminal where you ran it. 

## 🚨 IMPORTANT: Wiring it to Claude Code

For the bell to actually ring once Claude finishes, the widget listens for a `SIGUSR1` signal and rings the bell when it receives one. To make it ring every time Claude Code finishes answering, you must add a `Stop` hook to your `~/.claude/settings.json`:

```json
"hooks": {
  "Stop": [
    {
      "hooks": [
        { "type": "command", "command": "pkill -SIGUSR1 -x OverlayWidget" }
      ]
    }
  ]
}
```

If you already have a `hooks` key, merge this into your existing `Stop` array instead of overwriting it.

## How it works

- `Sources/OverlayWidgetApp.swift` - app entry point; sets up the floating panel and a `DispatchSource` signal handler for `SIGUSR1`
- `Sources/FloatingWidgetPanel.swift` - the borderless, always-on-top `NSPanel`
- `Sources/WidgetView.swift` - the SwiftUI view with the animated bell frames
- `Sources/Resources/BellFrames/` - the bell animation frames
