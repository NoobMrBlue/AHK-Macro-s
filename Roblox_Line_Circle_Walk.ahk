#Requires AutoHotkey v2.0
#SingleInstance Force

SendMode "Event"
SetKeyDelay 20, 20

running := false
loopActive := false
robloxWin := "ahk_exe RobloxPlayerBeta.exe"

; ===== Compact GUI =====
g := Gui("+AlwaysOnTop -MinimizeBox", "Line / Circle Walk")
g.SetFont("s9")
g.Add("Text", "w60", "Mode:")
modeDrop := g.Add("DropDownList", "x+5 w100 Choose1", ["Line (W/S)", "Circle"])
g.Add("Text", "xm w220", "Line: hold time per direction (ms):")
holdEdit := g.Add("Edit", "w80 Number", "2000")
g.Add("UpDown", "Range100-60000", 2000)
lbl := g.Add("Text", "xm w220", "Circle: turn speed 8 px/tick")
slider := g.Add("Slider", "w220 Range1-100 ToolTip", 8)
slider.OnEvent("Change", (c, *) => lbl.Value := "Circle: turn speed " c.Value " px/tick")
dirDrop := g.Add("DropDownList", "xm w70 Choose1", ["Right", "Left"])
rmbChk := g.Add("Checkbox", "x+10 yp+4 Checked", "Hold RMB (circle)")
focusChk := g.Add("Checkbox", "xm Checked", "Auto-focus Roblox")
statusTxt := g.Add("Text", "xm w220", "Status: Stopped")
btn := g.Add("Button", "w220 h30", "Start (X)")
g.Add("Text", "xm cGray", "X = start/stop   |   C = exit")
btn.OnEvent("Click", (*) => Toggle())
g.OnEvent("Close", (*) => ExitApp())
g.Show("AutoSize")

Toggle() {
    global running, loopActive
    running := !running
    if running {
        btn.Text := "Stop (X)"
        if focusChk.Value && WinExist(robloxWin) && !WinActive(robloxWin)
            WinActivate(robloxWin)
        if modeDrop.Value = 1 {
            statusTxt.Value := "Status: Line walk"
            if !loopActive
                SetTimer(LineLoop, -10)
        } else {
            statusTxt.Value := "Status: Circle walk"
            Send("{w down}")
            if rmbChk.Value
                Send("{RButton down}")
            SetTimer(CircleTick, 10)
        }
    } else {
        SetTimer(CircleTick, 0)
        btn.Text := "Start (X)"
        statusTxt.Value := "Status: Stopped"
        ReleaseAll()
    }
}

GetHold() {
    try {
        t := Integer(holdEdit.Value)
        return t < 100 ? 100 : t
    }
    return 2000
}

LineLoop() {
    global running, loopActive
    loopActive := true
    while running {
        for k in ["w", "s"] {
            if !running
                break
            Send("{" k " down}")
            elapsed := 0
            hold := GetHold()
            while running && elapsed < hold {
                Sleep(50)
                elapsed += 50
            }
            Send("{" k " up}")
        }
    }
    loopActive := false
}

CircleTick() {
    px := slider.Value * (dirDrop.Value = 1 ? 1 : -1)
    DllCall("mouse_event", "UInt", 0x0001, "Int", px, "Int", 0, "UInt", 0, "UPtr", 0)
}

ReleaseAll() {
    Send("{w up}")
    Send("{s up}")
    Send("{RButton up}")
}

OnExit((*) => ReleaseAll())

$x:: Toggle()
$c:: ExitApp()
