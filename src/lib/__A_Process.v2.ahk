#Requires AutoHotkey v2+
#Include <Directives\__AE.v2>
#Include <Includes\Includes_Extensions>
#Include <Directives\__HznToolbar>
Persistent(1)
CoordMode("ToolTip", "Screen")
ProcessSetPriority('High')
; --------------------------------------------------------------------------------

; --------------------------------------------------------------------------------
; ICON := '.\ICON\DllCall.ico'
; ICON := 'HICON:' Create_DllCall_ico()
; TraySetIcon('HICON:' Create_DllCall_ico()) ; this changes the icon into a little dllcall thing.
; --------------------------------------------------------------------------------
#HotIf WinA := WinActive('ahk_exe hznhorizon.exe')
nHzn := 'ahk_exe hznHorizon.exe'
hHzn := WinWaitActive(nHzn)
pID := WinGetPID(hHzn)
threadId := DllCall("GetWindowThreadProcessId", "Int", hHzn, "UInt*", &pID)

; hook := SetWinEventHook(HandleWinEvent, hHzn, 32768, 32769)
hook := WinEventHook(32768, 32769, HandleWinEvent,'C Fast',pID,threadId,2)
; hook := SetWinEventHook(HandleWinEvent, 'SSMenu',32768, 32807)
class WinEventHook {
	__New(eventMin, eventMax, hookProc, options := '', idProcess := 0, idThread := 0, dwFlags := 0) {
		this.pCallback := CallbackCreate(hookProc, options, 7)
		this.hHook := DllCall('SetWinEventHook', 'UInt', eventMin, 'UInt', eventMax, 'Ptr', 0, 'Ptr', this.pCallback
			, 'UInt', idProcess, 'UInt', idThread, 'UInt', dwFlags, 'Ptr')
	}
	__Delete() {
		DllCall('UnhookWinEvent', 'Ptr', this.hHook)
		CallbackFree(this.pCallback)
	}
}
SetWinEventHook(callbackFunc, winTitle := 0, eventMin := 0x8000, eventMax := 0x8001, flags := 0x0002) {
	AE.BISL(1)
	AE.DH(1)
	EVENT_OBJECT_ACCELERATORCHANGE 	:= 0x8012, 	EVENT_OBJECT_STATECHANGE := 32778, 
	EVENT_OBJECT_CLOAKED 			:= 0x8017, 	EVENT_OBJECT_CONTENTSCROLLED := 0x8015, 
	EVENT_OBJECT_CONTENTSCROLLED 	:= 0x8015, 	EVENT_OBJECT_DEFACTIONCHANGE := 0x8011, 
	EVENT_OBJECT_DESCRIPTIONCHANGE 	:= 0x800D, 	EVENT_OBJECT_CREATE := 32768, 
	EVENT_OBJECT_DESTROY 			:= 32769, 	EVENT_OBJECT_DRAGSTART := 0x8021, 
	EVENT_OBJECT_DRAGCANCEL 		:= 0x8022, 	EVENT_OBJECT_DRAGCOMPLETE := 32803 ; 0x8023, 
	EVENT_OBJECT_DRAGENTER 			:= 0x8024, 	EVENT_OBJECT_DRAGLEAVE := 0x8025, 
	EVENT_OBJECT_DRAGDROPPED 		:= 0x8026, 	EVENT_OBJECT_END := 32769, 
	EVENT_OBJECT_FOCUS 				:= 0x8005, 	EVENT_OBJECT_HELPCHANGE := 0x8010, 
	EVENT_OBJECT_HIDE 				:= 0x8003, 	EVENT_OBJECT_HOSTEDOBJECTSINVALIDATED := 0x8020, 
	EVENT_OBJECT_IME_HIDE 			:= 0x8028, 	EVENT_OBJECT_IME_SHOW := 0x8027, 
	EVENT_OBJECT_IME_CHANGE 		:= 0x8029, 	EVENT_OBJECT_INVOKED := 0x8013, 
	EVENT_OBJECT_LIVEREGIONCHANGED 	:= 0x8019, 	EVENT_OBJECT_LOCATIONCHANGE := 0x800B, 		
	EVENT_OBJECT_NAMECHANGE 		:= 0x800C, 	EVENT_OBJECT_PARENTCHANGE := 0x800F, 
	EVENT_OBJECT_REORDER 			:= 0x8004, 	EVENT_OBJECT_SELECTION := 0x8006, 
	EVENT_OBJECT_SELECTIONADD 		:= 0x8007, 	EVENT_OBJECT_SELECTIONREMOVE := 0x8008, 	
	EVENT_OBJECT_SELECTIONWITHIN 	:= 0x8009, 	EVENT_OBJECT_SHOW := 0x8002, 
	EVENT_OBJECT_TEXTEDIT_CONVERSIONTARGETCHANGED 	:= 0x8030, 
	EVENT_OBJECT_TEXTSELECTIONCHANGED 				:= 0x8014, 
	EVENT_OBJECT_UNCLOAKED 			:= 0x8018, 
	EVENT_OBJECT_VALUECHANGE 		:= 0x800E, 	EVENT_SYSTEM_ALERT := 0x0002, 
	EVENT_SYSTEM_ARRANGMENTPREVIEW 	:= 0x8016, 	EVENT_SYSTEM_CAPTUREEND := 0x0009, 
	EVENT_SYSTEM_CAPTURESTART 		:= 0x0008, 	EVENT_SYSTEM_CONTEXTHELPEND := 0x000D, 
	EVENT_SYSTEM_CONTEXTHELPSTART 	:= 0x000C, 	EVENT_SYSTEM_DESKTOPSWITCH := 0x0020, 
	EVENT_SYSTEM_DIALOGEND 			:= 0x0011, 	EVENT_SYSTEM_DIALOGSTART := 0x0010, 
	EVENT_SYSTEM_DRAGDROPEND 		:= 0x000F, 	EVENT_SYSTEM_DRAGDROPSTART := 0x000E, 
	EVENT_SYSTEM_END 				:= 0x00FF, 	EVENT_SYSTEM_FOREGROUND := 0x0003, 
	EVENT_SYSTEM_MENUSTART 			:= 0x0004, 	EVENT_SYSTEM_MENUEND := 0x0005, 
	EVENT_SYSTEM_MENUPOPUPSTART 	:= 0x0006, 	EVENT_SYSTEM_MENUPOPUPEND := 0x0007, 
	EVENT_SYSTEM_MINIMIZEEND 		:= 0x0017, 	EVENT_SYSTEM_MINIMIZESTART := 0x0016, 
	EVENT_SYSTEM_MOVESIZEEND 		:= 0x000B, 	EVENT_SYSTEM_MOVESIZESTART := 0x000A, 
	EVENT_SYSTEM_SCROLLINGEND 		:= 0x0013, 	EVENT_SYSTEM_SCROLLINGSTART := 0x0012, 
	EVENT_SYSTEM_SOUND 				:= 0x0001, 	EVENT_SYSTEM_SWITCHEND := 0x0015, 
	EVENT_SYSTEM_SWITCHSTART 		:= 0x0014
	local PID := 0, callbackFuncType
	hook := { winTitle: winTitle, flags: flags, eventMin: eventMin, eventMax: eventMax, threadId: 0 }
	callbackFuncType := Type(callbackFunc)
	if !(callbackFuncType = "Func" || callbackFuncType = "Closure")
		throw ValueError("The callbackFunc argument must be a function", -1)
	if winTitle != 0 {
		if !(hook.winTitle := WinExist(winTitle)){
			throw TargetError("Window not found", -1)
		}
		hook.threadId := DllCall("GetWindowThreadProcessId", "Int", hook.winTitle, "UInt*", &PID)
		thPID := PID
	}
	; Infos('threadPID: ' . thPID . '`n')
	hook.hHook := DllCall(  'SetWinEventHook',
							'uint', eventMin, 
							'uint', eventMax, 
							'ptr', 	0, 
							'ptr', 	hook.callback := CallbackCreate(callbackFunc, "C Fast", 7), 
							; "Ptr", 	hook.callback := CallbackCreate(callbackFunc,, 7), 
							'uint', hook.PID := PID,
							'uint', hook.threadId,
							'uint', flags
						)
	
	hook.DefineProp("__Delete", 
	{ call: (this) => (DllCall("UnhookWinEvent", "Ptr", this.hHook), CallbackFree(this.callback)) })

	AE.DH(1)
	AE.BISL(0)
	return hook
}

