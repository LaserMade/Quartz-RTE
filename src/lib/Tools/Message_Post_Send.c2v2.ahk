#Requires Autohotkey v2.0.10+
#Include <Directives\__AE.v2>
#Include <Tools\Info>

; ---------------------------------------------------------------------------
*+Esc::Reload()
; ---------------------------------------------------------------------------
hznDrawBorder(WA := WinActive("A")) {
    Static OS:=3
    Static BG:="FF0000"
    Static myGui := Gui("+AlwaysOnTop +ToolWindow -Caption","GUI4Border")
    myGui.BackColor := BG
    ; WA:=WinActive("A")
    If WA && !WinGetMinMax(WA) && !WinActive("GUI4Border ahk_class AutoHotkeyGUI"){
        DPI.WinGetPos(&wX,&wY,&wW,&wH,WA)
        myGui.Show("x" wX " y" wY " w" wW " h" wH " NA")
        Try WinSetRegion("0-0 " wW "-0 " wW "-" wH " 0-" wH " 0-0 " OS "-" OS " " wW-OS
        . "-" OS " " wW-OS "-" wH-OS " " OS "-" wH-OS " " OS "-" OS,"GUI4Border")
    }
    Else {
    	myGui.Hide()
    }
}
; hznDrawBorder(hwnd, color:=0x04a230, enable:=1) {
;     static DWMWA_BORDER_COLOR := 34
;     static DWMWA_COLOR_DEFAULT	:= 0xFFFFFFFF
;     R := (color & 0xFF0000) >> 16
;     G := (color & 0xFF00) >> 8
;     B := (color & 0xFF)
;     color := (B << 16) | (G << 8) | R
;     DllCall("dwmapi\DwmSetWindowAttribute", "ptr", hwnd, "int", DWMWA_BORDER_COLOR, "int*", enable ? color : DWMWA_COLOR_DEFAULT, "int", 4)
; }
; ---------------------------------------------------------------------------
; ^!+Tab::ControlFocus('SSTabPanelWndClass2', 'A')
; ^#+Tab::ControlFocus('SSTabPanelWndClass1', 'A')
^!+Tab::WinActivate('SSTabPanelWndClass2')
^#+Tab::WinActivate('SSTabPanelWndClass1')
#1::SetTimer(WatchCursor1,1000)
WatchCursor1()
{
    _AE_DetectHidden(1)
    ct6 := ct5 := ct4 := ct3 := ct2 := ct1 := fCtl := 0, control := wCtl := ClassNN := ''
    lCtls := [], nCtls := '', fCtls := 0
    try fCtl := ControlGetFocus('A')
    try ClassNN := ControlGetClassNN(fCtl, 'A')
    ; lCtls := WinGetControls('ahk_exe hznHorizon.exe')
    try MouseGetPos(,,&wCtl, &control)
    try hznDrawBorder(ClassNN)
    ; lCtls := WinGetControls('A')
    lCtls := WinGetControls(wCtl)
    ; try ct1 := SendMessage(0x1304,0,0,fCtl, 'A')  ; 0x1304 is TCM_GETITEMCOUNT.
    ; try ct2 := SendMessage(0x1304,0,0,wCtl, 'A')  ; 0x1304 is TCM_GETITEMCOUNT.
    ; try ct3 := SendMessage(0x1304,0,0,control, 'A')  ; 0x1304 is TCM_GETITEMCOUNT.
    ; try ct4 := SendMessage(0x1304,,,fCtl, 'A')  ; 0x1304 is TCM_GETITEMCOUNT.
    ; try ct5 := SendMessage(0x1304,,,wCtl, 'A')  ; 0x1304 is TCM_GETITEMCOUNT.
    try ct6 := SendMessage(0x1304,,,control, 'A')  ; 0x1304 is TCM_GETITEMCOUNT.
    ; ---------------------------------------------------------------------------
    ; try ct1 := SendMessage(0x1304,0,0,fCtl)  ; 0x1304 is TCM_GETITEMCOUNT.
    ; try ct2 := SendMessage(0x1304,0,0,wCtl)  ; 0x1304 is TCM_GETITEMCOUNT.
    ; try ct3 := SendMessage(0x1304,0,0,control)  ; 0x1304 is TCM_GETITEMCOUNT.
    ; try ct4 := SendMessage(0x1304,,,fCtl)  ; 0x1304 is TCM_GETITEMCOUNT.
    ; try ct5 := SendMessage(0x1304,,,wCtl)  ; 0x1304 is TCM_GETITEMCOUNT.
    ; try ct6 := SendMessage(0x1304,,,control)  ; 0x1304 is TCM_GETITEMCOUNT.
    try ct1 := ControlGetIndex(fCtl, 'A')
    try ct2 := ControlGetIndex(ClassNN, 'A')
    try ct3 := ControlGetIndex(wCtl, 'A')
    try ct4 := ControlGetIndex(control, 'A') ;! Winner!!! SSTabPanelWndClass2
    for each, value in lCtls {
        try fCtls := ControlGetHwnd(value)
        nCtls .= value '(' fCtls ')' '`n'
    }
    CoordMode('ToolTip','Screen')
    ToolTip(
    ; Infos(
        'ClassNN: ' ClassNN '`n'
        'fCtl: ' fCtl '`n'
        'wCtl: ' wCtl '`n'
        'Ctl: ' control '`n'
        'GetItemCount1:' ct1 '`n'
        'GetItemCount2:' ct2 '`n'
        'GetItemCount3:' ct3 '`n'
        'GetItemCount4:' ct4 '`n'
        'GetItemCount5:' ct5 '`n'
        'GetItemCount6:' ct6 '`n'
        ; nCtls
	)
    ; ,750)
}
;#1::
;ControlGet, Ctlh, hWnd,,% hCtl, A
;ControlGet, Ctlt, hWnd,,% tCtl, A
;CoordMode, Mouse, Client
; bold button
;PostMessage,0x0201,,,, ahk_id %Ctlh% ;L_Button Down
;PostMessage,0x0202,,,, ahk_id %Ctlh% ;L_Button Up
;return

