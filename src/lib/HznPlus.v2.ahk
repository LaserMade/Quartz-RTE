#Requires AutoHotkey v2.0.10+
#Include <Directives\__AE.v2>
; @include-winapi
Persistent(1)
; Suspend(0)
; AE.SM(&sm)
; OnExit((*)=>Reload())
; /************************************************************************
; @function......: Horizon Button ==> A Horizon function library
; @description..: This library is a collection of functions and buttons that deal with missing interfaces with Horizon.
; @file: HznPlus.v2.ahk
; @author: OvercastBTC
; @date: 2024.05.14
; @version: 5.0.0
; @ahkversion: v2+
; @Section.....: Auto-Execution
;  ***********************************************************************/
; ---------------------------------------------------------------------------
;@Ahk2Exe-AddResource HznPlus256.ico, 160  ; Replaces 'H on blue'
;@Ahk2Exe-AddResource HznPlus256.ico, 206  ; Replaces 'S on green'
;@Ahk2Exe-AddResource HznPlus256.ico, 207  ; Replaces 'H on red'
;@Ahk2Exe-AddResource HznPlus256.ico, 208  ; Replaces 'S on red'
; ---------------------------------------------------------------------------

;! ---------------------------------------------------------------------------
TraySetIcon('HICON:' Create_HznHorizon_ico())
;! ---------------------------------------------------------------------------
#Include <Directives\__HznToolbar>
#Include <Includes\Includes_Extensions>
#Include <..\AHK.Projects.v2\Peep\PeepAHK\script\Peep.v2>
#Include <Includes\Includes_Standard>
; ---------------------------------------------------------------------------
#Include <__A_Process.v2> ;! needs to be here AFTER the TraySetIcon => Icon disabled in A_Process
#Include <__RichTextEditor.v2>
; ---------------------------------------------------------------------------
; Check_Startup_Status()
GroupAdd('DontWantActive', 'Find and Replace')
; ---------------------------------------------------------------------------


; ---------------------------------------------------------------------------
; /************************************************************************
; @Section...: #HotIf WinActive('ahk_exe hznhorizon.exe')
; @i...: Creates context sensitive hotkeys
; @i: This means other hotkeys that are the same, and/or used in a different program,
; @i: will continue to work as intended, while these will ONLY work in Horizon.
; @i: ;! This also means that if the other hotkeys are NOT context sensitive, they will fire at the same time.
;  ***********************************************************************/

; ---------------------------------------------------------------------------
#HotIf WinActive('ahk_exe hznHorizon.exe')
; ---------------------------------------------------------------------------



; /************************************************************************
; @function...: Horizon Hotkeys
; @description: Hotkeys (shortcuts) for normal Windows hotkeys that should exist
; @author.....: OvercastBTC
;  ***********************************************************************/

; ---------------------------------------------------------------------------
$^sc1F::hznHorizon.Save.RiskFile()			; @Save.RiskFile(): Ctrl & s
; ---------------------------------------------------------------------------

