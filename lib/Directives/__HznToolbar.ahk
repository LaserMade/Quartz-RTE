#Requires AutoHotkey v2+
#Include <Directives\__AE.v2>
; --------------------------------------------------------------------------------
/************************************************************************
* Function ..: __HznNew()
* @author ...: OvercastBTC
* @param hCtl ........: Gets the handle (hwnd) to the control in focus
* @param fCtl ........: Gets the ClassNN(hwnd) of the control in focus
* @param fCtlI .......: Gets the instance of the control in focus
* @param nCtl ........: Converts to ClassNN to the toolbar instance
* @param hTb .........: Gets the handle (hwnd) of the toolbar
* @param hTx .........: Gets the handle (hwnd) of the plain|rich text box
* @param pID .........: Gets the process ID using AHKv2 built-in fn()
* @param tpID .........: Gets the process ID using DllCall()
* @returns {integer|text}
* @issues
*      - the core issue is application iteself
*          - the age (early|pre-VB?) and not following modern standards
*          - parent/child relationships
*          - "pane" vs "toolbar" | "pane" vs "button" |etc
*      - not all are needed, or obtainable every time.
; ***********************************************************************/
#HotIf WinActive('ahk_exe hznHorizon.exe')
Class HznToolbar {
    static _fCtl(&fCtl?) 	=> fCtl := ControlGetFocus('A')
    static _cCtl() 			=> cCtl := ControlGetClassNN(this._fCtl())
    static _CtlI() 			=> CtlI :=  SubStr(this._cCtl(), -1, 1)
    static _tbCtl() 		=> tbCtl :=  "msvb_lib_toolbar" this._CtlI() ; ! => would love to regex this to anything containing 'bar' || toolbar || ?
    ; static _hTb(&hTb?) {
	; 	return hTb := ControlGethWnd(this._tbCtl(), "A")
	; }
    static _hTb(&hTb?) 		=> hTb := ControlGethWnd(this._tbCtl(), "A")
    static _hTx() 			=> this._fCtl()
    static _pID() 			=> pId := WinGetPID(this._hTb())
    static _tpID() 			=> tpID := DllCall("GetWindowThreadProcessId", "Ptr", this._hTb(), "UInt*", &targetProcessID:=0)
	; static hTb => (*) => this._hTb(&hTb)
}

