/************************************************************************
 * function ......: Auto Execution (AE)
 * @description ..: A work in progress (WIP) of standard AE setup(s)
 * @file AE.v2.ahk
 * @author OvercastBTC
 * @date 2024.06.13
 * @version 2.0.0
 * @ahkversion v2+
 ***********************************************************************/
; @revision(2.0.0)...: Converted all functions to a Class
; --------------------------------------------------------------------------------
/************************************************************************
 * function ...........: Resource includes for .exe standalone
 * @author OvercastBTC
 * @date 2023.08.15
 * @version 3.0.2
 ***********************************************************************/
;@Ahk2Exe-IgnoreBegin
; #Include <CheckUpdate\ScriptVersionMap>
; version :=  ScriptVersion.ScriptVersionMap['main'] 
;@Ahk2Exe-IgnoreEnd
SetVersion := "3.0.0" ; If quoted literal not empty, do 'SetVersion'
;@Ahk2Exe-Nop
;@Ahk2Exe-Obey U_V, = "%A_PriorLine~U)^(.+")(.*)".*$~$2%" ? "SetVersion" : "Nop"
;@Ahk2Exe-%U_V% %A_PriorLine~U)^(.+")(.*)".*$~$2%
; --------------------------------------------------------------------------------
#Requires AutoHotkey v2+
#Warn All, OutputDebug
#SingleInstance Force
#WinActivateForce
; --------------------------------------------------------------------------------
;! Need to investigate this stuff
; #MaxThreads 255 ; Allows a maximum of 255 instead of default threads.
; #MaxThreadsBuffer true
; A_MaxHotkeysPerInterval := 1000
; --------------------------------------------------------------------------------
SendMode("Input")
SetWorkingDir(A_ScriptDir)
SetTitleMatchMode(2)
; --------------------------------------------------------------------------------
AE.DH(true)
AE.SetDelays(-1)
AE.DPIAwareness()

; --------------------------------------------------------------------------------
/**
 * Function: Includes
 */
; #Include <Includes\Includes_Standard>

#Include <Includes\Includes_Extensions>
#Include <Includes\Includes_DPI>
#Include <Tools\Info>
#Include <Utils\ClipSend>
#Include <Tools\explorerGetPath.v2>
#Include <App\Autohotkey>
#Include <Tools\InternetSearch>
#Include <Tools\WAPI\WAPI>

; #Include <Includes\Includes_Runner>
; #Include <Abstractions\Script>
; ---------------------------------------------------------------------------
/**
 * Function ..: Create a shellhook to monitor for changes in Monitor DPI based on the Window location (hopefully).
 */
; ShellHook(A_DPI_GetInfo)
; ---------------------------------------------------------------------------
; toggleCapsLock(){
; 	SetCapsLockState(!GetKeyState('CapsLock', 'T'))
; }
toggleCapsLock() => AE.toggleCapsLock()
; ---------------------------------------------------------------------------
; ; _AE_bInpt_sLvl(n := 1) => (SendLevel(0), SendLevel(A_SendLevel + n), BlockInput(n))
; _AE_bInpt_sLvl(n := 1) => AE.BISL(n := 1)
; ; ---------------------------------------------------------------------------

; ; ---------------------------------------------------------------------------
; ; @i...: Old Method with a return value of original SendMode()
; ; ---------------------------------------------------------------------------
; _AE_SendModeEvent() => AE.SME()
; _AE_SME() => AE.SME()
; ; ---------------------------------------------------------------------------
; ; @i...: New Method with a return object
; ; ---------------------------------------------------------------------------
; _AE_SendMode() => AE.SM()
; ; ---------------------------------------------------------------------------
; _AE_SM() => AE.SM()
; ---------------------------------------------------------------------------
; **************************************************************************
; ---------------------------------------------------------------------------
; **************************************************************************
; @function...: Restore the SendMode() & SetKeyDelay()
; @i..........: Restore initial values from return object
; @example....: SendMode()  => default: SendMode('Event')
; @example....: s := A_SendMode, d := A_KeyDelay, p := A_KeyDuration
; **************************************************************************
; ---------------------------------------------------------------------------
; _AE_rSM(RestoreObject) => AE.rSM(RestoreObject)
; ---------------------------------------------------------------------------
; **************************************************************************
; ---------------------------------------------------------------------------
_AE_DetectHidden(n := 1) => AE._DetectHidden(n := 1)
; --------------------------------------------------------------------------------
_AE_SetDelays(n := -1) => AE.SetDelays(n := -1)
; --------------------------------------------------------------------------------
_AE_PerMonitor_DPIAwareness() => AE.DPIAwareness()

Class AE {
    static toggleCapsLock() => SetCapsLockState(!GetKeyState('CapsLock', 'T'))
	; --------------------------------------------------------------------------------
	static _DetectHidden(n := 1){
		DetectHiddenText(n)
		DetectHiddenWindows(n)
	}
	; ---------------------------------------------------------------------------
    ; @i...: Syntax Sugar
    ; ---------------------------------------------------------------------------
    /**
	 * Same as _DetectHidden(n := 1)
	 * @param {Integer} n 
	 */
	static DH(n := 1) => this._DetectHidden(n := 1)
	static DetectHidden(n := 1) => this._DetectHidden(n := 1)
	; --------------------------------------------------------------------------------
	static _SetDelays(n := -1) {
		SetControlDelay(n)
		SetMouseDelay(n)
		SetWinDelay(n)
	}
    ; ---------------------------------------------------------------------------
    ; @i...: Syntax Sugar
    ; ---------------------------------------------------------------------------
    static SetDelays(n := -1) => this._SetDelays(n := -1)
	; --------------------------------------------------------------------------------
    ; **************************************************************************
    ; @i...: Set or return the DPIAwareness
    ; **************************************************************************
	static _AE_PerMonitor_DPIAwareness() {
		; global A_DPIAwareness
		static n := 0
		static MaximumPerMonitorDpiAwarenessContext := VerCompare(A_OSVersion, '>=10.0.15063') ? -4 : -3
		static n := MaximumPerMonitorDpiAwarenessContext
		static DefaultDpiAwarenessContext := MaximumPerMonitorDpiAwarenessContext
        static A_DPIAwareness := DefaultDpiAwarenessContext
        switch {
            case n:
                DllCall('SetThreadDpiAwarenessContext', 'ptr', n, 'ptr')
            case n = -4:
                DllCall('SetThreadDpiAwarenessContext', 'ptr', -4, 'ptr')
            case n = -3:
                DllCall('SetThreadDpiAwarenessContext', 'ptr', -3, 'ptr')   
            default:
                DllCall('SetThreadDpiAwarenessContext', 'ptr', -4, 'ptr')
        }
		return A_DPIAwareness
	}
	static _DPIAwareness() {
		global A_DPIAwareness
		A_DPIAwareness := DPI().WinGetDpi('A')
		; tooltip(A_DPIAwareness)
		return A_DPIAwareness
	}
    ; ---------------------------------------------------------------------------
    ; @i...: Syntax Sugar
    ; ---------------------------------------------------------------------------    
    static DPIAwareness() => this._DPIAwareness()
    ; ---------------------------------------------------------------------------

    ; **************************************************************************
    ; @i...: Default: bi := 0 => BlockInput(0)
    ; @i...: Default: n  := 1 => SendLevel(A_SendLevel + n)
    ; **************************************************************************
    static _BlockInputSendLevel(n := 1, bi := 0, &sl?) {
		SendLevel(0)
        sl := A_SendLevel
        (sl < 100) ? SendLevel(sl + n) : SendLevel(n + n)
        (n >= 1) ? bi := 1 : bi := 0 
        BlockInput(bi)
		return sl
    }

    static BISL(n := 1, bi := 0, &sl?) => this._BlockInputSendLevel(n := 1, bi := 0, &sl?)
	static BI(bi := 1) => BlockInput(bi)
	static rBI(bi := 0) => BlockInput(bi)
	; static rBISL(s) => (this.rBI(bi:=0), SendLevel(s))
	static slBISL(&sl) => this.BISL(n := 1, bi := 0, &sl?)
	static rBISL(sl) => this._restoreBlockInputSendLevel(sl)
	static _restoreBlockInputSendLevel(sl){
		this.rBI(0)
		SendLevel(sl)
	}
    ; **************************************************************************
    ; @function...: Change the SendMode() & SetKeyDelay()
    ; @i..........: Store initial values to be used in return for restoration
    ; @example....: SendMode()  => default: SendMode('Event')
    ; @example....: s := A_SendMode, d := A_KeyDelay, p := A_KeyDuration
    ; **************************************************************************
    ; ---------------------------------------------------------------------------
    ; @i...: New Method with a return object
    ; ---------------------------------------------------------------------------
    static _SendMode(&SendModeObj?, &s?, &d?, &p?){
        s := A_SendMode, d := A_KeyDelay, p := A_KeyDuration
        SetKeyDelay(-1, -1)
        SendMode('Event')
        return SendModeObj := {s:s, d:d, p:p}
    }
    ; ---------------------------------------------------------------------------
    ; @i...: Syntax Sugar
    ; ---------------------------------------------------------------------------
    static SM(&SendModeObj?, &s?, &d?, &p?) => this._SendMode(&SendModeObj?, &s?, &d?, &p?) 
    ; ---------------------------------------------------------------------------
    
    ; ---------------------------------------------------------------------------
    ; **************************************************************************
    ; @function...: Restore the SendMode() & SetKeyDelay()
    ; @i..........: Restore initial values from return object
    ; @example....: SendMode()  => default: SendMode('Event')
    ; @example....: s := A_SendMode, d := A_KeyDelay, p := A_KeyDuration
    ; **************************************************************************
    ; ---------------------------------------------------------------------------
    static _RestoreSendMode(RestoreObject){
        SetKeyDelay(RestoreObject.d, RestoreObject.p)
        SendMode(RestoreObject.s)
    }
    ; ---------------------------------------------------------------------------
    ; @i...: Syntax Sugar
    ; ---------------------------------------------------------------------------
    static rSM(RestoreObject) => this._RestoreSendMode(RestoreObject)
    ; ---------------------------------------------------------------------------
    ; **************************************************************************
    ; ---------------------------------------------------------------------------
    ; **************************************************************************
    ; @function...: Set the SendMode() & SetKeyDelay() & SendLevel() & BlockInput()
    ; @i..........: Store initial values to be used in return for restoration
    ; @i..........: Can also obtain the value via the &variable (whatever that is called)
    ; @example....: SendMode()  => default: SendMode('Event')
    ; @example....: SendModeObj := {s:s := A_SendMode, d:d := A_KeyDelay, p:p := A_KeyDuration}
	; @function...: BISL(n := 1, bi := 0) => _BlockInputSendLevel(n := 1, bi := 0)
	; @i..........: Set the SendLevel() & BlockInput()
    ; @default....: n  := 1 => SendLevel(A_SendLevel + n)
	; @default....: bi := 0 => BlockInput(0)
	; @i..........: if n >= 1 => bi := 1 => you only need to input one number
	; @example....: AE.BISL(1) => n:=1 => bi := 1 => SendLevel(A_SendLevel + 1) => BlockInput(1)
    ; **************************************************************************
    ; ---------------------------------------------------------------------------
    static _SendMode_SendLevel_BlockInput(&SendModeObj?, n := 1){
        this.SM(&SendModeObj)
		this.BISL(1)
		return SendModeObj
    }
    ; ---------------------------------------------------------------------------
    ; @i...: Syntax Sugar
    ; ---------------------------------------------------------------------------
    static SM_BISL(&SendModeObj?, n := 1) => this._SendMode_SendLevel_BlockInput(&SendModeObj?, n := 1)
    ; ---------------------------------------------------------------------------
    ; **************************************************************************
	static _restore_SendMode_SendLevel_BlockInput(RestoreObj){
		this.BISL(0)
		this.rSM(RestoreObj)
	}
    ; ---------------------------------------------------------------------------
    ; @i...: Syntax Sugar
	; @function: this._restoreSendModeBlockInputSendLevel(RestoreObj)
    ; ---------------------------------------------------------------------------
	static rSM_BISL(RestoreObj) => this._restore_SendMode_SendLevel_BlockInput(RestoreObj)
    ; **************************************************************************
    ; @i: Clip_Sleep()
    ; @step: If clipboard still in use (long paste), sleep for a bit
    ; @param: n ...: default value = 10 ms
    ; ---------------------------------------------------------------------------
    static _Clipboard_Sleep(n:=10){
        loop n {
            Sleep(n)
        ; } Until !DllCall('GetOpenClipboardWindow')
        ; } Until !WAPI.GetOpenClipboardWindow() || (A_Index = 50)
        ; } Until !DllCall('GetOpenClipboardWindow') || (A_Index = 50)
        } Until (!this.GetOpenClipWin() || (A_Index = 50))
    }
    ; ---------------------------------------------------------------------------
    ; @i...: Sytax Sugar
    ; ---------------------------------------------------------------------------
    static cSleep(n:=10) => this._Clipboard_Sleep(n:=10)
    ; ---------------------------------------------------------------------------
    ; **************************************************************************
	static EmptyClipboard() => DllCall('User32\EmptyClipboard', 'int')
	static CloseClipboard() => DllCall('User32\CloseClipboard', 'int')
	static GetOpenClipboardWindow() => DllCall('GetOpenClipboardWindow')
	static GetOpenClipWin() => this.GetOpenClipboardWindow()
    ; ---------------------------------------------------------------------------

    ; **************************************************************************
    ; @region: _Clipboard_Backup_Clear()
    ; @param: cBak ...: clipboard backup 
    ; ---------------------------------------------------------------------------
	static _Clipboard_Backup_Clear(&cBak?){
		; ---------------------------------------------------------------------------
		; @i...: Backup current clipboard
		; ---------------------------------------------------------------------------
		cBak := ClipboardAll()
		; ---------------------------------------------------------------------------
		; @i...: Clear current clipboard
		; ---------------------------------------------------------------------------
		; EmptyClipboard() => WAPI.EmptyClipboard()
		this.EmptyClipboard()
		this.cSleep(100)
		; WAPI.CloseClipboard()
		this.CloseClipboard()
		return cBak
	}
    ; ---------------------------------------------------------------------------
    ; @SyntaxSugar...: Sytax Sugar
    ; ---------------------------------------------------------------------------
    static cBakClr(&cBak?) => this._Clipboard_Backup_Clear(&cBak?)
    ; ---------------------------------------------------------------------------
    ; **************************************************************************

    ; ---------------------------------------------------------------------------

    ; **************************************************************************
    ; @region: _Clipboard_Restore()
    ; @param: cBak ...: clipboard backup 
    ; ---------------------------------------------------------------------------
	static _Clipboard_Restore(cBak){
		; ---------------------------------------------------------------------------
		; @i...: Restore current clipboard
		; ---------------------------------------------------------------------------
		SetTimer(() => this.cSleep(50), -500)
		A_Clipboard := cBak
		; WAPI.CloseClipboard()
		this.CloseClipboard()
	}
    ; ---------------------------------------------------------------------------
    ; @SyntaxSugar...: Sytax Sugar
    ; ---------------------------------------------------------------------------
    static cRestore(cBak) => this._Clipboard_Restore(cBak)
    ; ---------------------------------------------------------------------------
    ; **************************************************************************
	static Timer(time:=100) => SetTimer(()=>AE.cSleep(0), time:=-100)
	static hfCtl(&fCtl?) {
		return fCtl := ControlGetFocus('A')
	}
	; ---------------------------------------------------------------------------
	static EM_SETSEL := 177
	static _Select(wParam, lParam) {
		; Static Msg := EM_SETSEL := 177
		return DllCall('SendMessage', 'UInt', this.hfCtl(), 'UInt', this.EM_SETSEL, 'UInt', wParam, (wParam = 0 && lParam = -1) ? 'UIntP' : 'UInt', lParam)
	}
	; static _Select(wParam, lParam, hCtl := ControlGetFocus('A')) => DllCall('SendMessage', 'UInt', hCtl, 'UInt', Msg := EM_SETSEL := 177, 'UInt', wParam, (wParam = 0 && lParam = -1) ? 'UIntP' : 'UInt', lParam)
	static sAll() => this._Select_All()
	static _Select_All() => this._Select( 0, -1)
	static sBegin() => this._Select_Beginning()
	static _Select_Beginning() => this._Select( 0,  0)
	static sEnd() => this._Select_End()
	static _Select_End() => this._Select(-1, -1)