HandleWinEvent(hWinEventHook, event, ghWnd, idObject, idChild, idEventThread, dwmsEventTime) {
	AE.DH(1)
	AE.BISL(1)
	static EVENT_OBJECT_CREATE := 32768, EVENT_OBJECT_DESTROY := 32769, OBJID_WINDOW := 0, INDEXID_CONTAINER := 0,
	EVENT_OBJECT_ACCELERATORCHANGE 	:= 0x8012, 	EVENT_OBJECT_STATECHANGE := 32778, 
	EVENT_OBJECT_CLOAKED 			:= 0x8017, 	EVENT_OBJECT_CONTENTSCROLLED := 0x8015, 
	EVENT_OBJECT_CONTENTSCROLLED 	:= 0x8015, 	EVENT_OBJECT_DEFACTIONCHANGE := 0x8011, 
	EVENT_OBJECT_DESCRIPTIONCHANGE 	:= 0x800D, 	EVENT_OBJECT_CREATE := 32768, 
	EVENT_OBJECT_DESTROY 			:= 32769, 	EVENT_OBJECT_DRAGSTART := 0x8021, 
	EVENT_OBJECT_DRAGCANCEL 		:= 0x8022, 	EVENT_OBJECT_DRAGCOMPLETE := 32803 ;_DRAGCOMPLETE := 0x8023, 
	EVENT_OBJECT_DRAGENTER 			:= 0x8024, 	EVENT_OBJECT_DRAGLEAVE := 0x8025, 
	EVENT_OBJECT_DRAGDROPPED 		:= 0x8026, 	EVENT_OBJECT_END := 32769, 
	EVENT_OBJECT_FOCUS 				:= 0x8005, 	EVENT_OBJECT_HELPCHANGE := 0x8010, 
	EVENT_OBJECT_HIDE 				:= 0x8003, 	EVENT_OBJECT_HOSTEDOBJECTSINVALIDATED := 0x8020, 
	EVENT_OBJECT_IME_HIDE 			:= 0x8028, 	EVENT_OBJECT_IME_SHOW := 0x8027, 
	EVENT_OBJECT_IME_CHANGE 		:= 0x8029, 	EVENT_OBJECT_INVOKED := 0x8013, 
	EVENT_OBJECT_LIVEREGIONCHANGED 	:= 0x8019, 	EVENT_OBJECT_LOCATIONCHANGE := 32779 ; _LOCATIONCHANGE := 0x800B, 		
	EVENT_OBJECT_NAMECHANGE 		:= 32780, EVENT_OBJECT_PARENTCHANGE := 0x800F, ; _NAMECHANGE := 0x800C
	EVENT_OBJECT_REORDER 			:= 0x8004, 	EVENT_OBJECT_SELECTION := 0x8006, 
	EVENT_OBJECT_SELECTIONADD 		:= 0x8007, 	EVENT_OBJECT_SELECTIONREMOVE := 0x8008, 	
	EVENT_OBJECT_SELECTIONWITHIN 	:= 0x8009, 	EVENT_OBJECT_SHOW := 0x8002, 
	EVENT_OBJECT_TEXTEDIT_CONVERSIONTARGETCHANGED 	:= 0x8030, 
	EVENT_OBJECT_TEXTSELECTIONCHANGED 				:= 0x8014, 
	EVENT_OBJECT_UNCLOAKED 			:= 0x8018, 
	EVENT_OBJECT_VALUECHANGE 		:= 0x800E, 	EVENT_SYSTEM_ALERT := 0x0002, 
	EVENT_SYSTEM_ARRANGMENTPREVIEW 	:= 0x8016, 	EVENT_SYSTEM_CAPTUREEND := 0x0009, 
	EVENT_SYSTEM_CAPTURESTART 		:= 0x0008, 	EVENT_SYSTEM_CONTEXTHELPEND := 0x000D, 
	EVENT_SYSTEM_CONTEXTHELPSTART 	:= 0x000C, 	EVENT_SYSTEM_DESKTOPSWITCH := 0x0020, 
	EVENT_SYSTEM_DIALOGEND 			:= 0x0011, 	EVENT_SYSTEM_DIALOGSTART := 0x0010, 
	EVENT_SYSTEM_DRAGDROPEND 		:= 0x000F, 	EVENT_SYSTEM_DRAGDROPSTART := 0x000E, 
	EVENT_SYSTEM_END 				:= 0x00FF, 	EVENT_SYSTEM_FOREGROUND := 0x0003, 
	EVENT_SYSTEM_MENUSTART 			:= 0x0004, 	EVENT_SYSTEM_MENUEND := 0x0005, 
	EVENT_SYSTEM_MENUPOPUPSTART 	:= 0x0006, 	EVENT_SYSTEM_MENUPOPUPEND := 0x0007, 
	EVENT_SYSTEM_MINIMIZEEND 		:= 0x0017, 	EVENT_SYSTEM_MINIMIZESTART := 0x0016, 
	EVENT_SYSTEM_MOVESIZEEND 		:= 0x000B, 	EVENT_SYSTEM_MOVESIZESTART := 0x000A, 
	EVENT_SYSTEM_SCROLLINGEND 		:= 0x0013, 	EVENT_SYSTEM_SCROLLINGSTART := 0x0012, 
	EVENT_SYSTEM_SOUND 				:= 0x0001, 	EVENT_SYSTEM_SWITCHEND := 0x0015, 
	EVENT_SYSTEM_SWITCHSTART 		:= 0x0014
	;
	
	ClassNN := '', tbClassNN := '', hCtl := 0
	mClassNN := '', mhCtl := 0
	dClassNN := ''
	hznMap := Map(),hCtlArray := [], cList := []
	if (event == EVENT_OBJECT_CREATE) {
		try cList := WinGetControls('A')
		try for each, tbClassNN in cList {
			if (tbClassNN ~= '(\w+_toolbar\d)+') {
				hCtl := ControlGetHwnd(tbClassNN, 'A')
				hznMap.SafeSet(tbClassNN, hCtl)
			}
			for mClassNN, mhCtl in hznMap {
				if hCtlArray.Has(mClassNN) {
					break
				} else {
					AE.BISL(1)
					EnableButtons(mhCtl)
					hCtlArray.SafePush(mhCtl)
                    AE.BISL(0)
				}
			}
		}
	} else if (event == EVENT_OBJECT_DESTROY) {
		; --------------------------------------------------------------------------------
		; fix ...: figure out a way to clear stuff
		SetTimer(ifDestroyed,-10000)
		ifDestroyed(*){
			
			for each, value in hCtlArray {
				try {
					try dClassNN := ControlGetClassNN(value)
					if dClassNN := '' {
						hCtlArray.RemoveAt(A_Index)
					}
				}
			}
		}
	}
	; --------------------------------------------------------------------------------
	AE.DH(1)
	AE.BISL(0)
	return
}
; --------------------------------------------------------------------------------
EnableButtons(hTb := HznToolbar._hTb()) {
	AE.DH(1)
	AE.BISL(1)
	; --------------------------------------------------------------------------------
	Static  WM_COMMAND := 273, TB_GETBUTTON:= 1047, TB_BUTTONCOUNT:= 1048,
			TB_COMMANDTOINDEX := 1049, TB_GETITEMRECT := 1053,
			MEM_PHYSICAL := 4, MEM_RELEASE := 32768,
			TB_GETSTATE := 1042,TB_GETBUTTONSIZE := 1082, TB_ENABLEBUTTON := 0x0401,
			TB_SETSTATE := 0x0411, TBSTATE_ENABLED := 4, TBSTATE_DISABLED := 0, TBSTATE_HIDDEN := 8 
	; --------------------------------------------------------------------------------
	; @Step: count and load all the msvb_lib_toolbar buttons into memory
	; --------------------------------------------------------------------------------
	buttonCount := SendMessage(TB_BUTTONCOUNT, 0, 0,, hTb)
    ; buttonCount := SendMessage(TB_BUTTONCOUNT, 0, 0, hTb)
    ; buttonCount := SendMessage(TB_BUTTONCOUNT, 0, 0, hTb, hTb)
	; --------------------------------------------------------------------------------
	; @Step: Use the @params to enable the button
	; --------------------------------------------------------------------------------
	Loop buttonCount {
		idCommand := A_Index +99
		; If (idCommand <= 102) {
		; 	Msg := TB_SETSTATE, wParam := idCommand, lParam_HI := 4, lParam_LO := TBSTATE_ENABLED, control := hTb
		; 	SendMessage(Msg, wParam, lParam_HI|lParam_LO,control,hTb)
		; }
		; If (idCommand > 108) {
		; 	Msg := TB_SETSTATE, wParam := idCommand, lParam_HI := 4, lParam_LO := TBSTATE_ENABLED, control := hTb
		; 	SendMessage(Msg, wParam, lParam_HI|lParam_LO,control,hTb)
		; }
        Msg := TB_SETSTATE, wParam := idCommand, lParam_HI := 4, lParam_LO := TBSTATE_ENABLED, control := hTb
        SendMessage(Msg, wParam, lParam_HI|lParam_LO,control,hTb)
	}
	AE.DH(1)
	AE.BISL(0)
	return
}
#HotIf
; --------------------------------------------------------------------------------
ShellHook_A_Process(callback := A_Process_GetInfo) {
	; Global HSHELL_RUDEAPPACTIVATED := 32772
	hWnd := WinActive('A')
	DllCall("RegisterShellHookWindow", "UInt", A_ScriptHwnd)
	OnMessage(DllCall("RegisterWindowMessage", "Str", "SHELLHOOK"), callback)
	; OnMessage(DllCall("RegisterWindowMessage", "Str", "SHELLHOOK"), MyFunc)
}
A_Process_GetInfo(event, hwnd,*) {
	AE.DH(1)
	AE.BISL(1)
	; --------------------------------------------------------------------------------
	hook := SetWinEventHook(HandleWinEvent)
	; --------------------------------------------------------------------------------
	HSHELL_WINDOWCREATED := 1, HSHELL_WINDOWDESTROYED := 2, HSHELL_ACTIVATESHELLWINDOW := 3, HSHELL_WINDOWACTIVATED := 4, HSHELL_WINDOWACTIVATED := 32772, HSHELL_GETMINRECT := 5, HSHELL_REDRAW := 6, HSHELL_TASKMAN := 7, HSHELL_LANGUAGE := 8, HSHELL_SYSMENU := 9, HSHELL_ENDTASK := 10, HSHELL_ACCESSIBILITYSTATE := 11, HSHELL_APPCOMMAND := 12, HSHELL_WINDOWREPLACED := 13, HSHELL_WINDOWREPLACING := 14, HSHELL_HIGHBIT := 32768, HSHELL_RUDEAPPACTIVATED := 32772, HSHELL_FLASH := 32774

	nEvent := (event = 1) ? 'HSHELL_WINDOWCREATED' : (event = 2) ? 'HSHELL_WINDOWDESTROYED' : (event = 3) ? 'HSHELL_ACTIVATESHELLWINDOW' : (event = 4) ? 'HSHELL_WINDOWACTIVATED' : (event = 32772) ? 'HSHELL_RUDEAPPACTIVATED' : (event = 5) ? 'HSHELL_GETMINRECT' : (event = 6) ? 'HSHELL_REDRAW' : (event = 7) ? 'HSHELL_TASKMAN' : (event = 8) ? 'HSHELL_LANGUAGE' : (event = 9) ? 'HSHELL_SYSMENU' : (event = 10) ? 'HSHELL_ENDTASK' : (event = 11) ? 'HSHELL_ACCESSIBILITYSTATE' : (event = 12) ? 'HSHELL_APPCOMMAND' : (event = 13) ? 'HSHELL_WINDOWREPLACED' : (event = 14) ? 'HSHELL_WINDOWREPLACING' : (event = 32768) ? 'HSHELL_HIGHBIT' : (event = 32774) ? 'HSHELL_FLASH' : 'No Event'
	if ((event = 1) || (event = 3) || (event = 4) || (event = 32772)) {

		hznHwnd := 0
		matches := []
		match := ''
		hWnd := WinActive('A')
		DllCall("GetWindowThreadProcessId", "Int", hwnd, "Int*", &tpID := 0)
		name := WinGetProcessName(hwnd)
		A_Process := name
		HznToolTip()
	}
	; --------------------------------------------------------------------------------
	HznToolTip() {
		ToolTip('A_Process: ' . A_Process . ' '
			. tpID . ' (tPID) ' . hWnd . ' (hWnd)' . '`n'
			. 'Event: ' . nEvent . ' (' . event . ')' . '`n'
			, 0, 0
		)
	}
	; --------------------------------------------------------------------------------
	AE.DH(1)
	AE.BISL(0)
	return A_Process
}