; Class h extends HznToolbar {
Class hzn extends HznToolbar {
	static Tb 	=> this._hTb(&hTb?)
	static fCtl => fCtl := ControlGetFocus('A')
}

Class HzP {
	; ---------------------------------------------------------------------------
	static _hznCtrlEnter(){
		tWin := ClassNN := '', fCtl := index := 0
		; Infos(
		try ClassNN := ControlGetClassNN(fCtl := ControlGetFocus('A'))
		tWin := WinGetTitle(DllCall( "GetAncestor", 'uint', fCtl, 'uint',GA_ROOTOWNER := 2 ))
		; if (ClassNN ~= 'SSUltraGridWndClass') && ((cHwnd := ControlGetFocus('A'), WinTP2 := WinGetTitle(DllCall( "GetAncestor", 'uint', cHwnd, 'uint',GA_ROOTOWNER := 2 ))) ~= 'Validation Results'){
		;     ControlClick('OK')
		; } 
		; else {
		;     ControlClick('Ok')
		; }
		ControlClick('OK', tWin)
	}
	; ---------------------------------------------------------------------------
	static hcEnter() => this._hznCtrlEnter()
	; ---------------------------------------------------------------------------
	static hCancel(){
		try ControlClick('Cancel', 'A')
	}
	static hCx() => this.hCancel()
	; ---------------------------------------------------------------------------
	; static hznTb() => HznToolbar()
    ; hBtn(idCommand:=0, hTb := hznTb()){
	static button(idCommand:=0){
        AE.BISL(1)
        AE.SM(&sm)
		Suspend(0)
        Static  WM_COMMAND := 273, hTb := HznToolbar._hTb()
        ; ---------------------------------------------------------------------------
        ; function: !!! ===> Programatically "Click" the button!!! <=== !!!
        Msg := WM_COMMAND, wParam_hi := 0, wParam_lo := idCommand, lParam := control := hTb
        ; DllCall('SendMessage', 'UInt', hTb, 'UInt', Msg, 'UInt', wParam_hi | wParam_lo, 'UIntP', lParam)
        SendMessage(Msg, wParam_hi | wParam_lo, lParam, hTb)
        ; ---------------------------------------------------------------------------
        AE.BISL(0)
        AE.rSM(sm)
    }
	static b(id) => this.button(id)
	; static btn := {italics:this.b(101)}
	; static toolbar := {toolbar:HznToolbar._hTb()}
	; Class hbutton {

	; }
}
Class HznButton {

    static button(idCommand:=0){
        AE.BISL(1)
        AE.SM(&sm)
        Suspend(0)
        Static  WM_COMMAND := 273
        hTb := HznToolbar._hTb()
        ; ---------------------------------------------------------------------------
        ; function: !!! ===> Programatically "Click" the button!!! <=== !!!
        Msg := WM_COMMAND, wParam_hi := 0, wParam_lo := idCommand, lParam := control := hTb
        ; DllCall('SendMessage', 'UInt', hTb, 'UInt', Msg, 'UInt', wParam_hi | wParam_lo, 'UIntP', lParam)
        SendMessage(Msg, wParam_hi | wParam_lo, lParam, hTb)
        ; ---------------------------------------------------------------------------
        AE.BISL(0)
        AE.rSM(sm)
        return
    }
    static b(id) => this.button(id)
    static HznFindReplace(){
        AE.cBakClr(&cBak)
        AE.BISL(1)
        AE.SM(&sm)
        str := RegExReplace(A_ThisHotkey, '\[^~+!]', '')
        tCtl := t := ''
        FindWhatTextBox := 'ThunderRT6TextBox2'
        ReplaceWithTextBox := 'ThunderRT6TextBox1'
        ; ---------------------------------------------------------------------------
        HotIfWinActive('Find and Replace')
        Hotkey('F4', 	  (*) => ControlClick('ThunderRT6CommandButton4'), 'On' )
        Hotkey('^Enter',  (*) => ControlClick('ThunderRT6CommandButton4'), 'On' )
        Hotkey('Enter',   (*) => ControlClick('ThunderRT6CommandButton1'), 'On' )
        Hotkey('^!Enter', (*) => ControlClick('ThunderRT6CommandButton2'), 'On' )
        Hotkey('Escape',  (*) => ControlClick('ThunderRT6CommandButton3'), 'On' )
        Hotkey('^h',  (*) => AE.cSleep(0), 'On' )
        ; ---------------------------------------------------------------------------
        ; Send('^{sc2E}') ;? ^c copy the selected word
        Send(key.copy)
        AE.cSleep(100)
        t := A_Clipboard
        AE.cSleep(100)
        ; ---------------------------------------------------------------------------
        ; @i: Find Button, or Find & Replace Button
        ; ---------------------------------------------------------------------------
        HznButton.b(120)
        ; Send('^{sc21}') ;? Send Ctrl + f
        ; ---------------------------------------------------------------------------
        ; @i: Wait until the Window is Active
        ; ---------------------------------------------------------------------------
        WinWaitActive('Find and Replace',,5)
        ; Send('{sc38 down}{sc2A down}{sc20}')
        ; Send(key.altdown key.shiftdown key.d key.shiftUp key.altUp) ;? LAlt down, f, s, LAlt up
        AE.Timer()
        FindWhatClassNN := ControlGetClassNN(FindWhatTextBox)
        hFindWhatClassNN := ControlGetHwnd(FindWhatClassNN)
        ReplaceWithClassNN := ControlGetClassNN(ReplaceWithTextBox)
        ; ---------------------------------------------------------------------------
        sleep(100)
        switch {
            case (str ~= 'F5'):     Send(key.altdown key.shiftdown key.d key.shiftup key.altup)
            case (str ~= key.k.F5): Send(key.altdown key.shiftdown key.d key.shiftup key.altup)
            case (str ~= 'd'):      Send(key.altdown key.shiftdown key.d key.shiftup key.altup)
            case (str ~= key.k.d):  Send(key.altdown key.shiftdown key.d key.shiftup key.altup)
            case (str ~= 'h'):      Send(key.altdown key.shiftdown key.p key.shiftup key.altup)
            case (str ~= key.k.h):  Send(key.altdown key.shiftdown key.p key.shiftup key.altup)
            default:                Send(key.altdown key.shiftdown key.d key.shiftup key.altup)
        }
        sleep(100)
        ControlFocus(FindWhatClassNN)
        sleep(100)
        ControlSetText(t, hFindWhatClassNN)
        if t.length != 0 {
            tCtl := ControlGetText(FindWhatClassNN)
            if !tCtl {
                ; Send('^{sc2F}')
                ; ClipSend(t,,false)
                Send(key.ctrldown key.v key.ctrlup)
            }
        }
        switch {
            case (str ~= 'F5'):     FindNext()
            case (str ~= key.k.F5): FindNext()
            case (str ~= 'd'):      FindNext()
            case (str ~= key.k.d):  FindNext()
            case (str ~= 'h'):      FindWordFocus()
            case (str ~= key.k.h):  FindWordFocus()
            default:                FindNext()
        }
        FindWordFocus() {
            AE.cSleep(100)
            ControlFocus(ReplaceWithClassNN)
        }
        FindNext(){
            Suspend(1)
            Send(key.tab)
            AE.cSleep()
            Suspend(0)
        }
        AE.rSM(sm)
        AE.BISL(0)
        AE.cRestore(cBak)
        return
    }
	static Find() => this.HznFindReplace()
    static Focus(&fCtl?){
        fCtl := ControlGetFocus('A'), nCtl := '', hWnd := hWndMainWindow := 0
        try hWndMainWindow := WinGetTitle(DllCall( "GetAncestor", 'uint', fCtl, 'uint',GA_ROOTOWNER := 2 ))
        try WinActivate(hWndMainWindow)
        hWnd := WinActive('A')
        nCtl := ControlGetClassNN(fCtl)
        GetKeyState(key.k.ctrl, 'P') ? Send(key.ctrlup) : 0 ;? Ctrl
        KeyWait(key.k.ctrl, 'U') ;? Ctrl Up
        return fCtl
    }

    static ActiveWin(&hWndMainWindow?){
        try ControlFocus('TX')
        try ControlFocus('Text')
        try fCtl := ControlGetFocus('A')
        try hWndMainWindow := WinGetTitle(DllCall( "GetAncestor", 'uint', fCtl, 'uint',GA_ROOTOWNER := 2 ))
        ; try infos(hWndMainWindow)
        ; WinActivate(hWndMainWindow)
        ; hWnd := WinActive('A')
        ; nCtl := ControlGetClassNN(fCtl)
        ; GetKeyState(key.k.ctrl, 'P') ? Send(key.ctrlup) : 0 ;? Ctrl
        ; KeyWait(key.k.ctrl, 'U') ;? Ctrl Up
        return {WinT:hWndMainWindow}
    }

    static RiskFileSave(){
        {
            AE.SM(&sm)
            AE.DH(0)
            ; fCtl := ControlGetFocus('A')
            ; try hWndMainWindow := WinGetTitle(DllCall( "GetAncestor", 'uint', fCtl, 'uint',GA_ROOTOWNER := 2 ))
            ; WinActivate(hWndMainWindow)
            ; hWnd := WinActive('A')
            ; nCtl := ControlGetClassNN(fCtl)
            ; GetKeyState('sc1D', 'P') ? Send('{sc1D up}') : 0 ;? LCtrl
            ; KeyWait('sc1D', 'U') ;? LCtrl
            this.Focus(&fCtl)
            ; HznMenu('!sc21') ;! fix []: cannot use the Send('{sc1F}') below, it sends the s to the txt box, need another keypress in there
            ; HznMenu('!sc21', hWndMainWindow)
            ; Send('{sc1F}') ;? s
            ; Send('{sc38 down}{sc21}{sc1F}{sc38 Up}') ;? LAlt down, f, s, LAlt up
            Send(key.altdown key.f key.s key.altup) ;? LAlt down, f, s, LAlt up
            ; Sleep(100)
            AE.DH(1)
            AE.rSM(sm)
            try ControlFocus('TX')
            try ControlFocus(fCtl)
        }
    }
    static Save(){
        try ControlClick('Save', 'A')
        try ControlClick('SAVE', 'A')
    }
    static HznClick(buttonN){
        AE.SM(&sm)
        AE.DH(0)
        ; try ControlFocus('TX')
        ; try ControlFocus('Text')
        HznButton.Focus(&fCtl)
        nCtl := ControlGetClassNN(fCtl)
        ControlClick(buttonN, 'A')
        AE.DH(1)
        Loop {
            try anCtl := ControlGetClassNN(fCtl)
        } until (nCtl != anCtl) || (A_Index = 50)
    }

}
Class i extends hznHorizon {
	static Bold := 100
	static Italics := 101
	static Underline := 102
	static Separator103 := 103
	static AlignLeft := 104
	static AlignRight := 105
	static AlignCenter := 106
	static Justified := 107
	static Separator108 := 108
	static Cut := 109
	static Copy := 110
	static Paste := 111
	static Separator112 := 112
	static Undo := 113
	static Redo := 114
	static Separator115 := 115
	static BulletedList := 116
	static SpellCheck := 117
	static InsertTable := 118
	static SuperScript := 119
	static SubScript := 119
	static Find := 120
}
Class hznHorizon {
	Class Save extends hznHorizon {
		static RiskFile(){
			AE.SM(&sm), AE.DH(0), this.Focus(&fCtl), Send(key.save)
			AE.cSleep(100), AE.DH(1), AE.rSM(sm)
			try ControlFocus('TX')
			try ControlFocus(fCtl)
		}
		static _Button(){
			try ControlClick('Save', 'A')
			try ControlClick('SAVE', 'A')
		}
	}
    Class button extends hznHorizon {
		static Bold 		=> (*) => this.b(i.Bold)
		static Italics 		=> (*) => this.b(i.Italics)
		static Underline 	=> (*) => this.b(i.Underline)
		;! static Separator103 => (*) => this.b(i.Separator103)
		static AlignLeft 	=> (*) => this.b(i.AlignLeft)
		static AlignRight 	=> (*) => this.b(i.AlignRight)
		static AlignCenter 	=> (*) => this.b(i.AlignCenter)
		static Justified 	=> (*) => this.b(i.Justified)
		;! static Separator108 => (*) => this.b(i.Separator108)
		static Cut 			=> (*) => this.b(i.Cut)
		static Copy 		=> (*) => this.b(i.Copy)
		static Paste 		=> (*) => this.b(i.Paste)
		;! static Separator112 => (*) => this.b(i.Separator112)
		static Undo 		=> (*) => this.b(i.Undo)
		static Redo 		=> (*) => this.b(i.Redo)
		;! static Separator115 => (*) => this.b(i.Separator115)
		static BulletedList => (*) => this.b(i.BulletedList)
		static SpellCheck 	=> (*) => this.b(i.SpellCheck)
		static InsertTable 	=> (*) => this.b(i.InsertTable)
		static SuperScript 	=> (*) => this._sup()
		static SubScript 	=> (*) => this._sub()
		static FindReplace 	=> (*) => this.b(i.Find) ;, this._FindReplace())
    }
	static _ButtonCount(&hTb := hzn.Tb) {
		Static Msg := TB_BUTTONCOUNT := 1048, wParam := 0, lParam := 0
		BUTTONCOUNT := SendMessage(TB_BUTTONCOUNT, wParam, lParam, , hTb)
		Infos('Used hznButtonCount()`n # of buttons is ' BUTTONCOUNT)
		return BUTTONCOUNT
	}
	static _Toolbar_Customize(control := hTb := hzn.Tb){
		try SendMessage(TB_CUSTOMIZE := 1051, wParam := 0, lParam := 0, control, hTb)
	}
	static TbCustomize() => this._Toolbar_Customize()
	; ---------------------------------------------------------------------------
	static _Toolbar_EnableButtons(control := &hTb:= hzn.Tb) {
		AE.BISL(1)
		; ---------------------------------------------------------------------------
		; @Step: count and load all the msvb_lib_toolbar buttons into memory
		; ---------------------------------------------------------------------------
		buttonCount := SendMessage(TB_BUTTONCOUNT:= 1048, 0, 0,, hTb)
		; ---------------------------------------------------------------------------
		; @Step: Use the @params to enable the button
		; ---------------------------------------------------------------------------
		Loop buttonCount {
			idCommand := A_Index +99
			Msg := TB_SETSTATE := 1041, wParam := idCommand, lParam_HI := 4, lParam_LO := TBSTATE_ENABLED := 4, control := hTb
			SendMessage(Msg, wParam, lParam_HI|lParam_LO,control,hTb)
		}
		AE.BISL(0)
	}
	static TbEnableButtons() => this._Toolbar_EnableButtons()
	; ---------------------------------------------------------------------------
    static _button(idCommand:=0, hTb := hzn.Tb){
        AE.SM_BISL(&sm), Suspend(0)
        ; ---------------------------------------------------------------------------
        ; @function: !!! ===> Programatically "Click" the button!!! <=== !!!
		; ---------------------------------------------------------------------------
        Msg := WM_COMMAND:= 273, wParam_hi := 0, wParam_lo := idCommand, lParam := control := hTb
        SendMessage(Msg, wParam_hi | wParam_lo, lParam, hTb)
        ; ---------------------------------------------------------------------------
        AE.rSM_BISL(sm)
    }
    static b(id) => this._button(id)
	; ---------------------------------------------------------------------------
	static _FindReplace(){
		AE.cBakClr(&cBak)
		AE.BISL(1)
		AE.SM(&sm)
		str := RegExReplace(A_ThisHotkey, '\[^~+!]', '')
		tCtl := t := ''
		FindWhatTextBox := 'ThunderRT6TextBox2'
		ReplaceWithTextBox := 'ThunderRT6TextBox1'
		; ---------------------------------------------------------------------------
		HotIfWinActive('Find and Replace')
		Hotkey('F4', 	  (*) => ControlClick('ThunderRT6CommandButton4'), 'On' )
		Hotkey('^Enter',  (*) => ControlClick('ThunderRT6CommandButton4'), 'On' )
		Hotkey('Enter',   (*) => ControlClick('ThunderRT6CommandButton1'), 'On' )
		Hotkey('^!Enter', (*) => ControlClick('ThunderRT6CommandButton2'), 'On' )
		Hotkey('Escape',  (*) => ControlClick('ThunderRT6CommandButton3'), 'On' )
		; Hotkey('^h',  (*) => AE.cSleep(0), 'On' )
		; ---------------------------------------------------------------------------
		; Send('^{sc2E}') ;? ^c copy the selected word
		Send(key.copy)
		AE.cSleep(100)
		t := A_Clipboard
		AE.cSleep(100)
		; ---------------------------------------------------------------------------
		; @i: Find Button, or Find & Replace Button
		; ---------------------------------------------------------------------------
		hznHorizon.button.FindReplace
		; RichEditDlgs.FindReplMsg
		; Send('{sc38 down}{sc2A down}{sc20}')
		; Send(key.altdown key.shiftdown key.d key.shiftUp key.altUp) ;? LAlt down, f, s, LAlt up
		; ---------------------------------------------------------------------------
		; @i: Wait until the Window is Active
		; ---------------------------------------------------------------------------
		WinWaitActive('Find and Replace',,5)
		AE.Timer()
		FindWhatClassNN := ControlGetClassNN(FindWhatTextBox)
		hFindWhatClassNN := ControlGetHwnd(FindWhatClassNN)
		ReplaceWithClassNN := ControlGetClassNN(ReplaceWithTextBox)
		; ---------------------------------------------------------------------------
		; Sleep(100)
		switch {
			case (str ~= 'F5'):     Send(key.find)
			case (str ~= key.k.F5): Send(key.find)
			case (str ~= 'd'):      Send(key.find)
			case (str ~= key.k.d):  Send(key.find)
			case (str ~= 'h'):      Send(key.replace)
			case (str ~= key.k.h):  Send(key.replace)
			default:                Send(key.find)
		}
		Sleep(100)
		ControlFocus(FindWhatClassNN)
		Sleep(100)
		ControlSetText(t, hFindWhatClassNN)
		; if t.length != 0 {
		; 	tCtl := ControlGetText(FindWhatClassNN)
		; 	if !tCtl {
		; 		; Send('^{sc2F}')
		; 		; ClipSend(t,,false)
		; 		Send(key.paste)
		; 	}
		; }
		switch {
			case (str ~= 'F5'):     FindNext()
			case (str ~= key.k.F5): FindNext()
			case (str ~= 'd'):      FindNext()
			case (str ~= key.k.d):  FindNext()
			case (str ~= 'h'):      FindWordFocus()
			case (str ~= key.k.h):  FindWordFocus()
			default:                FindNext()
		}
		FindWordFocus() {
			AE.cSleep(100)
			ControlFocus(ReplaceWithClassNN)
		}
		FindNext(){
			Suspend(1)
			Send(key.tab)
			AE.cSleep()
			Suspend(0)
		}
		AE.rSM(sm)
		AE.BISL(0)
		AE.cRestore(cBak)
	}
	static Search 	=> (*) => this._FindReplace()
	static Replace 	=> (*) => this._FindReplace()
	; ---------------------------------------------------------------------------
	static Super_Script(){
		; AE.BISL(1)
		AE.SM(&sm)
		hznHorizon.button.SuperScript
		ControlClick('SuperScript', 'A')
		ControlClick('OK', 'A')
		AE.rSM(sm)
	}
	static Sub_Script(){
		; AE.BISL(1)
		AE.SM(&sm)
		hznHorizon.button.SubScript
		ControlClick('Subscript', 'A')
		ControlClick('OK', 'A')
		; AE.BISL(0)
		AE.rSM(sm)
	}
	static _Script(){
		AE.SM(&sm)
		str := A_ThisHotkey
		switch {
			case (str = '^='):				this._sup()
			case (str = '^' key.k.equal): 	this._sup()
			case (str = '^+='):				this._sub()
			case (str = '^+' key.k.equal):	this._sub()		
		}
		ControlClick('OK', 'A')
		AE.rSM(sm)
	}
	static _sup(sup := 'SuperScript') 	=> (this.b(i.Superscript),  WinWaitActive('Font Attributes'), ControlClick(sup, 'A'), ControlClick('OK', 'A'))
	static _sub(sub := 'Subscript') 	=> (this.b(i.Subscript),	WinWaitActive('Font Attributes'), ControlClick(sub, 'A'), ControlClick('OK', 'A'))
	; ---------------------------------------------------------------------------
    static Focus(&fCtl?){
        fCtl := ControlGetFocus('A')
        hWndMainWindow := WinGetTitle(DllCall( "GetAncestor", 'uint', fCtl, 'uint',GA_ROOTOWNER := 2 ))
        WinActivate(hWndMainWindow)
        hWnd := WinActive('A')
        nCtl := ControlGetClassNN(fCtl)
        GetKeyState(key.k.ctrl, 'P') ? Send(key.ctrlup) : 0 ;? Ctrl
        KeyWait(key.k.ctrl, 'U') ;? Ctrl Up
        return fCtl
    }
	static _MenuBar(input, hMainWindow := 0){
		i := input
		m := c := sm := {}
		SplitArr := b := a := []
		key_hotkey_sc := km := c := k := v := key_VK := key_SC := key_name := key_mod := key := ''
		; static fCtl
		fCtl := 0
		; n := needle := 'im)(sc[\w\d]+)'
		n  := '^([~*$]{1})'
		n1 := '([!^+#<>]+)'
		n2 := '(sc[\w\d]{2})$'
		n3 := 'im)' n n1 n2
		n4 := 'im)' n1 n2
		AE.BISL(1)
		AE.SM(&sm)
		; ---------------------------------------------------------------------------
		; @i...: Remove ~ | * | $ to convert hotkey and modifiers to scan code
		;   @var...: i {String} - (same as input) the input {String} before removal
		;   @var...: a {Array}  - the {Array} after removal => converted to a {String}
		; ---------------------------------------------------------------------------
		a := i.Split(,'~ * $').ToString('')
		; ---------------------------------------------------------------------------
		; @i...: Matches (RegExMatchInfo) for the hotkey and its modifier(s)
		;   @var: m[] - the exact match of all matches
		;   @var: m[1] - the first match group (modifier(s))
		;   @var: m[2] - the second match group (hotkey)
		;   @return: {RegExMatchInfo} (similar to an array)
		; ---------------------------------------------------------------------------
		a.RegExMatch(n4, &m) 
		; ---------------------------------------------------------------------------
		; @i...: Identify if the hotkey modifier has a Left (L) or Right (R)
		; @i...: Convert into text for converstion to scan code ({scXX})
		; ---------------------------------------------------------------------------
		if m[1].length > 1 {
			b := m[1].Split()
			for each, value in b {
				switch {
					case (value = '!'): key.k.alt
					case (value = '+'): key.k := 'Shift'
					case (value = '^'): k := 'Ctrl'
					case (value = '#'): k := 'Win'
					case (value = '<'): km := 'L'
					case (value = '>'): km := 'R'
				}
			}
			; key_mod := km k
			key_mod := AE.SC_Convert(key_mod)
		}

		; ---------------------------------------------------------------------------
		; @i...: Convert hotkey modifier to text to convert to scan code ({scXX})
		; ---------------------------------------------------------------------------
		else {
			switch {
				case (m[1] = '!'): k := 'Alt'
				case (m[1] = '+'): k := 'Shift'
				case (m[1] = '^'): k := 'Ctrl'
				case (m[1] = '#'): k := 'Win'
				; case (value = '<'): km := 'L' ;? Won't be present
				; case (value = '>'): km := 'R' ;? Won't be present
			}
			key_mod := k
			key_mod := AE.SC_Convert(key_mod)
		}
		; ---------------------------------------------------------------------------
		; @i...: Convert hotkey to scan code
		; ---------------------------------------------------------------------------
		if m[2] ~= n2 {
			key_SC := AE.SC_Convert(m[2])
		}
		; ---------------------------------------------------------------------------
		; @i...: Recombine into a single scan code based Hotkey
		; ---------------------------------------------------------------------------
		key_hotkey_sc := key_mod key_SC
		; ---------------------------------------------------------------------------
		; ---------------------------------------------------------------------------
		; @i...: Activate the Horizon Main Window
		; ---------------------------------------------------------------------------
		fCtl := ControlGetFocus('A')
		; static c := HznActivate(fCtl)
		AE.DH(0)
		; Peep(c)
		; idWin := WinGetID('ahk_exe hznHorizon.exe')
		; ; infos('`n' c.fCtl '`n' fCtl)
		; WinActivate(idWin)
		; ; WinActivate(idWin)
		; WinActivate(c.rCtl)
		if !hMainWindow{
			try hWndMainWindow := WinGetTitle(DllCall( "GetAncestor", 'uint', fCtl, 'uint',GA_ROOTOWNER := 2 ))
			WinActivate(hWndMainWindow)
		}
		else {
			WinActivate(hMainWindow)
		}
		; hWndMainWindow := WinGetTitle(DllCall( "GetAncestor", 'uint', fCtl, 'uint',GA_ROOTOWNER := 3 ))
		hWnd := WinActive('A')
		; hWnd := WinActive(idWin)
		GetKeyState(k) ? Send('{' k ' Up}') : 0
		KeyWait(k, 'U')
		Send('{' k ' Down}' '{' key_SC '}' '{' k ' Up}')
		KeyWait(key_mod, 'U')
		if input ~= 's' || input ~= 'sc1F' {
	
		}
		AE.DH(1)
		try ControlFocus('TX', hWnd)
		try ControlFocus(fCtl, hWnd)
		AE.BISL(0)
		AE.rSM(sm)
	}
	
    static ActiveWin(&hWndMainWindow?){
        try ControlFocus('TX')
        try ControlFocus('Text')
        try fCtl := ControlGetFocus('A')
        try hWndMainWindow := WinGetTitle(DllCall( "GetAncestor", 'uint', fCtl, 'uint',GA_ROOTOWNER := 2 ))
        return {WinT:hWndMainWindow}
    }

	static _Enter(){
		try {
			try fCtl := ControlGetFocus('A')
			try ClassNN := ControlGetClassNN(fCtl)
			try title := WinGetTitle('ahk_id ' fCtl)
			if ClassNN ~= 'SSUltraGridWndClass' && ((cHwnd := ControlGetFocus('A'), WinTP2 := WinGetTitle(DllCall( "GetAncestor", 'uint', cHwnd, 'uint',GA_ROOTOWNER := 2 ))) ~= '[Main]'){
				ControlClick('ThunderRT6CommandButton4')
			}
			; if ClassNN ~= 'SSUltraGridWndClass' {
			; 	; ControlFocus('SSUltraGridWndClass')
			; 	Send('{Click}{Click}')
			; }
			else if ClassNN ~= 'ThunderRT6FormDC'{
				; ControlFocus('ThunderRT6FormDC')
				Send('{Click}{Click}')
			}
			else if ClassNN ~= 'TX11'{
				; Send('{Enter}')
				; Send('{sc1C}')
			}
			Else If (ClassNN ~= 'DT5ComboBox_PVCombo') {
				ControlClick(ClassNN)
			}
			Else If (ClassNN ~= 'DT5ComboBox_PVCombo4') {
				ControlClick('DT5ComboBox_PVCombo4')
			}
			Else If (ClassNN ~= 'DT5_PVCombo1') {
				ControlClick('DT5_PVCombo1')
			}
			Else If (ClassNN ~= 'SysTreeView321') && (WinGetTitle('A') ~= 'Equipment Type Selector') {
				ControlClick(ClassNN)
			}
			; Else If WinActive('ahk_exe hznHorizonMgr.exe') && (ClassNN ~= 'SSUltraGridWndClass1') {
			;     ; ControlFocus('SSUltraGridWndClass1')
			;     ControlClick('SSUltraGridWndClass1',,,,2)
			; }
			; else {
			;     Send('{sc1C}') ;? {Enter}
			; }
		}
	}
    static Click(buttonN){
        AE.SM(&sm)
        AE.DH(0)

        fCtl := ControlGetFocus('A')
        nCtl := ControlGetClassNN(fCtl)
		if nCtl ~= 'TX' {
			try ControlFocus('TX')
		}
		else if nCtl ~= 'Text' {
			try ControlFocus('Text')
		}
        hWndMainWindow := WinGetTitle(DllCall( "GetAncestor", 'uint', fCtl, 'uint',GA_ROOTOWNER := 2 ))
		; Infos(hWndMainWindow)
        WinActivate(hWndMainWindow)
        hWnd := WinActive('A')
        ControlClick(buttonN, 'A')
        AE.DH(1)
        Loop {
            try anCtl := ControlGetClassNN(fCtl)
        } until (nCtl != anCtl) || (A_Index = 50)
    }
	; ---------------------------------------------------------------------------
	/************************************************************************
	 * Function..: HznPaste() (Ctrl+Shift+v)
	 * @author...: OvercastBTC
	 * @source...: https://learn.microsoft.com/en-us/windows/win32/dataxchg/wm-paste
	 * @sourceparam.......: #define WM_PASTE                        0x0302
	 * @param hCtl........: Gets the control in focus hwnd, then the class name
	 * @param Msg.........: Windows API message => WM_PASTE
	 * @param WM_PASTE....: Decimal number (versus hex = 0x0302) for WM_PASTE
	 * @param wParam......: This parameter is not used and must be zero.
	 * @param lParam......: This parameter is not used and must be zero.
	 * @returns {null}....: This message does not return a value.
	***********************************************************************/
	static PasteSpecial() {
		Static Msg := WM_PASTE := 770, wParam := 0, lParam := 0
		hCtl := ControlGetFocus('A')
		DllCall('SendMessage', 'Ptr', hCtl, 'UInt', Msg, 'UInt', wParam, 'UIntP', lParam)
	}
	; ---------------------------------------------------------------------------
	static EM_SETSEL := 177
	; static _Select(wParam, lParam) {
	; 	return DllCall('SendMessage', 'UInt', hzn.fCtl, 'UInt', this.EM_SETSEL, 'UInt', wParam, (wParam = 0 && lParam = -1) ? 'UIntP' : 'UInt', lParam)
	; }
	static _Select(wParam, lParam) => DllCall('SendMessage', 'UInt', hzn.fCtl, 'UInt', this.EM_SETSEL, 'UInt', wParam, (wParam = 0 && lParam = -1) ? 'UIntP' : 'UInt', lParam)
	; static _Select(wParam, lParam, hCtl := ControlGetFocus('A')) => DllCall('SendMessage', 'UInt', hCtl, 'UInt', Msg := EM_SETSEL := 177, 'UInt', wParam, (wParam = 0 && lParam = -1) ? 'UIntP' : 'UInt', lParam)
	static sAll() => this._Select_All()
	static _Select_All() => this._Select( 0, -1)
	static sBegin() => this._Select_Beginning()
	static _Select_Beginning() => this._Select( 0,  0)
	static sEnd() => this._Select_End()
	static _Select_End() => this._Select(-1, -1)
	; ---------------------------------------------------------------------------
	static NewRec(){
		AE.SM_BISL(&sm)
		fCtl := ControlGetFocus('A'), ClassNN := ControlGetClassNN(fCtl), WinT := WinGetTitle('A'), bNew := '', hCtl := 0
		hWin := 'ahk_exe hznHorizon.exe'	
		try ControlClick('New Standard', 'A')
		WinWaitActive('New Standard Recommendation',,5)
		WinWaitActive('ThunderRT6CheckBox4',,5)
		try ControlClick('ThunderRT6CheckBox4', 'A')
		try ControlClick('ThunderRT6CheckBox3', 'A')
		try ControlClick('Rec Code', 'A')
		try ControlFocus('SysTreeView321', 'Recommendation Code Selector')
		try Send('{Right}')
		try Send('{Right}')
		try Send('{Right}')
		AE.rSM_BISL(sm)
	}

	static Tab(){
		Suspend(1)
		ClassNN := '', index := 0
		; Infos(
		try ClassNN := ControlGetClassNN(ControlGetFocus('A'))
		; )
		; If !ClassNN || ClassNN ~= 'ThunderRT6TextBox21' {
		If ClassNN ~= 'ThunderRT6TextBox21' {
			this.HznTab()
		}
		Else If (ClassNN ~= 'MSMaskWndClass13') {
			Sleep(100)
			ControlClick('ThunderRT6OptionButton9', 'A')
			; Sleep(100)
		}
		; ---------------------------------------------------------------------------
		; @i...: Equipment or [Vital Equipment for Site]
		; ---------------------------------------------------------------------------
		; @i...: Comments Tab => 'SSActiveTabsWndClass1' ;! Maybe all the Tabs?
		;; @i...: Equipment Factors Tab => 'SSActiveTabsWndClass2' ;! Nope
		; @i...: TE % => 'MSMaskWndClass7'
		; ---------------------------------------------------------------------------
		; @i...: If you are in the TE (%) text box, go to Equipment Factors Tab
		; ---------------------------------------------------------------------------
			; Else If (ClassNN ~= 'MSMaskWndClass7') {
		;     list := [], val := item := '', n := 1
		; 	ControlFocus('SSActiveTabsWndClass1', 'A')
		;     ; Send('{Left 2}')
		;     ; ControlChooseIndex(0, 'SSActiveTabsWndClass1', 'A') ;! Failed
		;     ; Infos(ControlGetChoice('SSActiveTabsWndClass1', 'A')) ;! Nothing
		;     ; ControlGetItems('SSActiveTabsWndClass1') ;! Value not enumerable
	
		;     ; list := WinGetControls('A')
		;     list := WinGetControlsHwnd('A')
		;     for each, value in list {
		;             val := WinGetTitle(value)
		;             if val = '' {
		;                 item .= 'C: ' ControlGetClassNN(value) '`n'
		;             }
		;             else {
		;                 item .= 'W: ' val '`n'
		;             }
		;     }
		;     ; item := list.ToString(' ')
		;     OutputDebug(item)
		;     ; ControlSetChecked(1, 'SSActiveTabsWndClass1', 'A') ;! Didn't do anything apparent???
		; }
		; ---------------------------------------------------------------------------
		; @i...: If you are on the Equipment Pane
		; ---------------------------------------------------------------------------
		Else If (ClassNN ~= 'ThunderRT6CommandButton4'){ ;! Magafying Glass Button
			; Send('{Tab}')
			ControlFocus('SSUltraGridWndClass1')
		} 
		Else If (ClassNN ~= 'SSUltraGridWndClass1'){
			Send('{Tab}')
		}
		Else If (ClassNN ~= 'ThunderRT6CommandButton1'){ ;! Equipment Page - "Duplicate" Button
			; Send('{Tab}')
			ControlFocus('ThunderRT6CommandButton4')
		}
		Else If (ClassNN ~= 'ThunderRT6CommandButton2'){ ;! Equipment Page - "New" Button
			; Send('{Tab}')
			ControlFocus('ThunderRT6CommandButton1')
		}
		Else if (ClassNN ~= 'ThunderRT6TextBox23') {
			ControlSend('{Tab}')
		}    
		Else if (ClassNN ~= 'DT5ComboBox_PVCombo4') {
			ControlSend('{Tab}')
		}    
		Else if (ClassNN ~= 'ThunderRT6TextBox28') {
			ControlSend('{Tab}')
		}
		Else if (ClassNN ~= 'ThunderRT6CheckBox1') {
			ControlSend('{Tab}')
		}    
		Else if (ClassNN ~= 'ThunderRT6CheckBox3') {
			ControlSend('{Tab}')
		}
		Else if (ClassNN ~= 'MSMaskWndClass17') {
			ControlSend('{Tab}')
		}
		Else if (ClassNN ~= 'ThunderRT6CheckBox2') {
			ControlSend('{Tab}')
		}
		Else if (ClassNN ~= 'DT5_PVCombo2') {
			ControlSend('{Tab}')
		}
		Else if (ClassNN ~= 'DT5ComboBox_PVCombo1') {
			ControlSend('{Tab}')
		}
		Else if (ClassNN ~= 'MSMaskWndClass11') {
			ControlSend('{Tab}')
		}
		Else if (ClassNN ~= 'MSMaskWndClass9') {
			ControlSend('{Tab}')
		}
		Else if (ClassNN ~= 'DT5ComboBox_PVCombo3') {
			ControlSend('{Tab}')
		}
		Else If (ClassNN ~= 'MSMaskWndClass7') {
			Send('{Tab}')
		}
		Else If (ClassNN ~= 'ThunderRT6CommandButton11') {
			Send('{Tab}')
		}
		; ---------------------------------------------------------------------------
		Else If (ClassNN ~= 'ThunderRT6OptionButton9') {
			Sleep(100)
			If (ControlGetText('ThunderRT6TextBox7') ~= 'Equipment') {
				ControlClick('ThunderRT6CommandButton9', 'A')
				Sleep(300)
				ControlClick('Button1', 'A')
			}
			Else {
				ControlFocus('ThunderRT6CommandButton9')
			}
		}
		Else If (ClassNN ~= 'ThunderRT6CommandButton9') {
			Sleep(100)
			If (ControlGetText('ThunderRT6TextBox7') ~= 'Equipment') {
				ControlClick('ThunderRT6OptionButton13', 'A')
				Sleep(100)
				ControlClick('ThunderRT6CommandButton10', 'A')
				Sleep(300)
				ControlClick('Button1', 'A')
			}
			Else {
				ControlFocus('ThunderRT6CommandButton10')
			}
		}
		Else If (ClassNN ~= 'ThunderRT6OptionButton13') {
			Sleep(100)
			ControlClick('ThunderRT6CommandButton10', 'A')
			Sleep(300)
			ControlClick('Button1', 'A')
		}
		Else If (ClassNN ~= 'ThunderRT6CommandButton10') {
			Sleep(100)
			ControlFocus('SSActiveTabsWndClass1', 'A')
			Sleep(100)
			Send('{Left}')
		}
		Else If (ClassNN ~= 'DT5ComboBox_PVCombo') {
			ControlClick(ClassNN)
		}
		Else If (ClassNN ~= 'DT5_PVCombo1') {
			ControlClick('DT5_PVCombo1')
		}
		Else If (ClassNN ~= 'SysTreeView326') {
			ControlClick('SSUltraGridWndClass1')
		}
		else if (ClassNN ~= 'SSActiveTabsWndClass') {
			index := ControlGetIndex(ClassNN)
			Infos(index)
			Send('{Right}')
		}
		; ; Else If WinActive('ahk_exe hznHorizonMgr.exe') && (ClassNN ~= 'SysTreeView321') {
		; ;     ControlFocus('SSUltraGridWndClass1')
		; ;     WinActivate('SSUltraGridWndClass1')
		; ;     ControlClick('SSUltraGridWndClass1')
		; ; }
		; Else {
		;     ; HznTab()
		;     ; ClipSend('    ')
		;     Send('{sc39 4}') ;@i...: sc39 = {Space}
		; }
		Suspend(0)
	}

	static Ctrl_Tab(){
		AE.BISL(1)
		AE.DH(0)
		hList := cList := [], hCtl := TabCt := idxTab := 0
		static fCtl := 0
		cl := c := e := v := ''
		static hzn := 'ahk_exe hznHorizon.exe'
		try fCtl := ControlGetFocus('A')
		try if !WinActive(hzn){
			idWin := WinGetID(hzn), WinActivate(idWin), WinWaitActive(idWin)
		}
		else {
			WinActivate(hzn)
		}
		if fCtl ~= 'SSActiveTabsWndClass1' {
			return
		}
		AE.DH(1)
		cList := WinGetControls('A')
		for v in cList {
			; if (v ~= 'im)SysTabControl32') {
			if (v ~= 'im)Tab') {
			;     try cl := ControlGetClassNN(ControlGetFocus('A'))
			;     Infos(v '`n' cl) ;? (AJB - 2024.04.17) validated it works to get all the Tab control names
			;     try hCtl := ControlGetHwnd(v)
			;     ; SendMessage(256,0,0,hCtl, 'A')
	
				try SendMessage(0,0,0,v, 'A')
			;     if v != 'SysTabControl321'{
			;         AE.DH(1)
			;         ControlChooseIndex(2, v)
			;     }
			}
			a := m := arr := []
			if (v ~= 'im)SysTabControl32') {
				RegExMatch(v, 'im)(\d+)', &m)
				for each, value in m {
					SafePush(arr, value)
					if value >= 322 {
						a.SafePush(value)
					}
				}
				; Infos(arr.ToString())
			}
			; if (v = 'SysTabControl322'){
			if ((v ~= 'SysTabControl32') && (v != 'SysTabControl321')) {
				; if (v ~= 'im)Tab'){
					try hCtl := ControlGetHwnd(v), ControlClick(hCtl)
					; try ControlClick(hCtl)
					; sleep(100)
					; try fCtl := ControlGetFocus('A')
					try idxTab := ControlGetIndex(hCtl, 'A')
					try TabCt := SendMessage(0x1304,0,0,hCtl, 'A')  ; 0x1304 is TCM_GETITEMCOUNT.
					; Infos(v '`n' hCtl '`n' idxTab '`n' TabCt)
					If idxTab < TabCt {
						try ControlChooseIndex(idxTab+1, hCtl)
					}
					if idxTab = TabCt {
						idxTab := 0
						Sleep(100)
						try ControlChooseIndex(idxTab+1, hCtl)
					}
				; }
			}
			for e in WinGetControls('A') {
				if e ~= 'im)TX11' {
					if ControlGetEnabled('TX111', 'A') != 1 {
						return
					}
					else {
						ControlFocus(e, 'A')
					}
				}
			}
		}
		try ControlFocus('TX', 'A')
		try ControlFocus(fCtl)
		AE.BISL(0)
	}
	; {
	; 	Suspend(1)
	; 	ClassNN := ''
	; 	; Infos(
	; 	try ClassNN := ControlGetClassNN(ControlGetFocus('A'))
	; 	; )
	; 	If ClassNN ~= 'TX11' {
	; 		Send('{Space 4}')
	; 	}
	; 	Suspend(0)
	; }

	static _Ctrl_Enter(){
		tWin := ClassNN := '', fCtl := index := 0
		; Infos(
		try ClassNN := ControlGetClassNN(fCtl := ControlGetFocus('A'))
		tWin := WinGetTitle(DllCall( "GetAncestor", 'uint', fCtl, 'uint',GA_ROOTOWNER := 2 ))
		; if (ClassNN ~= 'SSUltraGridWndClass') && ((cHwnd := ControlGetFocus('A'), WinTP2 := WinGetTitle(DllCall( "GetAncestor", 'uint', cHwnd, 'uint',GA_ROOTOWNER := 2 ))) ~= 'Validation Results'){
		;     ControlClick('OK')
		; } 
		; else {
		;     ControlClick('Ok')
		; }
		ControlClick('OK', tWin)
	}
	; ---------------------------------------------------------------------------
	static CtrlEnter() => this._Ctrl_Enter()
	; ---------------------------------------------------------------------------
	static _Cancel(){
		try ControlClick('Cancel', 'A')
	}
	static Cancel() => this._Cancel()
	; ---------------------------------------------------------------------------
	/************************************************************************
	 * Function..: HznGetText() (Ctrl+Shift+c)
	 * @author...: OvercastBTC
	 * @param hCtl........: Gets the handle (hwnd) to the control in focus
	 * @param A_Clipboard.: The AHK builtin clipboard
	 * @returns {text in the control (RT6TextBox or TX11)}
	***********************************************************************/
	class hznREmap {
		static rEditMap := Map(
			'width', rwidth := 2012,
			'height', rheight := 0,
			'x', rx := 42,
			'y', ry := 666,
			'top', rtop := 0,
			'bottom', rbottom := 0,
			'hCtl', hCtl := 134162,
			'nCtl', nCtl := '',
			'fName', fName := '',
		)
	}
	static _GetText(*) {
		AE.cBakClr(&cBak)
		AE.BISL(1)
		AE.SM(&sm)
		t := sm := '' 
		static hCtl := ControlGetFocus('A')
		Send(key.selectall) ;! ^a
		; HznSelectAll(hCtl)
		Sleep(100)
		Send(key.copy) ;! ^c
		AE.cSleep(100)
		t := A_Clipboard
		AE.cSleep(100)

		AE.rSM(sm)
		; MsgBox('The text has been copied to the clipboard.`nYou can paste it by Right Click and select paste, or the shortcut/hotkey ctrl & v.`nHere is what is on the clipboard:`n' t)
		; MsgBox('The text has been copied to the clipboard.`nYou can paste it by Right Click and select paste, or the shortcut/hotkey ctrl & v.')
		Infos('The text has been copied to the clipboard.`nYou can paste it by Right Click and select paste, or the shortcut/hotkey ctrl & v.', 10000)
		; A_Clipboard := cBak
		/*
		g := Gui('+DPIScale +ToolWindow +Resize','Basic Horizon Text Editor' )
		g.AddText('Center', 'Edit your text, copy, and paste back into Horizon.')
		g.AddText('Center', 'If it has formatting (bold, italics, underline), it will be lost.')
		g.AddEdit('vText s11 TimesNewRoman +Wrap +Multi w' (A_ScreenWidth / 3) ' h' (A_ScreenHeight / 2), t )
		g.Show('AutoSize NA')
		AE.BISL(0)
		; return
		*/
		/*
		cBak := _AE_BU_Clr_Clip()
		AE.BISL(1)

		rect := Map()
		hRect := []
		fname := ''
		hHzn := ''
		ftext := ''
		ftextName := ''
		; static hCtl := ControlGetFocus('A')
		hCtl := ControlGetFocus('A')
		hParent := DllCall("user32\GetAncestor", "Ptr", hCtl, "UInt", 1, "Ptr") ;GA_PARENT := 1
		hRoot := DllCall("user32\GetAncestor", "Ptr", hCtl, "UInt", 2, "Ptr") ;GA_ROOT := 2
		hOwner := DllCall("user32\GetWindow", "Ptr", hCtl, "UInt", 4, "Ptr") ;GW_OWNER = 4
		hChild := DllCall("RealChildWindowFromPoint", "Ptr", hCtl, "UInt", 4, "Ptr") ;GW_OWNER = 4
		nCtl := ControlGetClassNN(hCtl)
		hCtl_title := WinGetTitle(hRoot)
		tName := hCtl_title
		tIdx := hCtl_title
		tWO := hCtl_title
		tWinL := hCtl_title
		needle := '^([\w\s]+\b)[\s-]+([\d\s]+\b)[\s-]+([\d\-\d]+)\s+\d+\s+[\w, -]+ \[([\w]+)\]$'
		tName := RegExReplace(tName, needle, '$1')
		tIdx := RegExReplace(tIdx, needle, '$2')
		tWO := RegExReplace(tWO, needle, '$3')
		tWinL := RegExReplace(tWinL, needle, '$4')
		hHzn := WinExist('ahk_exe hznHorizon.exe')
		

		fPath := A_MyDocuments '\RichEdit\' tName '(' tIDx ')\' tWinL
		fName := '_' nCtl '_' A_Now '.rtf'
		fPathName := fPath '\' fname
		; MsgBox(fPathName)
		; return
		if !DirExist(fPath) {
			DirCreate(fPath)
		}
		if !FileExist(fName) {
			; WriteFile(fPathName, '')
			FileAppend('', fName)
		} else {
			FileDelete(fName)
			FileAppend(A_Clipboard, fName)
		}
		try receiver.rMap.Set('fName', fName)
		LineCount := 0
		loop read fName {
			LineCount := A_Index
		}
		nLineCount := LineCount
		try DPI.ControlGetPos(&x, &y, &w, &h, nCtl, 'A')
		; mRect := WindowGetRect(hCtl)
		; width := mRect.width
		; height := mRect.height
		width := w
		height := LineCount * 16
		rect.Set('width',width, 'height',height, 'x', x, 'y', y, 'hCtl', hCtl, 'nCtl', nCtl, 'fName', fName)
		; RTE_Title := 'hznRTE - A Rich Text Editor for Horizon'
		RTE_Title := 'Horizon Rich Text Editor - hznRTE -- A Rich Text Editor for Horizon'
		file_name := '__receiver.ahk'
		file_line := '', TX11 := '', match:='', aLine := ''
		aTX11 := [], new_map := []
		width_needle := 'i)width', height_needle := 'i)height',	x_needle := 'i)x', y_needle := 'i)y', hCtl_needle := 'i)hCtl', nCtl_needle := 'i)nCtl'
		match_array := [width_needle, height_needle, x_needle, y_needle, hCtl_needle, nCtl_needle]
		; ---------------------------------------------------------------------------
		; HznSelectAll(hCtl)
		; clip_it()
		; ---------------------------------------------------------------------------
		hzntx11 := FileOpen(file_name,'rw','UTF-8')
		Sleep(300)
		; ---------------------------------------------------------------------------
		Update_Receiver_Rect_Map(file_name)
		; ---------------------------------------------------------------------------
		Update_Receiver_Rect_Map(file_name){
			loop read file_name {
				aTX11.Push(A_LoopReadLine)
				file_line .= A_LoopReadLine . '`n'
			}
			; Sleep(500)
			; ---------------------------------------------------------------------------
			for each, aLine in aTX11 {
				; ---------------------------------------------------------------------------
				for each, match in match_array {
					if ((aLine ~= match)) {
						str_match := StrSplit(match,')','i ) "')
						rMatch := str_match[2]
						; Infos(rMatch)
						rect_match := rect[rMatch]
						; rect_match := dpiRect.%str_match[2]%
						new_str := RegExReplace(aLine, ':= ([0-9].*)', ':= ' rect_match . ',' )
						aLine := new_str
						aTX11.RemoveAt(A_Index)
						aTX11.InsertAt(A_Index, aLine)
					}
				}
				; ---------------------------------------------------------------------------
				; function: write each value in the array to @param TX11 (string variable)
				TX11 .= aLine . '`n'
				; ---------------------------------------------------------------------------
			}
			; Infos(file_line . '`n' . TX11)
			; ---------------------------------------------------------------------------
			; hzntx11 := FileOpen(file_name,'rw','UTF-8')
			hzntx11.Write(TX11)
			hzntx11 := ''
		}
		Send('^{sc1E}') ;! ^a
		HznSelectAll(hCtl)
		; AE_Set_Sel(0,-1, hCtl)
		; sel := AE_GetSel(hCtl)
		; AE_GetStats(hCtl)
		; count := AE_GetTextLen(hCtl, hCtl)
		; Infos(sel.S ' ' sel.E '`n' count)
		Send('^{sc2E}') ;! ^c
		sleep(30)
		ftext := A_Clipboard
		sleep(30)
		ftextName := A_MyDocuments '\RichEdit\' A_Now '.rtf'
		WriteFile(ftextName, ftext)
		Sleep(30)
		f := ''
		f := FileOpen(ftextName,'rw', 'UTF-8')
		Sleep(30)
		f.Write(ftext)
		Sleep(30)
		f.Close()
		Sleep(30)
		fR := f.Read()
		if A_IsCompiled {
			; Run('RichEdit_Editor_v2.exe')
			Run('RichEdit_Editor_v2.exe' ' /' '"' ftextName '"')
		}
		else {
			; Run(Paths.Lib '\RichEdit_Editor_v2.ahk')
			; Run(Paths.Lib '\RichEdit_Editor_v2.ahk ' '"' ftextName '"')
			Run(Paths.Lib '\RichEdit_Editor_v2.ahk ' ftextName)
			; Run(Paths.Lib '\RichEdit_Editor_v2.ahk' ' ' '"' ftextName '"')
			; (val := GetFilesSortedByDate(Paths.Lib '\RichEdit_Editor_v2.ahk'), runner := val.ToString(''), Infos(runner), Run(runner))
		}
		*/
		RTEdit()
		hznRTE := 'Horizon Rich Text Editor - hznRTE -- A Rich Text Editor for Horizon --'
		; A_Clipboard := ''
		; Sleep(100)
		; A_Clipboard := t
		; Loop {
		;     Sleep(50)
		; } Until !DllCall('GetOpenClipboardWindow', 'int') || A_Index > 20
		; hRTE := WinWaitActive(' hznRTE ',,5)
		hRTE := WinWaitActive(hznRTE,,5)
		reClassNN := 'RICHEDIT50W2', reHwnd := ControlGetHwnd(reClassNN) 
		; Infos('reClassNN: ' reClassNN ' (' reHwnd ')')
		Sleep(100)
		ControlFocus(reClassNN)
		pid_RTE := WinGetPID(hRTE)
		; Send('^{sc2F}') ; SndMsgPaste(reHwnd) ; AE_ReplaceSel(A_Clipboard, reHwnd) ; Send('^+v'); Send('^v')
		ClipSend(t)
		ProcessWaitClose(pid_RTE)
		t := ''
		; AE.rSM(sm)
		WinActivate(hHzn)
		ControlFocus(hCtl, hHzn)
		this._Select_All()
		Send(key.copy) ;? ^c
		AE.cSleep(100)
		t := A_Clipboard
		AE.cSleep(100)

		; Send('^{sc2F}') ; SndMsgPaste(hCtl)
		; Send(key.paste)

		try this._Select_Beginning()
		; AE.BISL(0)
		AE.cRestore(cBak)
		AE.rSM(sm)
		
	}
	; ---------------------------------------------------------------------------


	; ---------------------------------------------------------------------------
	/************************************************************************
	 * @function button()
	 * @author....: Descolada, OvercastBTC
	 * @Desc......:  Call the Horizon msvb_lib_toolbar buttons using the button() function
	 * @param A_ThisHotkey - AHK's built in variable.
	 * @param idCommand.: optional => idCommand := 0 (preset value, else => idCommand?)
	***********************************************************************/
	; #Include <Class\hzn\_hzTb.v2>
	; #HotIf WinActive('TX11')
	; button(idCommand:=0){
	; 	; AE.SM(&sm)
	; 	Infos(A_SendLevel)
	; 	AE.BISL(5)
	; 	static hCtl := ControlGetFocus('A')
	; 	static fCtl := ControlGetClassNN(hCtl)
	; 	static fCtlI := SubStr(fCtl, -1, 1)
	; 	static nCtl := 'msvb_lib_toolbar' fCtlI
	; 	static hTb := ControlGethWnd(nCtl, 'A')
	; 	SendMessage(TB_BUTTONCOUNT, 0, 0, hTb, hTb)
	; 	Static  WM_COMMAND := 273, TB_GETBUTTON := 1047, TB_BUTTONCOUNT := 1048
	; 	Static	TB_COMMANDTOINDEX := 1049, TB_GETITEMRECT := 1053 
	; 	Static	MEM_PHYSICAL := 4, MEM_RELEASE := 32768, TB_GETSTATE := 1042
	; 	Static	TB_GETBUTTONSIZE := 1082, TB_ENABLEBUTTON := 0x0401
		
	; 	; ---------------------------------------------------------------------------
	; 	; @function: !!! ===> Programatically "Click" the button!!! <=== !!!
	; 	; ---------------------------------------------------------------------------
	; 	static Msg := WM_COMMAND, wParam_hi := 0, wParam_lo := idCommand, lParam := control := hTb
	; 	; DllCall('SendMessage', 'UInt', hTb, 'UInt', Msg, 'UInt', wParam_hi | wParam_lo, 'UIntP', lParam)
	; 	SendMessage(Msg, wParam_hi | wParam_lo, lParam, hTb, hTb)
	; 	; ---------------------------------------------------------------------------
	; 	AE.BISL(0)
	; 	; AE.rSM(sm)
	; }
	; #HotIf WinActive('ahk_exe hznHorizon.exe')
	;     hznTb() => HznToolbar._hTb()
	;     ; hBtn(idCommand:=0, hTb := hznTb()){
	; 	button(idCommand:=0, hTb := hznTb()){
	;         AE.BISL(1)
	;         AE.SM(&sm)
	; 		Suspend(0)
	;         Static  WM_COMMAND := 273
	;         ; ---------------------------------------------------------------------------
	;         ; function: !!! ===> Programatically "Click" the button!!! <=== !!!
	;         Msg := WM_COMMAND, wParam_hi := 0, wParam_lo := idCommand, lParam := control := hTb
	;         ; DllCall('SendMessage', 'UInt', hTb, 'UInt', Msg, 'UInt', wParam_hi | wParam_lo, 'UIntP', lParam)
	;         SendMessage(Msg, wParam_hi | wParam_lo, lParam, hTb)
	;         ; ---------------------------------------------------------------------------
	;         AE.BISL(0)
	;         AE.rSM(sm)
	;     }
	; #HotIf
	; ---------------------------------------------------------------------------
	;/************************************************************************
	; @function...: HznButton()
	; @i...: Clicks the nth item in a Win32 application toolbar.
	; @author...: Descolada, OvercastBTC
	; @param...: hTb - The handle of the toolbar control.
	; @param...: hTb - same as hTb
	; @param...: fCtl* - [OPTIONAL] The ClassNN of the "focused" control.
	; @param...: fCtlInstance - The ClassNN [instance] of the "focused" control.
	; @param...: nCtl - The [ClassNN and instance] of the toolbar control.
	; @function...: param:=0 => in AHK v2 => optional
	; ***********************************************************************/
	; ---------------------------------------------------------------------------
	; HznButton(idCommand) {
	; 	AE.SM(&sm)
	; 	AE.BISL(1)
	; 	hTb := HznToolbar._hTb()
	; 	nCtl := ''
	; 	; ---------------------------------------------------------------------------
	; 	Static  WM_COMMAND := 273, TB_GETBUTTON := 1047, TB_BUTTONCOUNT := 1048
	; 	Static	TB_COMMANDTOINDEX := 1049, TB_GETITEMRECT := 1053 
	; 	Static	MEM_PHYSICAL := 4, MEM_RELEASE := 32768, TB_GETSTATE := 1042
	; 	Static	TB_GETBUTTONSIZE := 1082, TB_ENABLEBUTTON := 0x0401
	; 	; ---------------------------------------------------------------------------
	; 	; Step: count and load all the msvb_lib_toolbar buttons into memory
	; 	; ---------------------------------------------------------------------------
	; 	buttonCount := SendMessage(TB_BUTTONCOUNT, 0, 0, , hTb)
	; 	; ---------------------------------------------------------------------------
	; 	; Step: Use the @params to press the button
	; 	; ---------------------------------------------------------------------------
		
	; 	try if (idCommand >= 100 && idCommand <= (buttonCount + 99)) {
	; 		; * Get the toolbar "thread" process ID (PID)
	; 		DllCall("GetWindowThreadProcessId", "Ptr", hTb, "UInt*", &tpID := 0)
	; 		; ---------------------------------------------------------------------------
	; 		; * Open the process with PROCESS_VM_OPERATION, PROCESS_VM_READ, and PROCESS_VM_WRITE access
	; 		hProcess := DllCall('OpenProcess', 'UInt', 8 | 16 | 32, "Int", 0, "UInt", tpID, "Ptr")
	; 		; ---------------------------------------------------------------------------
	; 		; * Identify if the process is 32 or 64 bit (efficiency step)
	; 		Is32bit := Win32_64_Bit(hProcess)
	; 		; ---------------------------------------------------------------------------
	; 		; * Allocate memory for the TBBUTTON structure in the target process's address space
	; 		remoteMemory := remote_mem_buff(hProcess, Is32bit, &TBBUTTON_SIZE)
	; 		; ---------------------------------------------------------------------------
	; 		; DllCall("VirtualFreeEx", "Ptr", hProcess, "Ptr", remoteMemory, "UPtr", 0, "UInt", MEM_RELEASE)
	; 		; DllCall("CloseHandle", "Ptr", hProcess)
	; 		; ---------------------------------------------------------------------------
	; 		; Step: Store previous and set min delay
	; 		; ---------------------------------------------------------------------------
	; 		_AE_SetDelays(-1)
	; 		; ---------------------------------------------------------------------------
	; 		; try (idCommand < 100) ? idCommand := ((n - 1) + 100) : idCommand
	; 		; btnstate := GETBUTTONSTATE(idCommand, hTb)
	; 		; If (!btnstate = 4) || (!btnstate = 6) ;! note: (AJB - 09/2023) verified
	; 		; 	return
			
	; 		; ---------------------------------------------------------------------------
	; 		; ; function: !!! ===> Programatically "Click" the button!!! <=== !!!
	; 		Msg := WM_COMMAND, wParam_hi := 0, wParam_lo := idCommand, lParam := control := hTb
	; 		; DllCall('SendMessage', 'UInt', hTb, 'UInt', Msg, 'UInt', wParam_hi | wParam_lo, 'UIntP', lParam)
	; 		SendMessage(Msg, wParam_hi | wParam_lo, lParam, , hTb)
	; 		; ---------------------------------------------------------------------------
	; 		; Step: Restore previous and set delay
	; 		; ---------------------------------------------------------------------------
			
	; 		; ---------------------------------------------------------------------------
	; 		; BlockInput(0) ; 1 = On, 0 = Off
	; 		; ---------------------------------------------------------------------------
	; 	}
	; 	catch{
	; 		throw ValueError("The specified toolbar " nCtl " was not found. Please ensure the edit field has been selected and try again.", -1)
	; 		; Return 0
	; 	}
	; 	AE.BISL(0)
	; 	AE.rSM(sm)
	; }
	; ---------------------------------------------------------------------------
	static remote_mem_buff(hProcess, Is32bit?, CTRL_SIZE?){
		Static MEM_PHYSICAL := 4 ; 0x04 ; 0x00400000, ; via MSDN Win32
		Static MEM_COMMIT := 4096
		Is32bit := 0
		RPtrSize := Is32bit ? 4 : 8
		CTRL_SIZE := 8 + (RPtrSize * 3) 
		; remoteMemory := DllCall("VirtualAllocEx", "Ptr", hProcess, "Ptr", 0, "UPtr", CTRL_SIZE, "UInt", MEM_COMMIT, "UInt", MEM_PHYSICAL, "Ptr")
		; return remoteMemory
		return DllCall("VirtualAllocEx", "Ptr", hProcess, "Ptr", 0, "UPtr", CTRL_SIZE, "UInt", MEM_COMMIT, "UInt", MEM_PHYSICAL, "Ptr")
	}
	; ---------------------------------------------------------------------------
	; *************************************************************************
	; @function: Open the target process with PROCESS_VM_OPERATION, PROCESS_VM_READ, and PROCESS_VM_WRITE access
	; @param: tpID
	; @param: PROCESS_VM_READ
	; 		@param: Int32
	; 		@Dec_Value: 8
	; 		@Hex_Value: 0x00000008 ??? or 0x0018 ???
	; @param: PROCESS_VM_READ
	; 		@param: Int32
	; 		@Dec_Value: 16
	; 		@Hex_Value: 0x00000010 ??? or 0x0010
	; @param: PROCESS_VM_WRITE
	; 		@param: Int32
	; 		@Dec_Value: 32
	; 		@Hex_Value: 0x00000020 ??? or 0x0020
	; @example: hProcess := DllCall('OpenProcess', 'UInt', 0x0018 | 0x0010 | 0x0020, 'Int', 0, 'UInt', tpID, 'Ptr')
	; @returns: {hProcess}
	; ***********************************************************************/
	static _hProcess(tpID){
		Static PROCESS_VM_OPERATION := 8, PROCESS_VM_READ := 16, PROCESS_VM_WRITE := 32
		; hProcess := DllCall( 'OpenProcess', 'UInt'
							; , PROCESS_VM_OPERATION | PROCESS_VM_READ | PROCESS_VM_WRITE
							; , "Int", 0
							; , "UInt", tpID
							; , "Ptr")
		; return hProcess
		return DllCall( 'OpenProcess', 'UInt', PROCESS_VM_OPERATION | PROCESS_VM_READ | PROCESS_VM_WRITE, "Int", 0, "UInt", tpID, "Ptr")
	}
	; ---------------------------------------------------------------------------
	; rect := WindowGetRect("window title etc.")
	; MsgBox(rect.width "`n" rect.height)
	static hIntersectRect(l1, t1, r1, b1, l2, t2, r2, b2) {
		rect1 := Buffer(16), rect2 := Buffer(16), rectOut := Buffer(16)
		NumPut("int", l1, "int", t1, "int", r1, "int", b1, rect1)
		NumPut("int", l2, "int", t2, "int", r2, "int", b2, rect2)
		if DllCall("user32\IntersectRect", "Ptr", rectOut, "Ptr", rect1, "Ptr", rect2)
			return {l:NumGet(rectOut, 0, "Int"), t:NumGet(rectOut, 4, "Int"), r:NumGet(rectOut, 8, "Int"), b:NumGet(rectOut, 12, "Int")}
	}
	static WindowGetRect(hwnd) {
		try {
			rect := Buffer(64, 0) ; V1toV2: if 'rect' is a UTF-16 string, use 'VarSetStrCapacity(&rect, 16)'
			DllCall("GetClientRect", "Ptr", hwnd, "Ptr", rect)
			; return {width: NumGet(rect, 8, "Int"), height: NumGet(rect, 12, "Int")}
			return {Left: NumGet(rect, 0, "Int"), Top: NumGet(rect, 4, "Int"), Right: NumGet(rect, 8, "Int"), Bottom: NumGet(rect, 12, "Int"), Height: ((NumGet(rect, 12, "Int")) - (NumGet(rect, 4, "Int"))), Width: ((NumGet(rect, 8, "Int") - (NumGet(rect, 0, "Int")))) }
		}
	}
	static GetRect(hwnd, &RC := "", *) { ; Retrieves the rich edit control's formatting rectangle
	; Returns an object with keys L (eft), T (op), R (ight), and B (ottom).
	; If a variable is passed in the Rect parameter, the complete RECT structure will be stored in it.
	RC := Buffer(32, 0)
	; SendMessage(0x00B2, 0, RC.Ptr, HWND)
	SendMessage(178, 0, RC.Ptr, HWND)
	; Return {L: NumGet(RC, 0, "Int"), T: NumGet(RC, 4, "Int"), R: NumGet(RC, 8, "Int"), B: NumGet(RC, 12, "Int")}
	Return {Left: NumGet(RC, 0, "Int"), Top: NumGet(RC, 4, "Int"), Right: NumGet(RC, 8, "Int"), Bottom: NumGet(RC, 12, "Int"), Height: ((NumGet(RC, 12, "Int")) - (NumGet(RC, 4, "Int"))), Width: ((NumGet(RC, 8, "Int") - (NumGet(RC, 0, "Int")))) }
	}
	
	static GetClientSize(hCtl){
		BtnStructSize := 32
		; rc := Buffer(BtnStructSize, 0)
		rc := Buffer(BtnStructSize, 16)
		; Buffer(rc:=0,16)
		; DllCall("GetClientRect", "Ptr", hCtl, "Ptr", rc)
		tbRECT := hznHorizon.GETITEMRECT(hCtl)
		l:=tbRECT.Left
		b:=tbRECT.Bottom
		; SendMessage(Msg, wParam, lParam,, hTb)
		; l := NumGet(rc, 0, "Int")
		; t := NumGet(rc, 4, "Int")
		; r := NumGet(rc, 8, "int")
		; b := NumGet(rc, 12, "int")
		; w := l - r
		; h := b-t

		; MsgBox('w:' . w . ' ' . 'h: ' . h . '`n')
		; return {Left:l,Top:t,Right:r,Bottom:b,Width:w, Height:h}
		return {Left:l,Bottom:b}
	}

	static GetClientRect(hCtl, hCtl_title){
		
		mTX11 := Map()
		dpi_hzn := DPI.MonitorFromWindow('hznHorizon.exe')
		Info('dpi_hzn: ' . dpi_hzn, 30000)
		RECT := Buffer(32, 0)
		DllCall("MapWindowPoints", "Ptr", hCtl, "Ptr", 0, "Ptr", RECT, "UInt", 2)
		Left:= NumGet(RECT, 0, "Int")
		Top:= NumGet(RECT, 4, "Int"), 
		Right:= NumGet(RECT, 8, "Int")
		Bottom:= NumGet(RECT, 12, "Int")
		Width := (Left + (Right/2))
		Height := (Top + (Bottom/2))
		mTX11.Set('Left', Left, 'Right', Right, 'Top', Top, 'Bottom', Bottom, 'height', height, 'width', width)
		; Info(
		; 	'Left: ' . Left . ' ' . 'Right: ' . Right
		; 	. '`n'
		; 	'Top: ' . Top . '`n' . 'Bottom: ' . Bottom
		; 	. '`n'
		; 	'Height: ' . Height . '`n' . 'Width: ' . Width
		; 	, 30000)
		return mTX11
	}

	static _GETBUTTON(n:=1, hTb?, pID?, hProcess?){
		Static 	TB_GETBUTTON := 1047 ; hex = 0x417
		OutputDebug('n: ' n '`n')
		; pID := WinGetPID(hTb)
		pID := HznToolbar._pID()
		tpID := HznToolbar._tpID()
		hTb := HznToolbar._hTb()
		hProcess := hznHorizon._hProcess(tpID)
		; hProcess = 0 ? hProcess := hp_Remote(pID) : hpRemote := hpRemote
		remoteMemory := remote_buffer := hznHorizon.remote_mem_buff(hProcess,0,&TBBUTTON_SIZE)
		GETBUTTON := SendMessage(TB_GETBUTTON, n-1, remoteMemory, hTb, hTb)
		; MsgBox(GETBUTTON) ; ===> displays a zero (0)
		return GETBUTTON
	}
	static GETBUTTONINFO(hTb?){
		hTb := HznToolbar._hTb()
		; wParam := idButton, lParam := struct(), 
		; SendMessage(0x43F, wParam, lParam, , hTb) ; TB_GETBUTTONINFOW
		;;TBBUTTONINFO=48:32
	
		; typedef struct {
		; 	0: 0,
		; 	"UInt" UINT cbSize ;
		; 	4: 4,
		; 	"UInt" DWORD dwMask ;
		; 	8: 8,
		; 	"Int" int idCommand ;
		; 	12: 12,
		; 	"Int" int iImage ;
		; 	16: 16,
		; 	"UChar" BYTE fsState ;
		; 	17: 17,
		; 	"UChar" BYTE fsStyle ;
		; 	18: 18,
		; 	"UShort" WORD cx ;
		; 	24: 20,
		; 	"UPtr" DWORD_PTR lParam ;
		; 	32: 24,
		; 	"Ptr" LPTSTR pszText ;
		; 	40: 28,
		; 	"Int" int cchText ;
		; } TBBUTTONINFO, *LPTBBUTTONINFO ;
		; 48: 32
	}
	
	static GETBUTTONSTATE(idButton, hTb := HznToolbar._hTb()){
		Static TB_GETSTATE := 1042 ; 0x0412
		; hTb := HznToolbar._hTb()
		; btnCt := hznButtonCount()
		; Infos(btnCt)
		Msg := TB_GETSTATE, wParam := idButton, lParam := 0, control := hTb
		GETSTATE := SendMessage(TB_GETSTATE, wParam, lParam, hTb, hTb)
		btnstate := SubStr(GETSTATE,1,1)
		btnname := idButton = 100 ? 'Bold' : idButton = 101 ? 'Italic' : idButton = 102 ? 'Underline' : ''
		; If (btnstate = 4) || (btnstate = 6) || (btnstate = 1)
		; 	{
		; 	return btnstate
		; 	}
		; MsgBox(   'The ' btnname
		; 		. ' button is not available.' '`n'
		; 		. 'idButton: ' idButton '`n'
		; 		. 'btnstate: ' btnstate)
		; OutputDebug("btnstate: " . btnstate . "`n")
		return btnstate
	}
	; ---------------------------------------------------------------------------
	/**
	 * @function COMMANDBUTTON()
	 * @param Msg := WM_COMMAND
	 * @param wParam_hi := control defined notification code => := 0 or !btnstate (opposite of current position => 4 || 6)
	 * @param wParam_lo := control identifier => idCommand from above
	 * @param lParam 	:= handle to the control => hTb
	 */

	static COMMANDBUTTON(idCommand, hTb, btnstate:=0){
		Static WM_COMMAND := 273 ; hex = 0x111
		Static Msg := WM_COMMAND, wParam_hi := !btnstate , wParam_lo := idCommand, lParam := control := hTb := hTb
		; ---------------------------------------------------------------------------
		SendMessage(Msg, wParam_hi | wParam_lo,lParam,, hTb)
		; ---------------------------------------------------------------------------
		; if(btnstate = 4) ? SendMessage(TB_SETSTATE, idCommand, 6 | 0, hTb, hTb) : SendMessage(TB_SETSTATE, idCommand, 4 | 0, hTb, hTb)
		; WM_NCLBUTTONDOWN := 0x00A1
		; WM_NCLBUTTONUP := 0x00A2
		; SendMessage(WM_LBUTTONDOWN,,X1|Y1,hTb,hTb)
		; Sleep(100)
		; SendMessage(WM_LBUTTONUP,,X1|Y1,hTb,hTb)
	}
	; ---------------------------------------------------------------------------
	static Win32_64_Bit(hpRemote)
	; Win32_64_Bit(hpRemote, &Is32:='False')
	{
		A_Is64bitOS ? DllCall("IsWow64Process", "Ptr", hpRemote, "Int*", Is32bit := 0) : DllCall("IsWow64Process", "Ptr", hpRemote, "Int*", Is32bit := 1)
		; If (A_Is64bitOS)
		; 	{
		; 		Static Is32bit := 0
		; 	Try
		; 		DllCall("IsWow64Process", "Ptr", hpRemote, "Int*", Is32bit)
		; 	catch
		; 		Is32bit := 1
			Is32bit = 0 ? Is32:='False' : is32:='True'
		OutputDebug("Is32bit: " Is32 "`n")
		return Is32bit
	}
	; ---------------------------------------------------------------------------
	; /*
	static HznDPI(hCtl?,hCtl_title?, &arHznDPI:='', &DPIsc:=0)
	{
		hCtl := ControlGetFocus('A')
		hCtl_title := WinGetTitle(hCtl)
		arHznDPI := Array()
		try {
			nmHwnd 	:= GetNearestMonitorInfo().Handle
			nmName 	:= GetNearestMonitorInfo().Name
			nmNum 	:= GetNearestMonitorInfo().Number
			nmPri 	:= GetNearestMonitorInfo().Primary
			mDPIx 	:= GetNearestMonitorInfo().x
			mDPIy 	:= GetNearestMonitorInfo().y
			mDPIw 	:= GetNearestMonitorInfo().WinDPI
			DPImw 	:= DPI.GetForWindow('A')
			DPIsc 	:= DPI.GetScaleFactor(DPImw) ; <====== this one
			; DPIsc1 	:= DPI.GetScaleFactor(mDPIx)
		} catch Error as e {
			; OutputDebug('nmHwnd: '	nmHwnd '`n'
			; 		.	'nmName: '	nmName '`n'
			; 		.	'nmNum: '	nmNum '`n'
			; 		.	'nmPri: '	nmPri '`n'
			; 		.	'mDPIx: '	mDPIx '`n'
			; 		.	'mDPIy: '	mDPIy '`n'
			; 		.	'mDPIw: '	mDPIw '`n'
			; 		.	'DPImw: '	DPImw '`n'
			; 		.	'DPIsc: '	DPIsc '`n'
			; 		; .	'DPIsc1: '	DPIsc1 '`n'
			; 		.	'PriDPI: '	A_ScreenDPI '`n'
			; 		)		
			throw e		
		}
		arHznDPI.Push(
			{  	  Number: '(' nmNum ')'
				, 1_Handle:nmHwnd
				, 2_Name:nmName
				, 3_x:mDPIx
				, 4_y:mDPIy
				, 5_WinDPI:mDPIw
				, 6_MainWinDPI:DPImw
				, 7_ScreenDPI:DPIsc
			})
		; ---------------------------------------------------------------------------
		return {arHznDPI:arHznDPI,DPIsc:DPIsc}
	}
	; */
	; ---------------------------------------------------------------------------
	; TODO need to validate that this works, but not high priority
	/**
	 * @function.: for use in a button call that requires ControlCLick() and DPI adjustments
	 * @description Get the bounds of each button (Get Item Rectangle)
	 * @param GETITEMRECT( hProcess,n,remoteMemory,hTb,TBBUTTON_SIZE,Is32bit,&RECT,&BtnStructSize,&BtnStruct,&bytesRead,&Left,&Top,&Right,&Bottom, &X, &Y)
	*/	
	; GETITEMRECT(hProcess, n,remoteMemory,hTb, TBBUTTON_SIZE, Is32bit, &RECT, &BtnStructSize, &BtnStruct, &bytesRead, &Left, &Top, &Right, &Bottom, &X, &Y)
	static GETITEMRECT(hCtl)
	{
		; wParam := n, lParam := remoteMemory, control := ''
		Static Msg := TB_GETITEMRECT := 1053
		RECT := Buffer(32, 0)
		DllCall("GetClientRect", "Ptr", hCtl, "Ptr", 0, "Ptr", RECT, "UInt", 2)
		Left := NumGet(RECT, 0, "Int")
		Bottom := NumGet(RECT, 12, "Int")
		Info('Left: ' . Left . '`n' . 'Bottom: ' . Bottom, 30000)
		Return {Left:Left, Bottom:Bottom}
		; ---------------------------------------------------------------------------
		; Note: Updated 09.11.23
		; hCtl_title := WinGetTitle(hCtl)
		; DPIsc := HznDPI(hCtl,hCtl_title).DPIsc
		; X1 			:= Left
		; Y1 			:= Top
		; Left 		:= X1
		; Top			:= Y1
		; W1 			:= Right-Left
		; H1 			:= Bottom-Top
		; ; W 			:= W1/2
		; W 			:= W1
		; ; H 			:= H1/2
		; H 			:= H1
		; X2 			:= X1+W
		; Y2 			:= Y1+H
		; dpiX 		:= X2*=DPIsc
		; dpiY 		:= Y2*=DPIsc
		; dpiWidth	:= Round((W*=DPIsc),0)
		; dpiHeight 	:= Round((H*=DPIsc),0)
		; ---------------------------------------------------------------------------
		; OutputDebug(
		; MsgBox(	
		; 	'X1:' X1 . ' ' . 'Y1:' . Y1 .  ' ' . 'W1:' . W1 . ' ' . 'H1:' . H1 . '`n'
		; 	. 'W:' . W . " " . 'H:' . H . '`n'
		; 	. 'X2:' X2 . ' ' . 'Y2:' . Y2 . '`n'
		; 	. 'X:' . X . ' ' . 'Y:' . Y . '`n'
		; 	)
	}

	static somestufffortoolbar(idButton?, hTb?){
		buttons := hznHorizon._ButtonCount(&hTb)
		; hTb := HznToolbar._hTb()
		hTx := ControlGetFocus('A')
		pID := HznToolbar._pID()
		tpID := HznToolbar._tpID()
		Text := Buffer(128, 0)
		RECT := Buffer(32, 0)
		a_idButton := []
		aStrings := []
		a_text := []
		a_Rect := []
		vButton := ''
		idButton := ''
		vText := ''
		a_bText := ''
		b_bText := ''
		dText := ''
		vRect := ''
		text := ''
		TB_GETBUTTON := 1047
		Static Msg := TB_GETITEMRECT := 1053
		; Static Msg := EM_GETRECT := 178
		static wParam := 1
		Static PROCESS_VM_OPERATION := 8, PROCESS_VM_READ := 16, PROCESS_VM_WRITE := 32
		hCtl := hTb
		DllCall("GetWindowThreadProcessId", "Ptr", hCtl, "UInt*", &tpID := 0)
		hProcess := DllCall( 'OpenProcess', 'UInt', 8 | 16 | 32, "Int", 0, "UInt", tpID, "Ptr")
		Static MEM_PHYSICAL := 4 ; 0x04 ; 0x00400000, ; via MSDN Win32
		Static MEM_COMMIT := 4096
		Is32bit := 0, RPtrSize := Is32bit ? 4 : 8, CTRL_SIZE := 8 + (RPtrSize * 3) 
		remoteMemory := DllCall("VirtualAllocEx", "Ptr", hProcess, "Ptr", 1, "UPtr", CTRL_SIZE, "UInt", MEM_COMMIT, "UInt", MEM_PHYSICAL, "Ptr")
		; remoteMemory := remote_mem_buff(hProcess, , &CTRL_SIZE)
		lParam := remoteMemory
		SendMessage(Msg, wParam, lParam, hCtl, hCtl)
		RECT := Buffer(CTRL_SIZE, 0)
		; Note : Winapi TBBUTTON struct(32 bytes on x64, 20 bytes on x86)
		Is32bit := hznHorizon.Win32_64_Bit(remoteMemory)
		BtnStructSize := Is32bit ? 20 : 32
		; RECT := BtnStruct := Buffer(BtnStructSize, 0)
		; BtnStruct := Buffer(BtnStructSize, 0)
		; ---------------------------------------------------------------------------
		; * Read the button information stored in the RECT (remoteMemory)
		DllCall("ReadProcessMemory", "Ptr", hProcess, "Ptr", remoteMemory, "Ptr", RECT, "UPtr", BtnStructSize, "UInt*", &bytesRead:=32, "Int")
		Loop buttons {
			button := (A_Index + 99)
			idButton := String(button)
			; Get_Button := _GETBUTTON(idButton)
			hProcess := DllCall('OpenProcess', 'UInt', 8 | 16 | 32, "Int", 0, "UInt", tpID, "Ptr")
			remoteMemory := remote_buffer := hznHorizon.remote_mem_buff(hProcess,0,&TBBUTTON_SIZE)
			GETBUTTON := SendMessage(TB_GETBUTTON, idButton, remoteMemory, hTb, hTb)
	
			a_nText 	:= NumGet(Text, 0, 	"UInt")
			b_nText 	:= NumGet(Text, 4, 	"UInt")
			c_nText 	:= NumGet(Text, 8, 	"Int")
			d_nText 	:= NumGet(Text, 12, "Int")
			fsState 	:= NumGet(Text, 16, "UChar")
			fsStyle 	:= NumGet(Text, 17, "UChar")
			cxWORD 		:= NumGet(Text, 18, "UShort")
	
			Info(
				'[' button . '] ' 
				; '1 ' . txt_strcap . ' ' 
				; '2 ' . txt_buff . ' ' 
				'3 ' . a_bText   . ' ' 
				'4 ' . b_bText . ' ' 
				'5 ' . vText . ' ' 
				'6 ' . a_nText . ' '
				'7 ' . b_nText . ' ' 
				'8 ' . c_nText . ' '
				'9 ' . d_nText . ' ' 
				'10 ' . fsState . ' '
				'11 ' . fsStyle . ' '	
				'12 ' . cxWORD . ' '
				, 30000
			)
			; dText .= '[' . button . '] ' . 'a_bText: ' . a_bText . ' ' 
			; . 'b_bText: ' . b_bText . ' ' . 'vText: ' . vText . ' ' . 'a_nText: ' 
			; . a_nText . '`n' . 'b_nText: ' . b_nText . '`n' 
			; . 'c_nText: ' . c_nText . ' ' . 'd_nText: ' . d_nText . '`n'
			; dText := 'idButton: ' . button . '`n' . 'a_bText: ' . a_bText . '`n' . 'b_bText: ' . b_bText . '`n' . 'vText: ' . vText . '`n' . 'a_nText: ' 
			; ; . a_nText . '`n' . 'b_nText: ' . b_nText . '`n' 
			; . 'c_nText: ' . c_nText . '`n' . 'd_nText: ' . d_nText . '`n'
		}
		; Info(dText, 30000)
		; for each, idButton in a_idButton {
		; 	a_text.Push(text)
			; ---------------------------------------------------------------------------
		; SendMessage(0x433, idButton, RECT, hTx , hTx)	; TB_GETRECT
		DllCall("MapWindowPoints", "Ptr", hTx, "Ptr", 0, "Ptr", RECT, "UInt", 2)
		Left := NumGet(RECT, 0, "Int")
		Bottom := NumGet(RECT, 12, "Int")
		Info('Left: ' . Left . '`n' . 'Bottom: ' . Bottom, 30000)
		; 	a_Rect.Push(Left)
		; 	a_Rect.Push(Bottom)
		; }
		; for each, vButton in a_idButton {
		; 	idButton .= vButton . '`n'
		; 	for each, vText in a_text {
		; 		bText .= vText . '`n'
		; 	}
		; }
		; for each, vRect in a_Rect {
		; 	bRect := ''
		; 	bRect .= 'L: ' Left . ' ' . 'B: ' Bottom 
		; }
		; info(
		; 	'Buttond ID: ' 	. idButton 	. '`n'
		; 	'Text: ' 		. text 		. '`n'
		; 	'Left: ' 		. Left 		. '`n'
		; 	'Bottom: ' 		. Bottom 	. '`n'
		; 	, 30000
		; )
	}
	; ---------------------------------------------------------------------------
	/**
	 * Function: VirtualFreeEx
	 * @example
	Releases, decommits, or releases and decommits a region of memory within the 
	virtual address space of a specified process

	Parameters:
	hProcess - A valid handle to an open object. The handle must have the PROCESS_VM_OPERATION access right.

	Address - The pointer that specifies a desired starting address for the region to be freed. If the dwFreeType parameter is MEM_RELEASE, lpAddressmust be the base address returned by the VirtualAllocEx function when the region is reserved.
	Size - The size of the region of memory to be allocated, in bytes.If the FreeType parameter is MEM_RELEASE, dwSize must be 0 (zero). The function frees the entire region that is reserved in the initial allocation call to VirtualAllocEx.
	If FreeType is MEM_DECOMMIT, the function decommits all memory pages that contain one or more bytes in the range from the Address parameter to (lpAddress+dwSize). This means, for example, that a 2-byte region of memorythat straddles a page boundary causes both pages to be decommitted. If Address is the base address returned by VirtualAllocEx and dwSize is 0 (zero), thefunction decommits the entire region that is allocated by VirtualAllocEx. After that, the entire region is in the reserved state.
	FreeType - The type of free operation. This parameter can be one of the following values:
	MEM_DECOMMIT
	MEM_RELEASE

	Returns:
	If the function succeeds, the return value is a nonzero value.
	If the function fails, the return value is 0 (zero). 
	;! ---------------------------------------------------------------------------
	; ---------------------------------------------------------------------------
	static VirtualFreeEx(hProcess, Address, Size, FType){
		return DllCall("VirtualFreeEx"				 
	                    , "Ptr", hProcess				 
	                    , "Ptr", Address				 
	                    , "UInt", Size				 
	                    , "UInt", FType				 
	                    , "Int")
	}
	; ---------------------------------------------------------------------------
	/** ;! ---------------------------------------------------------------------------
	* Function: WriteProcessMemory
	* @example
	Description:
	Writes data to an area of memory in a specified process. The entire area to be written to must be accessible or the operation fails
	Parameters:
	* @param hProcess
	@example - A valid handle to an open object. The handle must have the PROCESS_VM_WRITE and PROCESS_VM_OPERATION access right.
	* @param BaseAddress
	@example - A pointer to the base address in the specified process to which data is written. Before data transfer occurs, the system verifies that all data in the base address and memory of the specified size is accessible for write access, and if it is not accessible, the function fails.

	* @param Buffer
	@example - A pointer to the buffer that contains data to be written in the address space of the specified process.

	* @param Size
	@example - The number of bytes to be written to the specified process.

	* @param NumberOfBytesWritten 
	@example - A pointer to a variable that receives the number of bytes transferred into the specified process. This parameter is optional. If NumberOfBytesWritten is NULL, the parameter is ignored.
	Returns:
		If the function succeeds, the return value is a nonzero value.
		If the function fails, the return value is 0 (zero). 
	*/ 
	;! ---------------------------------------------------------------------------

	static WriteProcessMemory(hProcess, BaseAddress, Buffer, Size, &NumberOfBytesWritten := 0){
		return DllCall("WriteProcessMemory"				 
	                    , "Ptr", hProcess				 
	                    , "Ptr", BaseAddress				 
	                    , "Ptr", Buffer				 
	                    , "Uint", Size				 
	                    , "UInt*", NumberOfBytesWritten				 
	                    , "Int")
	}
	; ---------------------------------------------------------------------------
	/** ;! ---------------------------------------------------------------------------
	* Function: ReadProcessMemory
	* @example 
	Reads data from an area of memory in a specified process. The entire area to be read must be accessible or the operation fails
	Parameters:
	hProcess 		- A valid handle to an open object. The handle must have the PROCESS_VM_READ access right.

	BaseAddress 	- A pointer to the base address in the specified process from which to read. Before any data transfer occurs, the system verifies that all data in the base address and memory of the specified size is accessible for read access, and if it is not accessible the function fails.

	buffer - A pointer to a buffer that receives the contents from the address space of the specified process.

	Size 	- The number of bytes to be read from the specified process.

	NumberOfBytesWritten - A pointer to a variable that receives the number of bytes transferred into the specified buffer. If lpNumberOfBytesRead is NULL, the parameter is ignored.
	Returns:
	If the function succeeds, the return value is a nonzero value.
	If the function fails, the return value is 0 (zero). 
	*/ 
	;! ---------------------------------------------------------------------------
	static ReadProcessMemory(hProcess, BaseAddress, Buffer, Size, &NumberOfBytesRead := 0){
		return DllCall("ReadProcessMemory", "Ptr", hProcess, "Ptr", BaseAddress,"Ptr", Buffer, "UInt", Size, "UInt*", NumberOfBytesRead, "Int")
	}
	; ---------------------------------------------------------------------------

	Class Experimental extends hznHorizon{
		; ---------------------------------------------------------------------------
		static lookie(){
			fCtl := WinPID := WinID := WinpE := hHzn := WinE := WinA := 0
			nCtl := WinPN := WinT := Hzn := gaWinT := text := state := visible := style := exstyle := name := item := hJson := ClassNN := WinC := list := fname := json_dir := json_dir_fname:=''
			wX := wY := wW := wH := ahWnd := 0
			hznArray := [], items := [], hznMapArray := []
			hznMap 	 := Map(), hznAMap := Map()
			; ---------------------------------------------------------------------------\
			; static json_dir := testjson.json_dir
			; static json_dirname := testjson.json_dirname
			; static jsongo_dirname := testjson.jsongo_dirname
			; ---------------------------------------------------------------------------
			; Infos('test')
			; IID:= '{66833FEA-8583-11D1-B16A-00C0F0283628}'
			; CLSID:= '{A7B26557-3DA6-11D5-92D4-0010A4D22E69}'

			; d := ComObject(clsid '.' iid)
			; MsgBox(
			; 	"Variant type:`t" ComObjType(d)
			; 	"Interface name:`t" ComObjType(d, "Name")
			; 	"Interface ID:`t" ComObjType(d, "IID")
			; 	"Class name:`t" ComObjType(d, "Class")
			; 	"Class ID (CLSID):`t" ComObjType(d, "CLSID")
			; )

			; return
			; default_fname := ('test' format(A_Now, 'YYYY.MM.DD') '.jsonc')
			Hzn := 'ahk_exe hznHorizon.exe'
			hHzn := WinWaitActive(Hzn)
			try fCtl := ControlGetFocus('A')
			try nCtl := ControlGetClassNN(fCtl)
			WinE := WinExist('ahk_exe hznHorizon.exe')
			WinA := WinActive('A')
			try WinPN := WinGetProcessName(WinA)
			try WinPID := WinGetPID('ahk_exe ' WinPN)
			try WinID := WinGetID(WinPID)
			try WinpE := WinExist(WinID)
			try {
				hGetAncestor := DllCall("GetAncestor", "UInt", hHzn, "Uint", 2)
				hGApID := WinGetProcessName(hGetAncestor)
				hWinE := WinExist(hGetAncestor)
				WinT := WinGetTitle(hGetAncestor)
				gaWinT := WinGetTitle(hWinE)
			}
			try WinT := WinGetTitle('A')
			; ---------------------------------------------------------------------------
			; Infos(WinpA '`n' WinT)
			Infos(
					'f: ' fCtl
					'`n'
					'n: ' nCtl
					'`n'
				'a: ' WinA
				'`n'
				'Proc: ' WinPN
				'`n'
				'pID: ' WinPID
				'`n'
				'pIDExist: ' WinpE
				'`n'
				'WinT: ' WinT
				'`n'
				'hGetAncestor: ' hGetAncestor
				'`n'
				'hGApID: ' hGApID
				'`n'
				'gaWinT: ' gaWinT
			)
			; ---------------------------------------------------------------------------
			; name := StrSplit(WinT, '  ', '  ' ,2)
			; ; fname := StrSplit(WinT, ' ',,3)
			; fname := StrSplit(name[1], ' - ' ,,3)
			; 	; ---------------------------------------------------------------------------
			; ; try Infos(
			; ; 		name[1]
			; ; 		'`n'
			; ; 		name[2]
			; ; 		; fname[3]
			; ; 	)
			; ; ---------------------------------------------------------------------------
			; ; fname := strsplit(fname[2], ' ',2)
			; fname[2] := RegExReplace(fname[2], ' ','-')
			; static jsonfname := fname[2] '.jsconc'
			; ; MsgBox(jsonfname,,3).OnEvent('Cancel', Exit())
			; ; ---------------------------------------------------------------------------
			; json_dir_fname := (json_dirname '\' jsonfname)
			; jsongo_dir_fname := (jsongo_dirname '\' jsonfname)
			; dirArray := [json_dirname, jsongo_dirname]
			; fileArray := [json_dir '\' jsonfname, json_dir_fname, jsongo_dir_fname]
			; result := '', text := '', existsArray:= []
			; ; ---------------------------------------------------------------------------
			; hznArray := WinGetControlsHwnd(WinT)
			; ; try Infos(fname[1] '`n' fname[2] '`n' fname[3])
			; ; hznArray := WinGetControlsHwnd(WinA)
			; ; ---------------------------------------------------------------------------
			; for each,value in dirArray {
			; 	If result := !DirExist(value) {
			; 		DirCreate(value)
			; 	}
			; 	(result = 0) ? result := 'Dir Exists' : result := 'Dir Created'
			; 	existsArray.Push(value ': ' result)
			; 	; Infos(result)
			; }
			; for each, value in fileArray {
			; 	if result := !FileExist(value) {
			; 		AppendFile(value, text)
			; 	}
			; 	(result = 0) ? result := 'File Exists' : result := 'File Created'
			; 	existsArray.Push(value ': ' result)
			; 	; Infos(result)
			; }
			; var := _ArrayToString(existsArray, ',`n')
			; Infos(var)
			; ---------------------------------------------------------------------------
			; hznArray := WinGetControlsHwnd(WinT)
			hznArray := WinGetControlsHwnd('A')
			for each, ahWnd in hznArray{
				try {
					ClassNN := ControlGetClassNN(ahWnd)
					SafeSet(hznAMap,ClassNN, ahWnd)
				} catch {
					WinC := WinGetClass(ahWnd)
					SafeSet(hznAMap,ClassNN, ahWnd)
				}
				SafeSetMap(hznAMap,hznMAP)
				for key, value in hznAMap {
					list .= key ' ' value '`n'
					hznMapArray.Push(key)
					hznMapArray.Push(value)
				}
				; a2s := hznMapArray.ToString()
				; Infos(a2s)
				; AppendFile((testjson.testdir '\' fname[1] '.ahk'), a2s)
			}	
				; return
			; wX := wY := wW := wH := ahWnd := 0
			DPI.WinGetPos(&wX,&wY,&wW,&wH,ahWnd)
			; try state := ControlGetEnabled(ahWnd)
			; 	; ---------------------------------------------------------------------------
			; 	if ((state != 0) &&	(wW != 0 || wH != 0)) {
			; 		try visible := ControlGetVisible(ahWnd)
			; 		if (visible != 0) {
			; 			try {
			; 				style := ControlGetStyle(ahWnd)
			; 				style := Format("0x{:08x}", style)
			; 				if (ClassNN ~= 'i)button') {
			; 					style := styleconverter(style)
			; 				}
			; 			}	
			; 			; } catch {
			; 			; 	style := WinGetStyle(ahWnd)
			; 			; 	style := Format("0x{:08x}", style)
			; 			; }
			; 			try exstyle := ControlGetExStyle(ahWnd)
			; 			try exstyle := Format("0x{:08x}", exstyle)
			; 			try text := '`n' ControlGetText(ahWnd)
			; 			try items := ControlGetItems(ahWnd)
			; 			try for each, item in items {
			; 				DrawBorder(item, 0x00FF00, toggle:=!toggle)
			; 				; Infos(
			; 					; OutputDebug(
			; 					; 	'C: ' ClassNN ' L[' items.Length '] ' item
			; 					; 	'`n'
			; 					; )
			; 					; test := (value != 'No' || 'Yes' || '')
			; 					; if test = 0 {
			; 						; 	test := 'false'
			; 						; } else {
			; 							; 	test := 'true'
			; 							; }
			; 							; Infos('test: ' test)
			; 							; if (value != '' || value != ' ' || value != '`t' || value != 'No' || value != 'Yes'){
			; 								; 	A_Clipboard := value
			; 								; 	try name := GetKeyName(value)
			; 								; 	Infos('[' value ']' name)
			; 								; KeyWait('RAlt', 'D')
			; 								; Infos.DestroyAll()
			; 								; }
			; 			}
			; 			; (text = '`n') ? text := text '(no text)' : text
			; 			; OutputDebug(
			; 			; 	ClassNN
			; 			; 	text
			; 			; 	'`n'
			; 			; 	'S[' state ']' 
			; 			; 	' Vis[' visible ']'
			; 			; 	' st[' style ']'
			; 			; 	' exst[' exstyle ']'
			; 			; 	'`n'
			; 			; 	'wX: ' wX
			; 			; 	' wY: ' wY
			; 			; 	' wW: ' wW
			; 			; 	' wH: ' wH
			; 			; 	'`n'
			; 			; )
			; 			; OutputDebug(toJson)
			; 			; DrawBorder(ahWnd)
			; 			; KeyWait('RAlt', 'D')
			; 		}
			; 	}
			; 	; ---------------------------------------------------------------------------
			; 	; toJson := (	
			; 	; 		ClassNN
			; 	; 		' S[' state ']' 
			; 	; 		' Vis[' visible ']'
			; 	; 		' st[' style ']'
			; 	; 		' exst[' exstyle ']'
			; 	; 		'`n'
			; 	; 		'wX: ' wX
			; 	; 		' wY: ' wY
			; 	; 		' wW: ' wW
			; 	; 		' wH: ' wH
			; 	; 		'`n'
			; 	; 		text
			; 	; 	)
			; 	; hJson .= toJson
			; 	if ((wW != 0 || wH != 0) && (visible != 0) ) {
			; 		try {
			; 			hznClass := ControlGetClassNN(value)
			; 			hznMap.Set(hznClass, value)
			; 		}
			; 	}
			; ; }
			; ---------------------------------------------------------------------------
			if ((wW != 0 || wH != 0) && (visible != 0) ) {
				try {
					hznClass := ControlGetClassNN(value)
					hznMap.Set(hznClass, value)
				}
			}
			for key, value in hznMap {
				; DrawBorder(value)
				DrawBorder(value, 0x00FF00, toggle:=!toggle)
				KeyWait('LAlt','D')
				; DPI.WinGetPos(&wX,&wY,&wW,&wH,value)
				; try visible := ControlGetVisible(value)
				; if ((wW != 0 || wH != 0) && (visible != 0) ) {
				; 	try text := '`n' ControlGetText(value)
				; 	try state := ControlGetEnabled(value)
				; 	; try visible := ControlGetVisible(value)
				; 	if (text = '`n'){
				; 		text := ''
				; 	}
				; 	if state != 0 {
				; 		; Infos(
				; 		; OutputDebug(
				; 		; 	'[' state '] '
				; 		; 	key ' (' value ')'
				; 		; 	' wX: ' wX
				; 		; 	' wY: ' wY
				; 		; 	' wW: ' wW
				; 		; 	' wH: ' wH
				; 		; 	text
				; 		; 	'`n'
				; 		; )
				; 		; DrawBorder(value)
				; 		; KeyWait('RAlt', 'D')
				; 	}
				; }
				; Infos.DestroyAll()
				; Infos(hznClassNN ' (' value ')')
				; Try {
				; 	hznClass := ControlGetClassNN(value)
				; }
				; Catch {
				; 	hznClass := WinGetClass(value)
				; }
				; Infos(hznClass)
				; DrawBorder(value)
				; KeyWait('LAlt','D')
				; Infos.DestroyAll()
			}
			;hznCtlJson := jsongo._Stringify(hznMap,'','`t', true)
			; if FileExist(fname[2] '.jsonc') {
			; 	FileDelete(fname[2] '.jsonc')
			; }

			;ApplyJson() => WriteFile(A_ScriptDir '\WriteToJSONTest\' fname[2] '.jsconc', json.stringify(hznMap,,'`t', true))
			;AppendFile(A_ScriptDir '\WriteToJSONGOTest\' fname[2] '.jsonc',hznCtlJson)
			; OutputDebug(hznCtlJson)
			; ---------------------------------------------------------------------------
			; DrawBorder(WA:=WinActive("A")){
			; 	Static OS:=3
			; 	Static BG:="FF0000"
			; 	Static myGui:=Gui("+AlwaysOnTop +ToolWindow -Caption","GUI4Border")
			; 	myGui.BackColor:=BG
			; 	; WA:=WinActive("A")
			; 	If WA && !WinGetMinMax(WA) && !WinActive("GUI4Border ahk_class AutoHotkeyGUI"){
			; 		DPI.WinGetPos(&wX,&wY,&wW,&wH,WA)
			; 		myGui.Show("x" wX " y" wY " w" wW " h" wH " NA")
			; 		Try WinSetRegion("0-0 " wW "-0 " wW "-" wH " 0-" wH " 0-0 " OS "-" OS " " wW-OS
			; 		. "-" OS " " wW-OS "-" wH-OS " " OS "-" wH-OS " " OS "-" OS,"GUI4Border")
			; 	}
			; 	Else{
			; 		myGui.Hide()
			; 	}
			; }
			; ---------------------------------------------------------------------------
			; F1::
			; hwnd := WinExist("A")
			; DrawBorder(hwnd, 0x00FF00, toggle:=!toggle)
			; Return

			DrawBorder(hwnd, color:=0xFF0000, enable:=1) {
				static DWMWA_BORDER_COLOR := 34
				static DWMWA_COLOR_DEFAULT	:= 0xFFFFFFFF
				R := (color & 0xFF0000) >> 16
				G := (color & 0xFF00) >> 8
				B := (color & 0xFF)
				color := (B << 16) | (G << 8) | R
				DllCall("dwmapi\DwmSetWindowAttribute", "ptr", hwnd, "int", DWMWA_BORDER_COLOR, "int*", enable ? color : DWMWA_COLOR_DEFAULT, "int", 4)
			}
			; hGui := Gui(fCtl)
			; hGui := Gui(rCtl)
			; text := RichEdit(hGui,'',true).GetRTF()
			; OutputDebug(
			; 	; 'rCtl: ' rCtl
			; 	'`n'
			; 	'Control: ' nCtl
			; 	' (' fCtl ')'
			; 	'`n'
			; 	'text:`n' text
			; )
			; SaveToJson(*) {		
			; 	hznMap.Set(WinT, Map("title", Saved.RecTitle,	"recommendation", Saved.RecText, "hazard", Saved.RecHazard, "technical detail", Saved.RecTechDetail))
				
			; 	this.ApplyJson()
			; }

			styleconverter(style){
				StyleMap := Map(
					0x6 , 'BS_AUTO3STATE' ; Creates a button that is the same as a three-state check box, except that the box changes its state when the user selects it. The state cycles through checked, indeterminate, and cleared.
					,
					0x3 , 'BS_AUTOCHECKBOX' ; Creates a button that is the same as a check box, except that the check state automatically toggles between checked and cleared each time the user selects the check box.
					,
					0x9 , 'BS_AUTORADIOBUTTON'	; Creates a button that is the same as a radio button, except that when the user selects it, the system automatically sets the button's check state to checked and automatically sets the check state for all other buttons in the same group to cleared.
					,
					0x100 , 'BS_LEFT' ; +/-Left. Left-aligns the text.
					,
					0x0 , 'BS_PUSHBUTTON' ; Creates a push button that posts a WM_COMMAND message to the owner window when the user selects the button.
					,
					0x1000 , 'BS_PUSHLIKE' ; Makes a checkbox or radio button look and act like a push button. The button looks raised when it isn't pushed or checked, and sunken when it is pushed or checked.
					,
					0x200 , 'BS_RIGHT' ; +/-Right. Right-aligns the text.
					,
					0x20 , 'BS_RIGHTBUTTON' ; +Right (i.e. +Right includes both BS_RIGHT and BS_RIGHTBUTTON, but -Right removes only BS_RIGHT, not BS_RIGHTBUTTON). Positions a checkbox square or radio button circle on the right side of the control's available width instead of the left.
					,
					0x800 , 'BS_BOTTOM' ; Places the text at the bottom of the control's available height.
					,
					0x300 , 'BS_CENTER' ; +/-Center. Centers the text horizontally within the control's available width.
					,
					0x1 , 'BS_DEFPUSHBUTTON' ; +/-Default. Creates a push button with a heavy black border. If the button is in a dialog box, the user can select the button by pressing Enter, even when the button does not have the input focus. This style is useful for enabling the user to quickly select the most likely option.
					,
					0x2000 , 'BS_MULTILINE' ; +/-Wrap. Wraps the text to multiple lines if the text is too long to fit on a single line in the control's available width. This also allows linefeed (`n) to start new lines of text.
					,
					0x4000 , 'BS_NOTIFY' ; Enables a button to send BN_KILLFOCUS and BN_SETFOCUS notification codes to its parent window. Note that buttons send the BN_CLICKED notification code regardless of whether it has this style. To get BN_DBLCLK notification codes, the button must have the BS_RADIOBUTTON or BS_OWNERDRAW style.
					,
					0x400 , 'BS_TOP' ; Places text at the top of the control's available height.
					,
					0xC00 , 'BS_VCENTER' ; Vertically centers text in the control's available height.
					,
					0x8000 , 'BS_FLAT' ; Specifies that the button is two-dimensional; it does not use the default shading to create a 3-D effect.
					,
					0x7 , 'BS_GROUPBOX' ; Creates a rectangle in which other controls can be grouped. Any text associated with this style is displayed in the rectangle's upper left corner.
				)
				for key, value in StyleMap {
					if style ~= key {
						return value
					}
				}
			}

		}
		/**
		#HotIf WinActive('ahk_exe hznHorizon.exe')
		#+1::style := ControlGetStyle(ControlGetFocus('A')), Infos('Done`n' 'Style: ' style)
		#+2::eStyle := ControlGetExStyle(ControlGetFocus('A')), Infos('Done`n' 'Style: ' eStyle)
		#+3::ControlSetExStyle(style := '+128', ControlGetFocus('A')), Infos('Done`n' 'Style: ' style)
		#+4::ControlSetExStyle(eStyle := '+4', ControlGetFocus('A')), Infos('Done`n' 'Style: ' eStyle)
		#+5::style := WinGetStyle(ControlGetFocus('A')), Infos('Done`n' 'Style: ' style)
		#+6::eStyle := WinGetExStyle(ControlGetFocus('A')), Infos('Done`n' 'Style: ' eStyle)
		#+7::WinSetExStyle(style := '+640', ControlGetFocus('A')), Infos('Done`n' 'Style: ' style)
		#+8::WinSetExStyle(eStyle := '+0', ControlGetFocus('A')), Infos('Done`n' 'Style: ' eStyle)
		; ^+!w::(style := '+4', ControlSetStyle(style,HznToolbar._hTx(),'A'), Infos('Done`n' style))
		^+!w::{
			style := ''
			A_Clipboard := ''
			Style := ControlGetStyle(fCtl := ControlGetFocus('A'),'A'),
			eStyle := ControlGetExStyle(fCtl := ControlGetFocus('A'),'A'),
			Infos('Done`n' style)
			A_Clipboard := style
		}
		;? TX11
		; 1444937728
		; 4
		;? ThunderRT6TextBox21
		; 1411448900
		; 512
		#+9::(Infos(ControlGetFocus('A') '`n' SendMessage(189, 0, 0, WinActive('A'))))
		#HotIf
		*/
	}

	; tab::(Suspend(1), (WinGetTitle(ControlGetFocus('A')) ~= 'i)txttextbox') ? HznSendTabSC() : HznTab(), Suspend(0))
	; #HotIf ControlGetFocus('MSMaskWndClass13')

	static HznTab() => Send('^{sc17}') ;? Ctrl & i

	; HznTab() => (Suspend(1), SendLevel(A_SendLevel + 1), SendEvent('{sc0F}'), Suspend(0), SendLevel(0))

	; HznSendTabSC() => Send('{sc0F}') ;? {Tab}

}

; ---------------------------------------------------------------------------
class testjson extends Paths {
	static testdirname := 'WriteFileTest'
	static testdir := Paths.Lib '\' testjson.testdirname
	static json_dir := testjson.testdir
	static json_dirname := testjson.json_dir '\WriteToJSONTest'
	static jsongo_dirname := testjson.json_dir '\WriteToJSONGOTest'
}
; ---------------------------------------------------------------------------

#HotIf

; --------------------------------------------------------------------------------
GetTbInfo()
{
    SendLevel(A_SendLevel+1) ; SendLevel higher than anything else (normally highest is 1)
    BlockInput(1) ; 1 = On, 0 = Off
    TbInfo := Array()
    try {
        hCtl := ControlGetFocus('A')
        fCtl := ControlGetClassNN(hCtl)
        fCtlI := SubStr(fCtl, -1, 1)
        nCtl := "msvb_lib_toolbar" fCtlI ; ! => would love to regex this to anything containing 'bar' || toolbar || ?
        hTb := ControlGethWnd(nCtl, "A")
        hTx := ControlGethWnd(fCtl, "A")
        pID := WinGetPID(hTb)
        DllCall("GetWindowThreadProcessId", "Ptr", hTb, "UInt*", &tpID := 0)
    } catch Error as e {
        return e
    }

    TbInfo.Push(hCtl, fCtl, fCtlI, nCtl, hTb, hTx, pID, tpID)
    return { hCtl: hCtl, fCtl: fCtl, fCtlI: fCtlI, nCtl: nCtl, hTb: hTb, hTx: hTx, pID: pID, tpID: tpID }
}
DisplayObj(Obj, Depth:=10, IndentLevel:="")
{
    list := ''
    if Type(Obj) = "Object"
        Obj := Obj.OwnProps()
    for k,v in Obj
        {
            List.= IndentLevel "[" k "]"
            ; List.= IndentLevel
            if (IsObject(v) && Depth>1)
                List.="`n" DisplayObj(v, Depth-1, IndentLevel . "    ")
            Else
                ; List.=" => " v
                List.=v
            ; List.= v
            List.="`n"
        }
        return RTrim(List)
}
DisplayArr(Obj, Depth:=10, IndentLevel:="")
{
    if Type(Obj) = "Array"
        Obj := Obj.OwnProps()
    for k,v in Obj
        {
            List.= IndentLevel "[" k "]"
            if (IsObject(v) && Depth>1)
                List.="`n" DisplayObj(v, Depth-1, IndentLevel . "    ")
            Else
                List.=" => " v
            List.="`n"
        }
        return RTrim(List)
}
; --------------------------------------------------------------------------------
