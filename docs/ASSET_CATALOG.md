# Asset Catalog

Curated subset copied from `D:\GameMaking\game assets`.

## Current Import Set

| Category | Project path | Count | Use |
|---|---:|---:|---|
| Modern interiors 32x32 | `res://assets/art/modern_interiors/interiors_32x32/` | 42 PNG groups | Indoor maps, props, floors, walls |
| Modern characters 32x32 | `res://assets/art/modern_interiors/characters_32x32/` | 281 PNG | Player/NPC walk, idle, run, sit, phone, reading, shop actions |
| Modern animated objects 32x32 | `res://assets/art/modern_interiors/animated_objects_32x32/` | 193 PNG spritesheets | Doors, appliances, elevators, traps, seasonal props |
| Modern UI | `res://assets/art/modern_interiors/ui/` | 6 PNG, 6 GIF | UI arrows, bubbles, emotes, timer references |
| Super Retro exterior | `res://assets/art/super_retro_world/exterior/` | 3 PNG | Outdoor atlas at 16/32/48 px |
| Super Retro interior | `res://assets/art/super_retro_world/interior/` | 3 PNG | Indoor atlas at 16/32/48 px |
| Super Retro animations | `res://assets/art/super_retro_world/animations/` | 8 PNG | Water, chest, fire |
| Shikashi icons | `res://assets/art/icons/shikashi/` | 17 PNG | Inventory, skills, status, item UI |

## Recommended First Choice

Use `32x32` as the default grid until the game idea says otherwise.

Reasons:

- Character sheets and tiles are already available at 32x32.
- Collision and camera tuning are easier than 16x16.
- It stays readable at 720p/1080p without excessive scaling.

## Ready Gameplay Directions

These asset groups can support several directions without more art:

- Modern indoor exploration/social sim: use `Modern_Interiors`.
- Shop, school, office, grocery, apartment, hospital-like maps: use `Modern_Interiors`.
- Fantasy RPG/exploration: use `Super_Retro_World` + `Shikashi`.
- Inventory/crafting/quest prototype: use `Shikashi`.
- Puzzle/escape-room prototype: use `Modern_Interiors` animated doors/traps/UI.

## Avoid For Now

- Source `*.gif` files except as visual references. Prefer PNG spritesheets in Godot.
- Godot 3 sample `.tres/.tscn` from Super Retro World. Rebuild/migrate TileSets in Godot 4.
- RPG Maker sheets unless the target is RPG Maker-style import.
- Unity package unless the target engine changes to Unity.
