#Requires AutoHotkey v2.0
#SingleInstance Force

SendMode "Event"

spinning := false
robloxWin := "ahk_exe RobloxPlayerBeta.exe"

; ===== Compact GUI =====
g := Gui("+AlwaysOnTop -MinimizeBox", "Spin")
g.SetFont("s9")
lbl := g.Add("Text", "w220", "Spin speed: 20 px/tick")
slider := g.Add("Slider", "w220 Range1-300 ToolTip", 20)
slider.OnEvent("Change", (c, *) => lbl.Value := "Spin speed: " c.Value " px/tick")
g.Add("Text", "w220", "Tick rate (ms, lower = smoother):")
tickEdit := g.Add("Edit", "w70 Number", "10")
g.Add("UpDown", "Range1-200", 10)
dirDrop := g.Add("DropDownList", "x+10 w70 Choose1", ["Right", "Left"])
rmbChk := g.Add("Checkbox", "xm Checked", "Hold RMB (needed for camera)")
focusChk := g.Add("Checkbox", "xm Checked", "Auto-focus Roblox")
statusTxt := g.Add("Text", "xm w220", "Status: Stopped")
btn := g.Add("Button", "w220 h30", "Start spin (X)")
g.Add("Text", "xm cGray", "X = start/stop   |   C = exit")
btn.OnEvent("Click", (*) => ToggleSpin())
g.OnEvent("Close", (*) => ExitApp())
g.Show("AutoSize")

ToggleSpin() {
    global spinning
    spinning := !spinning
    if spinning {
        btn.Text := "Stop spin (X)"
        statusTxt.Value := "Status: Spinning"
        if focusChk.Value && WinExist(robloxWin) && !WinActive(robloxWin)
            WinActivate(robloxWin)
        if rmbChk.Value
            Send("{RButton down}")
        SetTimer(SpinTick, GetTick())
    } else {
        SetTimer(SpinTick, 0)
        btn.Text := "Start spin (X)"
        statusTxt.Value := "Status: Stopped"
        Send("{RButton up}")
    }
}

GetTick() {
    try {
        t := Integer(tickEdit.Value)
        return t < 1 ? 1 : t
    }
    return 10
}

SpinTick() {
    global spinning
    if !spinning
        return
    px := slider.Value * (dirDrop.Value = 1 ? 1 : -1)
    DllCall("mouse_event", "UInt", 0x0001, "Int", px, "Int", 0, "UInt", 0, "UPtr", 0)
    ; keep the tick rate in sync if it was changed while spinning
    SetTimer(SpinTick, GetTick())
}

OnExit((*) => Send("{RButton up}"))

$x:: ToggleSpin()
$c:: ExitApp()