; ---------------------------------------------------------------------------
^sc1E:: AE._Select_All()					; @hotkey: Control & a (^a)
^sc147::AE._Select_Beginning() 				; @hotkey: Control & Home (^Home) 	;! Works without hotkey
^sc14F::AE._Select_End() 					; @hotkey: Control & End (^End) 	;! Works without hotkey
^sc30::hznHorizon.button.Bold				; @bold: Control & b (^b)
^sc17::hznHorizon.button.Italics			; @italics: Control & i (^i)
^sc16::hznHorizon.button.Underline			; @underline: Control & u (^u)
; ---------------------------------------------------------------------------
; ! hznHorizon.button.Separator103			; disabled
; ---------------------------------------------------------------------------
^l::hznHorizon.button.AlignLeft 			; @AlignLeft: Ctrl & l		;? No known action => does not do anything
^r::hznHorizon.button.AlignRight 			; @AlignRight: Ctrl & r		;? No known action => does not do anything
^e::hznHorizon.button.AlignCenter 			; @AlignCenter:	Ctrl & e 	;? No known action => does not do anything
^j::hznHorizon.button.Justified 			; @Justified: Ctrl & j 		;? No known action => does not do anything
; ---------------------------------------------------------------------------
; ! hznHorizon.button.Separator108			; disabled
; ---------------------------------------------------------------------------
^sc2D::hznHorizon.button.Cut 				; @cut:		Ctrl & x	;// ;! disabled	
^sc2E::hznHorizon.button.Copy 				; @copy:	Ctrl & c	;// ;! disabled
*^sc2F::hznHorizon.button.Paste 			; @paste:	Ctrl & v	;// ;! disabled
^!sc2F::hznHorizon.PasteSpecial()			; @PasteSpecial: Ctrl & Alt & v
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
; ! hznHorizon.button.Separator112			; disabled
; ---------------------------------------------------------------------------
^sc2C::hznHorizon.button.Undo 				; @undo: Ctrl & z	;// ;! disabled
^sc15::hznHorizon.button.Redo 				; @redo: Ctrl & y	;// ;! disabled
; ---------------------------------------------------------------------------
; ! hznHorizon.button.Separator115			; disabled
; ---------------------------------------------------------------------------
+sc58::hznHorizon.button.BulletedList 		; @BulletedList: Shift & F12
; ---------------------------------------------------------------------------
sc41::hznHorizon.button.SpellCheck			; @SpellCheck: F7
; ---------------------------------------------------------------------------
^sc58::hznHorizon.button.InsertTable		; @InsertTable: Ctrl & F12 ;! fix[] (needs to hit the drop down)
; ---------------------------------------------------------------------------
^scD::hznHorizon.button.SuperScript			; @Superscript: Ctrl & = 
; ---------------------------------------------------------------------------
^+scD::hznHorizon.button.SubScript			; @Subscript: Ctrl & Shift & =
; ---------------------------------------------------------------------------
; sc3F:: 										; @find: F5::			;?	find (focused tab) and find/replace
~^sc21::hznHorizon.button.Search			; @find: Ctrl & f 		;? find (focused tab) and find/replace
^sc23::hznHorizon.button.Replace			; @replace:Ctrl & h 	;? find/replace (focused tab) and find
; ---------------------------------------------------------------------------


; /************************************************************************
; @function...: Bonus Horizon Hotkeys
; @description: Extra hotkeys to help navigate the risk file
; @author.....: OvercastBTC
;  ***********************************************************************/

; ---------------------------------------------------------------------------
#HotIf WinActive('ahk_exe hznHorizon.exe') && !(WinActive('ahk_group DontWantActive'))
; ---------------------------------------------------------------------------
sc3B::hznHorizon.Click('1. Order')			; @F1:	; :ControlClick('ThunderRT6CommandButton5')
sc3C::hznHorizon.Click('2. Tracking')		; @F2:	; :ControlClick('ThunderRT6CommandButton6')
sc3D::hznHorizon.Click('3. FE Data')		; @F3:	; :ControlClick('ThunderRT6CommandButton7')
sc3E::hznHorizon.Click('4. Location CSP')	; @F4:	; :ControlClick('ThunderRT6CommandButton8')
sc3F::hznHorizon.Click('5. Reporting')		; @F5:	; :ControlClick('ThunderRT6CommandButton9')
sc40::hznHorizon.Click('6. Closing')		; @F6:	; :ControlClick('ThunderRT6CommandButton10')
; ---------------------------------------------------------------------------
#HotIf
; ---------------------------------------------------------------------------

; /************************************************************************
; @i.....: ;!Experimental!
; @function...: Experimental Horizon Hotkeys
; @description: Extra hotkeys to help, but not fully vettet yet
; @author.....: OvercastBTC
;  ***********************************************************************/