; /************************************************************************
; @i...: GetKey sc/vk returns a base 10 value, when both of those are actually base 16.
; @i...: This makes no sense. So, we use format to format a base 10 integer into a base 16 int for both of them
; @i...: key_name := GetKeyName(key), key_SC := GetKeySC(key), key_VK := GetKeyVK(key)
; @i...: key_SC := Format("sc{:X}", key_SC), key_VK := Format("vk{:X}", key_VK)
; @edit: Combined into a single function
;  ***********************************************************************/
	static SC_Convert(key){
		key_SC := GetKeySC(key)
		return key_SC := Format("sc{:X}", key_SC)
	}
}
Class key {
	static k := {
		alt : 'sc38',
		shift : 'sc2A',
		ctrl : 'sc1D',
		tab : 'scF',
		equal : 'scD',
		F5 : 'sc3F',
		a : 'sc1E',
		b : 'sc30',
		c : 'sc2E',
		d : 'sc20',
		e : 'sc12',
		f : 'sc21',
		g : 'sc22',
		h : 'sc23',
		i : 'sc17',
		p : 'sc19',
		s : 'sc1F',
		v : 'sc2F',
		x : 'sc2D',
		y : 'sc15',
		z : 'sc2C',
	}
	static down := ' down'
	static up := ' up'
	static b1   := '{'
	static b2   := '}'
	; ---------------------------------------------------------------------------
	static alt          := this.b1 this.k.alt this.b2
	static altdown      := this.b1 this.k.alt this.down this.b2
	static altup        := this.b1 this.k.alt this.up this.b2
	; ---------------------------------------------------------------------------
	static ctrl          := this.b1 this.k.ctrl this.b2
	static ctrldown      := this.b1 this.k.ctrl this.down this.b2
	static ctrlup        := this.b1 this.k.ctrl this.up this.b2
	; ---------------------------------------------------------------------------
	static shift        := this.b1 this.k.shift this.b2
	static shiftdown    := this.b1 this.k.shift this.down this.b2
	static shiftup      := this.b1 this.k.shift this.up this.b2
	; ---------------------------------------------------------------------------
	static tab          := this.b1 this.k.tab this.b2
	static tabdown      := this.b1 this.k.tab this.down this.b2
	static tabtup       := this.b1 this.k.tab this.up this.b2
	; ---------------------------------------------------------------------------
	static a            := this.b1 this.k.a this.b2
	static adown        := this.b1 this.k.a this.down this.b2
	static aup          := this.b1 this.k.a this.up this.b2
	; ---------------------------------------------------------------------------
	static b            := this.b1 this.k.b this.b2
	static bdown        := this.b1 this.k.b this.down this.b2
	static bup          := this.b1 this.k.b this.up this.b2
	; ---------------------------------------------------------------------------
	static c            := this.b1 this.k.c this.b2
	static cdown        := this.b1 this.k.c this.down this.b2
	static cup          := this.b1 this.k.c this.up this.b2
	; ---------------------------------------------------------------------------
	static d            := this.b1 this.k.d this.b2
	static ddown        := this.b1 this.k.d this.down this.b2
	static dup          := this.b1 this.k.d this.up this.b2
	; ---------------------------------------------------------------------------
	static e            := this.b1 this.k.e this.b2
	static edown        := this.b1 this.k.e this.down this.b2
	static eup          := this.b1 this.k.e this.up this.b2
	; ---------------------------------------------------------------------------
	static f            := this.b1 this.k.f this.b2
	static fdown        := this.b1 this.k.f this.down this.b2
	static fup          := this.b1 this.k.f this.up this.b2
	; ---------------------------------------------------------------------------
	static g            := this.b1 this.k.g this.b2
	static gdown        := this.b1 this.k.g this.down this.b2
	static gup          := this.b1 this.k.g this.up this.b2
	; ---------------------------------------------------------------------------
	static h            := this.b1 this.k.h this.b2
	static hdown        := this.b1 this.k.h this.down this.b2
	static hup          := this.b1 this.k.h this.up this.b2
	; ---------------------------------------------------------------------------
	static i            := this.b1 this.k.i this.b2
	static idown        := this.b1 this.k.i this.down this.b2
	static iup          := this.b1 this.k.i this.up this.b2
	; ---------------------------------------------------------------------------
	static p            := this.b1 this.k.p this.b2
	static pdown        := this.b1 this.k.p this.down this.b2
	static pup          := this.b1 this.k.p this.up this.b2
	; ---------------------------------------------------------------------------
	static s            := this.b1 this.k.s this.b2
	static sdown        := this.b1 this.k.s this.down this.b2
	static sup          := this.b1 this.k.s this.up this.b2
	; ---------------------------------------------------------------------------
	static v            := this.b1 this.k.v this.b2
	static vdown        := this.b1 this.k.v this.down this.b2
	static vup          := this.b1 this.k.v this.up this.b2
	; ---------------------------------------------------------------------------
	static x            := this.b1 this.k.x this.b2
	static xdown        := this.b1 this.k.x this.down this.b2
	static xup          := this.b1 this.k.x this.up this.b2
	; ---------------------------------------------------------------------------
	static y            := this.b1 this.k.y this.b2
	static ydown        := this.b1 this.k.y this.down this.b2
	static yup          := this.b1 this.k.y this.up this.b2
	; ---------------------------------------------------------------------------
	static z            := this.b1 this.k.z this.b2
	static zdown        := this.b1 this.k.z this.down this.b2
	static zup          := this.b1 this.k.z this.up this.b2
	; ---------------------------------------------------------------------------
	static paste 		:= this.ctrldown this.v this.ctrlup
	; ---------------------------------------------------------------------------
	static copy 		:= this.ctrldown this.c this.ctrlup
	; ---------------------------------------------------------------------------
	static selectall	:= this.ctrldown this.a this.ctrlup
	; ---------------------------------------------------------------------------
	static find 		:= this.altdown this.shiftdown this.d this.shiftup this.altup
	static replace 		:= this.altdown this.shiftdown this.p this.shiftup this.altup
	; ---------------------------------------------------------------------------
	static save			:= this.altdown this.f this.s this.altup 						;? LAlt down, f, s, LAlt up
}
; SetClipboardFont(isItalic := false, isBold := false, isUnderline := false, isStrikeOut := false, isSubscript := false, isSuperscript := false
; 	, nHeight := 0, nWidth := 0, nEscapement := 0, nOrientation := 0, nCharSet := 1, nOutPrecision := 3, nQuality := 1, nPitchAndFamily := 49, lpszFace := 'Times New Roman', fontSize := 11) {
	; t:= ''
	
SetClipboardFont(isItalic := false, isBold := false, isUnderline := false, isStrikeOut := false, isSubscript := false, isSuperscript := false
	, nHeight := 0, nWidth := 0, nEscapement := 0, nOrientation := 0, nCharSet := 0, nOutPrecision := 0, nQuality := 0, nPitchAndFamily := 0, lpszFace := 'Times New Roman', fontSize := 11) {
	; hdc := DllCall("GetDC", "ptr", fCtl := ControlGetFocus('A'), 'ptr')
	hdc := DllCall("GetDC", "ptr", fCtl := ControlGetFocus('A'), 'ptr')
	fnWeight := isBold ? 700 : 400
	fnItalic := isItalic ? 1 : 0
	fnUnderline := isUnderline ? 1 : 0
	fnStrikeOut := isStrikeOut ? 1 : 0
	fnSubscript := isSubscript ? 1 : 0
	fnSuperscript := isSuperscript ? 1 : 0
	; Mapping nCharSet options to corresponding values
	charSetOptions := Map("ANSI_CHARSET", 0, "DEFAULT_CHARSET", 1, "SYMBOL_CHARSET", 2, "SHIFTJIS_CHARSET", 128, "HANGEUL_CHARSET", 129, "HANGUL_CHARSET", 129, "GB2312_CHARSET", 134, "CHINESEBIG5_CHARSET", 136, "OEM_CHARSET", 255)
	;    nCharSet := charSetOptions[nCharSet] ? charSetOptions[nCharSet] : charSetOptions["DEFAULT_CHARSET"]
	; Mapping nOutPrecision options to corresponding values
	outPrecisionOptions := Map("OUT_DEFAULT_PRECIS", 0, "OUT_STRING_PRECIS", 1, "OUT_CHARACTER_PRECIS", 2, "OUT_STROKE_PRECIS", 3, "OUT_TT_PRECIS", 4, "OUT_DEVICE_PRECIS", 5, "OUT_RASTER_PRECIS", 6, "OUT_TT_ONLY_PRECIS", 7, "OUT_OUTLINE_PRECIS", 8)
	;    nOutPrecision := outPrecisionOptions[nOutPrecision] ? outPrecisionOptions[nOutPrecision] : outPrecisionOptions["OUT_DEFAULT_PRECIS"]
	; Mapping nQuality options to corresponding values
	qualityOptions := Map("DEFAULT_QUALITY", 0, "DRAFT_QUALITY", 1, "PROOF_QUALITY", 2, "NONANTIALIASED_QUALITY", 3, "ANTIALIASED_QUALITY", 4)
	;    nQuality := qualityOptions[nQuality] ? qualityOptions[nQuality] : qualityOptions["DEFAULT_QUALITY"]
	; Mapping nPitchAndFamily options to corresponding values
	pitchAndFamilyOptions := Map("DEFAULT_PITCH", 0, "FIXED_PITCH", 1, "VARIABLE_PITCH", 2, "FF_DONTCARE", 0<<4, "FF_ROMAN", 1<<4, "FF_SWISS", 2<<4, "FF_MODERN", 3<<4, "FF_SCRIPT", 4<<4, "FF_DECORATIVE", 5<<4)
	;    nPitchAndFamily := pitchAndFamilyOptions[nPitchAndFamily] ? pitchAndFamilyOptions[nPitchAndFamily] : pitchAndFamilyOptions["FIXED_PITCH"]
	hfont := DllCall("CreateFont", "int", nHeight, "int", nWidth, "int", nEscapement, "int", nOrientation
		, "int", fnWeight, "uint", fnItalic, "uint", fnUnderline, "uint", fnStrikeOut, "uint", nCharSet
		, "uint", nOutPrecision, "uint", 0, "uint", nQuality, "uint", nPitchAndFamily, "str", lpszFace)
	oldFont := DllCall("SelectObject", "ptr", hdc, "ptr", hfont)
	DllCall("DeleteObject", "ptr", oldFont)
	DllCall("ReleaseDC", "ptr", 0, "ptr", hdc)
	return hfont
}
__AE_CopyLib() {
	local Lib := A_MyDocuments '\AutoHotkey\Lib'
	If !(DirExist(Lib)) {
		DirCreate(Lib)
	}
	FileCopy(A_ScriptName, Lib A_ScriptName, 1)
}

; AE_Select(hCtl := ControlGetFocus('A'), wParam := 0, lParam := -1) {
; 	Static Msg := EM_SETSEL := 177
; 	return DllCall('SendMessage', 'UInt', hCtl, 'UInt', Msg, 'UInt', wParam, 'UIntP', lParam)
; }
AE_Select(wParam, lParam, hCtl := ControlGetFocus('A')) => DllCall('SendMessage', 'UInt', hCtl, 'UInt', Msg := EM_SETSEL := 177, 'UInt', wParam, 'UIntP', lParam)
AE_SelectAll() => AE_Select(0, -1)
; AE_SelectAll(hCtl := ControlGetFocus('A'),*) {
; 	Static Msg := EM_SETSEL := 177, wParam := 0, lParam := -1
; 	return DllCall('SendMessage', 'UInt', hCtl, 'UInt', Msg, 'UInt', wParam, 'UIntP', lParam)
; }
AE_Select_End() =>( DllCall('SendMessage', 'UInt', ControlGetFocus('A'), 'UInt', 177, 'UInt', -1, 'UInt', -1), g := AE_GetScrollPos()) ; , Infos(g.X '`n' g.Y))
AE_Select_Beginning() => (DllCall('SendMessage', 'UInt', ControlGetFocus('A'), 'UInt', 177, 'UInt', 0, 'UInt', 0), g := AE_GetScrollPos()) ; , Infos(g.X '`n' g.Y))
; AE_Select_End(hCtl := ControlGetFocus('A')) {
; 	Static Msg := EM_SETSEL := 177, wParam := -1, lParam := -1
; 	return DllCall('SendMessage', 'UInt', hCtl, 'UInt', Msg, 'UInt', wParam, 'UInt', lParam)
; }
; AE_Select_Beginning(hCtl := ControlGetFocus('A')) {
; 	Static Msg := EM_SETSEL := 177, wParam := 0, lParam := 0
; 	DllCall('SendMessage', 'UInt', hCtl, 'UInt', Msg, 'UInt', wParam, 'UInt', lParam)
; }
AE_GetScrollPos() { ; Obtains the current scroll position
	; Returns on object with keys 'X' and 'Y' containing the scroll position.
	static Msg := EM_GETSCROLLPOS := 1245 ; 0x04DD
	PT := Buffer(8, 0)
	SendMessage(Msg, 0, PT.Ptr, ControlGetFocus('A'))
	Return {X: NumGet(PT, 0, 'Int'), Y: NumGet(PT, 4, 'Int')}
}
; ------------------------------------------------------------------------------------------------------------------
AE_SetScrollPos(X, Y) { ; Scrolls the contents of a rich edit control to the specified point
	; X : x-position to scroll to.
	; Y : y-position to scroll to.
	; EM_SETSCROLLPOS = 0x04DE
	PT := Buffer(8, 0)
	NumPut('Int', X, 'Int', Y, PT)
	Return SendMessage(0x04DE, 0, PT.Ptr, ControlGetFocus('A'))
}
; --------------------------------------------------------------------------------
AE_ScrollCaret() { ; Scrolls the caret into view
	EM_SCROLLCARET := 0x00B7
	SendMessage(EM_SCROLLCARET, 0, 0, ControlGetFocus('A'))
	Return True
}
AE_MoveCaret() { ; Scrolls the caret into view
	EM_LINESCROLL := 0x00B6
	SendMessage(EM_LINESCROLL, 0, 1, ControlGetFocus('A'))
	Return True
}

