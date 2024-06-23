#Requires AutoHotkey v2.0.11+
#Include <Directives\__AE.v2>
#Include <Includes\Includes_Standard>
; SendMode('Event')
; Clip() - Send and Retrieve Text Using the Clipboard
; by berban - updated 6/23/2023
; https://www.autohotkey.com/boards/viewtopic.php?f=83&t=118764
Clip(Text:="", Reselect:=true, Restore:=False)
{
	Static BackUpClip := '', Stored := False, LastClip := '', RestoreClip := Clip.Bind(,,True)
	wordCount := 0
	; BackUpClip := ''
	; Stored := False
	; LastClip := ''
	; static RestoreClip := Clip.Bind(,,True)
	if text {
		wordCount := RegExMatch(text, '([\s]+)')
	}
	If !Stored {
		Stored := True
		BackUpClip := ClipboardAll() ; ClipboardAll must be on its own line (or does it in v2?)
	}
	Else {
		SetTimer(RestoreClip, 0)
	}
	; LongCopy gauges the amount of time it takes to empty the clipboard which can predict how long the subsequent clipwait will need
	LongCopy := A_TickCount, A_Clipboard := "", LongCopy -= A_TickCount 
	If (Text = "") {
		Send("^c")
		ClipWait( LongCopy ? 0.6 : 0.2, True)
	}
	Else {
		A_Clipboard := LastClip := Text
		; A_Clipboard := Text
		ClipWait(10)
		; Send("^v")
		Send('^{sc2F}')
	}
	SetTimer(RestoreClip, -700)
	; ---------------------------------------------------------------------------
	; @i ..: Short sleep in case Clip() is followed by more keystrokes such as {Enter}
	Sleep(50) 
	; ---------------------------------------------------------------------------
	If (Text = ""){
		Return LastClip := A_Clipboard
		; Return A_Clipboard := LastClip
	}
	Else If ReSelect and ((ReSelect = True) or (StrLen(Text) < 3000)) { ; and !(WinActive("ahk_class XLMAIN") or WinActive("ahk_class OpusApp"))
		; Send("{Shift Down}{Left " StrLen(StrReplace(Text, "`r")) "}{Shift Up}")
		SetKeyDelay(100)
		Send("{Control Down}{Shift Down}{Left " (wordCount + 1) "}{Shift Up}{Control Up}")
		; Send('^+' (wordCount + 1))
	}
	sleep(100)
	; If Restore {
	; 	If (A_Clipboard == LastClip){
	; 		A_Clipboard := BackUpClip
	; 	}
	; 	BackUpClip := LastClip := Stored := ""
	; }
	; Run(A_ScriptName)
}