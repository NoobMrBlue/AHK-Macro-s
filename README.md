# Roblox AutoHotkey Macros

A collection of small AutoHotkey macros for Roblox, most with a compact GUI.

> **Use at your own risk.** Always check the rules of the game you're playing. Some games ban macros or have anti-cheat that flags them.

## Requirements

- [AutoHotkey v2](https://www.autohotkey.com/) for every script except `MouseMacro_v1.ahk`, which needs AutoHotkey v1.
- Windows.

## Setup

1. Install AutoHotkey.
2. Download the script you want and double-click it.
3. If Roblox ignores the keys or mouse movement, right-click the script and choose **Run as administrator**.
4. In Windows mouse settings, turn off **Enhance pointer precision** for the most accurate camera movement.

The Roblox scripts use `SendMode "Event"` because Roblox often ignores `SendInput`.

## Scripts

| Script | What it does | Hotkeys |
| --- | --- | --- |
| `Roblox_AFK_Square_Walk_GUI.ahk` | Walks in a square by holding W, A, S, D in turn. GUI for hold time per key and auto-focus Roblox. | F1 start/stop, F2 exit |
| `Roblox_Line_Circle_Walk.ahk` | **Line** mode walks forward and back (W/S). **Circle** mode holds W while turning the camera. | X start/stop, C exit |
| `Roblox_Spin_Macro.ahk` | Spins the camera continuously. Set the speed (px per tick) and tick rate, and pick left or right. | X start/stop, C exit |
| `Roblox_Hotbar_Cycler.ahk` | Cycles through hotbar slots in order. Set the first and last slot (1-10) and the switch speed in ms. | X start/stop, C exit |
| `MouseMacro_v2.ahk` | Toggle on, then each left click moves the mouse to x=600, waits 50 ms, then moves to x=700. | Q toggle, F3 exit |
| `MouseMacro_v1.ahk` | The same mouse macro for AutoHotkey v1. | Q toggle, F3 exit |

## Notes

- Three of the scripts share the X and C hotkeys, so only run one at a time.
- The camera scripts hold right-click while moving the camera, because Roblox only turns the camera with right-click held. Untick **Hold RMB** if you use shift lock.
- Pixel values depend on your Roblox and Windows mouse sensitivity, so you may need to adjust the sliders.
- `MouseMacro_v1.ahk` and `MouseMacro_v2.ahk` use absolute screen coordinates, so the result depends on your screen setup.

## Credits

Thanks to: https://www.youtube.com/@stubbydinosaur for lending the Macro to the wallhopper!!

## Licence

MIT Licence