; ---------------------------------------------------------------------------
; @function Set_Sel() ...: Set, or highlight, the text to be selected
; @params ...: wParam := 0, lParam := 0, fCtl := 0, hWnd := tryHwnd()
; @params ...: wParam = Starting Char, lParam = Ending Char
; ---------------------------------------------------------------------------
AE_Set_Sel(wParam := 0, lParam := 0, fCtl := 0, hWnd := 0) {
	Static Msg := EM_SETSEL := 177
	; if (hWnd = 0) {
	; 	hWnd := tryHwnd()
	; }
	; if fCtl {
	; 	DllCall('SendMessage', 'UInt', fCtl, 'UInt', Msg, 'UInt', wParam, 'UIntP', lParam)
	; }
	; if !fCtl {
	; 	; DllCall('SendMessage', 'UInt', hWnd, 'UInt', Msg, 'UInt', Start, 'UInt', End)
	; 	DllCall('SendMessage', 'UInt', hWnd, 'UInt', Msg, 'UInt', wParam, 'UIntP', lParam)
	; 	; SendMessage(Msg, wParam, lParam,, hWnd)
	; }
	; return SendMessage(Msg, wParam, lParam, fCtl, 'A')
	return DllCall('SendMessage', 'UInt', fCtl, 'UInt', Msg, 'UInt', wParam, 'UInt', lParam)
}
AE_Get_TEXTLIMIT(*) {
	Static Msg := WM_GETTEXT := 0x000D
	afont := []
	buff_size := 64000
	wParam := &buff_size, lParam := &buff
	VarSetStrCapacity(&buff, buff_size)
	; Static Msg := EM_GETLIMITTEXT := 1061, wParam := 0, lParam := 0
	; Static Msg := EM_GETTEXTLENGTH := 0x000E, wParam := 0, lParam := 0
	; Static Msg := WM_GETFONT := 0x0031, wParam := 0, lParam := 0
	; text := StrPtr('hznRTE ')
	; Static Msg := WM_SETTEXT := 0x000C, wParam := 0, lParam := text
	try (fCtl := ControlGetFocus('A'), ClassNN := ControlGetClassNN(fCtl))
	hWnd := tryHwnd()
	hCtl := ControlGetFocus('A')
	; Limit := DllCall('SendMessage', 'UInt', hCtl, 'UInt', Msg, 'UInt', wParam, 'UInt', lParam)
	; Limit := SendMessage(Msg,wParam, lParam, hCtl, hCtl)
	Text := SendMessage(Msg,wParam, lParam, hCtl, hCtl)
	afont := GuiCtrlTextSize(hCtl,text)
	for each, value in afont {
		font := ''
		font .= value . '`n'
	}
	; Infos(font)
	GuiCtrlTextSize(GuiCtrlObj, Text)
	{
		Static WM_GETFONT := 0x0031, DT_CALCRECT := 0x400
		hDC := DllCall('GetDC', 'Ptr', GuiCtrlObj.Hwnd, 'Ptr')
		hPrevObj := DllCall('SelectObject', 'Ptr', hDC, 'Ptr', SendMessage(WM_GETFONT, , , GuiCtrlObj), 'Ptr')
		height := DllCall('DrawText', 'Ptr', hDC, 'Str', Text, 'Int', -1, 'Ptr', buf := Buffer(16), 'UInt', DT_CALCRECT)
		width := NumGet(buf, 8, 'Int') - NumGet(buf, 'Int')
		DllCall('SelectObject', 'Ptr', hDC, 'Ptr', hPrevObj, 'Ptr')
		DllCall('ReleaseDC', 'Ptr', GuiCtrlObj.Hwnd, 'Ptr', hDC)
		Return { Width: Round(width * 96 / A_ScreenDPI), Height: Round(height * 96 / A_ScreenDPI) }
	}
	; Return Limit
}
; ---------------------------------------------------------------------------
; @function GetSelText() ...: Retrieves the currently selected text as plain text
; @i ...: Returns selected text.
; ---------------------------------------------------------------------------
AE_GetSelText(fCtl := 0, hWnd := tryHwnd()) { 
	static EM_GETSELTEXT := 0x043E, EM_EXGETSEL := 0x0434
	Txt := ''
	Try (fCtl := ControlGetFocus('A'), ClassNN := ControlGetClassNN(fCtl))
	CR := AE_GetSel()
	TxtL := CR.E - CR.S + 1
	If (TxtL > 1) {
		VarSetStrCapacity(&Txt, TxtL)
		if (fCtl = 0) {
			SendMessage(EM_GETSELTEXT, 0, StrPtr(Txt), hWnd, hWnd)
			; SendMessage(0x043E, 0, StrPtr(Txt), , hWnd)
		} else {
			SendMessage(EM_GETSELTEXT, 0, StrPtr(Txt), fCtl, hWnd)
		}
		VarSetStrCapacity(&Txt, -1)
	}
	Return Txt
}
; ---------------------------------------------------------------------------
; @function GetSel() ...: Retrieves the starting and ending character positions of the selection in a rich edit control
; ---------------------------------------------------------------------------
; AE_GetSel(fCtl := ControlGetFocus('A'), hWnd := tryHwnd()) { 
; 	; Returns an object containing the keys S (start of selection) and E (end of selection)).
; 	Static Msg := EM_GETSEL := 176
; 	wParam := 0, lParam := 0
; 	try (fCtl := ControlGetFocus('A'), ClassNN := ControlGetClassNN(fCtl))
; 	wParam := Buffer(8, 0) ; LOWORD => start
; 	lParam := Buffer(8, 0) ; HIWORD => end
; 	; CR := Buffer(8, 0) ; LOWORD => start
; 	; CE := Buffer(8, 0) ; HIWORD => end
	