; ========== Human Element - Horizon - Italics ==============
;#2::
;ToolTip
;ControlGet, Ctlh, hWnd,,% hCtl, A
;ControlGet, Ctlt, hWnd,,% tCtl, A
;CoordMode, Mouse, Client
; italics button
;PostMessage,0x0201,,40,, ahk_id %Ctlh% ;L_Button Down
;PostMessage,0x0202,,40,, ahk_id %Ctlh% ;L_Button Up
;return

;#3:: ; Cut Button
;ControlGet, Ctlh, hWnd,,% hCtl, A
;ControlGet, Ctlt, hWnd,,% tCtl, A
;CoordMode, Mouse, Client
; Cut button
;PostMessage,0x0201,,70,, ahk_id %Ctlh% ;L_Button Down
;PostMessage,0x0202,,70,, ahk_id %Ctlh% ;L_Button Up
;return

;WatchCursor3:
;MouseGetPos, , , id, control, 3
;ControlGetFocus, ClassNN, A
;ControlGet, hCtl, Hwnd,, % ClassNN, A
;WinGetClass, vCtlClass, % "ahk_id " hCtl
;ControlGetText, vText, % ClassNN, A
;ControlGet, vText2, List,, % ClassNN, A
;MsgBox, % vCtlClass
;MsgBox, % vText
;ToolTip % vCtlClass " ID:"id
;Clipboard:= % vText
;MsgBox, % vText2
;return

^+2::
{
	text := txt := list := '', alist := []
	; try ClassNN := ControlGetClassNN('SysTreeView32')
	; try cHwnd := ControlGetHwnd(ClassNN)
	for each, value in WinGetControls('A') {
		txt := ControlGetText(value)
		text := WinGetText(value)
		list .= txt '`n' text
	}
	; for each, value in WinGetControlsHwnd() {
	; 	ClassNN := ControlGetClassNN(value)
	; 	txt := ControlGetText(value)
	; 	if !txt{
	; 		txt := WinGetText(value)
	; 	}
	; 	list .= ClassNN ' (' value ') ' txt '`n'
	; }
	Infos('`n' list)
}
; #HotIf
; #HotIf WinActive('ahk_exe hznHorizon.exe') ; && WinActive('ahk_class ThunderRT6MDIForm')

; Enter::{
; 	try ClassNN := ControlGetClassNN(ControlGetFocus('A'))
; 		if ClassNN ~= 'SSUltraGridWndClass' {
; 			Send('{Click}{Click}')
; 		}
; }

#HotIf
^+5::
{
Infos(
	'True: ' true ' False: ' false '`n'
	'Risk File Manager: ' WinActive('Risk File Manager') '`n'
	; 'ThunderRT6FormDC1: ' WinExist('ThunderRT6FormDC') '`n'
	'ThunderRT6FormDC: ' WinActive('ahk_class ThunderRT6FormDC') '`n'
	'ThunderRT6MDIForm: ' WinActive('ahk_class ThunderRT6MDIForm') '`n'
	)
}
#HotIf

#4::{
    SetTimer(WatchCursor4,1000)
    v := '', a := l := [], l := WinGetControls('ahk_exe hznHorizon.exe')
    for each, value in l {
        a.SafePush(value)
    }
    for v in a {
        ; try hznDrawBorder(v)
        if !v ~= 'ScrollBar'{
            hznDrawBorder(v)
        }
    }
}

