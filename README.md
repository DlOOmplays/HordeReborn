# HordeReborn

HordeReborn is an original 2D real-time strategy game, inspired by the classic RTS feel of *Horde II: The Citadel*. It is a clean-room reimagining: this repository contains no code, art, audio, maps, or other assets from that game.

## Technology

- **Engine:** Godot 4.7.2
- **Language:** GDScript
- **Genre:** 2D RTS
- **Target:** Windows PC
- **Direction:** top-down / isometric-ready 2D RTS

## Project structure

- `scenes/` — reusable Godot scenes, grouped by gameplay responsibility.
- `scripts/` — focused GDScript code for core, unit, world, UI, and future RTS systems.
- `assets/` — source placeholder and future production assets; never generated import cache.
- `maps/` and `data/` — future map and gameplay-data resources.
- `tests/` — future automated and manual test coverage.

## Open and run

1. In Godot 4.7.2, choose **Import** and select this repository folder (`D:\HordeReborn`) or its `project.godot` file.
2. Open the imported project.
3. Press **F6/F5** or choose **Run Project**.

The current foundation launches a procedural RTS test field with a grid, terrain props, placeholder units, an RTS camera, and a small instruction overlay. Use **WASD** or arrow keys to pan; use the mouse wheel to zoom.

## Phase 1: Unit control

- Unit selection and drag selection
- Multi-selection and Shift add/remove selection
- Procedural selection indicators
- Right-click movement commands
- Smooth basic movement with formation spreading

## Phase 2: Combat foundation

- Player and enemy team/faction identity
- Reusable health and melee-combat components
- Right-click attack commands against enemy units
- Damage, health bars, hit feedback, and clean unit death removal
- Basic enemy target acquisition and melee combat AI
- Death-time cleanup of selection and combat-target references

## Current phase

Phase 2: RTS combat foundation. The project now supports placeholder unit selection, movement, melee combat, and basic enemy combat AI; economy, buildings, and advanced RTS systems remain future work.
