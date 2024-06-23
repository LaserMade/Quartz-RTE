;No dependencies

; DarkMode(guiObj) {
DarkMode(guiObj, BackColor := '') {
	; guiObj.BackColor := "171717" ;? original
	; guiObj.BackColor := "255"
	; guiObj.BackColor := "0x450095"
	; guiObj.BackColor := "0xA2AAAD"
	if BackColor = ''{
		; guiObj.BackColor := "171717" ;? original
		; guiObj.BackColor := "255"
		; guiObj.BackColor := "0x450095"
		guiObj.BackColor := "0xA2AAAD"
	} else {
		guiObj.BackColor := BackColor
	}
	return guiObj
}
Gui.Prototype.DefineProp("DarkMode", {Call: DarkMode})

MakeFontNicer(guiObj, fontSize := 20) {
	; guiObj.SetFont("s" fontSize " cC5C5C5", "Consolas") ;? cC5C5C5 = gray,gray,silver
	; guiObj.SetFont("s" fontSize " c0xA2AAAD", "Consolas") ;? cC5C5C5 = gray,gray,silver
	guiObj.SetFont("s" fontSize " c0000ff", "Consolas") ;? cC5C5C5 = gray,gray,silver
	return guiObj
}
Gui.Prototype.DefineProp("MakeFontNicer", {Call: MakeFontNicer})

PressTitleBar(guiObj) {
	PostMessage(0xA1, 2,,, guiObj) ;? WM_NCLBUTTONDOWN
	return guiObj
}
Gui.Prototype.DefineProp("PressTitleBar", {Call: PressTitleBar})

NeverFocusWindow(guiObj) {
	WinSetExStyle("0x08000000L", guiObj) ;? WS_EX_NOACTIVATE
	WinSetExStyle('0x00000020L', guiObj) ;? WS_EX_TRANSPARENT
	WinSetExStyle('0x02000000L', guiObj) ;? WS_EX_COMPOSITED ; Paints all descendants of a window in bottom-to-top painting order using double-buffering. Bottom-to-top painting order allows a descendent window to have translucency (alpha) and transparency (color-key) effects, ...
	WinSetExStyle('0x00000200L', guiObj) ;? WS_EX_CLIENTEDGE ; The window has a border with a sunken edge.
	WinSetExStyle('0x00040000L', guiObj) ;? WS_EX_APPWINDOW ; Forces a top-level window onto the taskbar when the window is visible.
	return guiObj
}
Gui.Prototype.DefineProp("NeverFocusWindow", {Call: NeverFocusWindow})

MakeClickThrough(guiObj) {
	WinSetTransparent(255, guiObj)
	guiObj.Opt("+E0x20")
	return guiObj
}
Gui.Prototype.DefineProp("MakeClickThrough", {Call: MakeClickThrough})