WatchCursor4() {
    _AE_DetectHidden(1)
    SendLevel(1)
	p := ix := t := tab := v := cText := wText := item := nText := fText := ControlList := cTitle := title := nClassNN := ClassNN := ''
    TCS_T := im := i := idxTab := ct1 := ct := TabCount := iIndex := y := x:= fCtl := 0
    nCtlList := CtlList := oControlList := items := []
	try MouseGetPos(,, &tbctrl_ID, &control, 3)
    try MouseGetPos(, , &win, &nCtl)
    try p := WinGetProcessName(win)
	try hCtl := ControlGethWnd(tbctrl_ID, "A")
    ; try CaretGetPos(&x, &y)
    ; try dHwnd := DllCall( "ChildWindowFromPoint", 'uint',X, 'uint',Y )
    try fCtl := ControlGetFocus('A')
    try ClassNN := ControlGetClassNN(fCtl)
    try nClassNN := ControlGetClassNN(nCtl)
    try fText := ControlGetText(ClassNN, 'A')
    try nText := ControlGetText(nCtl, 'A')
    try wText := WinGetText(nCtl)
	try title := WinGetTitle('ahk_id ' tbctrl_ID)
    ; try title := WinGetTitle('ahk_id ' fCtl) ;! failed to work
	try class := WinGetClass('ahk_id ' tbctrl_ID)
	try oControlList := WinGetControls(win)
	try For v in oControlList {
		ControlList .= A_index=1 ? v : "`r`n" v
        SafePush(CtlList, v)
        v := ''
	}
    try for v in CtlList {
        vClassNN := ControlGetClassNN(v)
        SafePush(nCtlList, v)
        if vClassNN ~= 'im)Tab' {
            tab .= nClassNN '`n'
            ; try SendMessage(64,0,0,nCtl, 'A') ; TCS_HOTTRACK
            TCS_T := SendMessage(0,0,0,nCtl, 'A') ; TCS_TABS
        }
        v := ''
    }
    try {
        iIndex := ControlGetIndex(nCtl)
        idxTab := ControlGetIndex(fCtl, 'A')
        try im := SendMessage(4869,0,0,nCtl, 'A')  ; 0x133C is TCM_GETITEM
        if !iIndex {
            i := idxTab
            ix := 'idxTab'
        }
        else if !idxTab {
            i := im
            ix := 'im'
        }
        else {
            i := iIndex
            ix := 'iIndex'
        }
    }
    try {
        try ct := SendMessage(0x1304,,,fCtl)  ; 0x1304 is TCM_GETITEMCOUNT.
        try ct1 := SendMessage(0x1304,0,0,nCtl, 'A')  ; 0x1304 is TCM_GETITEMCOUNT.
        if !ct {
            TabCount := ct1
            t := 'ct1'
        }
        else {
            TabCount := ct
            t := 'ct'
        }
    }
    try items := ControlGetItems(nCtl)
    for v in items {
        ; item .= v '`n'
        if v ~= 'im)Tab' {
            item .= v '`n'
        }
        v := ''
    }


	ToolTip(
        'tbctrl_ID:' tbctrl_ID
        '`n'
        'ctl:' control ' ' 'win:' win
        '`n'
        'p:' p
        '`n'
        'nCtl:' nCtl
        '`n'
        'T: ' title
        '`n'
        'wTxt: ' wText
        '`n'
        'C: ' class
        '`n'
        'nCtl: ' nCtl '(' tbctrl_ID ')'
        '`n'
        'fCtl: ' ClassNN '(' fCtl ')'
        '`n'
        'Idx: ' i ' (of ' TabCount ') ct: ' t ' i: ' ix
        '`n'
        'Tab: ' tab
        '`n'
        'Itm: ' item
        '`n'
        'fTxt: ' fText
        '`n'
        'nTxt: ' nText
        '`n'
        'TCS_TABS: ' TCS_T
    )
    ; SetTimer(, -1000)
/*
	;compatibility types 
	UPtr := A_PtrSize ? "UPtr" : "UInt"
	AStr := A_IsUnicode ? "AStr" : "Str"
	
	;cinfo:= DllCall("ChildWindowFromPointEx", Ptr,hCtl, UInt,"0x0000")
	;hFont := DllCall("CreateFont",uint,20 ; int nHeight
	;, int,0 ; int nWidth
	;, int,0 ; int nEscapement
	;, int,0 ; int nOrientation
	;, int,646 ; int fnWeight
	;, int,0 ; DWORD fdwItalic
	;, uint,0 ; DWORD fdwUnderline
	;, uint,True ; DWORD fdwStrikeOut
	;, uint,0 ; DWORD fdwCharSet
	;, uint,0 ; DWORD fdwOutPutPrecision
	;, uint,0 ; DWORD fdwClipPrecision
	;, uint,0 ; DWORD fdwQuality
	;, uint,0 ; DWORD fdwPitchAndFamily
	;, str, "Arial") ; LPCTSTR lpszFace
	
	;SendMessage 0x30,d %w hfont, True, %control%, ahk_id %win%
	;ToolTip Info: %cinfo% Control: %hCtl% ahk_id %win%
*/
	return
}
#HotIf WinActive('ahk_exe hznHorizon.exe')
#6::
{
    aTitle := [], title := ''
    aTitle := WinGetList('A')
    for each, value in aTitle {
        title .= WinGetTitle(value) '`n'
    }
    ToolTip(title)
}

#7::SetTimer(WatchCursor7,1000)
{
    WatchCursor7() {
        nCtl := winT := hCtl := win := ''
        try MouseGetPos(,,&win,&hCtl)
        try winT := WinGetTitle(win)
        try nCtl := ControlGetClassNN(hCtl)
        ToolTip('winT:' winT '`n' 'nCtl:' hCtl)
    }
}
#HotIf

