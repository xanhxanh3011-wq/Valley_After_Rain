# UI/UX Direction - Đèn Hẻm Sau Mưa

## Layout

- 16:9 landscape.
- Top 60-65%: pixel-art cafe scene.
- Bottom 35-40%: dark brown interaction panel.
- No combat HUD, no score HUD, no countdown pressure.

## Visual Tone

- Cozy late-night Vietnamese alley cafe.
- Dark wood, amber light, cream text, muted rain blue.
- Pixel sprites use nearest filtering.
- Scene is intentionally sparse: bar counter, a few guests, rain windows, warm light pools, small props.

## Implemented UI States

- Main menu over cafe scene.
- Prep/menu selection as a two-page warm paper menu with recipe icons and a live selected-items page.
- Dialogue with customer choices.
- Recipe selection with filter chips and a sidepanel-style menu book: left page recipe list, right page customer/mood notes.
- Cooking panel with item preview, flavor/emotion chips, and actions.
- Serve reaction.
- Notebook styled as paper note cards with tabs.
- End-of-night summary.
- Settings with demo-ready sliders/toggles.

## Palette

- Background dark brown: `#1b1009`
- UI panel brown: `#24150d`
- Border warm brown: `#6b4728`
- Highlight amber: `#d7a64b`
- Text cream: `#f1d8a0`
- Muted text: `#9d8464`
- Wood floor: `#5a351c`
- Deep night blue: `#18202a`

## Next Polish

- Replace rectangle-based floor/wall with a real TileMap.
- Add click-to-advance dialogue text.
- Add larger portraits per customer.
- Add audio ambience and UI SFX.
- Add small animated steam/cat/light flicker using AnimatedSprite2D.
