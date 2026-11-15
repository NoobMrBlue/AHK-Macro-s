#Requires AutoHotkey v2.0
#SingleInstance Force

; Roblox usually ignores SendInput, so use classic event mode
SendMode "Event"
SetKeyDelay 10, 10

robloxWin := "ahk_exe RobloxPlayerBeta.exe"
settingsFile := A_ScriptDir "\MacroHubSettings.ini"
runId := 0            ; changes every start/stop so old loops know to quit
activeMode := 0       ; which tab's macro is currently running (0 = none)
hotCur := 0
startTick := 0
sliders := []
tabNames := ["Square Walk", "Line/Circle Walk", "Spin", "Flick", "Quick Turn", "Hotbar Cycler", "Anti-idle", "Key Spam"]

; ===================== GUI =====================
g := Gui("+AlwaysOnTop -MinimizeBox", "Roblox Macro Hub")
g.SetFont("s9")

AddSlider(title, lo, hi, def, unit, opt := "") {
    lbl := g.Add("Text", "w290 " opt, title ": " def " " unit)
    s := g.Add("Slider", "w290 Range" lo "-" hi " ToolTip", def)
    info := {s: s, lbl: lbl, title: title, unit: unit}
    sliders.Push(info)
    s.OnEvent("Change", (*) => RefreshLabel(info))
    return s
}

RefreshLabel(info) {
    info.lbl.Value := info.title ": " info.s.Value " " info.unit
}

tabs := g.Add("Tab3", "w320 h260", ["Square", "Line/Circle", "Spin", "Flick", "Turn", "Hotbar", "Anti-idle", "Spam"])

; --- 1: Square walk ---
tabs.UseTab(1)
g.Add("Text", "w290", "Holds W, A, S, D in turn to walk a square.")
g.Add("Text", "w290", "Hold time per key (ms):")
sqHold := g.Add("Edit", "w90 Number", "2000")

; --- 2: Line / Circle ---
tabs.UseTab(2)
lcMode := g.Add("DropDownList", "w140 Choose1", ["Line (W/S)", "Circle"])
g.Add("Text", "w290", "Line: hold time per direction (ms):")
lcHold := g.Add("Edit", "w90 Number", "2000")
lcSl := AddSlider("Circle: turn speed", 1, 100, 8, "px/tick")
lcDir := g.Add("DropDownList", "w80 Choose1", ["Right", "Left"])

; --- 3: Spin ---
tabs.UseTab(3)
spSl := AddSlider("Spin speed", 1, 300, 20, "px/tick")
g.Add("Text", "w290", "Tick rate (ms, lower = smoother):")
spTick := g.Add("Edit", "w90 Number", "10")
spDir := g.Add("DropDownList", "w80 Choose1", ["Right", "Left"])

; --- 4: Flick ---
tabs.UseTab(4)
g.Add("Text", "w290", "Flicks the camera out and snaps it back.")
flSl := AddSlider("Flick distance", 20, 2000, 400, "px")
flDir := g.Add("DropDownList", "w80 Choose1", ["Right", "Left"])

; --- 5: Quick turn ---
tabs.UseTab(5)
g.Add("Text", "w290", "Turns the camera in one instant jump.")
tnSl := AddSlider("Turn amount (about 180)", 100, 3000, 800, "px")
tnDir := g.Add("DropDownList", "w80 Choose1", ["Right", "Left"])

; --- 6: Hotbar ---
tabs.UseTab(6)
g.Add("Text", "w290", "From slot (1-10):")
hbFrom := g.Add("Edit", "w60 Number", "1")
g.Add("Text", "w290", "To slot (1-10):")
hbTo := g.Add("Edit", "w60 Number", "5")
g.Add("Text", "w290", "Switch speed (ms between slots):")
hbSpeed := g.Add("Edit", "w90 Number", "200")

; --- 7: Anti-idle ---
tabs.UseTab(7)
g.Add("Text", "w290", "Stops Roblox kicking you for being idle.")
idleMode := g.Add("DropDownList", "w180 Choose1", ["Jump (Space)", "Step forward/back", "Tiny camera nudge"])
g.Add("Text", "w290", "Do it every (seconds):")
idleSec := g.Add("Edit", "w90 Number", "120")

; --- 8: Key spam ---
tabs.UseTab(8)
g.Add("Text", "w290", "Presses one key on a timer (collect, interact, etc).")
g.Add("Text", "w290", "Key (e, 1, space, LButton...):")
ksKey := g.Add("Edit", "w90", "e")
g.Add("Text", "w290", "Press every (ms):")
ksInterval := g.Add("Edit", "w90 Number", "1000")

tabs.UseTab()

