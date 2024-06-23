#Requires AutoHotkey v2+ 
#Include <Includes\Includes_Extensions>
#Include <Utils\GetFilesSortedByDate>
#Include <Paths>
#Include <App\VSCode>

; ---------------------------------------------------------------------------
; @i: Open the folder containing the file, and (optional) edit the file in VS Code
; @var: path: Can contain the file name, or just the path to the file
; @var: newWin: Open file/folder in new window
; @var: edit: Default = true (1) = Edit the file in VS Code
; @var: oFolder: Default = true (1) = Open the file in Explorer
; @var: fRun: Default = true (1) = Run the file
; ---------------------------------------------------------------------------
OpenEdit(fullpath := '', fRun := true, newWin := false, edit := true, oFolder := true) {
	; n := f := p:= '', list := [], n := ('^([\\])$(\w+\.\w+)') ;! not in use atm
	; ---------------------------------------------------------------------------
	; @i...: Unless provided, get the full path of the file (in an array)
	; ---------------------------------------------------------------------------
	val := GetFilesSortedByDate(fullpath)
	; ---------------------------------------------------------------------------
	; @i...: convert the file path array into a single string
	; ---------------------------------------------------------------------------
	strPath := val.ToString('')
	; ---------------------------------------------------------------------------
	; @i...: If opening the folder, first check for the strPath (full file path)
	; @i...: Else the full file path is already provided (fullpath)
	; ---------------------------------------------------------------------------
	(oFolder = 1 && strPath != '') ? Explorer.OpenFolder(strPath) : (oFolder = 1 && fullpath != '') ? Explorer.OpenFolder(fullpath): Infos('No folder found to open.', 5000)
	; Infos('`nstrpath: ' strPath '`nfullpath: ' fullpath, 10000)
	; edit = 1 ? Run(Paths.Code ' "' fullpath '"') : Infos('Unable to open the file for editing.', 5000)
	; ---------------------------------------------------------------------------
	; @i...: Edit the file in VS Code in the existing window, or a new window
	; ---------------------------------------------------------------------------
	edit = 1 ? (newWin = 1 ? VSCode.nEdit(fullpath) : VSCode.Edit(fullpath)) : Infos('Unable to open the file for editing.', 5000)
}
; ---------------------------------------------------------------------------