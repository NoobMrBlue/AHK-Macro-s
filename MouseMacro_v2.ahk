#Requires AutoHotkey v2.0
SendMode "Input"
SetTitleMatchMode 2

toggle := false

F3::ExitApp()   ; quit the script

~q:: {          ; toggles the script on/off
    global toggle
    toggle := !toggle
}

~LButton:: {    ; runs the mouse macro on left click while toggled on
    global toggle
    if toggle {
        MouseGetPos(, &y)
        MouseMove(600, y, 1)
        Sleep(50)
        MouseGetPos(, &y)
        MouseMove(700, y, 1)
    }
}
