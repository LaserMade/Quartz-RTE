; #Requires AutoHotkey v1.1+ 
#Include <Class\WinClip\WinClip>
#Include <Class\WinClip\WinClipAPI>
;============================== Start Auto-Execution Section ==============================
; #Warn  ; Enable warnings to assist with detecting common errors.
; REMOVED: ;#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.; Avoids checking empty variables to see if they are environment variables.
;#Persistent ; Keeps script permanently running
;#SingleInstance,Force
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
;SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; REMOVED: ;SetBatchLines, -1 ; Determines how fast a script will run (affects CPU utilization). ; The value -1 means the script will run at it's max speed possible.
;SetWinDelay, -1
;SetControlDelay, -1
;SetTitleMatchMode, 2 ; sets title matching to search for "containing" instead of "exact"
;============================== End Auto-Execution Section ==============================

; | ============================== Horizon Italics Script ============================== |

/*; | ------------------------------ Begin Test Function ------------------------------ |
; ctrl alt v will paste "Send this string in Italic" where ever the cursor is.
; Format: HorzItalic("string", fontsize, font)
; Font Options: fontsize and font are optional. The main function is below as sets the fontsize to 11 (Horizon's fontsize), and font to Times New Roman.
^!v::
{ ; V1toV2: Added bracket
str_in:= "My purpose is to be a test string. I don't do/interfere with anything; however, I can change stuff here to see what it looks like."
HorzItalic(str_in, 11, default)
return
; | ------------------------------ End Test Function ------------------------------ |
*/
;Note: font size is set with \fs and uses half points meaning if you want size 10 you need to set it as \fs20 hence the (fontsize * 2) below. Also note that Changing fonts is a bit more tricky than you might think, RTF format uses font families, Times New Roman is part of the swiss font family (hence the \fswiss just before we select the font name). IF you want to change to a font not in the swiss family you can find them here on page 6: https://latex2rtf.sourceforge.net/RTF-Spec-1.2.pdf.If you want to reset the font to non-italics, note the {... " str_in " \i0  }. {... "{Space}str_in{Space}"{Space}\i0{Space1}{Space2}} <==== two spaces are REQUIRED!!!{Space1} is a format perameter, {Space2} is an actual space.
; | ------------------------------ Main Function ------------------------------ |

HorzItalic(str_in, fontsize := 11, font := "Times New Roman") {
	rtf:= Ltrim("{\rtf1\ansi{\fonttbl\f0\fswiss " font ";}\f0\pard{\i\fs" fontsize * 2 " " str_in "}{ }}")
	WinClip.Clear()
	WinClip.SetRTF(rtf)
	WinClip.Paste()
	Send("{Backspace}")
	Sleep(25)
}
; | ============================== End Script ============================== |

; | ========================================================= Additional/Other Script Testing for RTF ========================================================= |

; | ------------------------------ Test Function ------------------------------ |

#HotIf WinActive("ahk_exe hznhorizon.exe", )
^#b::
{ ; V1toV2: Added bracket
Send("^c")
Errorlevel := !ClipWait(1)
Sleep(100)
str_in:= A_Clipboard
Sleep(100)
send_bold(str_in)
} ; V1toV2: Added Bracket before hotkey or Hotstring
^#i::
{ ; V1toV2: Added bracket
Send("^c")
Errorlevel := !ClipWait(1)
Sleep(100)
str_in:= A_Clipboard
Sleep(100)
send_italic(str_in)
} ; V1toV2: Added Bracket before hotkey or Hotstring
^#u::
{ ; V1toV2: Added bracket
Send("^c")
Errorlevel := !ClipWait(1)
str_in:= A_Clipboard
send_underline(str_in)
} ; V1toV2: Added bracket in the end
#HotIf
;============================== End Script ==============================
;============================== Horizon Send Italic Text =============================================================
send_italic(str_in, fontsize := 11, font := "Times New Roman") ;defaults to 11pt font size, times new roman
{
	WinClip.Clear()
	WinClip.SetRTF(Ltrim( "{\rtf1\ansi{\fonttbl\f0\fswiss " font ";}\f0\pard{\i\fs" fontsize * 2 " " str_in "}{ }}"))
	WinClip.Paste()
	Sleep(100)
	Send("{Backspace}")
	Sleep(25)
}
;============================== End Script ==============================
;============================== Horizon Send Bold Text =============================================================
send_bold(str_in, fontsize := 11, font := "Times New Roman") ;defaults to 11pt font size, times new roman
{
	WinClip.Clear()
	WinClip.SetRTF(Ltrim( "{\rtf1\ansi{\fonttbl\f0\fswiss " font ";}\f0\pard{\b\fs" fontsize * 2 " " str_in "}{ }}"))
	WinClip.Paste()
	Sleep(100)
	Send("{Backspace}")
	Sleep(25)
}
return
;============================== End Script ==============================

send_underline(str_in, fontsize := 11, font := "Times New Roman") ;defaults to 11pt font size, times new roman
{
	WinClip.Clear()
	WinClip.SetRTF(Ltrim( "{\rtf1\ansi{\fonttbl\f0\fswiss " font ";}\f0\pard{\ul\fs" fontsize * 2 " " str_in "}{ }}"))
	WinClip.Paste()
	Sleep(100)
	Send("{Backspace}")
	Sleep(25)
}
return
;============================== End Script ==============================

; |------------------------ Original -----------------------------------
;send_italic(str_in)
;{
	;	WinClip.Clear()
	;	rtf :=
	;  (Ltrim
;   "{\rtf1\ansi{\fonttbl\f0\froman Times New Roman;}\f0\fs22\pard
;   {\i " str_in "}
;   { }}"
;   )								
;	WinClip.SetRTF(rtf)
;	return WinClip.Paste()
;}
;============================== End Script ==============================