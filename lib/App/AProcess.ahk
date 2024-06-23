#Include <Utils\Win>
#Include <Abstractions\Text>
#Include <Tools\Info>
#Include <Extensions\String>
#Include <Paths>

class AProcess {

	static exeTitle := AutoHotkey.exeTitle
	static winTitle := "__A_Process.v2.ahk"
	static path := Paths.Lib '\__A_Process.v2.ahk'

	static winObj := Win({
		winTitle: this.winTitle,
		exePath:  this.path,
	})

	static CloseAllTabs()  => Send("+!w")
	static Reload()        => Send("+!y+!y")
	static CloseTab()      => Send("!w")

}