/*
test_A_Process_GetInfo(event, hwnd,*) {
	; Shell Hook Events:
	HSHELL_WINDOWCREATED := 1, HSHELL_WINDOWDESTROYED := 2, HSHELL_ACTIVATESHELLWINDOW := 3, HSHELL_WINDOWACTIVATED := 4, HSHELL_WINDOWACTIVATED := 32772, HSHELL_GETMINRECT := 5, HSHELL_REDRAW := 6, HSHELL_TASKMAN := 7, HSHELL_LANGUAGE := 8, HSHELL_SYSMENU := 9, HSHELL_ENDTASK := 10, HSHELL_ACCESSIBILITYSTATE := 11, HSHELL_APPCOMMAND := 12, HSHELL_WINDOWREPLACED := 13, HSHELL_WINDOWREPLACING := 14, HSHELL_HIGHBIT := 32768, HSHELL_RUDEAPPACTIVATED := 32772, HSHELL_FLASH := 32774
	; 32768 = 0x8000 = HSHELL_HIGHBIT := 32768
	; 32772 = 0x8000 + 4 = 0x8004 = HSHELL_RUDEAPPACTIVATED := 32772 (HSHELL_HIGHBIT + HSHELL_WINDOWACTIVATED)
	; 32774 = 0x8000 + 6 = 0x8006 = HSHELL_FLASH := 32774 (HSHELL_HIGHBIT + HSHELL_REDRAW)
	; EVENT_OBJECT_CREATE := 32768 (0x8000)
	; --------------------------------------------------------------------------------
	EVENT_OBJECT_ACCELERATORCHANGE := 0x8012, 	EVENT_OBJECT_STATECHANGE := 32778, 
	EVENT_OBJECT_CLOAKED := 0x8017, 			EVENT_OBJECT_CONTENTSCROLLED := 0x8015, 
	EVENT_OBJECT_CONTENTSCROLLED := 0x8015, 	EVENT_OBJECT_DEFACTIONCHANGE := 0x8011, 
	EVENT_OBJECT_DESCRIPTIONCHANGE := 0x800D, 	EVENT_OBJECT_CREATE := 32768, 
	EVENT_OBJECT_DESTROY := 0x8001, 			EVENT_OBJECT_DRAGSTART := 0x8021, 
	EVENT_OBJECT_DRAGCANCEL := 0x8022, 			EVENT_OBJECT_DRAGCOMPLETE := 0x8023, 
	EVENT_OBJECT_DRAGENTER := 0x8024, 			EVENT_OBJECT_DRAGLEAVE := 0x8025, 
	EVENT_OBJECT_DRAGDROPPED := 0x8026, 		EVENT_OBJECT_END := 0x80FF, 
	EVENT_OBJECT_FOCUS := 0x8005, 				EVENT_OBJECT_HELPCHANGE := 0x8010, 
	EVENT_OBJECT_HIDE := 0x8003, 				EVENT_OBJECT_HOSTEDOBJECTSINVALIDATED := 0x8020, 
	EVENT_OBJECT_IME_HIDE := 0x8028, 			EVENT_OBJECT_IME_SHOW := 0x8027, 
	EVENT_OBJECT_IME_CHANGE := 0x8029, 			EVENT_OBJECT_INVOKED := 0x8013, 			EVENT_OBJECT_LIVEREGIONCHANGED := 0x8019, 	EVENT_OBJECT_LOCATIONCHANGE := 0x800B, 		
	EVENT_OBJECT_NAMECHANGE := 0x800C, 			EVENT_OBJECT_PARENTCHANGE := 0x800F, 
	EVENT_OBJECT_REORDER := 0x8004, 			EVENT_OBJECT_SELECTION := 0x8006, 
	EVENT_OBJECT_SELECTIONADD := 0x8007, 		EVENT_OBJECT_SELECTIONREMOVE := 0x8008, 	
	EVENT_OBJECT_SELECTIONWITHIN := 0x8009, 	EVENT_OBJECT_SHOW := 0x8002, 
	EVENT_OBJECT_TEXTEDIT_CONVERSIONTARGETCHANGED := 0x8030, 
	EVENT_OBJECT_TEXTSELECTIONCHANGED := 0x8014, 
	EVENT_OBJECT_UNCLOAKED := 0x8018, 
	EVENT_OBJECT_VALUECHANGE := 0x800E, 		EVENT_SYSTEM_ALERT := 0x0002, 
	EVENT_SYSTEM_ARRANGMENTPREVIEW := 0x8016, 	EVENT_SYSTEM_CAPTUREEND := 0x0009, 
	EVENT_SYSTEM_CAPTURESTART := 0x0008, 		EVENT_SYSTEM_CONTEXTHELPEND := 0x000D, 
	EVENT_SYSTEM_CONTEXTHELPSTART := 0x000C, 	EVENT_SYSTEM_DESKTOPSWITCH := 0x0020, 
	EVENT_SYSTEM_DIALOGEND := 0x0011, 			EVENT_SYSTEM_DIALOGSTART := 0x0010, 
	EVENT_SYSTEM_DRAGDROPEND := 0x000F, 		EVENT_SYSTEM_DRAGDROPSTART := 0x000E, 
	EVENT_SYSTEM_END := 0x00FF, 				EVENT_SYSTEM_FOREGROUND := 0x0003, 
	EVENT_SYSTEM_MENUSTART := 0x0004, 			EVENT_SYSTEM_MENUEND := 0x0005, 
	EVENT_SYSTEM_MENUPOPUPSTART := 0x0006, 		EVENT_SYSTEM_MENUPOPUPEND := 0x0007, 
	EVENT_SYSTEM_MINIMIZEEND := 0x0017, 		EVENT_SYSTEM_MINIMIZESTART := 0x0016, 
	EVENT_SYSTEM_MOVESIZEEND := 0x000B, 		EVENT_SYSTEM_MOVESIZESTART := 0x000A, 
	EVENT_SYSTEM_SCROLLINGEND := 0x0013, 		EVENT_SYSTEM_SCROLLINGSTART := 0x0012, 
	EVENT_SYSTEM_SOUND := 0x0001, 				EVENT_SYSTEM_SWITCHEND := 0x0015, 
	EVENT_SYSTEM_SWITCHSTART := 0x0014

	nEvent := (event = 1) ? 'HSHELL_WINDOWCREATED' : (event = 2) ? 'HSHELL_WINDOWDESTROYED' : (event = 3) ? 'HSHELL_ACTIVATESHELLWINDOW' : (event = 4) ? 'HSHELL_WINDOWACTIVATED' : (event = 32772) ? 'HSHELL_RUDEAPPACTIVATED' : (event = 5) ? 'HSHELL_GETMINRECT' : (event = 6) ? 'HSHELL_REDRAW' : (event = 7) ? 'HSHELL_TASKMAN' : (event = 8) ? 'HSHELL_LANGUAGE' : (event = 9) ? 'HSHELL_SYSMENU' : (event = 10) ? 'HSHELL_ENDTASK' : (event = 11) ? 'HSHELL_ACCESSIBILITYSTATE' : (event = 12) ? 'HSHELL_APPCOMMAND' : (event = 13) ? 'HSHELL_WINDOWREPLACED' : (event = 14) ? 'HSHELL_WINDOWREPLACING' : (event = 32768) ? 'HSHELL_HIGHBIT' : (event = 32774) ? 'HSHELL_FLASH' : 'No Event'
	; //0x800A = EVENT_OBJECT_STATECHANGE := 32778
	; (hookevent = 0x8012) ? 'EVENT_OBJECT_ACCELERATORCHANGE' : 'Fail'
	; = 'EVENT_OBJECT_CLOAKED'
	; if (event != HSHELL_RUDEAPPACTIVATED || !hwnd || !1){
	; 	return
	; }
	; if ((event = 1) || (event = 2) || (event = 3) || (event = 4) || (event = 32772)) {
	if ((event = 1) || (event = 3) || (event = 4) || (event = 32772)) {
	SendLevel((A_SendLevel + 1))
	BlockInput(1)
	pvTxt := A_DetectHiddenText, DetectHiddenText(1)
	pvWin := A_DetectHiddenWindows, DetectHiddenWindows(1)
	hznHwnd := 0
	matches := []
	match := ''
	hWnd := WinActive('A')
	
	; hznGUI := Gui('+LastFound') ;, A_Process)
	
	; hznGUI.Opt('LastFound')
	; Infos(hznGUI.Opt('LastFound'))
	; GuiControlObj := GuiCtrlFromHwnd(Hwnd)
	DllCall("GetWindowThreadProcessId", "Int", hwnd, "Int*", &tpID := 0)
	name := WinGetProcessName(hwnd)
	A_Process := name
	; if (A_Process ~= 'i).*hznHorizon.*'){
	; 	hznGui.OnEvent('32768'||'32778'||'0x8002',OtherToolTip)
	; }
	; hznGUI.Show()

	HznToolTip()
; ------------------------------------------

; hWinEventHook := DllCall("SetWinEventHook"
; 	, "UInt", eventMin ;  UINT eventMin
; 	, "UInt", eventMax ;  UINT eventMax
; 	, "Ptr", 0x0 ;  HMODULE hmodWinEventProc
; 	, "Ptr", CB_WinEventProc ;  WINEVENTPROC lpfnWinEventProc
; 	, "UInt", idProcess ;  DWORD idProcess
; 	, "UInt", 0x0 ;  DWORD idThread
; 	, "UInt", 0x0 | 0x2) ;  UINT dwflags, OutOfContext|SkipOwnProcess
	; ------------------------------------------
	HznToolTip() {
		ToolTip('A_Process: ' . A_Process . ' '
			. tpID . ' (tPID) ' . hWnd . ' (hWnd)' . '`n'
			. 'Event: '		. event . '`n'
			. 'nEvent: '		. nEvent . '`n'
			; . 'C_Focus_Hwnd:  '	. fCtl . '`n'
			; . 'C_Focus_Class:  '	. hCtl . '`n'
			; . 'List: '		. list . '`n'
			, 0, 0
		)
	}
	OtherToolTip() {
		ToolTip('A_Process: ' . A_Process . ' '
			; . 'C_Focus_Hwnd:  '	. fCtl . '`n'
			; . 'C_Focus_Class:  '	. hCtl . '`n'
			; . 'List: '		. list . '`n'
			, 0, 0
		)
	}
	; ------------------------------------------
		DetectHiddenText(pvTxt), DetectHiddenWindows(pvWin)
		BlockInput(0)
		SendLevel(0)
		return A_Process
	}
	}
*/