#8::SetTimer(WatchCursor8,1000)
{
    ; SetTimer(WatchCursor8,500)
	; static toggle := 0
	; static toggle := !toggle
	; ; toggle := !toggle
	; if toggle {
	; 	ToolTip()
	; }
	; else {
	; ; else if !toggle {
	; 	Exit()
	; 	Run(A_ScriptName)
	; }
	; global win
	; global Ctl
}
; TCM_GETCURFOCUS := 0x132F
; TCM_GETROWCOUNT := 0x132C
WatchCursor8(){
	CoordMode("ToolTip", "Screen")
	cHwnd := y := x := hWinPt := hCtl := WinTpt := idxTab3 := idxTab2 := idxTab1 := idxTab := hCtl := win := LV1 := LV := ChoicePos1 := ChoicePos := choice1 := choice := LC := 0
    WinTP4 := WinTP3 := WinTP2 := WinTP1 := nCtl := wTxt := cTxt := txt1 := WinP := WinT := WinC := text := sTxt := ''
	try MouseGetPos(, , &win, &nCtl)
	try WinP := WinGetProcessName(win)
	try WinT := WinGetTitle(win)
	try WinC := WinGetClass(win)
	try hCtl := ControlGethWnd(nCtl, 'A')
	try cTxt := ControlGetText(hCtl, 'A')
    try {
        loop parse cTxt, '\n' {
            If A_Index = 1 {
                sTxt .= A_LoopField
            }
        }
    }
	try wTxt := WinGetText('A')
	try {
		loop parse wTxt, '\n' {
			If A_Index = 1 {
				sTxt .= A_LoopField
			}
		}
	}
	try idxTab := ControlGetIndex(hCtl, 'A')
	try idxTab1 := SendMessage(0x1304,0,0,hCtl, 'A')  ; 0x1304 is TCM_GETITEMCOUNT.
	; ChoicePos is now 0 if there is no item selected.
	try idxTab2 := SendMessage(0x132E, 0, 0, hCtl, 'A')
	try idxTab3 := SendMessage(0x132C, 0, 0, hCtl, 'A')
	try choice := ControlGetChoice(hCtl, 'A')
	try choice1 := ControlGetChoice(win, 'A')
	try ChoicePos := SendMessage(0x0188, 0, 0,hCtl, 'A') , ChoicePos += 1 ; 0x0188 is LB_GETCURSEL (for a ListBox).
	try ChoicePos1 := SendMessage(0x0147, 0, 0, hCtl, 'A') , ChoicePos1 += 1 ; 0x0147 is CB_GETCURSEL (for a DropDownList or ComboBox).
	try LC := EditGetLineCount(nCtl, 'A')
	try LV := ListViewGetContent(, hCtl, 'A')
	try LV1 := ListViewGetContent(, nCtl, 'A')
    
    try {
        CaretGetPos(&x,&y)
        ; cHwnd := DllCall( "WindowFromPoint", 'uint',X, 'uint',Y )
        cHwnd := ControlGetFocus('A')
        WinTP1 := WinGetTitle(DllCall( "GetAncestor", 'uint', cHwnd, 'uint',GA_ROOTOWNER := 1 ))
        WinTP2 := WinGetTitle(DllCall( "GetAncestor", 'uint', cHwnd, 'uint',GA_ROOTOWNER := 2 ))
        WinTP3 := WinGetTitle(DllCall( "GetAncestor", 'uint', cHwnd, 'uint',GA_ROOTOWNER := 3 ))
        WinTP4 := WinGetTitle(DllCall( "GetAncestor", 'uint', cHwnd, 'uint',GA_ROOTOWNER := 4 ))
        hWinPt := DllCall("GetAncestor", 'uint', nCtl, 'uint',GA_ROOTOWNER := 3 )
        WinTpt := WinGetTitle(hWinPt)
    }
	ToolTip(
		"Control: " nCtl "`nhCtl: " hCtl
		'`n'
		'WinP: ' WinP
		'`n'
		'WinT: ' WinT
		'`n'
		'WinC: ' WinC
		' (' Win ')'
		'`n'
		'CtlGetTxt: ' cTxt
		'`n'
		; 'WinGetTxt: ' sTxt
		; '`n'
		'idxTab: ' idxTab
		'`n'
		'idxTabCt: ' idxTab1
		'`n'
		'idxTab2: ' idxTab2
		'`n'
		'idxTab3: ' idxTab3
		'`n'
		'choice: ' choice
		'`n'
		'choice1: ' choice1
		'`n'
		'choicepos: ' choicepos
		'`n'
		'choicepos1: ' choicepos1
		'`n'
		'LC: ' LC
		'`n'
		'LV: ' LV
		'`n'
		'LV1: ' LV1
		'`n'
        'WindowInfo: ' WinTpt ' (' hWinPt ')'
		'`n'
        'x: ' x ' y: ' y
        '`n'
        'WinTP1:' WinTP1
        '`n'
        'WinTP2:' WinTP2
        '`n'
        'WinTP3:' WinTP3
        '`n'
        'WinTP4:' WinTP4
        '`n'
		; , 0, 0
	)
	Return
}

; Function: ClickToolbarItem
; Description: Clicks the nth item in a toolbar.
; Parameters:
;   - hWndToolbar: The handle of the toolbar control.
;   - n: The index of the toolbar item to click.

; #6::
; {
; 	hToolbar := ControlGethWnd("msvb_lib_toolbar1", "A")
; 	ClickToolbarItem(hToolbar,21)
; 	; return
; 	; 1=Bold, 2=Italics, 10=Cut, 11=Copy, 12=Paste, 14=Undo, 15=Redo
; 	; 17=Bulleted List, 18=Spell Check, 20=Super/Sub Script, 21=Find/Replace
; 	; Mystery or Spacers: 3-9, 13, 16, 19=?Bold?
; } ; Added bracket before function

; ;/*
; ClickToolbarItem(hWndToolbar, n) {
; 	static TB_BUTTONCOUNT := 0x418, TB_GETBUTTON := 0x417, TB_GETITEMRECT := 0x41D
; 	ErrorLevel := SendMessage(TB_BUTTONCOUNT, 0, 0, , "ahk_id " hWndToolbar)
; 	buttonCount := ErrorLevel
; 	if (n >= 1 && n <= buttonCount) {
; 		DllCall("GetWindowThreadProcessId", "Ptr", hWndToolbar, "UIntP", &targetProcessID)
; 		; Open the target process with PROCESS_VM_OPERATION, PROCESS_VM_READ, and PROCESS_VM_WRITE access
; 		hProcess := DllCall("OpenProcess", "UInt", 0x0018 | 0x0010 | 0x0020, "Int", 0, "UInt", targetProcessID, "Ptr")
; 		; Allocate memory for the TBBUTTON structure in the target process's address space
; 		remoteMemory := DllCall("VirtualAllocEx", "Ptr", hProcess, "Ptr", 0, "UPtr", 16, "UInt", 0x1000, "UInt", 0x04, "Ptr")
; 		ErrorLevel := SendMessage(TB_GETITEMRECT, n-1, remoteMemory, , "ahk_id " hWndToolbar)
; 		RECT := Buffer(16, 0) ; V1toV2: if 'RECT' is a UTF-16 string, use 'VarSetStrCapacity(&RECT, 16)'
; 		DllCall("ReadProcessMemory", "Ptr", hProcess, "Ptr", remoteMemory, "Ptr", RECT, "UPtr", 16, "UIntP", &bytesRead, "Int")
; 		DllCall("VirtualFreeEx", "Ptr", hProcess, "Ptr", remoteMemory, "UPtr", 0, "UInt", 0x8000)
; 		DllCall("CloseHandle", "Ptr", hProcess)
		
; 		X := NumGet(RECT, 0, "int"), Y := NumGet(RECT, 4, "int"), W := NumGet(RECT, 8, "int")-X, H := NumGet(RECT, 12, "int")-Y, prevDelay := A_ControlDelay
; 		ControlClick("x" (X+W//2) " y" (Y+H//2), "ahk_id " hWndToolbar, , , , "NA")
; 		SetControlDelay(prevDelay)
; 		;ToolTip % "X: " X " Y: " Y " W: " W " H: " H " #: " buttonCount
; 	} else {
; 		MsgBox("The specified index " n " is out of range. Please specify a valid index between 1 and " buttonCount ".", "Error", 48)
; 	}
; 	return
; }

#2::SetTimer(WatchCursor5,500)

WatchCursor5(){
	hwnd := ovCtlList := vctllist := vOutput := id := control := pid := ClassNN := vText := ovText2 := vText2 := hWndParent := hWndRoot := hWndOwner := hWndChild := chWnd := vWinClass1 := vWinClass2 := vWinClass3 := vWinClass4 := pWinT := rWinT := oWinT  := cWinT  := ''
	hWnd := WinGetID("A")
	;WinGet, vCtlList, ControlList, % "ahk_id " hWnd
	ovCtlList := WinGetControls("ahk_id " hWnd,,,)
	For v in ovCtlList {
	vCtlList .= A_index=1 ? v : "`r`n" v
	}
	vOutput := ""
	; return
	MouseGetPos(&x,&y , &id, &control)
	try pid := WinGetpid("id")
	try fCtl := ControlGetFocus('A')
	try ClassNN := ControlGetClassNN(fCtl)
	try hCtl := ControlGetHwnd(ClassNN, "A")
	try vCtlClass := WinGetClass("ahk_id " hCtl)
	try vText := ControlGetText(ClassNN, "A")
	try ovText2 := ControlGetItems(ClassNN, "A", , , )
	try loop ovText2.length {
		vText2 .= A_index=1 ? "" : "`n"
		vText2 .= ovText2[A_Index] 
	}
	try hWndParent := DllCall("user32\GetAncestor", "Ptr", hCtl, "UInt", 1, "Ptr") ;GA_PARENT := 1
	try hWndRoot := DllCall("user32\GetAncestor", "Ptr", hCtl, "UInt", 2, "Ptr") ;GA_ROOT := 2
	try hWndOwner := DllCall("user32\GetAncestor", "Ptr", hCtl, "UInt", 4, "Ptr") ;GW_OWNER = 4
	try hWndChild := DllCall("RealChildWindowFromPoint", "Ptr", hCtl, "UInt", 4, "Ptr") ;GW_OWNER = 4
	try chWnd := WinGetID(hWndChild)
	try vWinClass1 := WinGetClass(hWndParent), pWinT := WinGetTitle(hWndParent)
	try vWinClass2 := WinGetClass(hWndRoot), rWinT := WinGetTitle(hWndRoot)
	try vWinClass3 := WinGetClass(hWndOwner), oWinT := WinGetTitle(hWndOwner)
	try vWinClass4 := WinGetClass(hWndChild), cWinT := WinGetTitle(hWndChild)
	ToolTip(
		"Parent: " vWinClass1 ' T: ' pWinT  '`n'
		"Root: " vWinClass2 ' T: ' rWinT  '`n'
		"Owner: " vWinClass3 ' T: ' oWinT  '`n'
		"Child: " vWinClass4 '[' ClassNN ']' ' T: ' cWinT  '`n'
		"ID: " ID '`n'
		"PID: " pid
	)
	A_Clipboard := rWinT
	return
	; Loop Parse, vCtlList, "`n"
	; {
	; 	ClassNN := A_LoopField
	; 	try hCtl := ControlGetHwnd(ClassNN, "ahk_id " hWnd)
	; 	; hWndParent := DllCall("user32\GetAncestor", "Ptr", hCtl, "UInt", 1, "Ptr") ;GA_PARENT := 1
	; 	; hWndRoot := DllCall("user32\GetAncestor", "Ptr", hCtl, "UInt", 2, "Ptr") ;GA_ROOT := 2
	; 	; hWndOwner := DllCall("user32\GetWindow", "Ptr", hCtl, "UInt", 4, "Ptr") ;GW_OWNER = 4
	; 	; hWndChild := DllCall("RealChildWindowFromPoint", "Ptr", hCtl, "UInt", 4, "Ptr") ;GW_OWNER = 4
	; 	; ;CursorHwnd := DllCall("WindowFromPoint", "int64", CursorX | (CursorY << 32), "Ptr")
	; 	; vWinClass1 := WinGetClass("ahk_id " hWndParent)
	; 	; vWinClass2 := WinGetClass("ahk_id " hWndRoot)
	; 	; vWinClass3 := WinGetClass("ahk_id " hWndOwner)
	; 	; vWinClass4 := WinGetClass("ahk_id " hWndChild)
	; 	try hWndParent := DllCall("user32\GetAncestor", "Ptr", hCtl, "UInt", 1, "Ptr") ;GA_PARENT := 1
	; 	try hWndRoot := DllCall("user32\GetAncestor", "Ptr", hCtl, "UInt", 2, "Ptr") ;GA_ROOT := 2
	; 	try hWndOwner := DllCall("user32\GetAncestor", "Ptr", hCtl, "UInt", 4, "Ptr") ;GW_OWNER = 4
	; 	try hWndChild := DllCall("RealChildWindowFromPoint", "Ptr", hCtl, "UInt", 4, "Ptr") ;GW_OWNER = 4
	; 	try chWnd := WinGetID(hWndChild)
	; 	try vWinClass1 := WinGetClass(hWndParent), pWinT := WinGetTitle(hWndParent)
	; 	try vWinClass2 := WinGetClass(hWndRoot), rWinT := WinGetTitle(hWndRoot)
	; 	try vWinClass3 := WinGetClass(hWndOwner), oWinT := WinGetTitle(hWndOwner)
	; 	; try vWinClass4 := WinGetClass(hWndChild), cWinT := WinGetTitle(hWndChild)
	; 	vOutput .= A_Index ":" ClassNN "|" vWinClass1 "|" vWinClass2 "|" vWinClass3 "`n" ;"|" vWinClass4 "`r`n"
	; }
	; ; A_Clipboard := vOutput 
	; ToolTip(vOutput)
	; ;MsgBox, % vOutput
	; return
}



#5::
{ ; V1toV2: Added bracket
	hWnd := WinGetID("A")
	;WinGet, vCtlList, ControlList, % "ahk_id " hWnd
	ovCtlList := WinGetControls("ahk_id " hWnd,,,)
	For v in ovCtlList
	{
	vCtlList .= A_index=1 ? v : "`r`n" v
	}
	vOutput := ""
	Loop Parse, vCtlList, "`n"
	{
		ClassNN := A_LoopField
		hCtl := ControlGetHwnd(ClassNN, "ahk_id " hWnd)
		try hWndParent := DllCall("user32\GetAncestor", "Ptr", hCtl, "UInt", 1, "Ptr") ;GA_PARENT := 1
		try hWndRoot := DllCall("user32\GetAncestor", "Ptr", hCtl, "UInt", 2, "Ptr") ;GA_ROOT := 2
		; hWndOwner := DllCall("user32\GetAncestor","Ptr", hCtl, "UInt",4, "Ptr") ;GA_ROOT := 2
		try hWndOwner := DllCall("user32\GetWindow", "Ptr", hCtl, "UInt", 4, "Ptr") ;GW_OWNER = 4
		try hWndChild := DllCall("RealChildWindowFromPoint", "Ptr", hCtl, "UInt", 4, "Ptr") ;GW_OWNER = 4
		try CursorHwnd := DllCall("WindowFromPoint", "int64", &CursorX:=0 | (&CursorY:=0 << 32), "Ptr")
		try vWinClass1 := WinGetClass("ahk_id " hWndParent)
		try vWinClass2 := WinGetClass("ahk_id " hWndRoot)
		try vWinClass3 := WinGetClass("ahk_id " hWndOwner)
		try vWinClass4 := WinGetClass("ahk_id " hWndChild)
		try vOutput .= "[" A_Index "]" " | ClassNN: " ClassNN " | hWndChild: " vWinClass4 " | hWndChild: " hWndChild " | hWndParent: " hWndParent " | hWndRoot: " hWndRoot " | hWndOwner: " hWndOwner " | CursorHwnd: " CursorHwnd "`n" ;"|" vWinClass1 "|" vWinClass2 "|" vWinClass3 "|" vWinClass4 "`r`n" ;"|" vWinClass4 "`r`n"
	}
	; A_Clipboard := vOutput 
	;ToolTip, % ClassNN,x+1,0
	ToolTip(vOutput)
	;MsgBox, % vOutput
	return


	/*
	WinGetPos, PosX, PosY, SizeW, SizeH, ahk_id %Gui1UniqueID%
	IniWrite, x%PosX% y%PosY% , %IniFile%, Settings, Gui1Pos
	IniWrite, %SizeW% , %IniFile%, Settings, Gui1W
	IniWrite, %SizeH% , %IniFile%, Settings, Gui1H
	IniWrite, %IntGuiStyle%, %IniFile%, Settings, IntGuiStyle
	IniWrite, %BolResizeTreeH%, %IniFile%, Settings, BolResizeTreeH
	IniWrite, %BolRollUpDown%,  %IniFile%, Settings, BolRollUpDown
	IniWrite, %BolAlwaysOnTop%, %IniFile%, Settings, BolAlwaysOnTop
	IniWrite, %StrFontName%,    %IniFile%, Settings, StrFontName
	IniWrite, %IntFontSize%,    %IniFile%, Settings, IntFontSize
	FileAppend, `n`n, %IniFile%
	return
	*/
} ; V1toV2: Added Bracket before hotkey or Hotstring

