#Requires AutoHotkey v2.0
#SingleInstance Force

; Roblox usually ignores SendInput, so use classic event mode
SendMode "Event"
SetKeyDelay 20, 20

keys := ["w", "a", "s", "d"]
running := false
loopActive := false
robloxWin := "ahk_exe RobloxPlayerBeta.exe"

; ===== GUI =====
g := Gui("+AlwaysOnTop", "Roblox AFK Square Walk")
g.SetFont("s10")
g.Add("Text", , "Hold time per key (ms):")
holdEdit := g.Add("Edit", "w120 Number", "2000")
g.Add("UpDown", "Range100-60000", 2000)
focusChk := g.Add("Checkbox", "Checked", "Auto-focus Roblox window")
statusTxt := g.Add("Text", "w260", "Status: Stopped")
btn := g.Add("Button", "w260 h40", "Start (F1)")
g.Add("Text", "cGray w260", "F1 = start/stop   |   F2 = exit")
btn.OnEvent("Click", Toggle)
g.OnEvent("Close", (*) => ExitApp())
g.Show()

OnExit((*) => ReleaseAll())

; ===== Logic =====
Toggle(*) {
    global running, loopActive
    running := !running
    if running {
        btn.Text := "Stop (F1)"
        if !loopActive
            SetTimer(WalkLoop, -10)
    } else {
        btn.Text := "Start (F1)"
        statusTxt.Value := "Status: Stopped"
        ReleaseAll()
    }
}

GetHoldTime() {
    try {
        t := Integer(holdEdit.Value)
        return t < 100 ? 100 : t
    }
    return 2000
}

WalkLoop() {
    global running, loopActive, keys, robloxWin
    loopActive := true
    while running {
        for k in keys {
            if !running
                break
            if focusChk.Value && WinExist(robloxWin) && !WinActive(robloxWin)
                WinActivate(robloxWin)
            statusTxt.Value := "Status: Holding " StrUpper(k)
            Send("{" k " down}")
            hold := GetHoldTime()
            elapsed := 0
            while running && elapsed < hold {
                Sleep(50)
                elapsed += 50
            }
            Send("{" k " up}")
        }
    }
    loopActive := false
}

ReleaseAll() {
    global keys
    for k in keys
        Send("{" k " up}")
}

F1:: Toggle()
F2:: ExitApp()
