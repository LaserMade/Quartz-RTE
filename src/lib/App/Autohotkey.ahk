#Include <Utils\Win>

class AutoHotkey_ProgFiles {

	static path := A_ProgramFiles "\AutoHotkey"
	static currVersion := this.path "\v2"
	static processExe := A_AhkPath
	static exeTitle := "ahk_exe " this.processExe

}
class AutoHotkey {

	; static path := RegExReplace(A_AppData, 'i)\Roaming', '\Local\Programs\' . "\AutoHotkey\v2")
	static path := Paths.v2Prog
	; static currVersion := this.path "\v2"
	static processExe := A_AhkPath
	static exeTitle := "ahk_exe " this.processExe
	static exe := RegExReplace(this.processExe, '.ahk', '.exe')

}

Class AHK_v2_Projects extends AutoHotkey {
	static path := AutoHotkey.path
	static v2folder := this.path '\AHK.Projects.v2'
}

Class RichEdit_Editor_v2 {
	static path := A_MyDocuments . '\AutoHotkey\Lib'
	static folder := this.path '\RTE.v2'
	static project := this.folder . '\Project Files'
	static file_name := 'RichEdit_Editor_v2.ahk'
	static run := this.project . '\' . this.file_name
}
