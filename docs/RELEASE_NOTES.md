# Den Hem Sau Mua - Production Backbone Notes

## Scope Implemented

- Recipe Book and Notebook now open as centered open-book modal overlays.
- Background cafe scene remains visible through a dim layer while book overlays are open.
- Bottom gameplay panel is dimmed and input-locked while overlays are active.
- Production content patch adds 15 more nights, 30 more recipes, and 10 more customers/wanderers.
- Save data now has `save_version` and a lightweight migration path for older demo saves.
- LimeZu idle frame mapping was corrected so `idle_down` uses the front-facing frame.
- A headless smoke test was added for overlay, data merge, and first customer walk-in checks.

## Current Content Size

- 20 playable nights total after merge.
- 49 recipes total after merge.
- 18 customer IDs total after merge.

## Validation

Run parse/boot:

```powershell
& 'D:\GameMaking\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe' --headless --path 'D:\GameMaking\idea-ready-game' --quit-after 3
```

Run smoke test:

```powershell
& 'D:\GameMaking\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe' --headless --path 'D:\GameMaking\idea-ready-game' --script 'res://scripts/tools/smoke_test.gd'
```

Run game locally:

```powershell
& 'D:\GameMaking\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe' --path 'D:\GameMaking\idea-ready-game'
```

## Remaining Release Risks

- No final exported desktop build was created in this pass.
- Audio assets and final mix are still direction-level unless added later.
- The generated open-book PNGs are reused from the current generated UI kit and should be replaced by final production art when available.
- Full manual playthrough of all 20 nights is still required before public release.