:*:WM_NULL::0x0000
:*:WM_CREATE::0x0001
:*:WM_DESTROY::0x0002
:*:WM_MOVE::0x0003
:*:WM_SIZE::0x0005
:*:WM_ACTIVATE::0x0006
:*:WM_SETFOCUS::0x0007
:*:WM_KILLFOCUS::0x0008
:*:WM_ENABLE::0x000A
:*:WM_SETREDRAW::0x000B
:*:WM_SETTEXT::0x000C
:*:WM_GETTEXT::0x000D
:*:WM_GETTEXTLENGTH::0x000E
:*:WM_PAINT::0x000F
:*:WM_CLOSE::0x0010
:*:WM_QUERYENDSESSION::0x0011
:*:WM_QUIT::0x0012
:*:WM_QUERYOPEN::0x0013
:*:WM_ERASEBKGND::0x0014
:*:WM_SYSCOLORCHANGE::0x0015
:*:WM_ENDSESSION::0x0016
:*:WM_SYSTEMERROR::0x0017
:*:WM_SHOWWINDOW::0x0018
:*:WM_CTLCOLOR::0x0019
:*:WM_WININICHANGE::0x001A
:*:WM_SETTINGCHANGE::0x001A
:*:WM_DEVMODECHANGE::0x001B
:*:WM_ACTIVATEAPP::0x001C
:*:WM_FONTCHANGE::0x001D
:*:WM_TIMECHANGE::0x001E
:*:WM_CANCELMODE::0x001F
:*:WM_SETCURSOR::0x0020
:*:WM_MOUSEACTIVATE::0x0021
:*:WM_CHILDACTIVATE::0x0022
:*:WM_QUEUESYNC::0x0023
:*:WM_GETMINMAXINFO::0x0024
:*:WM_PAINTICON::0x0026
:*:WM_ICONERASEBKGND::0x0027
:*:WM_NEXTDLGCTL::0x0028
:*:WM_SPOOLERSTATUS::0x002A
:*:WM_DRAWITEM::0x002B
:*:WM_MEASUREITEM::0x002C
:*:WM_DELETEITEM::0x002D
:*:WM_VKEYTOITEM::0x002E
:*:WM_CHARTOITEM::0x002F

