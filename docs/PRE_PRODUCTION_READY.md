# Pre-Production Ready Checklist

The project is prepared to receive a game idea.

## Already Done

- Godot 4.7 project scaffold exists.
- Main scene exists at `res://scenes/world/ReadyRoom.tscn`.
- Placeholder player scene exists at `res://scenes/world/Player.tscn`.
- Movement actions exist: `move_left`, `move_right`, `move_up`, `move_down`.
- Pixel-art texture filter is disabled by default.
- Curated asset subset is copied into `res://assets/`.
- License notes and source readmes are copied.
- Asset catalog identifies which pack fits which game direction.

## Need From Game Idea

- Genre and player fantasy.
- Core loop in one sentence.
- World style: modern indoor, fantasy outdoor, or hybrid.
- Camera: top-down, fixed room, scrolling map, or menu-heavy.
- Primary interaction: combat, dialogue, crafting, shop, puzzle, stealth, collecting, or exploration.
- Target scope for first playable: 1 room, 1 quest, 1 enemy, 1 puzzle, or 1 shop loop.

## Fast Start Once Idea Arrives

1. Choose the main art direction.
2. Build the first playable scene from `ReadyRoom`.
3. Convert required atlas sections into Godot 4 TileSets.
4. Turn one character sheet into real animation states.
5. Implement the smallest complete gameplay loop.
6. Only then expand maps, UI, and content.
