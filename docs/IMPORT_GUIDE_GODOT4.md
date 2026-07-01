# Godot 4 Import Guide

## Texture Defaults

Project default:

- `textures/canvas_textures/default_texture_filter=0`

This keeps pixel art sharp.

## Tile Size

Default working grid:

- `32x32`

Use `16x16` only if the game needs dense maps and smaller characters. Use `48x48` only if the game needs larger/readable sprites with less scaling.

## TileSet Work

Godot 4 TileSets should be rebuilt in-editor.

Good source files:

- `res://assets/art/modern_interiors/interiors_32x32/Theme_Sorter_32x32/*.png`
- `res://assets/art/super_retro_world/exterior/atlas_32x.png`
- `res://assets/art/super_retro_world/interior/atlas_32x.png`

Do not rely on the Super Retro World Godot sample directly. It is Godot 3-era TileMap/TileSet data.

## Animation Work

Prefer PNG spritesheets.

Good source files:

- `res://assets/art/modern_interiors/characters_32x32/*.png`
- `res://assets/art/modern_interiors/animated_objects_32x32/*.png`
- `res://assets/art/super_retro_world/animations/*.png`

GIFs are kept only where no PNG equivalent was copied, mostly as references.

## Transparency

Most copied assets use alpha transparency.

Known caution:

- Some Super Retro atlas/RPG Maker source files use magenta key backgrounds in the original pack.
- The copied atlas files should still be checked visually after Godot import.