; 	;! ---------------------------------------------------------------------------
; 	; @i ... Working Calls
; 	; ---------------------------------------------------------------------------
; 	; DllCall('SendMessage', 'UInt', fCtl, 'UInt', Msg, 'UInt', wParam.Ptr, 'UInt', 0)
; 	; DllCall('SendMessage', 'UInt', fCtl, 'UInt', Msg, 'UInt', 0, 'UInt', lParam.Ptr)
; 	; ---------------------------------------------------------------------------
; 	DllCall('SendMessage', 'UInt', fCtl, 'UInt', Msg, 'UInt', wParam.Ptr, 'UInt', lParam.Ptr)
; 	; DllCall('SendMessage', 'UInt', fCtl, 'UInt', Msg, 'ptr', wParam.Ptr, 'ptr', lParam.Ptr) ;? (AJB - 2024.01.19) this also works
; 	; ---------------------------------------------------------------------------
; 	; SendMessage(Msg, wParam.Ptr, lParam.Ptr, fCtl)
; 	;! ---------------------------------------------------------------------------
; 	Return {S: NumGet(wParam,0,'uint'), E: NumGet(lParam,0, 'uint')}
; 	; Return {S: NumGet(wParam,0,'uint'), E: NumGet(lParam,4, 'uint')}
; 	; Return {S: NumGet(CR, 0, 'Int'), E: NumGet(CE, 0, 'Int')}
; }
; ---------------------------------------------------------------------------
; @i ...: Retrieves the starting and ending character positions of the selection in a rich edit control
; @i ...: Works great in ThunderRT6TextBox
; @i ...: Will retrieve the total in TX11
; ---------------------------------------------------------------------------
^+F1::AE_GetStats()
AE_GetSel(fCtl := ControlGetFocus('A'), hWnd := WinActive('A')) { 
	; Returns an object containing the keys S (start of selection) and E (end of selection)).
	Msg := EM_GETSEL := 176
	; Msg := EM_EXGETSEL := 1076 ; 0x0434
	wParam := Buffer(8, 0) ; LOWORD => start
	lParam := Buffer(8, 0) ; HIWORD => end
	SendMessage(Msg, wParam.Ptr, lParam.Ptr, fCtl, hWnd)
	; SendMessage(Msg, 0, lParam.Ptr, fCtl, hWnd)
	; SendMessage(Msg, 0, lParam.Ptr, , fCtl)
	; SendMessage(Msg, wParam.Ptr, 0, , fCtl)
	; SendMessage(Msg, wParam.Ptr, 0, fCtl, hWnd)
	; DllCall('SendMessage', 'UInt', fCtl, 'UInt', Msg, 'UInt', wParam.Ptr, 'UInt', lParam.Ptr)
	; DllCall('SendMessage', 'UInt', fCtl, 'UInt', Msg, 'UInt', wParam.Ptr, 'UInt', 0)
	; DllCall('SendMessage', 'UInt', fCtl, 'UInt', Msg, 'UInt', 0, 'UInt', lParam.Ptr)
	Infos(
		'S: ' NumGet(wParam, 0,'uint')
		'`n'
		'E: ' NumGet(lParam, 0,'uint')
		)
	Return {S: NumGet(wParam, 0,'uint'), E: NumGet(lParam, 4, 'uint')}
	; Return {S: NumGet(wParam, 0,'uint'), E: NumGet(wParam, 4, 'uint')}
}
; --------------------------------------------------------------------------------
; @function: GetText() ...: Gets the whole content of the control as plain text
; --------------------------------------------------------------------------------
AE_GetText(fCtl := 0, hWnd := tryHwnd()) {  
	; EM_GETTEXTEX = 0x045E
	Txt := '', TxtL := 0
	try (fCtl := ControlGetFocus('A'), ClassNN := ControlGetClassNN(fCtl))
	; GETTEXTEX structure
	GTX := Buffer(12 + (A_PtrSize * 2), 0) 
	NumPut('UInt', TxtL * 2, GTX) ; cb
	NumPut('UInt', 1200, GTX, 8)  ; codepage = Unicode
	If (TxtL := AE_GetTextLen() + 1) {
		; If (TxtL := AE_GetTextLen(fCtl, hWnd) + 1) {
		VarSetStrCapacity(&Txt, TxtL)
		if (fCtl = 0) {
			SendMessage(0x045E, GTX.Ptr, StrPtr(Txt), hWnd, hWnd)
			; SendMessage(0x045E, GTX.Ptr, StrPtr(Txt), , hWnd)
		} else {
			SendMessage(0x045E, GTX.Ptr, StrPtr(Txt), fCtl, hWnd)
		}
		VarSetStrCapacity(&Txt, -1)
	}
	Return Txt
}
; ---------------------------------------------------------------------------
; @function: GetTextLen() ...: Calculates text length in various ways
; ---------------------------------------------------------------------------
AE_GetTextLen(fCtl := 0, hWnd := tryHwnd()) { 
	static EM_GETTEXTLENGTHEX := 0x045F
	; ---------------------------------------------------------------------------
	; @GETTEXTLENGTHEX GETTEXTLENGTHEX Structure
	; ---------------------------------------------------------------------------
	GTL := Buffer(8, 0)
	; codepage = Unicode
	NumPut('UInt', 1200, GTL.Ptr, 4)  
	if (fCtl = 0) {
		; txtL := SendMessage(EM_GETTEXTLENGTHEX, GTL.Ptr, 0, hWnd,hWnd)
		; SendMessage(EM_GETTEXTLENGTHEX, GTL.Ptr, 0, ,hWnd)
		try (fCtl := ControlGetFocus('A'), ClassNN := ControlGetClassNN(fCtl))
		txtL := SendMessage(EM_GETTEXTLENGTHEX, GTL.Ptr, 0, fCtl)
	} else (
		txtL := SendMessage(EM_GETTEXTLENGTHEX, GTL.Ptr, 0, WinActive('A'))
		; txtL := SendMessage(EM_GETTEXTLENGTHEX, GTL.Ptr, 0, fCtl,hWnd)
	)
	Return txtL
}
; ---------------------------------------------------------------------------
; @GETTEXTLENGTHEX GETTEXTLENGTHEX Structure
; ---------------------------------------------------------------------------
struct_GTL(fCtl := 0, hWnd := tryHwnd()) => struct_GETTEXTLENGTHEX(fCtl := 0, hWnd := tryHwnd())
struct_GETTEXTLENGTHEX(fCtl := 0, hWnd := tryHwnd()) {
	; codepage = Unicode
	GTL := Buffer(8, 0)
	return NumPut('UInt', 1200, GTL.Ptr, 4)  
}
; ---------------------------------------------------------------------------
; @function ReplaceSel() ...: Replaces the selected text with the specified text
; ---------------------------------------------------------------------------
_AE_ReplaceSel(Text := '') { ; Replaces the selected text with the specified text
	Msg := EM_REPLACESEL := 0x00C2
	; WM_SETTEXT := 0x000C
	Return SendMessage(Msg, 1, StrPtr(Text), ControlGetFocus('A'))
}
EM_REPLACESEL := 0x00C2
AE_ReplaceSel(Text := '', fCtl := 0, hWnd := tryHwnd()) { 
	static EM_REPLACESEL := 194 ; 0xC2
	; try (fCtl := ControlGetFocus('A'), ClassNN := ControlGetClassNN(fCtl))
	; If (fCtl = 0) {
	; 	try text := SendMessage(EM_REPLACESEL, 1, StrPtr(Text), fCtl, hWnd)
	; }else if (text = '') {
	; 	try text := SendMessage(EM_REPLACESEL, 1, StrPtr(Text), , hWnd)
	; } else {
	; 	; SndMsgPaste()
	; }
	; Return SendMessage(EM_REPLACESEL, 1, StrPtr(Text), fCtl, hWnd)
	Return SendMessage(EM_REPLACESEL, 1, StrPtr(Text), fCtl)
	; Return text
}
; ---------------------------------------------------------------------------
tryHwnd() {
	hWnd := ''
	try hWnd := ControlGetFocus('A')
	if !hWnd {
		try hWnd := WinActive('A')
	}
	if !hWnd {
		try hWnd := WinGetID('A')
	}
	return hWnd
}
; --------------------------------------------------------------------------------
; Line handling
; --------------------------------------------------------------------------------
; @function GetCaretLine() ...: Get the line containing the caret
; ---------------------------------------------------------------------------
AE_GetCaretLine(line := -1, fCtl := ControlGetFocus('A'), hWnd := tryHwnd()) {
	static EM_LINEINDEX := 187, EM_EXLINEFROMCHAR := 1078, EM_LINEFROMCHAR:= 201
	CL := 0
	; try ClassNN := ControlGetClassNN(fCtl)
	; If (fCtl = 0) {
		;! original Result := (SendMessage(EM_LINEINDEX, -1, 0, ,hWnd)-1) ;? starting character number
		;! original CL :=     (SendMessage(EM_LINEFROMCHAR, line, 0,     , hWnd) + 1)
		Result := (SendMessage(EM_LINEINDEX,    line, 0, hWnd, hWnd)) ;? starting character number
		CL :=     (SendMessage(EM_LINEFROMCHAR, line, 0, hWnd, hWnd) + 1)
		; Result := (SendMessage(EM_LINEINDEX,    line, 0, , hWnd) - 1) ;? starting character number
		; CL :=     (SendMessage(EM_LINEFROMCHAR, line, 0, , hWnd) + 1)
	; } else {
		Result := (SendMessage(EM_LINEINDEX,    line, 0, fCtl, hWnd)) ;? starting character number
		CL := 	  (SendMessage(EM_LINEFROMCHAR, line, 0, fCtl, hWnd) + 1)
	; }
	; Result := SendMessage(EM_LINEINDEX, line, 0, ClassNN,hWnd)
	; CL := (SendMessage(EM_EXLINEFROMCHAR,0, 100, ClassNN, hWnd) + 1)
	Return CL
	; Result := SendMessage(EM_LINEINDEX, line, 0, fCtl)
	; Return SendMessage(EM_LINEFROMCHAR, 0, Result, fCtl) + 1
}
; --------------------------------------------------------------------------------
; Get the total number of lines
; ---------------------------------------------------------------------------
AE_GetLineCount(fCtl := ControlGetFocus('A'), hWnd := tryHwnd()) {
	static EM_GETLINECOUNT := 186
	LC := 0
	LC := SendMessage(EM_GETLINECOUNT,0,0,fCtl,'A')
	; LC := SendMessage(EM_GETLINECOUNT,,,,'ahk_id ' hWnd)
	; try ClassNN := ControlGetClassNN(fCtl)
	; If (fCtl = 0) {
	; 	; LC := SendMessage(0xBA,,,hWnd,hwnd)
	; 	LC := SendMessage(EM_GETLINECOUNT,,,,hwnd)
	; } else {
	; 	LC := SendMessage(EM_GETLINECOUNT,0,0,fCtl,'A')
	; }
	; Infos('LC: ' LC)
	Return LC := SendMessage(EM_GETLINECOUNT,0,0,fCtl,'A')
	; Return LC := SendMessage(EM_GETLINECOUNT,,,fCtl,'A')
}
Edit_GetLineCount(hEdit, hWnd){
    Static EM_GETLINECOUNT:=0xBA
    Return SendMessage(EM_GETLINECOUNT,0,0,hEdit, hWnd)
}
; --------------------------------------------------------------------------------
; Get the index of the first character of the specified line.
; ---------------------------------------------------------------------------
AE_GetLineIndex(LineNumber := -1, fCtl := 0, hWnd := tryHwnd()) { 
	Static EM_LINEINDEX := 187 ;, LI := 0
	; LineNumber   -  zero-based line number
	; if !fCtl => ControlGetFocus('A')
	LI := SendMessage(EM_LINEINDEX, LineNumber, , fCtl, hWnd)
	Return LI 
}
AE_GetLinePos(fCtl:=0){
	LI := AE_GetLineIndex(, fCtl)
	LP 	 := Buffer(A_PtrSize, 0)
	LinePos := (NumGet(LP, 'Ptr') - (LI + 1))
}
; --------------------------------------------------------------------------------
; Statistics
; Get some statistic values
; Get the line containing the caret, it's position in this line, the total amount of lines, the absulute caret
; position and the total amount of characters.
; EM_GETSEL = 0xB0, EM_LINEFROMCHAR = 0xC9, EM_LINEINDEX = 0xBB, EM_GETLINECOUNT = 0xBA
; --------------------------------------------------------------------------------
AE_GetStats(fCtl := ControlGetFocus('A'), hWnd := tryHwnd()) {
	static EM_LINEINDEX := 187, EM_EXLINEFROMCHAR := 1078
	static EM_GETSEL := 176, EM_LINEFROMCHAR:= 201, EM_GETLINE := 196
	; fCtl := 0
	SB := 0, LI := 0, start := 0, end := 0
	LinePos := 0,Line := 0,LineCount := 0,CharCount := 0, 
	CurrentCol :=  Result := Result1 := LinePos1 := num_of_chars := GetCaretLine := LI1 := LineCount1 := MaxLinePos := L := 0, 
	sel := '', getline := 0, selected := '', ClassNN := ''
	getsel := [], getsel1 := [], ctrls := [], ctrl := []
	; Stats := {}
	; Stats := [LinePos,Line,LineCount,CharCount]
	Stats := []
	SB 	 := Buffer(A_PtrSize, 0)
	SBgl := Buffer(A_PtrSize, 0)
	; try (fCtl := ControlGetFocus('A'), ClassNN := ControlGetClassNN(fCtl)) ;, Infos(ClassNN)
	(fCtl := ControlGetFocus('A'), ClassNN := ControlGetClassNN(fCtl)) ;, Infos(ClassNN)
	; If ClassNN = 0 {
	; 	ClassNN := unset
	; }
	; egcl := EditGetLineCount(ClassNN)
	; try getSel := AE_GetSel(fCtl, hWnd)
	try getSel := AE_GetSel(fCtl)
	; try Selected := EditGetSelectedText(fCtl, hWnd)
	; try MaxLinePos := SendMessage(EM_GETSEL, SB.Ptr, 0,fCtl,hWnd) ;? total characters in edit control
	; try LineCount := EditGetLineCount(fCtl,'A')
	; try LineCount1 := AE_GetLineCount(fCtl, hWnd)
	;!try  LineCount1 := Edit_GetLineCount(fCtl, hWnd)
	;!try  getline := SendMessage(EM_GETLINE,1, SBgl.Ptr, fCtl, hWnd)
	; try  getline := SendMessage(EM_GETLINE,1, SBgl.Ptr, fCtl)
	; try Line := (SendMessage(EM_LINEFROMCHAR, -1, 0, fCtl,hWnd) + 1)
		
	; try GetCaretLine := AE_GetCaretLine(-1,fCtl, hWnd)
	; try CurrentCol := EditGetCurrentCol(fCtl, hWnd)
	; ---------------------------------------------------------------------------
	; @grouped -1 = current line => @param ...: this_line := -1
	; ---------------------------------------------------------------------------
	; this_line := -1
	; try Result := (SendMessage(EM_LINEINDEX, this_line, 0, fCtl,hWnd)) ;? starting character number
	; try LI := AE_GetLineIndex(this_line, fCtl, hWnd) ;
	; try LinePos := (NumGet(SB, 'Ptr') - (LI + 1))
	; ---------------------------------------------------------------------------
	; @group 1 => +1 line to try and get the difference between the two
	; ---------------------------------------------------------------------------
	; try n_line := 1
	; try Result1 := (SendMessage(EM_LINEINDEX, this_line, 0, fCtl,hWnd)) ;? starting character number
	; try LI1 := AE_GetLineIndex(this_line, fCtl, hWnd) ;
	; try LinePos1 := (NumGet(SB, 'Ptr') - (LI + 1))
	; try num_of_chars := SendMessage(WM_GETTEXTLENGTH := 0x000E, 0, 0, fCtl, hWnd)
	; ---------------------------------------------------------------------------
	; try CharCount := AE_GetTextLen(fCtl, hWnd)
	
	Try {
		
		Infos(
			; 'fCtl: ' fCtl
			; '`n'
			; 'ClassNN: ' ClassNN
			; '`n'
			'getsel.s (start): ' getsel.S '`n' 
			'getsel.e   (end): ' getsel.E '`n' 
			'Total Chars: ' MaxLinePos '`n' 
			'LineCount: ' LineCount '`n' 
			'LineCount1: ' LineCount1 '`n' 
			'getline: ' getline '`n'
			'Line: ' Line '`n'
			; '`n'
			'-----------------------------------`n'
			'Selected: "' Selected '"`n'
			'Chars: ' Selected.Length '`n'
			'Spaces: ' RegExMatch(Selected.Length, '[ ]+$') '`n'
			'-----------------------------------`n'
			'CurrentCol: ' CurrentCol '`n'
			'-----------------------------------`n'
			'Result: ' Result '`n'
			'LineIndex (charpos @ BOL): ' LI '`n'
			'LinePos(chars in line = LinePos+1): ' LinePos '`n'
			'-----------------------------------`n'
			'Result1: ' Result1 '`n'
			'LineIndex1 (charpos @ BOL): ' LI1 '`n'
			'LinePos1(chars in line = LinePos+1): ' LinePos1 '`n'
			'-----------------------------------`n'
			'num_of_chars: ' num_of_chars '`n'
			'-----------------------------------`n'
			'GetCaretLine: ' GetCaretLine '`n'
			'CharCount: ' CharCount
		)
		; , 3000)
	}
	selS := getsel.S
	selE := getsel.E
	selL := Selected.Length
	sel  := Selected
	; Stats.SafePush(getsel.S)
	; Stats.SafePush(getsel.E)
	Stats.SafePush('LinePos: ' LinePos)
	Stats.SafePush('Line: ' Line)
	Stats.SafePush('LineCount: ' LineCount)
	Stats.SafePush('CharCount: ' CharCount)
	Return Stats := {
		LinePos:LinePos,
		selS:selS,
		selE:selE,
		selL:selL,
		sel:sel

	}
}
; ---------------------------------------------------------------------------
; Hides or shows the selection ;! still doesn't work
; ---------------------------------------------------------------------------
; AE_HideSelection(Mode, ClassNN := ControlGetClassNN(ControlGetFocus('A')), hWnd := tryHwnd()) { 
; 	; Mode : True to hide or False to show the selection.
; 	EM_HIDESELECTION := 0x043F ; (WM_USER + 63)
; 	; SendMessage(EM_HIDESELECTION, !!Mode, 0, hWnd)
; 	SendMessage(EM_HIDESELECTION, !!Mode, 0, ClassNN, hWnd)
; 	Return True
; }
AE_HideSelection(Mode := true, fCtl := 0, hWnd := tryHwnd()) { 
	; Mode : True to hide or False to show the selection.
	EM_HIDESELECTION := 0x043F ; (WM_USER + 63)
	try (fCtl := ControlGetFocus('A'), ClassNN := ControlGetClassNN(fCtl)) ;, Infos(ClassNN)
	If (fCtl = 0) {
		Return SendMessage(EM_HIDESELECTION, Mode, 0, hWnd, hWnd)
		; Return SendMessage(EM_HIDESELECTION, Mode, 0, , hWnd)
	} else {
		Return SendMessage(EM_HIDESELECTION, Mode, 0, fCtl, hWnd)
	}
	; SendMessage(EM_HIDESELECTION, !!Mode, 0, hWnd)
	; SendMessage(EM_HIDESELECTION, !!Mode, 0, ClassNN, hWnd)
	; SendMessage(EM_HIDESELECTION, Mode, 0, ClassNN, hWnd)
	; Return True
	
}


