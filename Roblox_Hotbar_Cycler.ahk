#Requires AutoHotkey v2.0
#SingleInstance Force

SendMode "Event"
SetKeyDelay 10, 10

running := false
current := 0
robloxWin := "ahk_exe RobloxPlayerBeta.exe"

; ===== Compact GUI =====
g := Gui("+AlwaysOnTop -MinimizeBox", "Hotbar Cycler")
g.SetFont("s9")
g.Add("Text", "w60", "From slot:")
fromEdit := g.Add("Edit", "x+5 w45 Number", "1")
g.Add("UpDown", "Range1-10", 1)
g.Add("Text", "x+10 w45", "To slot:")
toEdit := g.Add("Edit", "x+5 w45 Number", "5")
g.Add("UpDown", "Range1-10", 5)
g.Add("Text", "xm w200", "Switch speed (ms between slots):")
speedEdit := g.Add("Edit", "w80 Number", "200")
g.Add("UpDown", "Range1-10000", 200)
focusChk := g.Add("Checkbox", "xm Checked", "Auto-focus Roblox")
statusTxt := g.Add("Text", "xm w200", "Status: Stopped")
btn := g.Add("Button", "w200 h30", "Start (X)")
g.Add("Text", "xm cGray", "X = start/stop   |   C = exit")
btn.OnEvent("Click", (*) => Toggle())
g.OnEvent("Close", (*) => ExitApp())
g.Show("AutoSize")

Toggle() {
    global running, current
    running := !running
    if running {
        btn.Text := "Stop (X)"
        if focusChk.Value && WinExist(robloxWin) && !WinActive(robloxWin)
            WinActivate(robloxWin)
        current := 0
        SetTimer(Tick, GetSpeed())
    } else {
        SetTimer(Tick, 0)
        btn.Text := "Start (X)"
        statusTxt.Value := "Status: Stopped"
    }
}

GetNum(ctrl, def, lo, hi) {
    try {
        n := Integer(ctrl.Value)
        return Max(lo, Min(hi, n))
    }
    return def
}

GetSpeed() => GetNum(speedEdit, 200, 1, 10000)

Tick() {
    global running, current
    if !running
        return
    lo := GetNum(fromEdit, 1, 1, 10)
    hi := GetNum(toEdit, 5, 1, 10)
    if lo > hi {
        tmp := lo
        lo := hi
        hi := tmp
    }
    current := (current < lo || current >= hi) ? lo : current + 1
    key := (current = 10) ? "0" : current
    Send("{" key "}")
    statusTxt.Value := "Status: Slot " current
    ; keep speed in sync if changed while running
    SetTimer(Tick, GetSpeed())
}

$x:: Toggle()
$c:: ExitApp()