; --- shared options ---
jitterSl := AddSlider("Random timing jitter", 0, 50, 0, "%", "xm")
g.Add("Text", "xm", "Auto-stop after (minutes, 0 = never):")
asEdit := g.Add("Edit", "x+8 yp-3 w60 Number", "0")
rmbChk := g.Add("Checkbox", "xm Checked", "Hold RMB for camera moves (untick if shift lock)")
focusChk := g.Add("Checkbox", "xm Checked", "Auto-focus Roblox")
onTopChk := g.Add("Checkbox", "xm Checked", "Always on top")
statusTxt := g.Add("Text", "xm w320", "Status: Stopped")
startBtn := g.Add("Button", "xm w155 h32", "Start (X)")
stopBtn := g.Add("Button", "x+10 w155 h32", "Stop all (C)")
g.Add("Text", "xm cGray", "X = start/stop current tab   |   C = stop everything")
startBtn.OnEvent("Click", Toggle)
stopBtn.OnEvent("Click", (*) => StopAll())
tabs.OnEvent("Change", (*) => UpdateBtn())
onTopChk.OnEvent("Click", (c, *) => g.Opt((c.Value ? "+" : "-") "AlwaysOnTop"))
g.OnEvent("Close", (*) => ExitApp())

; ===================== Saved settings =====================
settingsList := [
    ["sqHold", sqHold, "e"], ["lcMode", lcMode, "n"], ["lcHold", lcHold, "e"],
    ["lcSl", lcSl, "n"], ["lcDir", lcDir, "n"],
    ["spSl", spSl, "n"], ["spTick", spTick, "e"], ["spDir", spDir, "n"],
    ["flSl", flSl, "n"], ["flDir", flDir, "n"],
    ["tnSl", tnSl, "n"], ["tnDir", tnDir, "n"],
    ["hbFrom", hbFrom, "e"], ["hbTo", hbTo, "e"], ["hbSpeed", hbSpeed, "e"],
    ["idleMode", idleMode, "n"], ["idleSec", idleSec, "e"],
    ["ksKey", ksKey, "e"], ["ksInterval", ksInterval, "e"],
    ["jitter", jitterSl, "n"], ["autoStop", asEdit, "e"],
    ["rmb", rmbChk, "n"], ["focus", focusChk, "n"], ["onTop", onTopChk, "n"]
]

LoadSettings() {
    for item in settingsList {
        v := IniRead(settingsFile, "Settings", item[1], "")
        if v = ""
            continue
        try item[2].Value := (item[3] = "n") ? Integer(v) : v
    }
    for info in sliders {
        RefreshLabel(info)
    }
}

SaveSettings() {
    for item in settingsList {
        try IniWrite(item[2].Value, settingsFile, "Settings", item[1])
    }
}

LoadSettings()
g.Opt((onTopChk.Value ? "+" : "-") "AlwaysOnTop")
UpdateBtn()
g.Show("AutoSize")

; ===================== Helpers =====================
GetInt(ctrl, def, lo, hi) {
    try {
        n := Integer(ctrl.Value)
        return Max(lo, Min(hi, n))
    }
    return def
}

; adds random +/- jitter (percent) to a time in ms
Jit(ms) {
    j := jitterSl.Value
    return Max(1, Round(ms * (1 + Random(-j, j) / 100)))
}

RelMove(dx) {
    DllCall("mouse_event", "UInt", 0x0001, "Int", dx, "Int", 0, "UInt", 0, "UPtr", 0)
}

FocusRoblox() {
    if focusChk.Value && WinExist(robloxWin) && !WinActive(robloxWin) {
        WinActivate(robloxWin)
        Sleep(80)
    }
}

RmbDown() {
    if rmbChk.Value
        Send("{RButton down}")
}

ReleaseAll() {
    for k in ["w", "a", "s", "d"]
        Send("{" k " up}")
    Send("{Space up}")
    Send("{RButton up}")
}

UpdateBtn() {
    m := tabs.Value
    if m = 4 || m = 5
        startBtn.Text := "Do it (X)"
    else if activeMode = m
        startBtn.Text := "Stop (X)"
    else
        startBtn.Text := "Start (X)"
}

; ===================== Control =====================
Toggle(*) {
    m := tabs.Value
    if m = 4 {
        DoFlick()
        return
    }
    if m = 5 {
        DoTurn()
        return
    }
    if activeMode = m
        StopAll()
    else
        Start(m)
}

StopAll(msg := "Status: Stopped") {
    global runId, activeMode
    runId += 1
    activeMode := 0
    SetTimer(CircleTick, 0)
    SetTimer(SpinTick, 0)
    SetTimer(HotbarTick, 0)
    SetTimer(IdleTick, 0)
    SetTimer(KeySpamTick, 0)
    SetTimer(StatusTick, 0)
    ReleaseAll()
    statusTxt.Value := msg
    UpdateBtn()
}