; --------------------------------------------------------------------------------
;              Ctrl+s Reload AutoHotKey Scripts (to test/load changes)
; --------------------------------------------------------------------------------
#HotIf WinActive(' - Visual Studio Code')
	; ~^s::ReloadAllAhkScripts()
	~^s::Reload()
	; ~^s::Script.Reload()
#HotIf
; --------------------------------------------------------------------------------
/**
 * function ...: Reload AutoHotKey Script (to load changes)
 * @example Ctrl+Shift+Alt+r
 * Note: I think the 654*** is for v2 => avoid the 653***'s
	[x] Reload:		65400
	[x] Help: 		65411 ; 65401 doesn't really work or do anything that I can tell
	[x] Spy: 			65402
	[x] Pause: 		65403
	[x] Suspend: 		65404
	[x] Exit: 		65405
	[x] Variables:	65406
	[x] Lines Exec:	65407 & 65410
	[x] HotKeys:		65408
	[x] Key History:	65409
	[x] AHK Website:	65412 ; Opens https://www.autohotkey.com/ in default browser; and 65413
	[x] Save?:		65414
	! Don't use these => static a := { Open: 65300, Help:    65301, Spy: 65302, XXX (nonononono) Reload: 65303 [bad reload like Reload()], Edit: 65304, Suspend: 65305, Pause: 65306, Exit:   65307 }
	scripts .=  (scripts ? '`r`n' : '') . RegExReplace(title, ' - AutoHotkey v[\.0-9]+$')
 * @example
	Refactored:
		- Changed DetectHiddenWindows(true) to AE._DetectHidden(true)
		- Declared vars: oList := [], aList := [], i := '', v := '', scripts := '', excludeTitle := '', excludeText := ''
		- Added a RegExMatch => via ~= => to see if the Title or Text exists
 *	//; TODO Change exList's to Arrays, and create for-loops
 */