#HotIf WinActive('ahk_exe hznHorizon.exe')
; ---------------------------------------------------------------------------
; @i.....: Get the text in the edit control (e.g., TX11), copy, open an RTE, & paste
; ---------------------------------------------------------------------------

^+sc2E::hznHorizon._GetText()						; @CopyText_PasteInRichTextEditor: Ctrl & Shift & c

; ---------------------------------------------------------------------------
; @hotkey: Ctrl + n
; ---------------------------------------------------------------------------

^n::HznHorizon.NewRec()					; @NewStandardRec: Ctrl & n

#HotIf


; ---------------------------------------------------------------------------
; @i: If Horizon Manager, or Horizon and ThunderRT6FormDC are active
; @i: {Enter} will select the highlighted selection
; ---------------------------------------------------------------------------
#HotIf WinActive('ahk_exe hznHorizonMgr.exe') || WinActive('ahk_exe hznHorizon.exe') && WinActive('ahk_class ThunderRT6FormDC')
; ---------------------------------------------------------------------------
~Enter::hznHorizon._Enter()
#HotIf




; /************************************************************************
; @function...: Functions for Hotkeys
; @description: Functions that have not been transferred to a class yet
; @author.....: OvercastBTC
;  ***********************************************************************/


; ---------------------------------------------------------------------------
#HotIf WinActive('ahk_exe hznhorizon.exe')
; ---------------------------------------------------------------------------
; @Hotkey...: {Tab}
; @i...: Enables {Tab} within the edit controls
; ---------------------------------------------------------------------------

tab::hznHorizon.Tab()

;! ---------------------------------------------------------------------------
^tab::hznHorizon.Ctrl_Tab()
^Enter::hznHorizon.CtrlEnter()				; @CtrlEnter: Ctrl & Enter ; @i: Allows you to "Click" an OK button by hitting enter
Esc::hznHorizon.Cancel()					; @Cancel: Escape ; @i: Hit the Cancel button




; ---------------------------------------------------------------------------
; @i...: HznMenu() - Access to the normal menu bar for the main window using normal hotkeys
; @i...: Horizon maintains focus on the active control (generally), and hitting !f (alt & f) will not access the File Menu without setting focus to the "main" window.
; ---------------------------------------------------------------------------
; @hotkey...: Alt & f
; @menu.....: File Menu
; ---------------------------------------------------------------------------
; ~!f::HznMenu(SubStr(A_ThisHotkey, -1, 1)) ;? Alt & f
; ~<!f::HznMenu(A_ThisHotkey)
~!sc21::hznHorizon._MenuBar(A_ThisHotkey)
; ---------------------------------------------------------------------------
; @hotkey...: Alt & v
; @menu.....: View Menu
; ---------------------------------------------------------------------------
; ~!v::HznMenu(SubStr(A_ThisHotkey, -1, 1)) ;? Alt & v
; *<!sc2F::HznMenu(A_ThisHotkey)
; ---------------------------------------------------------------------------
; @hotkey...: Alt & i
; @menu.....: Insert Menu
; ---------------------------------------------------------------------------
; ~!i::HznMenu(SubStr(A_ThisHotkey, -1, 1)) ;? Alt & i
; ~!sc17::HznMenu(A_ThisHotkey) 
;! For some reason this disables ^i (OC - 2024.06.14)
; ---------------------------------------------------------------------------
; @hotkey...: Alt & t
; @menu.....: Tools Menu
; ---------------------------------------------------------------------------
; ~!t::HznMenu(SubStr(A_ThisHotkey, -1, 1)) ;? Alt & t
; ~<!sc14::HznMenu(A_ThisHotkey)
; ---------------------------------------------------------------------------
; @hotkey...: Alt & w
; @menu.....: Window Menu
; ---------------------------------------------------------------------------
; ~!w::HznMenu(SubStr(A_ThisHotkey, -1, 1)) ;? Alt & w
; ~<!sc11::HznMenu(A_ThisHotkey)
; ---------------------------------------------------------------------------
; @hotkey...: Alt & h
; @menu.....: Help Menu
; ---------------------------------------------------------------------------
; ~!h::HznMenu(SubStr(A_ThisHotkey, -1, 1)) ;? Alt & h
; ~<!sc23::{
;     HznMenu(A_ThisHotkey) ;? Alt & h
;     AE.DH(1)
;     try fCtl := ControlGetFocus('A')
;     try ClassNN := ControlGetClassNN(fCtl, 'A')
;     try wT := WinGetTitle('A')
;     Infos(ClassNN '(' fCtl ')' '`n' wT)
; }
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------

