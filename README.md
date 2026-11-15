# Roblox AutoHotkey Macros

A collection of AutoHotkey macros for Roblox, including an all-in-one **Macro Hub** and a set of smaller standalone scripts. Most have a compact GUI so you can change speeds and settings without editing code.

> **Use at your own risk.** Always check the rules of the game you're playing. Some games ban macros or have anti-cheat that flags them.

## Requirements

- Windows
- [AutoHotkey v2](https://www.autohotkey.com/) for every script except `MouseMacro_v1.ahk`, which needs AutoHotkey v1

## Setup

1. Install AutoHotkey.
2. Download the script you want and double-click it.
3. If Roblox ignores the keys or mouse movement, right-click the script and choose **Run as administrator**.
4. In Windows mouse settings, turn off **Enhance pointer precision** for the most accurate camera movement.

The Roblox scripts use `SendMode "Event"` because Roblox often ignores `SendInput`.

## Macro Hub (recommended)

`Roblox_Macro_Hub.ahk` puts all the macros in one window with tabs, so there are no hotkey clashes.

| Tab | What it does |
| --- | --- |
| Square | Walks in a square by holding W, A, S, D in turn. |
| Line/Circle | Walks forward and back (W/S), or in a circle while turning the camera. |
| Spin | Spins the camera continuously. Set the speed and tick rate. |
| Flick | Flicks the camera out and snaps it back to its exact start. |
| Turn | Turns the camera in one instant jump (about 180 degrees). |
| Hotbar | Cycles through hotbar slots at the speed you set. |
| Anti-idle | A jump, a small step or a tiny camera nudge every N seconds, so you don't get kicked for idling. |
| Spam | Presses one key (like E) on a timer. |

**Extra features**

- **Saved settings:** your settings are remembered between sessions in `MacroHubSettings.ini`.
- **Random timing jitter:** adds randomness (0-50%) to timings so the pattern isn't perfectly robotic.
- **Auto-stop timer:** stops the macro after a set number of minutes.
- **Elapsed timer:** the status line shows how long the macro has been running.
- **Always on top** option.

**Hotkeys**

- `X` starts or stops the macro on the current tab (on Flick and Turn it does the action once).
- `C` stops everything and releases all held keys.
- The hotkeys don't fire while the hub window is focused, so typing in its boxes is safe.

## Standalone scripts

| Script | What it does | Hotkeys |
| --- | --- | --- |
| `Roblox_AFK_Square_Walk_GUI.ahk` | Walks in a square by holding W, A, S, D in turn. Set the hold time per key. | F1 start/stop, F2 exit |
| `Roblox_Line_Circle_Walk.ahk` | **Line** mode walks forward and back. **Circle** mode holds W while turning the camera. | X start/stop, C exit |
| `Roblox_Spin_Macro.ahk` | Spins the camera continuously. Set the speed (px per tick) and tick rate. | X start/stop, C exit |
| `Roblox_Hotbar_Cycler.ahk` | Cycles through hotbar slots. Set the first and last slot (1-10) and the switch speed in ms. | X start/stop, C exit |
| `MouseMacro_v2.ahk` | Toggle on, then each left click moves the mouse to x=600, waits 50 ms, then moves to x=700. | Q toggle, F3 exit |
| `MouseMacro_v1.ahk` | The same mouse macro for AutoHotkey v1. | Q toggle, F3 exit |

## Notes

- Some standalone scripts share the X and C hotkeys, so only run one at a time. The hub avoids this by keeping everything in one window.
- The camera macros hold right-click while moving the camera, because Roblox only turns the camera with right-click held. Untick **Hold RMB** if you use shift lock.
- Pixel values depend on your Roblox and Windows mouse sensitivity, so you may need to adjust the sliders.
- `MouseMacro_v1.ahk` and `MouseMacro_v2.ahk` use absolute screen coordinates, so the result depends on your screen setup.

## Licence

Released under the [MIT Licence](LICENSE).
