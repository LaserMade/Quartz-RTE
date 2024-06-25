#Requires AutoHotkey v2
#Include <Directives\__AE.v2>
#Include <Tools\Info>
#Include <Includes\Includes_Extensions>
; #Include <Extensions\Array>
; #Include <..\AHK.Projects.v2\PDF2txt.ahk-v2\PDF2TXT>
; #Include <..\..\AHK.Projects.v2\PDF2txt.ahk-v2\PDF2TXT>
; ---------------------------------------------------------------------------
; @region...: explorerGetPath()
; ---------------------------------------------------------------------------
; #HotIf WinActive('ahk_class CabinetWClass')
; F3:: Infos(explorerGetPath())
; ^+Enter::
; ^+LButton::Run(Paths.Code '"' explorerGetPath() '"')
; #HotIf
; ---------------------------------------------------------------------------
; @link...: v1: explorerGetSelection() https://www.autohotkey.com/boards/viewtopic.php?style=17&t=60403#p255169
; //TODO - convert the above script to v2
; @link...: v2: https://www.autohotkey.com/boards/viewtopic.php?p=518918#p518918
; @link...: v2: https://www.autohotkey.com/boards/viewtopic.php?p=387113#p387113
; ---------------------------------------------------------------------------
explorerGetPath(hwnd := 0) {
	Static winTitle := 'ahk_class CabinetWClass'
	hWnd?    explorerHwnd := WinExist(winTitle ' ahk_id ' hwnd)
		: ((!explorerHwnd := WinActive(winTitle)) && explorerHwnd := WinExist(winTitle))
	If explorerHwnd{
		For window in ComObject('Shell.Application').Windows
			Try If (window && window.hwnd && window.hwnd = explorerHwnd) {
				Return window.Document.Folder.Self.Path
			}
		}
	Return False
}
; ---------------------------------------------------------------------------
; @endregion
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
; @region...: explorerGetFilePath()
; ---------------------------------------------------------------------------
#HotIf WinActive('ahk_class CabinetWClass')
; F3::{
; 	sel := []
; 	sel := getSelected()
; 	str := ''
; 	str := sel.ToString()
; 	len := sel.Length
; 	Infos(len '`n' str)
; }
F3::fileString()
fileString(&str?){
	sel := []
	sel := getSelected()
	str := ''
	str := sel.ToString()
	len := sel.Length
	; Infos(len '`n' str)
	return str
}
^+Enter::
^+LButton::{
	sel := []
	sel := ''
	sel := getSelected()
	len := sel.length
	if len == 1 {
		sel := sel.ToString()
		Run(Paths.Code ' "' sel '"')
		; Infos('len == ' len)
	}
	else {
		for each, value in sel {
			Run(Paths.Code ' "' value '"')
			; Infos('I did this array to run.')
		}
	}
}
; ^+p::{
; 	; sel := []
;     text := ''
; 	sel := ''
; 	sel := getSelected()
;     Infos(sel)
;     ; return
;     text := PDF2TXT(sel)
; 	; len := sel.length
; 	; if len == 1 {
; 	; 	sel := sel.ToString()
;     ;     text := PDF2TXT(sel)
; 	; 	; Run(Paths.Code ' "' sel '"')
; 	; }
; 	; else {
; 	; 	for each, value in sel {
; 	; 		; Run(Paths.Code ' "' value '"')
;     ;         text := PDF2TXT(value)
; 	; 	}
; 	; }
;     MsgBox(text)
; }
#HotIf
; ---------------------------------------------------------------------------
; @description..: Get the paths of selected files and folders both in Explorer and on the Desktop
; @link...: v1: GEV: https://www.autohotkey.com/boards/viewtopic.php?p=514288#p514288
; @link...: v2: https://www.autohotkey.com/boards/viewtopic.php?style=17&t=60403#p255256
; @author.: v1: GEV, teadrinker
; @author.: v2: mikeyww
; ---------------------------------------------------------------------------
getSelected(hWnd := 0) { 
	Static SWC_DESKTOP := 8, SWFO_NEEDDISPATCH := 1
	winClass := WinGetClass(hWnd := WinActive('A'))
	If !(winClass ~= 'Progman|WorkerW|(Cabinet|Explore)WClass'){
		Return
	}
	shellWindows := ComObject('Shell.Application').Windows
	sel := []
	If !(winClass ~= 'Progman|WorkerW') {
		For window in shellWindows{
			If hWnd = window.HWND && shellFolderView := window.Document{
				Break
			}
		}
	}
	Else shellFolderView := shellWindows.FindWindowSW(0, 0, SWC_DESKTOP, 0, SWFO_NEEDDISPATCH).Document
	For item in shellFolderView.SelectedItems{
		sel.SafePush(item.Path)
	}
	Return sel
}
; ---------------------------------------------------------------------------
; @endregion
; ---------------------------------------------------------------------------