:*:WM_SETFONT::0x0030
:*:WM_GETFONT::0x0031
:*:WM_SETHOTKEY::0x0032
:*:WM_GETHOTKEY::0x0033
:*:WM_QUERYDRAGICON::0x0037
:*:WM_COMPAREITEM::0x0039
:*:WM_COMPACTING::0x0041
:*:WM_WINDOWPOSCHANGING::0x0046
:*:WM_WINDOWPOSCHANGED::0x0047
:*:WM_POWER::0x0048
:*:WM_COPYDATA::0x004A
:*:WM_CANCELJOURNAL::0x004B
:*:WM_NOTIFY::0x004E
:*:WM_INPUTLANGCHANGEREQUEST::0x0050
:*:WM_INPUTLANGCHANGE::0x0051
:*:WM_TCARD::0x0052
:*:WM_HELP::0x0053
:*:WM_USERCHANGED::0x0054
:*:WM_NOTIFYFORMAT::0x0055
:*:WM_CONTEXTMENU::0x007B
:*:WM_STYLECHANGING::0x007C
:*:WM_STYLECHANGED::0x007D
:*:WM_DISPLAYCHANGE::0x007E
:*:WM_GETICON::0x007F
:*:WM_SETICON::0x0080

:*:WM_NCCREATE::0x0081
:*:WM_NCDESTROY::0x0082
:*:WM_NCCALCSIZE::0x0083
:*:WM_NCHITTEST::0x0084
:*:WM_NCPAINT::0x0085
:*:WM_NCACTIVATE::0x0086
:*:WM_GETDLGCODE::0x0087
:*:WM_NCMOUSEMOVE::0x00A0
:*:WM_NCLBUTTONDOWN::0x00A1
:*:WM_NCLBUTTONUP::0x00A2
:*:WM_NCLBUTTONDBLCLK::0x00A3
:*:WM_NCRBUTTONDOWN::0x00A4
:*:WM_NCRBUTTONUP::0x00A5
:*:WM_NCRBUTTONDBLCLK::0x00A6
:*:WM_NCMBUTTONDOWN::0x00A7
:*:WM_NCMBUTTONUP::0x00A8
:*:WM_NCMBUTTONDBLCLK::0x00A9