; ##################################################################################
; # This #Include file was generated by Image2Include.ahk, you must not change it! #
; ##################################################################################
Create_DllCall_ico(NewHandle := False) {
	Static hBitmap := 0
	If (NewHandle){
		hBitmap := 0
	}
	If (hBitmap){
		Return hBitmap
	}
	B64 := "AAABAAEAYGAAAAEAIAColAAAFgAAACgAAABgAAAAwAAAAAEAIAAAAAAAAJAAABMLAAATCwAAAAAAAAAAAABPgTsAT4E7AE+BOwBPgTsAT4E7AE+BOwBPgTsAT4E7AE+BOwBPgTsAT4E7IU+BO4ZPgTtyT4E7cE+BO3BPgTtwT4E7cE+BO3BPgTtwT4E7cE+BO3BPgTtwT4E7cE+BO3BPgTtwT4E7cE+BO3BPgTtwT4E7cE+BO3BPgTtwT4E7cE+BO3BPgTtwT4E7cE+BO3BPgTtwT4E7cE+BO3BPgTtwT4E7cE+BO3BPgTtwT4E7cE+BO3BPgTtwT4E7cE+BO3BPgTtwT4E7cE+BO3BPgTtwT4E7cE+BO3BPgTtwT4E7cE+BO3BPgTtwT4E7cE+BO3BPgTtwT4E7cE+BO3BPgTtwT4E7cE+BO3BPgTtwT4E7cE+BO3BPgTtwT4E7cE+BO3BPgTtwT4E7cE+BO3BPgTtwT4E7cE+BO3BPgTtwT4E7cE+BO3BPgTtwT4E7cE+BO3BPgTtwT4E7cE+BO3BPgTtwT4E7cE+BO3BPgTtwT4E7cE+BO3BPgTt1ToE6ekuDOCxPgTsAT4E7AE+BOwBPgTsAT4E7AE+BOwBPgTsAT4E7AE+BOwBPgTsAT4E7Pk+BO+RPgTvMT4E7yk+BO8pPgTvKT4E7yk+BO8pPgTvKT4E7yk+BO8pPgTvKT4E7yk+BO8pPgTvKT4E7yk+BO8pPgTvKT4E7yk+BO8pPgTvKT4E7yk+BO8pPgTvKT4E7yk+BO8pPgTvKT4E7yk+BO8pPgTvKT4E7yk+BO8pPgTvKT4E7yk+BO8pPgTvKT4E7yk+BO8pPgTvKT4E7yk+BO8pPgTvKT4E7yk+BO8pPgTvKT4E7yk+BO8pPgTvKT4E7yk+BO8pPgTvKT4E7yk+BO8pPgTvKT4E7yk+BO8pPgTvKT4E7yk+BO8pPgTvKT4E7yk+BO8pPgTvKT4E7yk+BO8pPgTvKT4E7yk+BO8pPgTvKT4E7yk+BO8pPgTvKT4E7yk+BO8pPgTvKT4E7yk+BO8pPgTvKT4E7yk+BO8pPgTvKT4E7yk+BO8pPgTvQToE61UuDOFJMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7VEyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOHFMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7UEyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGtMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBPP9Ogj3/ToI9/06CPf9Ogj3/ToI9/06CPf9Ogj3/ToI9/06CPf9Ogj3/ToI9/06CPf9Ogj3/ToI9/06CPf9Ogj3/ToI9/06CPf9Ogj3/ToI9/06CPf9Ogj3/ToI9/06CPf9Ogj3/ToI9/06CPf9Ogj3/ToI9/06CPf9Ogj3/ToI9/06CPf9Ogj3/TYE8/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/02BPP9Ogj3/ToI9/06CPf9Ogj3/ToI9/06CPf9Ogj3/ToI9/06CPf9MgTz/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/ToI9/z13Kv8xbRj/MW4Y/zJuGf8ybhn/Mm4Z/zJuGf8ybhn/Mm4Z/zJuGf8ybhn/Mm4Z/zJuGf8ybhn/Mm4Z/zJuGf8ybhn/Mm4Z/zJuGf8ybhn/Mm4Z/zJuGf8ybhn/Mm4Z/zJuGf8ybhn/Mm4Z/zJuGf8ybhn/Mm4Z/zJuGf8ybhn/Mm4Z/zJuGf8wbRj/PHUn/06CPP9OgTz/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/ToM//zt2KP8vbRf/Mm4Z/zJuGf8ybhn/Mm4Z/zJuGf8ybhn/MW4Z/zFtGP8+dyr/ToI9/0yBPP9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9KgDn/SX82/32ibv+nwJ3/psCb/6S/mf+kv5n/pL+Z/6S/mf+kv5n/pL+Z/6S/mf+kv5n/pL+Z/6S/mf+kv5n/pL+Z/6S/mf+kv5n/pL+Z/6S/mf+kv5n/pL+Z/6S/mf+kv5n/pL+Z/6S/mf+kv5n/pL+Z/6S/mf+kv5n/pL+Z/6S/mf+kv5n/pL+Z/6W/mv+pwp//g6d2/0p/Of9Kfzj/TIE7/0yBO/9MgTv/TIE7/0yBO/9LgTr/RXsx/3uhbf+owp7/pL6Z/6K9l/+ivZf/or2X/6K9l/+ivZf/o76Y/6fAnP97oWv/SH81/0qAOP9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9Ifjf/Q3su/8rYw///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////2+XY/0qAOP9EfDL/TIE8/0yBO/9MgTv/TIE7/0yBO/9LgDn/OXEi/8/dy//////////////////////////////////////////////////M2sf/SH00/0d9NP9MgTz/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9Ifjf/Q3ov/8PUvf//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////09/Q/0yBOv9FfDL/TIE8/0yBO/9MgTv/TIE7/0yBO/9LgDn/OnIj/8rZxP/////////////////////////////////////////////////G1sD/SX41/0d9NP9MgTz/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9Ifjf/Q3ov/7/SuP//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////ztvM/0uAOf9FfDL/TIE8/0yBO/9MgTv/TIE7/0yBO/9LgDn/OnMi/8XVv//////////////////////////////////////////////////B1Lv/SH40/0h9NP9MgTz/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9Ifjf/Q3ov/8DSuf//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////z9zM/0uAOf9FfDL/TIE8/0yBO/9MgTv/TIE7/0yBO/9LgDn/O3Mj/8bWwP/////////////////////////////////////////////////C1Lz/SH40/0h9NP9MgTz/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9Ifjf/RHsw/8jXwv//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////1+LU/0yBOv9EfDH/TIE8/0yBO/9MgTv/TIE7/0yBO/9Ifjb/Q3kt/9Xh0f/////////////////////////////////////////////////K2cb/Sn82/0d9NP9MgTz/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9Jfzj/QXou/7bLrv//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////ydfD/0d/NP9FfTT/TIE8/0yBO/9MgTv/TIE7/0yBO/9Ifzf/QXkt/8fWwf////////////////////////////////////////////////+5zrL/RHwx/0d+Nf9MgTz/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/RHwz/2OQUv+atpD/lbOK/5OyiP+Tsoj/k7KI/5OyiP+Tsoj/k7KI/5OyiP+Tsoj/k7KI/5OyiP+Tsoj/k7KI/5OyiP+Tsoj/k7KI/5OyiP+Tsoj/k7KI/5OyiP+Tsoj/k7KI/5OyiP+Tsoj/k7KI/5OyiP+Tsoj/k7KI/5OyiP+Tsoj/k7KI/5Syif+ct5L/apVa/0V9Mf9LgDr/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/RH0z/26XXv+ZtY7/kK+F/4+vhf+Pr4X/j6+F/4+vhf+Pr4X/kbGG/5e0jf9kklX/RHwz/0uAOv9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TYI9/0R7Mv88dCb/OnQm/zp1Jv86dSb/OnUm/zp1Jv86dSb/OnUm/zp1Jv86dSb/OnUm/zp1Jv86dSb/OnUm/zp1Jv86dSb/OnUm/zp1Jv86dSb/OnUm/zp1Jv86dSb/OnUm/zp1Jv86dSb/OnUm/zp1Jv86dSb/OnUm/zp1Jv86dSb/OnUm/zp0Jv87dCX/Qnsw/02CPP9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TYI9/0N6MP87dSb/OnUn/zp1J/86dSf/OnUn/zp1J/86dSf/O3Um/zx0Jv9EfDL/TYI8/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0uBOv9LgDn/S4A6/0uAOv9LgDr/S4A6/0uAOv9LgDr/S4A6/0uAOv9LgDr/S4A6/0uAOv9LgDr/S4A6/0uAOv9LgDr/S4A6/0uAOv9LgDr/S4A6/0uAOv9LgDr/S4A6/0uAOv9LgDr/S4A6/0uAOv9LgDr/S4A6/0uAOv9LgDr/S4A6/0uAOv9LgDn/S4E6/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBOv9KgDn/S4A6/0uAOv9LgDr/S4A6/0uAOv9LgDr/S4A6/0uAOf9LgTr/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBPP9NgTz/TYE8/02BPP9NgTz/TYE8/02BPP9NgTz/TYE8/02BPP9NgTz/TYE8/02BPP9NgTz/TYE8/02BPP9NgTz/TYE8/02BPP9NgTz/TYE8/02BPP9NgTz/TYE8/02BPP9NgTz/TYE8/02BPP9NgTz/TYE8/02BPP9NgTz/TYE8/02BPP9NgTz/TYE8/02BPP9MgTz/TIE8/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4A4/0d8M/9GfDP/Rn0z/0Z9M/9GfTP/Rn0z/0Z9M/9GfTP/Rn0z/0Z9M/9GfTP/Rn0z/0Z9M/9GfTP/Rn0z/0Z9M/9GfTP/Rn0z/0Z9M/9GfTP/Rn0z/0Z9M/9GfTP/Rn0z/0Z9M/9GfTP/Rn0z/0Z9M/9GfTP/Rn0z/0Z9M/9GfTP/Rn0z/0Z9M/9GfTP/Rn0z/0Z9M/9GfDP/Rnwz/0l/N/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyB"
	B64 .= "OwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/02BPP9LgTv/RHsy/0l9Nf9GfDP/RXwy/0V8Mv9FfDL/RXwy/0V8Mv9FfDL/RXwy/0V8Mv9FfDL/RXwy/0V8Mv9FfDL/RXwy/0V8Mv9FfDL/RXwy/0V8Mv9FfDL/RXwy/0V8Mv9FfDL/RXwy/0V8Mv9FfDL/RXwy/0V8Mv9FfDL/RXwy/0V8Mv9FfDL/RXwy/0V8Mv9FfDL/RXwy/0V8Mv9GfDP/R300/0Z9NP9Ngjz/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlLgjoATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0uAOv9EezH/fqRy/8PUvv/A0br/vtC4/77QuP++0Lj/vtC4/77QuP++0Lj/vtC4/77QuP++0Lj/vtC4/77QuP++0Lj/vtC4/77QuP++0Lj/vtC4/77QuP++0Lj/vtC4/77QuP++0Lj/vtC4/77QuP++0Lj/vtC4/77QuP++0Lj/vtC4/77QuP++0Lj/vtC4/77QuP++0Lj/vtC4/77QuP/A0br/w9O9/4qrfv9CeS//SoA5/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlLgToASYM5AE2BPABMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0Z9Nf9IfTL/z9zI/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////9Dcy/82cSP/R342/0yBPP9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGlvbVIASYI5AEiDOABMgTsATIE7AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0d9Nv9IfTT/ydfC/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////8zax/84cyT/SH42/0yBPP9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGl/ZF0AcG1UAEqCOgBIgzgATYE8AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0d9Nv9HfDP/xtW//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////8jXw/84cyT/SH42/0yBPP9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGl4aFgAf2RfAHFsVQBIgzkASIM4AEyBOwBMgTsATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0d9Nv9HfDP/xtW//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////8jXw/84cyT/SH42/0yBPP9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGl4aFgAeGhaAH9kXwBwbVQASoI6AEiDOABNgTwATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0d9Nv9IfTP/ztvI/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////9Lezf83ciP/R342/0yBPP9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGl4aFgAeGhaAHhoWgB/ZF8AcWxVAEiDOQBIgzgATIE7AEyBOwBMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0h9Nv9GezL/v9G3/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////8HSu/85dCT/SH83/0yBPP9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGl4aFgAeGhaAHhoWgB4aFoAf2RfAHBtVABKgjoASIM4AE2BPABMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBOv9KgDr/WIlG/2yWWf9plVb/aZRW/2mUVv9plFb/aZRW/2mUVv9plFb/aZRW/2mUVv9plFb/aZRW/2mUVv9plFb/aZRW/2mUVv9plFb/aZRW/2mUVv9plFb/aZRW/2mUVv9plFb/aZRW/2mUVv9plFb/aZRW/2mUVv9plFb/aZRW/2mUVv9plFb/aZRW/2mUVv9plFb/aZRW/2mUVv9plVb/bJZa/1aHRf9KgDn/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGl4aFgAeGhaAHhoWgB4aFoAeGhaAH9kXwBxbFUASIM5AEiDOABMgTsATIE7TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9Ngjz/QHku/zZxH/83cSD/N3Ig/zdyIP83ciD/N3Ig/zdyIP83ciD/N3Ig/zdyIP83ciD/N3Ig/zdyIP83ciD/N3Ig/zdyIP83ciD/N3Ig/zdyIP83ciD/N3Ig/zdyIP83ciD/N3Ig/zdyIP83ciD/N3Ig/zdyIP83ciD/N3Ig/zdyIP83ciD/N3Ig/zdyIP83ciD/N3Ig/zdyIP83cSD/NnEf/0B5Lf9Ogj7/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGl4aFgAeGhaAHhoWgB4aFoAeGhaAHhoWgB/ZF8AcG1UAEqCOgBIgzgATYE8TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE8/02CPP9Ngjz/TYI8/02CPP9Ngjz/TYI8/02CPP9Ngjz/TYI8/02CPP9Ngjz/TYI8/02CPP9Ngjz/TYI8/02CPP9Ngjz/TYI8/02CPP9Ngjz/TYI8/02CPP9Ngjz/TYI8/02CPP9Ngjz/TYI8/02CPP9Ngjz/TYI8/02CPP9Ngjz/TYI8/02CPP9Ngjz/TYI8/02CPP9Ngjz/TYI8/02BPP9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGl4aFgAeGhaAHhoWgB4aFoAeGhaAHhoWgB4aFoAf2RfAHFsVQBIgzkASIM4TkyBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGl4aFgAeGhaAHhoWgB4aFoAeGhaAHhoWgB4aFoAeGhaAH9kXwBvbVQATYE8QkmEOv9Lgzv/S4M7/0uDO/9Lgzv/S4M7/0uDO/9Lgzv/S4M7/0uDO/9Lgzv/S4M7/0uDO/9Lgzv/S4M7/0uDO/9Lgzv/S4M7/0uDO/9Lgzv/S4M7/0uDO/9Lgzv/S4M7/0uDO/9Lgzv/S4M7/0uDO/9Lgzv/S4M7/0uDO/9Lgzv/S4M7/0uDO/9Lgzv/S4M7/0uDO/9Lgzv/S4M7/0uDO/9Lgzv/S4M7/0uDO/9Lgzv/S4M7/0uDO/9Lgzv/S4M7/0uDO/9Lgzv/S4M7/0uDO/9Lgzv/S4M7/0uDO/9Lgzv/S4M7/0uDO/9Lgzv/S4M7/0uDO/9Lgzv/S4M7/0uDO/9Lgzv/S4M7/0uDO/9Lgzv/S4M7/0uDO/9Lgzv/S4M7/0uDO/9Kgzv/TII7/0yBO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGl4aFgLeGhaIHhoWh54aFodeGhaHXhoWh14aFodeGhaHXhoWh2BY2AVam9QYkiBN/9Ofjv/Tn47/05+O/9Ofjv/Tn47/05+O/9Ofjv/Tn47/05+O/9Ofjv/Tn47/05+O/9Ofjv/Tn47/05+O/9Ofjv/Tn47/05+O/9Ofjv/Tn47/05+O/9Ofjv/Tn47/05+O/9Ofjv/Tn47/05+O/9Ofjv/Tn47/05+O/9Ofjv/Tn47/05+O/9Ofjv/Tn47/05+O/9Ofjv/Tn47/05+O/9Ofjv/Tn47/05+O/9Ofjv/Tn47/05+O/9Ofjv/Tn47/05+O/9Ofjv/Tn47/05+O/9Ofjv/Tn47/05+O/9Ofjv/Tn47/05+O/9Ofjv/Tn47/05+O/9Ofjv/Tn47/05+O/9Ofjv/Tn47/05+O/9Ofjv/Tn47/05+O/9Ofjv/Tn47/05+O/9Pfjv/TYA7/0yCO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGl4aFhTeGha1XhoWtB4aFrKeGhaynhoWsp4aFrKeGhaynhoWsp9Z16+cGlR2lduN/9abTv/Wm07/1ptO/9abTv/Wm07/1ptO/9abTv/Wm07/1ptO/9abTv/Wm07/1ptO/9abTv/Wm07/1ptO/9abTv/Wm07/1ptO/9abTv/Wm07/1ptO/9abTv/Wm07/1ptO/9abTv/Wm07/1ptO/9abTv/Wm07/1ptO/9abTv/Wm07/1ptO/9abTv/Wm07/1ptO/9abTv/Wm07/1ptO/9abTv/Wm07/1ptO/9abTv/Wm07/1ptO/9abTv/Wm07/1ptO/9abTv/Wm07/1ptO/9abTv/Wm07/1ptO/9abTv/Wm07/1ptO/9abTv/Wm07/1ptO/9abTv/Wm07/1ptO/9abTv/Wm07/1ptO/9abTv/Wm07/1ptO/9abTv/Wm07/1ptO/9dazv/UHs7/0qEO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGl4aFhyeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv97aV7/cGlQ/1xoN/9faDv/X2g7/19oO/9faDv/X2g7/19oO/9faDv/X2g7/19oO/9faDv/X2g7/19oO/9faDv/X2g7/19oO/9faDv/X2g7/19oO/9faDv/X2g7/19oO/9faDv/X2g7/19oO/9faDv/X2g7/19oO/9faDv/X2g7/19oO/9faDv/X2g7/19oO/9faDv/X2g7/19oO/9faDv/X2g7/19oO/9faDv/X2g7/19oO/9faDv/X2g7/19oO/9faDv/X2g7/19oO/9faDv/X2g7/19oO/9faDv/X2g7/19oO/9faDv/X2g7/19oO/9faDv/X2g7/19oO/9faDv/X2g7/19oO/9faDv/X2g7/19oO/9faDv/X2g7/19oO/9faDv/X2g7/19oO/9hZTv/Unk7/0qEO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGl4aFhreGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv97aV7/cGlQ/1tpN/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9gZjv/UXo7/0qEO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGl4aFhoeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv97aV7/cGlQ/1tpN/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9gZjv/UXo7/0qEO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOGl4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv98aV7/cGlQ/1ppNv9daTr/XWk6/11pOv9daTr/XWk6/11pOv9daTr/XWk6/11pOv9daTr/XWk6/11pOv9daTr/XWk6/11pOv9daTr/XWk6/11pOv9daTr/XWk6/11pOv9daTr/XWk6/11pOv9daTr/XWk6/11pOv9daTr/XWk6/11pOv9daTr/XWk6/11pOv9daTr/XWk6/11pOv9daTr/XWk6/11pOv9daTr/XWk6/11pOv9daTr/XWk6/11pOv9daTr/XWk6/11pOv9daTr/XWk6/11pOv9daTr/XWk6/11pOv9daTr/XWk6/11pOv9daTr/XWk6/11pOv9daTr/XWk6/11pOv9daTr/XWk6/11pOv9daTr/XWk6/11pOv9daTr/XWk6/11pOv9fZjr/UHo7/0qEO/9MgTv/TIE7/0yBO/9MgTv/TIE7/0yBO/9MgTv/S4E6/0qDOG94aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv98aV7/cGlQ/1xpN/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9eaTv/Xmk7/15pO/9gZjv/Uno7/0uEO/9NgTv/TYE7/02BO/9NgTv/TYE7/02BO/9NgTv/TIE6/0qDOG14aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv96aVz/dGlV/2lpR/9raUn/a2lJ/2tpSf9raUn/a2lJ/2tpSf9raUn/a2lJ/2tpSf9raUn/a2lJ/2tpSf9raUn/a2lJ/2tpSf9raUn/a2lJ/2tpSf9raUn/a2lJ/2tpSf9raUn/a2lJ/2tpSf9raUn/a2lJ/2tpSf9raUn/a2lJ/2tpSf9raUn/a2lJ/2tpSf9raUn/a2lJ/2tpSf9raUn/a2lJ/2tpSf9raUn/a2lJ/2tpSf9raUn/a2lJ/2tpSf9raUn/a2lJ/2tpSf9raUn/a2lJ/2tpSf9raUn/a2lJ/2tpSf9raUn/a2lJ/2tpSf9raUn/a2lJ/2tpSf9raUn/a2lJ/2tpSf9raUn/a2lJ/2tpSf9raUn/a2lJ/2tpSf9raUn/a2lJ/2tpSf9uZkv/VHs9r0qFOH9QgTuMT4E7jE+BO4xPgTuMT4E7jE+BO4xPgTuSToE6l0uDODd4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv99Z13/ZHRLTEeFNgBOgjoAT4E7AE+BOwBPgTsAT4E7AE+BOwBPgTsAToE6AEuDOAB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3lpW/95aVv/eWlb/3lpW/95aVv/eWlb/3lpW/95aVv/eWlb/3lpW/95aVv/eWlb/3lpW/95aVv/eWlb/3lpW/95aVv/eWlb/3lpW/95aVv/eWlb/3lpW/95aVv/eWlb/3lpW/95aVv/eWlb/3lpW/95aVv/eWlb/3lpW/95aVv/eWlb/3lpW/95aVv/eWlb/3lpW/95aVv/eWlb/3lpW/95aVv/eWlb/3lpW/95aVv/eWlb/3lpW/95aVv/eWlb/3lpW/95aVv/eWlb/3lpW/95aVv/eWlb/3lpW/95aVv/eWlb/3lpW/95aVv/eWlb/3lpW/95aVv/eWlb/3lpW/95aVv/eWlb/3lpW/95aVv/eWlb/3lpW/95aVv/eWlb/3lpW/95aVv/f2VfSmV0TABIhTYAToI6AE+BOwBPgTsAT4E7AE+BOwBPgTsAToE6AEuDOAB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eWhbTn9lXwBidUkASIU2AE6COgBPgTsAT4E7AE+BOwBPgTsAToE6AEuDOAB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eWpb/3prXP96a1z/emtc/3prXP96a1z/emtc/3prXP96a1z/emtc/3prXP96a1z/emtc/3prXP96a1z/emtc/3prXP96a1z/emtc/3prXP96a1z/emtc/3prXP96a1z/emtc/3prXP96a1z/emtc/3prXP96a1z/emtc/3prXP96a1z/emtc/3prXP96a1z/emtc/3prXP96a1z/emtc/3prXP96a1z/emtc/3prXP96a1z/emtc/3prXP96a1z/emtc/3prXP94alv/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnloWwB/ZV8AZXVMAEiFNgBOgjoAT4E7AE+BOwBPgTsAToE6AEuDOAB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv97bF3/b19O/2NRQP9kUkH/ZFJB/2RSQf9kUkH/ZFJB/2RSQf9kUkH/ZFJB/2RSQf9kUkH/ZFJB/2RSQf9kUkH/ZFJB/2RSQf9kUkH/ZFJB/2RSQf9kUkH/ZFJB/2RSQf9kUkH/ZFJB/2RSQf9kUkH/ZFJB/2RSQf9kUkH/ZFJB/2RSQf9kUkH/ZFJB/2RSQf9kUkH/ZFJB/2RSQf9kUkH/ZFJB/2RSQf9kUkH/ZFJB/2RSQf9kUkH/ZFJB/2RSQf9kUkH/ZFFA/2RSQf9wYVH/emtc/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB5aFsAf2VfAGJ1SQBIhTYAToI6AE+BOwBPgTsAToE6AEuDOAB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3lqWv9zY1T/iHpt/56Tif+ckYb/nJCG/5yQhv+ckIb/nJCG/5yQhv+ckIb/nJCG/5yQhv+ckIb/nJCG/5yQhv+ckIb/nJCG/5yQhv+ckIb/nJCG/5yQhv+ckIb/nJCG/5yQhv+ckIb/nJCG/5yQhv+ckIb/nJCG/5yQhv+ckIb/nJCG/5yQhv+ckIb/nJCG/5yQhv+ckIb/nJCG/5yQhv+ckIb/nJCG/5yQhv+ckIb/nJCG/5yQhv+ckIb/nJCG/5yQhv+ckIb/nZGG/5ySh/+Fd2n/dWVW/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeWhbAH9lXwBldUwASIU2AE6COgBPgTsAToE6AEuDOAB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3lqW/9jUkH/ubGq//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////+vpp3/allJ/3doWf94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHloWwB/ZV8AYnVJAEiFNgBOgjoAToE6AEuDOAB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3lqW/9kU0H/t7Co//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////+tpJv/alpJ/3doWf94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB5aFsAf2VfAGV1TABIhTYATYI5AEuDOAB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3lqW/9lVEL/s6uj//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////+pn5b/a1tK/3doWf94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeWhbAH9lXwBjdUkASIU1AEqENwB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3lqW/9lVEL/tKuj//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////+pn5b/a1tK/3doWf94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHloWwB/ZWAAZXRLAEOHMwB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3lqW/9iUUD/urOr////////////////////////////////////"
	B64 .= "//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////+wp5//allJ/3doWf94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB5aFsAfmZfAGJ2SQB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3lqW/9nV0X/rKOb/+/t6//p5+T/6OXj/+jl4//o5eP/6OXj/+jl4//o5eP/6OXj/+jl4//o5eP/6OXj/+jl4//o5eP/6OXj/+jl4//o5eP/6OXj/+jl4//o5eP/6OXj/+jl4//o5eP/6OXj/+jl4//o5eP/6OXj/+jl4//o5eP/6OXj/+jl4//o5eP/6OXj/+jl4//o5eP/6OXj/+jl4//o5eP/6OXj/+jl4//o5eP/6OXj/+jl4//o5eP/6OXj/+jl4//o5eP/6ufm/+ro5v+kmpD/bVxM/3doWf94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAH1mXgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv91Zlb/gnRn/5SIff+Pgnb/joJ2/46Cdv+Ognb/joJ2/46Cdv+Ognb/joJ2/46Cdv+Ognb/joJ2/46Cdv+Ognb/joJ2/46Cdv+Ognb/joJ2/46Cdv+Ognb/joJ2/46Cdv+Ognb/joJ2/46Cdv+Ognb/joJ2/46Cdv+Ognb/joJ2/46Cdv+Ognb/joJ2/46Cdv+Ognb/joJ2/46Cdv+Ognb/joJ2/46Cdv+Ognb/joJ2/46Cdv+Ognb/joJ2/46Cdv+Ognb/kIN4/5CEef9/cWP/dmdX/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv96a1z/dGRV/21dTf9uXk7/bl5O/25eTv9uXk7/bl5O/25eTv9uXk7/bl5O/25eTv9uXk7/bl5O/25eTv9uXk7/bl5O/25eTv9uXk7/bl5O/25eTv9uXk7/bl5O/25eTv9uXk7/bl5O/25eTv9uXk7/bl5O/25eTv9uXk7/bl5O/25eTv9uXk7/bl5O/25eTv9uXk7/bl5O/25eTv9uXk7/bl5O/25eTv9uXk7/bl5O/25eTv9uXk7/bl5O/25eTv9uXk7/bl5O/25eTv90ZVb/eWpb/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/d2hZ/3ZnWP93aFn/d2hZ/3doWf93aFn/d2hZ/3doWf93aFn/d2hZ/3doWf93aFn/d2hZ/3doWf93aFn/d2hZ/3doWf93aFn/d2hZ/3doWf93aFn/d2hZ/3doWf93aFn/d2hZ/3doWf93aFn/d2hZ/3doWf93aFn/d2hZ/3doWf93aFn/d2hZ/3doWf93aFn/d2hZ/3doWf93aFn/d2hZ/3doWf93aFn/d2hZ/3doWf93aFn/d2hZ/3doWf93aFn/d2hZ/3doWP94aFn/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3lqW/95alv/eWpb/3lqW/95alv/eWpb/3lqW/95alv/eWpb/3lqW/95alv/eWpb/3lqW/95alv/eWpb/3lqW/95alv/eWpb/3lqW/95alv/eWpb/3lqW/95alv/eWpb/3lqW/95alv/eWpb/3lqW/95alv/eWpb/3lqW/95alv/eWpb/3lqW/94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3lqW/95alv/eWpb/3lqW/95alv/eWpb/3lqW/95alv/eWpb/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv95alv/dmdY/3NkVf90ZVX/dGVV/3RlVf90ZVX/dGVV/3RlVf90ZVX/dGVV/3RlVf90ZVX/dGVV/3RlVf90ZVX/dGVV/3RlVf90ZVX/dGVV/3RlVf90ZVX/dGVV/3RlVf90ZVX/dGVV/3RlVf90ZVX/dGVV/3RlVf90ZVX/dGVV/3RlVf90ZVX/dGVV/3NkVP92Z1j/eWpb/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/dmdX/3RkVf90ZVX/dGVV/3RlVf90ZVX/dGVV/3RlVf90ZVX/c2RU/3dnWP94alv/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv95a1z/dGRV/25fT/9vYFD/b2BQ/29gUP9vYFD/b2BQ/29gUP9vYFD/b2BQ/29gUP9vYFD/b2BQ/29gUP9vYFD/b2BQ/29gUP9vYFD/b2BQ/29gUP9vYFD/b2BQ/29gUP9vYFD/b2BQ/29gUP9vYFD/b2BQ/29gUP9vYFD/b2BQ/29gUP9vYFD/b2BQ/25eT/91ZVb/emtc/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv95alv/c2NU/29fUP9vX0//b2BQ/29gUP9vYFD/b2BQ/29gUP9wYFD/bl9P/3RlVv95a1z/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv9xYlP/joF1/6+mnf+poZf/qaCW/6mglv+poJb/qaCW/6mglv+poJb/qaCW/6mglv+poJb/qaCW/6mglv+poJb/qaCW/6mglv+poJb/qaCW/6mglv+poJb/qaCW/6mglv+poJb/qaCW/6mglv+poJb/qaCW/6mglv+poJb/qaCW/6mglv+poJb/qaCW/7Kpof+OgnX/cGBQ/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3ZnV/91ZVb/lYh8/66lnP+poJf/qaCW/6mglv+poJb/qaCW/6mglv+qoZf/sKig/4p+cf9xYVH/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3doWf9mVEP/u7Os//////////////7+///+/v///v7///7+///+/v///v7///7+///+/v///v7///7+///+/v///v7///7+///+/v///v7///7+///+/v///v7///7+///+/v///v7///7+///+/v///v7///7+///+/v///v7///7+///+/v///v7///7+//////+2rqX/Y1E//3hpWv94aVr/eGla/3hpWv94aVr/eWpb/3JjU/9tXU3/zMXB//////////////7+///+/v///v7///7+///+/v///////////6+mnf9jUkD/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3doWf9lVEP/u7Os//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////+4sKf/YlA//3hpWv94aVr/eGla/3hpWv94aVr/eGpb/3NjVP9uXUz/zMbC/////////////////////////////////////////////////7Cnn/9iUT//eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3doWf9mVUT/t62n//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////+1raT/Y1FA/3hpWv94aVr/eGla/3hpWv94aVr/eGpb/3NjVP9uXU3/yMG8/////////////////////////////////////////////////62km/9kUkH/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3doWf9mVUT/tq2m//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////+1raT/Y1FA/3hpWv94aVr/eGla/3hpWv94aVr/eGpb/3NjVP9uXU3/yMC7/////////////////////////////////////////////////62km/9kUkH/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3doWf9kU0L/wLiy//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////+7tKv/YU8+/3hpWv94aVr/eGla/3hpWv94aVr/eWpb/3JiU/9tXEz/0szI/////////////////////////////////////////////////7Sso/9hUD7/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3doWf9oV0f/saig//Dv7f/v7ev/7uzr/+7s6//u7Ov/7uzr/+7s6//u7Ov/7uzr/+7s6//u7Ov/7uzr/+7s6//u7Ov/7uzr/+7s6//u7Ov/7uzr/+7s6//u7Ov/7uzr/+7s6//u7Ov/7uzr/+7s6//u7Ov/7uzr/+7s6//u7Ov/7uzr/+7s6//u7Ov/7uzr//Lw7/+vppz/ZVVD/3hpWv94aVr/eGla/3hpWv94aVr/eGpb/3NkVP9vX0//wLiy//Du7f/v7ev/7uzr/+7s6//u7Ov/7uzr/+7s6//u7Ov/8e/u/6iflf9mVEP/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVv/dmdY/3ZnWP92Zlf/dWZX/3VmV/91Zlf/dWZX/3VmV/91Zlf/dWZX/3VmV/91Zlf/dWZX/3VmV/91Zlf/dWZX/3VmV/91Zlf/dWZX/3VmV/91Zlf/dWZX/3VmV/91Zlf/dWZX/3VmV/91Zlf/dWZX/3VmV/91Zlf/dWZX/3VmV/91Zlf/dWZX/3doWf93Z1j/eWla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/dmZY/3ZnWP92Zlf/dWZX/3VmV/91Zlf/dWZX/3VmV/91Zlf/d2dZ/3dnWf94aVv/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv95alz/cmJT/2tZSf9rWkr/a1tK/2tbSv9rW0r/a1tK/2tbSv9rW0r/a1tK/2tbSv9rW0r/a1tK/2tbSv9rW0r/a1tK/2tbSv9rW0r/a1tK/2tbSv9rW0r/a1tK/2tbSv9rW0r/a1tK/2tbSv9rW0r/a1tK/2tbSv9rW0r/a1tK/2tbSv9rW0r/a1tK/2pZSf9yYlP/emtc/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpW/95alv/cGBQ/2taSf9rWkr/a1tK/2tbSv9rW0r/a1tK/2tbSv9rW0r/allJ/3NjVP95a1z/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eWpb/3lqW/95alv/eWpb/3lqW/95alv/eWpb/3lqW/95alv/eWpb/3lqW/95alv/eWpb/3lqW/95alv/eWpb/3lqW/95alv/eWpb/3lqW/95alv/eWpb/3lqW/95alv/eWpb/3lqW/95alv/eWpb/3lqW/95alv/eWpb/3lqW/95alv/eWpb/3lqW/95alv/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eWpb/3lqW/95alv/eWpb/3lqW/95alv/eWpb/3lqW/95alv/eWpb/3hqW/94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhpeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhoeGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaTnhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhveGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hp"
	B64 .= "Wv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaU3hpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFhueGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGla/3hpWv94aVr/eGlaUXhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aVoAeGlaAHhpWgB4aFg4eGhal3hoWpJ4aFqMeGhajHhoWox4aFqMeGhajHhoWox4aFqMeGhajHhoWox4aFqMeGhajHhoWox4aFqMeGhajHhoWox4aFqMeGhajHhoWox4aFqMeGhajHhoWox4aFqMeGhajHhoWox4aFqMeGhajHhoWox4aFqMeGhajHhoWox4aFqMeGhajHhoWox4aFqMeGhajHhoWox4aFqMeGhajHhoWox4aFqMeGhajHhoWox4aFqMeGhajHhoWox4aFqMeGhajHhoWox4aFqMeGhajHhoWox4aFqMeGhajHhoWox4aFqMeGhajHhoWox4aFqMeGhajHhoWox4aFqMeGhajHhoWox4aFqMeGhajHhoWox4aFqMeGhajHhoWox4aFqMeGhajHhoWox4aFqMeGhajHhoWox4aFqMeGhajHhoWox4aFqMeGhajHhoWo54aFqleGhaKnhoWgB4aFoAeGhaAHhoWgB4aFoAeGhaAHhoWgB4aFoAeGhaAHhoWgD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAD/wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8AAAAAAAAAAAAAA/8="
	If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", StrPtr(B64), "UInt", 0, "UInt", 0x01, "Ptr", 0, "UIntP", &DecLen := 0, "Ptr", 0, "Ptr", 0)
	   Return False
	Dec := Buffer(DecLen, 0)
	If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", StrPtr(B64), "UInt", 0, "UInt", 0x01, "Ptr", Dec, "UIntP", &DecLen, "Ptr", 0, "Ptr", 0)
	   Return False
	; Bitmap creation adopted from "How to convert Image data (JPEG/PNG/GIF) to hBITMAP?" by SKAN
	; -> http://www.autohotkey.com/board/topic/21213-how-to-convert-image-data-jpegpnggif-to-hbitmap/?p=139257
	hData := DllCall("Kernel32.dll\GlobalAlloc", "UInt", 2, "UPtr", DecLen, "UPtr")
	pData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hData, "UPtr")
	DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", pData, "Ptr", Dec, "UPtr", DecLen)
	DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hData)
	DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", True, "PtrP", pStream := ComValue(13, 0))
	hGdip := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll", "UPtr")
	SI := Buffer(8 + 2 * A_PtrSize, 0), NumPut("UInt", 1, SI, 0)
	DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", &pToken := 0, "Ptr", SI, "Ptr", 0)
	DllCall("Gdiplus.dll\GdipCreateBitmapFromStream",  "Ptr", pStream, "PtrP", &pBitmap := 0)
	DllCall("Gdiplus.dll\GdipCreateHICONFromBitmap", "Ptr", pBitmap, "PtrP", &hBitmap := 0)
	DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", pBitmap)
	DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", pToken)
	DllCall("Kernel32.dll\FreeLibrary", "Ptr", hGdip)
	Return hBitmap
	}
	