; #HotIf !WinActive(' - Visual Studio Code') && WinActive('ahk_exe hznHorizon.exe') && (fCtl := ControlGetFocus('A'), cClass := WinGetClass(fCtl), cClass = 'TX11' || cClass = 'ThunderRT6TextBox')
;! where does this go now?

;! ---------------------------------------------------------------------------
; @i.....: ;! Development Only
; @i.....: Access the customize toolbar menu
; @hotkey: Ctrl + Shift + 8
; ---------------------------------------------------------------------------

^+8::hznHorizon.TbCustomize() 	; works!!! enables and shows all buttons on the toolbar
; ---------------------------------------------------------------------------


; ---------------------------------------------------------------------------
; @i.....: Enables ALL the buttons available in the msvb_lib_toolbar
; @i.....: msvb_lib_toolbar is the VB6 pre Toolbar32 control
; @hotkey: Ctrl + Shift + 9
; ---------------------------------------------------------------------------

^+9::hznHorizon.TbEnableButtons()

; ---------------------------------------------------------------------------
#HotIf
;! ---------------------------------------------------------------------------

; fix
^+7::hznHorizon.somestufffortoolbar()

; ---------------------------------------------------------------------------
; @i.....: ;!Experimental! Development Only
; @i.....: Various test functions utilized during development
; @hotkey: Ctrl + Win + 1
; ---------------------------------------------------------------------------
^#1::hznHorizon.Experimental.Lookie()
; ---------------------------------------------------------------------------

#+8:: {
	clss := txt := text := controls := ''
	aWinC := WinGetControls('A')
	aWinW := WinGetControlsHwnd('A')
    
	; for each, value in aWinC {
	; 	ClassNN := ControlGetClassNN(value)
	; 	controls .= ClassNN '`n'
	; 	If ClassNN ~= 'TX11' {
	; 		text := ClassNN '`t' ClassNN
	; 	}
	; 	else {
	; 		try text := ControlGetText(value)
	; 	}
	; 	txt .= ClassNN '`t' text '`n'
	; }
	for each, value in aWinW {
		try text := WinGetText(value)
		try clss := WinGetClass(value)
		txt .= value '`t' clss '`t' text '`n'
	}
	Infos(txt)
	; Msg := 
	; TCM_GETITEMCOUNT := 0x1304
	; TCM_SETCURFOCUS := 0x1330
	; TCM_SETCURSEL := 0x130C
	; TCM_GETCURFOCUS := 0x132F
	; TCM_GETCURSEL := 0x130B
	; Infos(SendMessage(Msg, 1, 0, , 'A'))
	; ControlClick('Risk Conclusions', 'A')
}

; ---------------------------------------------------------------------------
/**
 * Installs the script to the user startup folder
 * @function Check_Startup_Status()
 * @param hWndToolbar - The handle of the toolbar control.
 * @param n - The index of the toolbar item to click (1-based). Note: Separators are considered items as well.
 * @returns {void} 
 */