:*:WM_KEYFIRST::0x0100
:*:WM_KEYDOWN::0x0100
:*:WM_KEYUP::0x0101
:*:WM_CHAR::0x0102
:*:WM_DEADCHAR::0x0103
:*:WM_SYSKEYDOWN::0x0104
:*:WM_SYSKEYUP::0x0105
:*:WM_SYSCHAR::0x0106
:*:WM_SYSDEADCHAR::0x0107
:*:WM_KEYLAST::0x0108

:*:WM_IME_STARTCOMPOSITION::0x010D
:*:WM_IME_ENDCOMPOSITION::0x010E
:*:WM_IME_COMPOSITION::0x010F
:*:WM_IME_KEYLAST::0x010F

:*:WM_INITDIALOG::0x0110
:*:WM_COMMAND::0x0111
:*:WM_SYSCOMMAND::0x0112
:*:WM_TIMER::0x0113
:*:WM_HSCROLL::0x0114
:*:WM_VSCROLL::0x0115
:*:WM_INITMENU::0x0116
:*:WM_INITMENUPOPUP::0x0117
:*:WM_MENUSELECT::0x011F
:*:WM_MENUCHAR::0x0120
:*:WM_ENTERIDLE::0x0121

:*:WM_CTLCOLORMSGBOX::0x0132
:*:WM_CTLCOLOREDIT::0x0133
:*:WM_CTLCOLORLISTBOX::0x0134
:*:WM_CTLCOLORBTN::0x0135
:*:WM_CTLCOLORDLG::0x0136
:*:WM_CTLCOLORSCROLLBAR::0x0137
:*:WM_CTLCOLORSTATIC::0x0138

