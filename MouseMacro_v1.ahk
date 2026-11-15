SendMode Input

SetTitleMatchMode, 2

F3::Exitapp ;if your having trouble or just want ti quit the ahk then press this

Toggle := 0

~q:: ;toggles the script on/off
    Toggle := !Toggle
return

~LButton:: ;press this for the macro to macro
    if (Toggle)
    {
        SetDefaultMouseSpeed 1
        MouseGetPos, , y
        MouseMove, 600, % y
        Sleep 50
        MouseGetPos, , y
        MouseMove, 700, % y
    }
return