; ---------------------------------------------------------------------------
Check_Startup_Status(){
arrStartup := Array(
	startup := A_Startup '\',
	script := StrSplit(A_Startup, '.'),
	scriptnoext := script[1],
	scriptlnk := script[1] . '.lnk',
	scriptSC := script[1] . script[2] . ' - Shortcut',
	)

Startup_Shortcut := arrStartup() 
; Startup_Shortcut := A_Startup "\" A_ScriptName
If (!FileExist(Startup_Shortcut))
    {
        
        myGui := Gui(,"Add Script to Startup Folder",)
        myGui.Opt("AlwaysOnTop")
        myGui.SetFont("s12")
        myGui.Add("Text",, "It is recommended you add this script to your Startup folder so`nthat it is active every time your computer starts.`n`nMake sure that the script is in the location you want to save`nit in before adding it to the startup folder.`n`nWould you like to add this script to the startup folder now?")
        myGui.Add("Button","x15 +default", "Add to Startup").OnEvent("Click", ClickedAdd)
        myGui.Add("Button","x+m", "Cancel").OnEvent("Click", ClickedCancel)
        myGui.Show("w500")
        
        ClickedAdd(*)
        {
            myGui.Destroy()
            FileCreateShortcut(A_ScriptDir "\" A_ScriptName, Startup_Shortcut)
            Run( "shell:startup")
            MsgBox("Shortcut added to your Startup folder at:`n`n" Startup_Shortcut "`n`nYour Startup folder has been opened for you. Please delete any old shortcuts.")
            Return
        }

        ClickedCancel(*)
        {
            myGui.Destroy()
            MsgBox("Please move the file to the location you want to save it, then run it again.")
            Return
        }
    } 
Else 
    {
		; MsgBox("Shortcut Exists") ; Test message for debugging. Leave commented out for normal operation.
        Return
    }
}



/************************************************************************
 * @function Create_HznHorizon_ico()
 * function: Create the .ico file for use in as the Tray Icon
 * @author 2.0.00.00 - 2023-07-31 - iPhilip - converted script to AutoHotkey v2
 * @param B64 - A picture converted to a string and encoded via b64
 * @source ;-> https://www.autohotkey.com/boards/viewtopic.php?f=83&t=119966
***********************************************************************/
; ##################################################################################
; # This #Include file was generated by Image2Include.ahk, you must not change it! #
; ##################################################################################
Create_HznHorizon_ico(NewHandle := False) {
	Static hBitmap := 0
	If (NewHandle)
		hBitmap := 0
	If (hBitmap)
		Return hBitmap
	B64 := "AAABAAEAICAAAAEAIACoEAAAFgAAACgAAAAgAAAAQAAAAAEAIAAAAAAAgBAAAGAbAABgGwAAAAAAAAAAAAD7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv////////////////////////////////////////////////f/////RERE//tcQv/7XEL////////////////////////////////////////////////3/////0RERP/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL///////////////////////////f/////RERE//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC////////////////////////////////90RERP/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/////////////////RERE//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC/////////////////0RERP/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC/////////////////0RERP/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/////////////////RERE//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/////////////////RERE//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC/////////////////0RERP/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC/////////////////0RERP/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/////////////////RERE//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/////////////////RERE//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC/////////////////0RERP/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC////////////////////////////////////////////////////////////////////////////////////////////RERE//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL///////////////////////////////////////////f////3////9/////f///////////////////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC/////////////////0RERP/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC/////////////////0RERP/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/////////////////RERE//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/////////////////RERE//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC/////////////////0RERP/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC/////////////////0RERP/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/////////////////RERE//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/////////////////RERE//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC/////////////////0RERP/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/////////////////////////////////RERE//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//////////////////////////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC////////////////////////////////////////////RERE//tcQv/7XEL/+1xC//tcQv////////////////////////////////////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
	If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", StrPtr(B64), "UInt", 0, "UInt", 0x01, "Ptr", 0, "UIntP", &DecLen := 0, "Ptr", 0, "Ptr", 0)
		Return False
	Dec := Buffer(DecLen, 0)
	If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", StrPtr(B64), "UInt", 0, "UInt", 0x01, "Ptr", Dec, "UIntP", &DecLen, "Ptr", 0, "Ptr", 0)
		Return False
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