; #Requires AutoHotkey v2

; Map out all open windows so we can keep track of their names when they're closed.
; After the window close event the windows no longer have their titles, so we can't do it afterwards.

; Set up our hook. Putting it in a variable is necessary to keep the hook alive, since once it gets
; rewritten (for example with hook := "") the hook is automatically destroyed.
; hook := SetWinEventHook(HandleWinEvent)
; We have no hotkeys, so Persistent is required to keep the script going.
; Persistent()

/**
 * Our event handler which needs to accept 7 arguments. To ignore some of them use the * character,
 * for example HandleWinEvent(hWinEventHook, event, hwnd, idObject, idChild, *)
 * @param hWinEventHook Handle to an event hook function. This isn't useful for our purposes 
 * @param event Specifies the event that occurred. This value is one of the event constants (https://learn.microsoft.com/en-us/windows/win32/winauto/event-constants).
 * @param hwnd Handle to the window that generates the event, or NULL if no window is associated with the event.
 * @param idObject Identifies the object associated with the event.
 * @param idChild Identifies whether the event was triggered by an object or a child element of the object.
 * @param idEventThread Id of the thread that triggered this event.
 * @param dwmsEventTime Specifies the time, in milliseconds, that the event was generated.
 */


/**
 * Sets a new WinEventHook and returns on object describing the hook. 
 * When the object is released, the hook is also released.
 * @param callbackFunc The function that will be called, which needs to accept 7 arguments:
 *    hWinEventHook, event, hwnd, idObject, idChild, idEventThread, dwmsEventTime
 * @param winTitle Optional: WinTitle of a certain window to hook to. Default is system-wide hook.
 * @param eventMin Optional: Specifies the event constant for the lowest event value in the range of events that are handled by the hook function.
 *  Default is EVENT_OBJECT_CREATE = 0x8000
 *  See more about event constants: https://learn.microsoft.com/en-us/windows/win32/winauto/event-constants
 * @param eventMax Optional: Specifies the event constant for the highest event value in the range of events that are handled by the hook function.
 *  Default is EVENT_OBJECT_DESTROY = 0x8001
 * @param flags Flag values that specify the location of the hook function and of the events to be skipped.
 *  Default is WINEVENT_OUTOFCONTEXT = 0 and WINEVENT_SKIPOWNPROCESS = 2. 
 * @returns {Object} 
 */