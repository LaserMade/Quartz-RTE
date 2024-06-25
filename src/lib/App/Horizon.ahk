#Include <Utils\Win>

class Horizon {

	static process := 'hznHorizon.exe'	
	static exeTitle := 'ahk_exe ' this.process
	; static winTitle := "DS4Windows " this.exeTitle
	static winTitle := "hznHorizonMgr.exe"
	static path := Paths.Horizon 

	static winObj := Win({
		winTitle: this.winTitle,
		exePath: this.path
	})
}