; --------------------------------------------------------------------------------
;                Ctrl+Shift+Alt+r Reload AutoHotKey Script (to load changes)
; --------------------------------------------------------------------------------
^+!r::ReloadAllAhkScripts()
ReloadAllAhkScripts()
{
	DetectHiddenWindows(true)
	static oList := WinGetList("ahk_class AutoHotkey",,,)
	aList := Array()
	List := oList.Length
	For v in oList
	{
		aList.Push(v)
	}
	scripts := ""
	Loop aList.Length
		{
			title := WinGetTitle("ahk_id " aList[A_Index])
			;PostMessage(0x111,65414,0,,"ahk_id " aList[A_Index])
			dnrList := [A_ScriptName, "Scriptlet_Library"]
			rmList := InStr(title, "Scriptlet_Library", false)
			
			If (title = A_ScriptName) || (title = "Scriptlet_Library"){
				continue
			}
			PostMessage(0x111,65400,0,,"ahk_id " aList[A_Index])
			; Note: I think the 654*** is for v2 => avoid the 653***'s
			; [x] Reload:		65400
			; [x] Help: 		65411 ; 65401 doesn't really work or do anything that I can tell
			; [x] Spy: 			65402
			; [x] Pause: 		65403
			; [x] Suspend: 		65404
			; [x] Exit: 		65405
			; [x] Variables:	65406
			; [x] Lines Exec:	65407 & 65410
			; [x] HotKeys:		65408
			; [x] Key History:	65409
			; [x] AHK Website:	65412 ; Opens https://www.autohotkey.com/ in default browser; and 65413
			; [x] Save?:		65414
			; Don't use these => ;//static a := { Open: 65300, Help:    65301, Spy: 65302, XXX (nonononono) Reload: 65303 [bad reload like Reload()], Edit: 65304, Suspend: 65305, Pause: 65306, Exit:   65307 }
			; scripts .=  (scripts ? "`r`n" : "") . RegExReplace(title, " - AutoHotkey v[\.0-9]+$")
			scripts .=  (scripts ? "`r`n" : "") . RegExReplace(title, " - AutoHotkey v[\.0-9]+$")
		}
}