:*:WM_MOUSEFIRST::0x0200
:*:WM_MOUSEMOVE::0x0200
:*:WM_LBUTTONDOWN::0x0201
:*:WM_LBUTTONUP::0x0202
:*:WM_LBUTTONDBLCLK::0x0203
:*:WM_RBUTTONDOWN::0x0204
:*:WM_RBUTTONUP::0x0205
:*:WM_RBUTTONDBLCLK::0x0206
:*:WM_MBUTTONDOWN::0x0207
:*:WM_MBUTTONUP::0x0208
:*:WM_MBUTTONDBLCLK::0x0209
:*:WM_MOUSEWHEEL::0x020A
:*:WM_MOUSEHWHEEL::0x020E

:*:WM_PARENTNOTIFY::0x0210
:*:WM_ENTERMENULOOP::0x0211
:*:WM_EXITMENULOOP::0x0212
:*:WM_NEXTMENU::0x0213
:*:WM_SIZING::0x0214
:*:WM_CAPTURECHANGED::0x0215
:*:WM_MOVING::0x0216
:*:WM_POWERBROADCAST::0x0218
:*:WM_DEVICECHANGE::0x0219

:*:WM_MDICREATE::0x0220
:*:WM_MDIDESTROY::0x0221
:*:WM_MDIACTIVATE::0x0222
:*:WM_MDIRESTORE::0x0223
:*:WM_MDINEXT::0x0224
:*:WM_MDIMAXIMIZE::0x0225
:*:WM_MDITILE::0x0226
:*:WM_MDICASCADE::0x0227
:*:WM_MDIICONARRANGE::0x0228
:*:WM_MDIGETACTIVE::0x0229
:*:WM_MDISETMENU::0x0230
:*:WM_ENTERSIZEMOVE::0x0231
:*:WM_EXITSIZEMOVE::0x0232
:*:WM_DROPFILES::0x0233
:*:WM_MDIREFRESHMENU::0x0234

:*:WM_IME_SETCONTEXT::0x0281
:*:WM_IME_NOTIFY::0x0282
:*:WM_IME_CONTROL::0x0283
:*:WM_IME_COMPOSITIONFULL::0x0284
:*:WM_IME_SELECT::0x0285
:*:WM_IME_CHAR::0x0286
:*:WM_IME_KEYDOWN::0x0290
:*:WM_IME_KEYUP::0x0291

:*:WM_MOUSEHOVER::0x02A1
:*:WM_NCMOUSELEAVE::0x02A2
:*:WM_MOUSELEAVE::0x02A3

:*:WM_CUT::0x0300
:*:WM_COPY::0x0301
:*:WM_PASTE::0x0302
:*:WM_CLEAR::0x0303
:*:WM_UNDO::0x0304

:*:WM_RENDERFORMAT::0x0305
:*:WM_RENDERALLFORMATS::0x0306
:*:WM_DESTROYCLIPBOARD::0x0307
:*:WM_DRAWCLIPBOARD::0x0308
:*:WM_PAINTCLIPBOARD::0x0309
:*:WM_VSCROLLCLIPBOARD::0x030A
:*:WM_SIZECLIPBOARD::0x030B
:*:WM_ASKCBFORMATNAME::0x030C
:*:WM_CHANGECBCHAIN::0x030D
:*:WM_HSCROLLCLIPBOARD::0x030E
:*:WM_QUERYNEWPALETTE::0x030F
:*:WM_PALETTEISCHANGING::0x0310
:*:WM_PALETTECHANGED::0x0311

:*:WM_HOTKEY::0x0312
:*:WM_PRINT::0x0317
:*:WM_PRINTCLIENT::0x0318

:*:WM_HANDHELDFIRST::0x0358
:*:WM_HANDHELDLAST::0x035F
:*:WM_PENWINFIRST::0x0380
:*:WM_PENWINLAST::0x038F
:*:WM_COALESCE_FIRST::0x0390
:*:WM_COALESCE_LAST::0x039F
:*:WM_DDE_FIRST::0x03E0
:*:WM_DDE_INITIATE::0x03E0
:*:WM_DDE_TERMINATE::0x03E1
:*:WM_DDE_ADVISE::0x03E2
:*:WM_DDE_UNADVISE::0x03E3
:*:WM_DDE_ACK::0x03E4
:*:WM_DDE_DATA::0x03E5
:*:WM_DDE_REQUEST::0x03E6
:*:WM_DDE_POKE::0x03E7
:*:WM_DDE_EXECUTE::0x03E8
:*:WM_DDE_LAST::0x03E8

:*:WM_USER::0x0400
:*:WM_APP::0x8000
:*:VK_LBUTTON::0x01
;============================== End Script ==============================
