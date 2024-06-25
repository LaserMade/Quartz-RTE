#Include <Utils\Win>
#Include <Abstractions\Text>
#Include <Tools\Info>
#Include <Extensions\String>
#Include <Paths>

class VSCode {

	; static exeTitle := "ahk_exe Code - Insiders.exe"
	static exeTitle := "ahk_exe Code.exe"
	static winTitle := "Visual Studio Code " this.exeTitle
	static path := Paths.Code

	static winObj := Win({
		winTitle: this.winTitle,
		exePath:  this.path,
	})

    static Edit_Window_Current(fileOrfolder) {
        ; Run(Paths.Code ' "' fileOrfolder '"') ;! This works, but below using the App syntax
        Run(this.winObj.exePath ' "' fileOrfolder '"')
    }
    static Edit_Window_New(fileOrfolder) {
        ; Run(Paths.Code ' -n "' fileOrfolder '"') ;! This works, but below using the App syntax
        Run(this.winObj.exePath ' -n "' fileOrfolder '"')
    }
    
    ; ---------------------------------------------------------------------------
    ; @i...: Syntax Sugar - make it easier to call the class methods using dot notification
    ; ---------------------------------------------------------------------------
    static nEdit(fileOrfolder) => this.Edit_Window_New(fileOrfolder)
    static Edit(fileOrfolder) => this.Edit_Window_Current(fileOrfolder)
    ; ---------------------------------------------------------------------------

	static CloseAllTabs()  => Send("+!w")
	static Reload()        => Send("+!y+!y")
	static CloseTab()      => Send("!w")

}