; --------------------------------------------------------------------------------
^+!r::ReloadAllAhkScripts()
; ^+!r::ReloadList()
ReloadAllAhkScripts() {
	AE.DH(true)
	aList := [], title := '', WinTitle := '', scripts := ''
	aList := ReloadList()
	; Infos(aList.ToString(',`n'))
	static  WM_COMMAND := 273, ; 0x111 or 0x00000111
			; menucmdid := cmdidOLEObjectMenuButton := 65400,
			menucmdid := cmdidOLEObjectMenuButton := 65303,
			Msg := WM_COMMAND, wParam := menucmdid, lParam := 0
	; Loop aList.Length {
	for each, WinTitle in aList {
			; WinTitle := 'ahk_id ' aList[A_Index]
		WinTitle := 'ahk_id ' WinTitle
		title := WinGetTitle(WinTitle)
			; PostMessage(WM_COMMAND,65400,0,,'ahk_id ' aList[A_Index])
			; PostMessage(Msg,wParam,lParam,,title)
			; SendMessage(Msg,wParam,lParam,,title)
		Run(title)
		WinKill(title)
		; Exit()
		scripts .=  (scripts ? '`r`n' : '') . RegExReplace(title, ' - AutoHotkey v[\.0-9]+$')
	}
		; Infos(scripts)
}
ReloadList() {
	AE.DH(true)
	static oList := [], aList := [], exListTitleArr := [], exclTitleArr := [], exListTextArr := [], exclTextArr := [], sList := [], noList := []
	static  i := '', v := '', scripts := '', excludeTitle := '', excludeText := '',
			aTitleExcl := '', aTextExcl := '', WinT := '', WinE := 0
	static  WM_COMMAND := 273, ; 0x111 or 0x00000111
			menucmdid := cmdidOLEObjectMenuButton := 65400
	static exListTitleArr := ['RichEdit'], exListTextArr := ['Horizon']
	for each, aTitleExcl in exListTitleArr {
		try {
			WinE := WinExist(aTitleExcl)
			WinT := WinGetTitle(WinE)
		}
		try {
			if WinT ~= aTitleExcl {
				excludeTitle := WinT
				noList.SafePush(excludeTitle)
			}
		}
	}
	static oList := WinGetList('ahk_class AutoHotkey',,excludeTitle)
	List := oList.Length
	for i, v in oList {
		aList.SafePush(v)
	}
	for each, WinTitle in aList {
		; WinTitle := 'ahk_id ' aList[A_Index]
	WinTitle := 'ahk_id ' WinTitle
	title := WinGetTitle(WinTitle)
	sList.SafePush(title)
}
	; Loop aList.Length {
	; 	local WinTitle := 'ahk_id ' aList[A_Index]
	; 	title := WinGetTitle(WinTitle)
	; 	sList.SafePush(title)
	; }
	return aList
}
; ---------------------------------------------------------------------------
ShellHook(callback := '') {
	; HSHELL_RUDEAPPACTIVATED := 32772
	; hWnd := WinActive('A')
	rVal := ''
	hWnd := ControlGetFocus('A')
	DllCall('RegisterShellHookWindow', 'UInt', A_ScriptHwnd)
	OnMessage(DllCall('RegisterWindowMessage', 'Str', 'SHELLHOOK'), rval := callback)
	; OnMessage(DllCall('RegisterWindowMessage', 'Str', 'SHELLHOOK'), MyFunc)
	return rVal
}
; ---------------------------------------------------------------------------
A_DPI_GetInfo(event := HSHELL_WINDOWCREATED := 1, hWnd := WinActive('A'),info*) {
	CoordMode('ToolTip', 'Client')
	AE.DH(1)
	AE.BISL(1)
	; --------------------------------------------------------------------------------
	; hook := SetWinEventHook(HandleWinEvent)
	; --------------------------------------------------------------------------------
	static HSHELL_WINDOWCREATED := 1, HSHELL_WINDOWDESTROYED := 2, HSHELL_ACTIVATESHELLWINDOW := 3, HSHELL_WINDOWACTIVATED := 4, HSHELL_WINDOWACTIVATED := 32772, HSHELL_GETMINRECT := 5, HSHELL_REDRAW := 6, HSHELL_TASKMAN := 7, HSHELL_LANGUAGE := 8, HSHELL_SYSMENU := 9, HSHELL_ENDTASK := 10, HSHELL_ACCESSIBILITYSTATE := 11, HSHELL_APPCOMMAND := 12, HSHELL_WINDOWREPLACED := 13, HSHELL_WINDOWREPLACING := 14, HSHELL_HIGHBIT := 32768, HSHELL_RUDEAPPACTIVATED := 32772, HSHELL_FLASH := 32774
	; ---------------------------------------------------------------------------
	static hznHwnd := 0, match := '', A_Process := '', A_DPI := 0, mName := '', name := ''
	matches := [], ProcessInfo := []
	processInfoMap := Map()
	; ---------------------------------------------------------------------------
	nEvent := (event = 1) ? 'HSHELL_WINDOWCREATED' : (event = 2) ? 'HSHELL_WINDOWDESTROYED' : (event = 3) ? 'HSHELL_ACTIVATESHELLWINDOW' : (event = 4) ? 'HSHELL_WINDOWACTIVATED' : (event = 32772) ? 'HSHELL_RUDEAPPACTIVATED' : (event = 5) ? 'HSHELL_GETMINRECT' : (event = 6) ? 'HSHELL_REDRAW' : (event = 7) ? 'HSHELL_TASKMAN' : (event = 8) ? 'HSHELL_LANGUAGE' : (event = 9) ? 'HSHELL_SYSMENU' : (event = 10) ? 'HSHELL_ENDTASK' : (event = 11) ? 'HSHELL_ACCESSIBILITYSTATE' : (event = 12) ? 'HSHELL_APPCOMMAND' : (event = 13) ? 'HSHELL_WINDOWREPLACED' : (event = 14) ? 'HSHELL_WINDOWREPLACING' : (event = 32768) ? 'HSHELL_HIGHBIT' : (event = 32774) ? 'HSHELL_FLASH' : 'No Event'
	if ((event = 1) || (event = 4) || (event = 32772)) {
		; hWnd := WinActive('A')
		DllCall('GetWindowThreadProcessId', 'Int', hwnd, 'Int*', &tpID := 0)
		try name := WinGetProcessName(hwnd)
		if name = '' {
			return
		}
		A_Process := name
		Monitor := DPI.GetMonitorInfo(hWnd)
		; hMon_Win := DPI.MonitorFromWindow(hwnd)
		hMon  := Monitor.Handle
		mName := Monitor.Name
		wDPI  := Monitor.winDPI
		A_DPI := Monitor.DPI
		; mName := RegExReplace(mName, '\\\\\.\\', '')
		; mDPI := DPI.GetForMonitor(hMon_Win)
		; ToolTip(hMon_Win ': ' mDPI  ' : ' A_DPIAwareness, 0,0, 2)
		; wDPI := DPI.WinGetDPI(A_Process)
		; Infos(wDPI)
		; A_DPI := [mDPI, Monitor.x, Monitor.y]
		; A_DPI := A_DPI.ToString(' ')
		; A_DPI := wDPI
		ProcessInfo.SafePush(A_Process)
		processInfoMap.SafeSet('Process', A_Process)
		processInfoMap.SafeSet('Monitor', mName)
		processInfoMap.SafeSet('hMon', hMon)
		processInfoMap.SafeSet('A_DPI', A_DPI)
	}
	; --------------------------------------------------------------------------------
	; --------------------------------------------------------------------------------
	AE.BISL(0)
	; match := processInfoMap.ToString('`n')
	; ToolTip(A_Process ': ' A_DPI ' : ' A_DPIAwareness, 0, 100, 1)
	; ToolTip(match, 0, 0, 1)
	; ToolTip(A_DPI, 0, 0, 1)
	; ToolTip(A_DPI, 0, 0)
	; Infos(match)
	; return processInfoMap
	return A_DPI
}
Edit_Copy(fCtl := ControlGetFocus('A'), hEdit := tryHwnd()) {
	Static WM_COPY:=0x301
	; SendMessage(WM_COPY, 0, 0, , 'ahk_id ' hEdit)
	if WinActive('ahk_exe hznHorizon.exe') {
		SendMessage(WM_COPY, 0, 0, fCtl,hEdit)
	} else {
		; SendMessage(WM_COPY, 0, 0, hEdit, hEdit)
		SendMessage(WM_COPY, 0, 0, , 'A')
	}
	; Infos(A_Clipboard)
}
SndMsgCopy(fCtl := 0) {
	; @link ...: https://learn.microsoft.com/en-us/windows/win32/dataxchg/wm-copy
	; @info ...: wParam & lParam MUST be 0
	; @struct .: COPYDATASTRUCT ...: 
	; @link ...: https://learn.microsoft.com/en-us/windows/win32/dataxchg/wm-copydata
	; @func ...: StringLen := NumGet(lParam + A_PtrSize, 'int')    StringAddress := NumGet(lParam + 2*A_PtrSize)    Data := StrGet(StringAddress, StringLen, Encoding)
	static WM_COPY := 0x0301, wParam := 0, lParam := 0
	try fCtl := ControlGetFocus('A')
	(fCtl = 0) ? SendEvent('^{sc2E}') : SendMessage(WM_COPY,wParam,lParam,fCtl,'A')
}
; ---------------------------------------------------------------------------
SndMsgCut(fCtl := 0) {
	; @link : https://learn.microsoft.com/en-us/windows/win32/dataxchg/wm-cut
	; @info : wParam & lParam MUST be 0
	static WM_CUT := 0x0300, wParam := 0, lParam := 0
	try fCtl := ControlGetFocus('A')
	(fCtl = 0) ? SendEvent('^{sc2D}') : SendMessage(WM_CUT,lParam,lParam,fCtl,'A')
}
; ---------------------------------------------------------------------------
SndMsgPaste(fCtl := 0) {
	; @link : https://learn.microsoft.com/en-us/windows/win32/dataxchg/wm-paste
	; @info : wParam & lParam MUST be 0
    AE.SM(&sm)
	static WM_PASTE := 0x0302, wParam := 0, lParam := 0, paste := '{sc1D}{sc2F}' ;? ^v
	try fCtl := ControlGetFocus('A')
	(fCtl = 0) ? Send(paste) : SendMessage(WM_PASTE,wParam,lParam,fCtl,'A')
    AE.rSM(sm)
}

trayNotify(title, message, options := 0) {
    TrayTip(title, message, options)
}
#HotIf WinActive(' Visual Studio Code')
^+m::
{
	text := ''
	cBak := ClipboardAll()
	; Infos(EmptyClipboard(), 3000)
	Sleep(100)
	SndMsgCopy()
	text :=  A_Clipboard
	loop {
		Sleep(20)
	} until (text.length > 0)
	InternetSearch.TriggerSearch('msdn win32 ' text)
	AE.EmptyClipboard()
	Sleep(1000)
	A_Clipboard := cBak
}
#HotIf
; ---------------------------------------------------------------------------
; ;===================================================================================================
; ;AUTHOR   : https://www.autohotkey.com/boards/viewtopic.php?p=509863#p509863
; ;Function : XYplorer Get Selection
; ;Created  : 2023-02-28
; ;Modified : 2023-06-13
; ;Version  : v1.3
; ;===================================================================================================
; #Requires AutoHotkey v2.0.2



; ; Get our own HWND (we have no visible window)
; G_OwnHWND := A_ScriptHwnd + 0


; ; Get messages back from XYplorer
; OnMessage(0x4a, Receive_WM_COPYDATA)


; dataReceived := ''


; F1::
; {
;     path := XYGetPath()
;     all  := XYGetAll()
;     sel  := XYGetSelected()
;     MsgBox path
;     MsgBox all
;     MsgBox sel
; 	Send_WM_COPYDATA('::echo 'Hello!'')
; return
; }


; XYGetPath()
; {
;    return XY_Get()
; }


; XYGetAll()
; {
;    return XY_Get(true)
; }


; XYGetSelected()
; {
;    return XY_Get(, true)
; }


; XY_Get(bAll:=false, bSelection:=false)
; {
;     xyQueryScript := '::if (!' bAll ' && !' bSelection ') {$return = '<curpath>'`;} elseif (' bAll ') {$return = listpane(, , , '<crlf>')`;} elseif (' bSelection ') {$return = get('SelectedItemsPathNames', '<crlf>')`;} copydata ' G_OwnHWND ', '$return', 2`;'

;     Send_WM_COPYDATA(xyQueryScript)

;     return dataReceived
; }


; GetXYHWND() {
; static xyClass := 'ahk_class ThunderRT6FormDC'

; if hwnd := WinActive(xyClass) || WinExist(xyClass) {
; 	for xyid in WinGetList(xyClass)
; 		for ctrl in WinGetControls(xyid)
; 			if ctrl = 'ThunderRT6PictureBoxDC70'
; 				return xyid
; 	if hwnd
; 		return hwnd
; 	else
; 		return WinGetList(xyClass)[1]
; }
; }


; Send_WM_COPYDATA(message) {
; xyHwnd := GetXYHWND()

; if !(xyHwnd)
; 	return

; size := StrLen(message)

; COPYDATA := Buffer(A_PtrSize * 3)
; NumPut('Ptr', 4194305, COPYDATA, 0)
; NumPut('UInt', size * 2, COPYDATA, A_PtrSize)
; NumPut('Ptr', StrPtr(message), COPYDATA, A_PtrSize * 2)

; return DllCall('User32.dll\SendMessageW', 'Ptr', xyHwnd, 'UInt', 74, 'Ptr', 0, 'Ptr', COPYDATA, 'Ptr')
; }


; Receive_WM_COPYDATA(wParam, lParam, *) {
; global dataReceived := StrGet(
; 	NumGet(lParam + 2 * A_PtrSize, 'Ptr'),   ; COPYDATASTRUCT.lpData, ptr to a str presumably
; 	NumGet(lParam + A_PtrSize, 'UInt') / 2   ; COPYDATASTRUCT.cbData, count bytes of lpData, /2 to get count chars in unicode str
; )
; }

; ;===================================================================================================
; ;AUTHOR   : https://www.autohotkey.com/boards/viewtopic.php?p=509863#p509863
; ;Function : XYplorer Get Selection
; ;Created  : 2023-02-28
; ;Modified : 2023-06-13
; ;Version  : v1.1
; ;===================================================================================================
; #Requires AutoHotkey v2.0.2



; ; Get our own HWND (we have no visible window)
; DetectHiddenWindows(true)
; G_OwnHWND := WinExist('Ahk_PID ' DllCall('GetCurrentProcessId'))
; G_OwnHWND += 0


; ; Get messages back from XYplorer
; OnMessage(0x4a, Receive_WM_COPYDATA)

; global dataReceived := ''

; F1::
; {
;     path := XYGetPath()
;     all  := XYGetAll()
;     sel  := XYGetSelected()
;     MsgBox path
;     MsgBox all
;     MsgBox sel
; return
; }


; XYGetPath()
; {
;     return XY_Get()
; }


; XYGetAll()
; {
;    return XY_Get(true)
; }


; XYGetSelected()
; {
;    return XY_Get(, true)
; }


; XY_Get(bAll:=false, bSelection:=false)
; {
;     xyQueryScript := '::if (!' bAll ' && !' bSelection ') {$return = '<curpath>'`;} elseif (' bAll ') {$return = listpane(, , , '<crlf>')`;} elseif (' bSelection ') {$return = get('SelectedItemsPathNames', '<crlf>')`;} copydata ' G_OwnHWND ', '$return', 2`;'

;     Send_WM_COPYDATA(xyQueryScript)

;     return dataReceived
; }


; GetXYHWND() {
; 	static xyClass := 'ahk_class ThunderRT6FormDC'

;     if hwnd := WinActive(xyClass) || WinExist(xyClass) {
;         for xyid in WinGetList(xyClass)
;             for ctrl in WinGetControls(xyid)
;                 if ctrl = 'ThunderRT6PictureBoxDC70'
;                    return xyid
;         if hwnd
;            return hwnd
;         else
;            return WinGetList(xyClass)[1]
;     }
; }


; Send_WM_COPYDATA(message) {
;    xyHwnd := GetXYHWND()

;    if !(xyHwnd)
;        return

;    size := StrLen(message)
;    if !(StrLen(Chr(0xFFFF))) {
;       data := Buffer(size * 2, 0)
;       StrPut(message, &data, size, 'UTF-16')
;    } else {
;       data := message
;    }

;    COPYDATA := Buffer(A_PtrSize * 3)
;    NumPut('Ptr', 4194305, COPYDATA, 0)
;    NumPut('UInt', size * 2, COPYDATA, A_PtrSize)
;    NumPut('Ptr', StrPtr(data), COPYDATA, A_PtrSize * 2)

;    return DllCall('User32.dll\SendMessageW', 'Ptr', xyHwnd, 'UInt', 74, 'Ptr', 0, 'Ptr', COPYDATA, 'Ptr')
; }


; Receive_WM_COPYDATA(wParam, lParam, *) {
; 	global dataReceived := StrGet(
; 		NumGet(lParam + 2 * A_PtrSize, 'Ptr'), ; COPYDATASTRUCT.lpData, ptr to a str presumably
; 		NumGet(lParam + A_PtrSize, 'UInt') / 2 ; COPYDATASTRUCT.cbData, count bytes of lpData, /2 to get count chars in unicode str
; 	)
; }


/************************************************************************
 * function ...: Update_Receiver_Map()
 * @author OvercastBTC
 * @example :
;! Note: while the fName is the file name, the fOpen likel needs to be opened beforehand (prior to refactoring, this was how it worked before in Horizon)

Inputs:
; ---------------------------------------------------------------------------
; @i ...: Inputs: fName (file name)
; @i ...: Inputs: fOpen (that file name opened)
; @i ...: Inputs: [Optional - RegExMatch &/or InStr(?) Object]
; ---------------------------------------------------------------------------

ClassMap:
; ---------------------------------------------------------------------------
class receiver {
	static rMap := Map(
		'width', width := 2012,
		'height', height := 0,
		'x', x := 42,
		'y', y := 666,
		'top', top := 0,
		'bottom', bottom := 0,
		'hCtl', hCtl := 134162,
		'nCtl', nCtl := '',
		'fPath', fPath := '',
		'fName', fName := '',
	)
}

RegEx:
; ---------------------------------------------------------------------------
; @i ...: Group 1 ($1) = key of Map (MatchObj) (e.g., 'width' of the key-value pair 'width', width := 0)
; @i ...: kNeedle := '([\`'\`"]\w+[\`'\`"])'
; @i ...: We need to match the key, in the identically named key-value pair (e.g., 'width', width := 0).
; @i ...: If there is a match, we will use the following two groups to remove the value (of the value)
; @i ...: E.g., Array.RemoveAt(A_Index) and then Array.InsertAt(A_Index, aLine)
; ---------------------------------------------------------------------------
; @i ...: Group 2 ($2) = value of the value of Map (MatchObj) (e.g., 12345 of the value of the key-value pair 'height', height := 12345)
; @i ...: vNeedle := ':= (\d+,)'
; ---------------------------------------------------------------------------
; @i ...: Group 3 ($3) = blank value of the value of Map (MatchObj) (e.g., '' || "" of the value of the key-value pair 'fPath', fPath := '')
; @i ...: bNeedle := '([\`'\`"]{2})'
; ---------------------------------------------------------------------------
; @i ...: This needle matches ALL three groups, but in an or state
; Needle := '([\`'\`"]\w+[\`'\`"])|:= (\d+,)|([\`'\`"]{2})'
; Needle := '([\`'\`"]\w+[\`'\`"][,\s])|:= (\d+,)|(:= [\`'\`"]{2})'
Needle := '(?:([\`'\`"]\w+[\`'\`"][,\s])|(\d+,)|([\`'\`"]{2}))' ;? includes a ?: or 'match all' but as a non-capturing group
; ---------------------------------------------------------------------------
 * @param {string} fName 
 * @param {string} fOpen 
 * @param MatchObj 
 * @returns {number} 
 ***********************************************************************/

Update_Receiver_Map(fName:='', fOpen := '', MatchObj?){
	rMap := Map()
	arrFile := [], arrMap := [], fArrObj:=[]
	fLine := '', vLine := '', mV := '', rMatch := '', rect_match := '', new_str := '', mTest := '', fString := ''
	; kNeedle := '([\`'\`"]\w+[\`'\`"])' ;? I'm thinking this is the better one so I'm not capturing the 'comma-space' after the key, but I dunno yet
	kNeedle := '([\`'\`"]\w+[\`'\`"][,\s])'
	kReplace := '$1' ;? not necessarily needed, but included for reference
	; vNeedle := ':= (\d+,)'
	vNeedle := '(\d+,)'
	vReplace := '$2' ;? not necessarily needed, but included for reference
	bNeedle := '([\`'\`"]{2})'
	bReplace := '$3' ;? not necessarily needed, but included for reference
	; ---------------------------------------------------------------------------
	; @i ...: Loop through each line of the file (fName)
	; ---------------------------------------------------------------------------
	loop read fName {
		fArrObj.SafePush(A_LoopReadLine)
		fLine .= A_LoopReadLine '`n'
	}
	; ---------------------------------------------------------------------------
	for each, vLine in arrFile {
		; ---------------------------------------------------------------------------
		aLine.RegExMatch(kNeedle | vNeedle, &MatchObj)
		for each, mV in MatchObj {
			if ((aLine ~= mV)) {
				str_match := StrSplit(mV,')','i ) "')
				rMatch := str_match[2]
				; Infos(rMatch)
				rect_match := rMap[rMatch]
				; rect_match := dpiRect.%str_match[2]%
				aLine.RegExReplace(vNeedle, '$1' rect_match ',')
				; new_str := RegExReplace(aLine, ':= ([0-9].*)', ':= ' rect_match . ',' )
				aLine := new_str
				fName.RemoveAt(A_Index)
				fName.InsertAt(A_Index, aLine)
			}
		}
		; ---------------------------------------------------------------------------
		; @i ...: Write each value in the array to @param fString (the new file's string variable)
		; ---------------------------------------------------------------------------
		fString .= aLine . '`n'
		; ---------------------------------------------------------------------------
	}
	; ---------------------------------------------------------------------------
	fOpen.Write(fString)
	fOpen := ''
	return 0
}