Start(mode) {
    global activeMode, hotCur, startTick
    StopAll()
    FocusRoblox()
    activeMode := mode
    startTick := A_TickCount
    id := runId
    if mode = 1 {
        SetTimer(() => WalkLoop(id, ["w", "a", "s", "d"], sqHold), -10)
    } else if mode = 2 {
        if lcMode.Value = 1 {
            SetTimer(() => WalkLoop(id, ["w", "s"], lcHold), -10)
        } else {
            Send("{w down}")
            RmbDown()
            SetTimer(CircleTick, 10)
        }
    } else if mode = 3 {
        RmbDown()
        SetTimer(SpinTick, GetInt(spTick, 10, 1, 200))
    } else if mode = 6 {
        hotCur := 0
        SetTimer(HotbarTick, GetInt(hbSpeed, 200, 1, 10000))
    } else if mode = 7 {
        SetTimer(IdleTick, GetInt(idleSec, 120, 5, 3600) * 1000)
    } else if mode = 8 {
        SetTimer(KeySpamTick, GetInt(ksInterval, 1000, 10, 3600000))
    }
    SetTimer(StatusTick, 1000)
    StatusTick()
    UpdateBtn()
}

; shows elapsed time and handles the auto-stop timer
StatusTick() {
    if !activeMode
        return
    elapsed := (A_TickCount - startTick) // 1000
    t := Format("{}:{:02}:{:02}", elapsed // 3600, Mod(elapsed // 60, 60), Mod(elapsed, 60))
    extra := (activeMode = 6 && hotCur) ? " (slot " hotCur ")" : ""
    statusTxt.Value := "Status: Running - " tabNames[activeMode] extra "  [" t "]"
    limit := GetInt(asEdit, 0, 0, 100000)
    if limit > 0 && (A_TickCount - startTick) >= limit * 60000 {
        StopAll("Status: Stopped - auto-stop timer reached")
        SoundBeep(750, 300)
    }
}

; ===================== Macros =====================
WalkLoop(id, keyList, holdCtrl) {
    while runId = id {
        for k in keyList {
            if runId != id
                break
            Send("{" k " down}")
            ms := Jit(GetInt(holdCtrl, 2000, 100, 60000))
            elapsed := 0
            while runId = id && elapsed < ms {
                Sleep(50)
                elapsed += 50
            }
            Send("{" k " up}")
        }
    }
}

CircleTick() {
    RelMove(lcSl.Value * (lcDir.Value = 1 ? 1 : -1))
}

SpinTick() {
    RelMove(spSl.Value * (spDir.Value = 1 ? 1 : -1))
}

DoFlick() {
    FocusRoblox()
    px := flSl.Value * (flDir.Value = 1 ? 1 : -1)
    RmbDown()
    RelMove(px)
    Sleep(25)          ; short pause so Roblox registers the flick
    RelMove(-px)       ; exact opposite amount, back to start
    Send("{RButton up}")
}

DoTurn() {
    FocusRoblox()
    px := tnSl.Value * (tnDir.Value = 1 ? 1 : -1)
    RmbDown()
    RelMove(px)
    Sleep(15)
    Send("{RButton up}")
}

HotbarTick() {
    global hotCur
    id := runId
    lo := GetInt(hbFrom, 1, 1, 10)
    hi := GetInt(hbTo, 5, 1, 10)
    if lo > hi {
        tmp := lo
        lo := hi
        hi := tmp
    }
    hotCur := (hotCur < lo || hotCur >= hi) ? lo : hotCur + 1
    Send("{" (hotCur = 10 ? "0" : hotCur) "}")
    if runId = id
        SetTimer(HotbarTick, Jit(GetInt(hbSpeed, 200, 1, 10000)))
}

IdleTick() {
    id := runId
    FocusRoblox()
    m := idleMode.Value
    if m = 1 {
        Send("{Space down}")
        Sleep(50)
        Send("{Space up}")
    } else if m = 2 {
        Send("{w down}")
        Sleep(150)
        Send("{w up}")
        Sleep(50)
        Send("{s down}")
        Sleep(150)
        Send("{s up}")
    } else {
        RmbDown()
        RelMove(4)
        Sleep(30)
        RelMove(-4)
        Send("{RButton up}")
    }
    if runId = id
        SetTimer(IdleTick, Jit(GetInt(idleSec, 120, 5, 3600) * 1000))
}

KeySpamTick() {
    id := runId
    k := Trim(ksKey.Value)
    if k = ""
        return
    try {
        Send("{" k "}")
    } catch {
        StopAll("Status: Stopped - invalid key name: " k)
        return
    }
    if runId = id
        SetTimer(KeySpamTick, Jit(GetInt(ksInterval, 1000, 10, 3600000)))
}

ExitHandler(*) {
    SaveSettings()
    ReleaseAll()
}
OnExit(ExitHandler)

; Hotkeys only fire when the hub window itself isn't focused,
; so typing in its boxes never triggers them.
#HotIf !WinActive("ahk_id " g.Hwnd)
$x:: Toggle()
$c:: StopAll()
#HotIf
