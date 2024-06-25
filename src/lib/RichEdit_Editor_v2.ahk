; @i ...: RichEdit Demo
; ================================================================================
; @Ahk2Exe-IgnoreBegin
#Requires AutoHotkey v2.0
#Include <Directives\__AE.v2>
#Include <Includes\Includes_Standard>
; @Ahk2Exe-IgnoreEnd
AE._DPIAwareness()
; ---------------------------------------------------------------------------
; @i ...:function ...: Create a Gui with RichEdit controls
; ---------------------------------------------------------------------------
;! ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
; @i ...: function: Initial values
; ---------------------------------------------------------------------------
global GuiTitle := 'Horizon Rich Text Editor - hznRTE -- A Rich Text Editor for Horizon',
FontName := "Times New Roman", FontSize := "11",
BackColor := "cYellow", FontStyle := "Norm",
FontCharSet := 1, TextColor := "cBlack",
TextBkColor := "Auto",
WordWrap := True, AutoURL := False, ShowWysiwyg := False, HasFocus := False, 
Zoom := "100 %", CurrentLine := 0, CurrentLineCount := 0,
hMult := 5, wMult := 2, gHmult := 2,div := 5, MarginX := 10, MarginY := 10,
EditH:=0, EditW:=0, w := EditW, h := EditH, GuiW := Round(A_ScreenWidth * (1/4)),
GuiH := Round(A_ScreenHeight * (1/4)), REW := w, REH := h
Options := (' +Resize' ' +Border' ' +DPIScale' ' +Caption')
; ---------------------------------------------------------------------------
rteFilesDir := A_MyDocuments '\RichEdit'
rteFilesCurrDir := rteFilesDir '\' A_YWeek
rteJsonDir := rteFilesDir '\jsonMap'
rtfName := (A_UserName '.' A_YYYY '.' A_MM '.' A_DD ' ' A_Hour '.' A_Min '.rtf')
rtfPath := rteFilesCurrDir '\' rtfName
; ---------------------------------------------------------------------------
jsonMapFName := 'jsonMap.json'
jsonPath := rteJsonDir '\' jsonMapFName
; ---------------------------------------------------------------------------
if !DirExist(rteFilesDir) {
	DirCreate(rteFilesDir)
}
if !DirExist(rteFilesCurrDir){
	DirCreate(rteFilesCurrDir)
}
if !DirExist(rteJsonDir) {
	DirCreate(rteJsonDir)
}
jsonMap := Map(
	'x', x := 0,
	'y', y := 0,
	'w', w := 0,
	'h', h := 0,
	'fCtl', fCtl := 0,
	'hWnd', WinA := 0,
	'ClassNN', ClassNN := '',
	'title', WinT := '',
	'rteFilesDir', rteFilesDir := (A_MyDocuments '\RichEdit'),
	'rteFilesCurrDir', rteFilesCurrDir := (rteFilesDir '\' A_YWeek),
	'rtfName', rtfName := (A_UserName '.' A_YYYY '.' A_MM '.' A_DD ' ' A_Hour '.' A_Min '.rtf'),
)
jsontxt := jsongo.Stringify(jsonMap,,'`n`t')
WriteNotesJson() => WriteFile(jsonPath, jsontxt)
If !FileExist(jsonPath) {
	WriteNotesJson()
}
notesmap := jsongo.Parse(ReadFile(jsonPath))
if !FileExist(rtfPath) {
	AppendFile(rtfPath, rtfName)
}
; ---------------------------------------------------------------------------
switch {
	case WinExist(receiver.rMap['hCtl']):
		EditW := (receiver.rMap['width']+ (MarginX * wMult))
		EditW := Round((EditW / div) * (div - 1))
		EditH := (receiver.rMap['height'] + (MarginY * hMult))
		EditH := Round(EditH)*2
	default:
		EditW := (A_ScreenHeight / 2)
		EditH := 1000
}

global MainGui := Gui(Options, GuiTitle)

EditH := Round(GuiH + (MarginY * hMult))
; ---------------------------------------------------------------------------
(EditW > GuiW) ? EditW := (GuiW * 1.75) : EditW := (GuiW * 1.75)
; ---------------------------------------------------------------------------
REW := w := EditW, REH := h := EditH
; ---------------------------------------------------------------------------
defaultFont()

; ---------------------------------------------------------------------------
; @Section ...: Menus
; ---------------------------------------------------------------------------
; @i ...: FileMenu
; ---------------------------------------------------------------------------
; FileMenu := Menu()
; FileMenu.Add("&Open", FileLoadFN.Bind("Open"))
; FileMenu.Add("&Append", FileLoadFN.Bind("Append"))
; FileMenu.Add("&Insert", FileLoadFN.Bind("Insert"))
; FileMenu.Add("&Close", FileCloseFN)
; FileMenu.Add("&Save", FileSaveFN)
; FileMenu.Add("Save &as", FileSaveAsFN)
; FileMenu.Add()
; FileMenu.Add("Page &Margins", PageSetupFN)
; FileMenu.Add("&Print", PrintFN)
; FileMenu.Add()
; FileMenu.Add("&Exit", MainGuiClose)
RE_FileMenu()
RE_FileMenu(*){
	Global FileMenu
	FileMenu := Menu()
	FileMenu.Add("&Open", FileLoadFN.Bind("Open"))
	FileMenu.Add("&Append", FileLoadFN.Bind("Append"))
	FileMenu.Add("&Insert", FileLoadFN.Bind("Insert"))
	FileMenu.Add("&Close", FileCloseFN)
	FileMenu.Add("&Save", FileSaveFN)
	FileMenu.Add("Save &as", FileSaveAsFN)
	FileMenu.Add()
	FileMenu.Add("Page &Margins", PageSetupFN)
	FileMenu.Add("&Print", PrintFN)
	FileMenu.Add()
	FileMenu.Add("&Exit", MainGuiClose)
}
; ---------------------------------------------------------------------------
; @i ...: EditMenu
; ---------------------------------------------------------------------------
; EditMenu := Menu()
; EditMenu.Add("&Undo`tCtrl+Z", UndoFN)
; EditMenu.Add("&Redo`tCtrl+Y", RedoFN)
; EditMenu.Add()
; EditMenu.Add("C&ut`tCtrl+X", CutFN)
; EditMenu.Add("&Copy`tCtrl+C", CopyFN)
; EditMenu.Add("&Paste`tCtrl+V", PasteFN)
; EditMenu.Add("C&lear`tDel", ClearFN)
; EditMenu.Add()
; EditMenu.Add("Select &all `tCtrl+A", SelAllFN)
; EditMenu.Add("&Deselect all", DeselectFN)
RE_EditMenu()
RE_EditMenu(*) {
	Global EditMenu
	EditMenu := Menu()
	EditMenu.Add("&Undo`tCtrl+Z", UndoFN)
	EditMenu.Add("&Redo`tCtrl+Y", RedoFN)
	EditMenu.Add()
	EditMenu.Add("C&ut`tCtrl+X", CutFN)
	EditMenu.Add("&Copy`tCtrl+C", CopyFN)
	EditMenu.Add("&Paste`tCtrl+V", PasteFN)
	EditMenu.Add("C&lear`tDel", ClearFN)
	EditMenu.Add()
	EditMenu.Add("Select &all `tCtrl+A", SelAllFN)
	EditMenu.Add("&Deselect all", DeselectFN)
}
; ---------------------------------------------------------------------------
; @i ...: SearchMenu
; ---------------------------------------------------------------------------
; SearchMenu := Menu()
; SearchMenu.Add("&Find", FindFN)
; SearchMenu.Add("&Replace", ReplaceFN)
RE_SearchMenu()
RE_SearchMenu(*){
	Global SearchMenu
	SearchMenu := Menu()
	SearchMenu.Add("&Find", FindFN)
	SearchMenu.Add("&Replace", ReplaceFN)
}
; ---------------------------------------------------------------------------
; @Section ...: FormatMenu
; ---------------------------------------------------------------------------
; @i ...: Paragraph
; ---------------------------------------------------------------------------
; AlignMenu := Menu()
; AlignMenu.Add("Align &left`tCtrl+L", AlignFN.Bind("Left"))
; AlignMenu.Add("Align &center`tCtrl+E", AlignFN.Bind("Center"))
; AlignMenu.Add("Align &right`tCtrl+R", AlignFN.Bind("Right"))
; AlignMenu.Add("Align &justified", AlignFN.Bind("Justify"))
RE_AlignMenu()
RE_AlignMenu(*){
	global AlignMenu
	AlignMenu := Menu()
	AlignMenu.Add("Align &left`tCtrl+L", AlignFN.Bind("Left"))
	AlignMenu.Add("Align &center`tCtrl+E", AlignFN.Bind("Center"))
	AlignMenu.Add("Align &right`tCtrl+R", AlignFN.Bind("Right"))
	AlignMenu.Add("Align &justified", AlignFN.Bind("Justify"))
	return AlignMenu
}
; ---------------------------------------------------------------------------

IndentMenu := Menu()
IndentMenu.Add("&Set", IndentationFN.Bind("Set"))
IndentMenu.Add("&Reset", IndentationFN.Bind("Reset"))
; ---------------------------------------------------------------------------
LineSpacingMenu := Menu()
LineSpacingMenu.Add("1 line`tCtrl+1", SpacingFN.Bind(1.0))
LineSpacingMenu.Add("1.5 lines`tCtrl+5", SpacingFN.Bind(1.5))
LineSpacingMenu.Add("2 lines`tCtrl+2", SpacingFN.Bind(2.0))
; ---------------------------------------------------------------------------
NumberingMenu := Menu()
NumberingMenu.Add("&Set", NumberingFN.Bind("Set"))
NumberingMenu.Add("&Reset", NumberingFN.Bind("Reset"))
; ---------------------------------------------------------------------------
TabstopsMenu := Menu()
TabstopsMenu.Add("&Set Tabstops", SetTabstopsFN.Bind("Set"))
TabstopsMenu.Add("&Reset to Default", SetTabstopsFN.Bind("Reset"))
TabstopsMenu.Add()
TabstopsMenu.Add("Set &Default Tabs", SetTabstopsFN.Bind("Default"))
; ---------------------------------------------------------------------------
ParaSpacingMenu := Menu()
ParaSpacingMenu.Add("&Set", ParaSpacingFN.Bind("Set"))
ParaSpacingMenu.Add("&Reset", ParaSpacingFN.Bind("Reset"))
; ---------------------------------------------------------------------------
ParagraphMenu := Menu()
ParagraphMenu.Add("&Alignment", AlignMenu)
ParagraphMenu.Add("&Indentation", IndentMenu)
ParagraphMenu.Add("&Numbering", NumberingMenu)
ParagraphMenu.Add("&Linespacing", LineSpacingMenu)
ParagraphMenu.Add("&Space before/after", ParaSpacingMenu)
ParagraphMenu.Add("&Tabstops", TabstopsMenu)
; ---------------------------------------------------------------------------
; Character
; ---------------------------------------------------------------------------
TxColorMenu := Menu()
TxColorMenu.Add("&Choose", TextColorFN.Bind("Choose"))
TxColorMenu.Add("&Auto", TextColorFN.Bind("Auto"))
; ---------------------------------------------------------------------------
BkColorMenu := Menu()
BkColorMenu.Add("&Choose", TextBkColorFN.Bind("Choose"))
BkColorMenu.Add("&Auto", TextBkColorFN.Bind("Auto"))
; ---------------------------------------------------------------------------
CharacterMenu := Menu()
CharacterMenu.Add("&Font", ChooseFontFN)
CharacterMenu.Add("&Text color", TxColorMenu)
CharacterMenu.Add("Text &Backcolor", BkColorMenu)
; ---------------------------------------------------------------------------
; Format
; ---------------------------------------------------------------------------
FormatMenu := Menu()
FormatMenu.Add("&Character", CharacterMenu)
FormatMenu.Add("&Paragraph", ParagraphMenu)
; ---------------------------------------------------------------------------
; ViewMenu--------------------------------------------------------------------------------------------------------------
; ---------------------------------------------------------------------------
; Background
; ---------------------------------------------------------------------------
BackgroundMenu := Menu()
BackgroundMenu.Add("&Choose", BackGroundColorFN.Bind("Choose"))
BackgroundMenu.Add("&Auto", BackgroundColorFN.Bind("Auto"))
; ---------------------------------------------------------------------------
; Zoom
; ---------------------------------------------------------------------------
ZoomMenu := Menu()
ZoomMenu.Add("200 %", ZoomFN.Bind(200))
ZoomMenu.Add("150 %", ZoomFN.Bind(150))
ZoomMenu.Add("125 %", ZoomFN.Bind(125))
ZoomMenu.Add("100 %", Zoom100FN)
ZoomMenu.Check("100 %")
ZoomMenu.Add("75 %", ZoomFN.Bind(75))
ZoomMenu.Add("50 %", ZoomFN.Bind(50))
; ---------------------------------------------------------------------------
; View
; ---------------------------------------------------------------------------
ViewMenu := Menu()
MenuWordWrap := "&Word-wrap"
ViewMenu.Add(MenuWordWrap, WordWrapFN)
MenuWysiwyg := "Wrap as &printed"
ViewMenu.Add(MenuWysiwyg, WysiWygFN)
ViewMenu.Add("&Zoom", ZoomMenu)
ViewMenu.Add()
ViewMenu.Add("&Background Color", BackgroundMenu)
ViewMenu.Add("&URL Detection", AutoURLDetectionFN)
; ---------------------------------------------------------------------------
; ContextMenu ----------------------------------------------------------------------------------------------------------
; ---------------------------------------------------------------------------
ContextMenu := Menu()
ContextMenu.Add("&File", FileMenu)
ContextMenu.Add("&Edit", EditMenu)
ContextMenu.Add("&Search", SearchMenu)
ContextMenu.Add("F&ormat", FormatMenu)
ContextMenu.Add("&View", ViewMenu)
; ---------------------------------------------------------------------------
; MainMenuBar ----------------------------------------------------------------------------------------------------------
; ---------------------------------------------------------------------------
MainMenuBar := MenuBar()
MainMenuBar.Add("&File", FileMenu)
MainMenuBar.Add("&Edit", EditMenu)
MainMenuBar.Add("&Search", SearchMenu)
MainMenuBar.Add("F&ormat", FormatMenu)
MainMenuBar.Add("&View", ViewMenu)
;! ---------------------------------------------------------------------------
; @Section ...: Main Gui
;! ---------------------------------------------------------------------------
GuiNum := 1
Options := (' +Resize' ' +Border' ' +DPIScale' ' +Caption')
global MainGui := Gui(Options, GuiTitle)
; MainGui.OnEvent("Size", GuiReSizer)
MainGui.OnEvent("Size", MainGuiSize)
MainGui.OnEvent("Close", MainGuiClose)
MainGui.OnEvent("ContextMenu", MainContextMenu)
MainGui.MenuBar := MainMenuBar
MainGui.MarginX := MarginX
MainGui.MarginY := MarginY
; ---------------------------------------------------------------------------
; @Section ...: Style Buttons
; ---------------------------------------------------------------------------
; @Step ......: Bold
; ---------------------------------------------------------------------------
defaultFont()
MainGui.SetFont("Bold", FontName)
MainBNSB := MainGui.AddButton("xm y3 w20 h20", "&B")
MainBNSB.OnEvent("Click", SetFontStyleFN.Bind("B"))
GuiCtrlSetTip(MainBNSB, "Bold (Ctl+B)")
; ---------------------------------------------------------------------------
; @Step ......: Italic
; ---------------------------------------------------------------------------
MainGui.SetFont("Norm Italic")
MainBNSI := MainGui.AddButton("x+0 yp wp hp", "&I")
MainBNSI.OnEvent("Click", SetFontStyleFN.Bind("I"))
GuiCtrlSetTip(MainBNSI, "Italic (Ctl+I)")
; ---------------------------------------------------------------------------
; @Step ......: Underline
; ---------------------------------------------------------------------------
MainGui.SetFont("Norm Underline")
MainBNSU := MainGui.AddButton("x+0 yp wp hp", "&U")
MainBNSU.OnEvent("Click", SetFontStyleFN.Bind("U"))
GuiCtrlSetTip(MainBNSU, "Underline (Ctl+U)")
; ---------------------------------------------------------------------------
; @Step ......: Strikethrough/Strikeout
; ---------------------------------------------------------------------------
MainGui.SetFont("Norm Strike")
MainBNSS := MainGui.AddButton("x+0 yp wp hp", "&S")
MainBNSS.OnEvent("Click", SetFontStyleFN.Bind("S"))
GuiCtrlSetTip(MainBNSS, "Strikeout (Alt+S)")
; ---------------------------------------------------------------------------
; @Step ......: Superscript
; ---------------------------------------------------------------------------
MainGui.SetFont("Norm", FontName)
MainBNSH := MainGui.AddButton("x+0 yp wp hp", "¯")
MainBNSH.OnEvent("Click", SetFontStyleFN.Bind("H"))
GuiCtrlSetTip(MainBNSH, "Superscript (Ctrl=)")
; ---------------------------------------------------------------------------
; @Step ......: Subscript
; ---------------------------------------------------------------------------
MainBNSL := MainGui.AddButton("x+0 yp wp hp", "_")
MainBNSL.OnEvent("Click", SetFontStyleFN.Bind("L"))
GuiCtrlSetTip(MainBNSL, "Subscript (Ctrl Shift =)")
; ---------------------------------------------------------------------------
; @Step ......: Normal
; ---------------------------------------------------------------------------
MainBNSN := MainGui.AddButton("x+0 yp wp hp", "&N")
MainBNSN.OnEvent("Click", SetFontStyleFN.Bind("N"))
GuiCtrlSetTip(MainBNSN, "Normal (Alt+N)")
; ---------------------------------------------------------------------------
; @Step ......: Choose Text Color
; ---------------------------------------------------------------------------
bTextColor()
bTextColor(){
	global MainBNTC, MainGui
	MainBNTC := MainGui.SetFont('s10')
	MainBNTC := MainGui.AddButton("x+10 yp wp+70 hp", "&Text Color")
	MainBNTC.OnEvent("Click", TextColorFN.Bind("Choose"))
	GuiCtrlSetTip(MainBNTC, "Text color (Alt+T)")
	; MainBNTC := MainGui.SetFont('s' FontSize, FontName)
	defaultFont()
	; return MainBNTC
}
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
; @Step ......: Choose Text BackColor
; ---------------------------------------------------------------------------
bTextBkColor()
bTextBkColor(){
	global MainBNBC, MainColors, MainGui
	MainColors := MainGui.AddProgress("x+0 yp wp hp BackgroundYellow cNavy Border", 50)
	MainBNBC := MainGui.SetFont('s10')
	MainBNBC := MainGui.AddButton("x+0 yp wp hp", "Txt Bkg Color")
	; 
	if (WinActive() = 'ahk_exe hznHorizon.exe'){
		MainBNBC.OnEvent("Click", MainGuiSize)
	} else {
		MainBNBC.OnEvent("Click", TextBkColorFN.Bind("Choose"))
	}
	GuiCtrlSetTip(MainBNBC, "Text backcolor")
	defaultFont()
}
; ---------------------------------------------------------------------------
; @Step ......: Choose Font Name
; ---------------------------------------------------------------------------
Global DPI_Conversion := (DPI.WinGetDpi(MainGui.Hwnd)/A_ScreenDPI)
bChooseFont()
bChooseFont(){
	Global MainFNAME, MainBNCF, MainGui
	; MainFNAME := MainGui.AddEdit("x+10 yp w150 hp ", FontName)
	MainFNAME := MainGui.AddEdit("x+10 yp w150 hp +ReadOnly", FontName)
	; MainFNAME := MainGui.AddText("x+10 yp w150 hp Center", FontName)
	MainBNCF := MainGui.AddButton("x+0 yp w20 hp", "...")
	MainBNCF.OnEvent("Click", ChooseFontFN)
	GuiCtrlSetTip(MainBNCF, "Choose Font")
	defaultFont()
}
; ---------------------------------------------------------------------------
bFontSize_Increase()
bFontSize_Increase(){
	global MainBNFP, MainGui
	MainBNFP := MainGui.AddButton("x+5 yp wp hp", "&+")
	MainBNFP.OnEvent("Click", ChangeSize.Bind(1))
	GuiCtrlSetTip(MainBNFP, "Increase size (Alt+'+')")
	defaultFont()
	return MainBNFP
}
; ---------------------------------------------------------------------------
bFontSize_Decrease()
bFontSize_Decrease(){
	Global MainFSIZE, MainBNFM, MainGui
	; MainFSIZE := MainGui.AddEdit("x+0 yp w30 hp", FontSize)
	MainFSIZE := MainGui.AddEdit("x+0 yp w30 hp +ReadOnly", FontSize)
	; MainFSIZE := MainGui.AddText("x+0 yp w30 hp Center", FontSize)
	MainFSIZE.SetFont('s' FontSize, FontName)
	MainBNFM := MainGui.AddButton("x+5 yp wp hp", "&-")
	MainBNFM.OnEvent("Click", ChangeSize.Bind(-1))
	GuiCtrlSetTip(MainBNFM, "Decrease size (Alt+'-')")
	; return MainBNFM
}
;! ---------------------------------------------------------------------------
; @example RichEdit #1 (RE1)
; @function: RE1_Gui_ToolBar()
; @param RE1
;! ---------------------------------------------------------------------------
RE1_Gui_ToolBar()
RE1_Gui_ToolBar(){	; RE_1(){
	global RE1
	defaultFont()
	MainT1 := MainGui.AddText("x+10 yp hp", "WWWWWWWW")
	MainT1.GetPos(&TX := 0, &TY := 0, &TW := 0, &TH := 0)
	TX := (EditW - TW) - (MarginX * 5.75)
	MainT1.Move(TX)
	; ---------------------------------------------------------------------------
	Options := (
				' x' TX ' y' TY ' w' TW ' h' TH
				' Redraw'
			)
	global RE1 := RichEdit(MainGui, Options, False)
	defaultFont()
	; ---------------------------------------------------------------------------
	If !IsObject(RE1) {
		Throw("Could not create the RE1 RichEdit control!", -1)
	}
	RE1.ReplaceSel("AaBbYyZz")
	RE1.AlignText("CENTER")
	RE1.SetOptions(["READONLY"], "SET")
	RE1.SetParaSpacing({Before: 2})
	; ---------------------------------------------------------------------------
	;? Set buttons
	; ---------------------------------------------------------------------------
	defaultFont()
	; bAlign_Left()
	; bAlign_Center()
	; bAlign_Right()
	; bAlign_Justified()
	; bLineSpacing_Single()
	; bLineSpacing_OnePtFive()
	; bLineSpacing_Double()
	; bSave()
	; return RE1
}

; ---------------------------------------------------------------------------
; @Section ...: Alignment & Line Spacing
; ---------------------------------------------------------------------------
; @Subsection : Alignment
; ---------------------------------------------------------------------------
; @Step ......: Align Left
; ---------------------------------------------------------------------------
defaultFont()
MainGui.AddText("0x1000 xm y+2 h2 w" . EditW)
MainBNAL := MainGui.AddButton("x10 y+1 w30 h20",  "|<")
MainBNAL.OnEvent("Click", AlignFN.Bind("Left"))
GuiCtrlSetTip(MainBNAL, "Align left (Ctrl+L)")
defaultFont()
; ---------------------------------------------------------------------------
; @Step ......: Align Center
; ---------------------------------------------------------------------------
defaultFont()
MainBNAC := MainGui.AddButton("x+0 yp wp hp", "><")
MainBNAC.OnEvent("Click", AlignFN.Bind("Center"))
GuiCtrlSetTip(MainBNAC, "Align center (Ctrl+E)")
defaultFont()
; ---------------------------------------------------------------------------
; @Step ......: Align Right
; ---------------------------------------------------------------------------
MainBNAR := MainGui.AddButton("x+0 yp wp hp", ">|")
MainBNAR.OnEvent("Click", AlignFN.Bind("Right"))
GuiCtrlSetTip(MainBNAR, "Align right (Ctrl+R)")
defaultFont()
; ---------------------------------------------------------------------------
; @Step ......: Align Justified
; ---------------------------------------------------------------------------
defaultFont()
MainBNAJ := MainGui.AddButton("x+0 yp wp hp", "|<>|")
MainBNAJ.OnEvent("Click", AlignFN.Bind("Justify"))
GuiCtrlSetTip(MainBNAJ, "Align justified")
defaultFont()
; ---------------------------------------------------------------------------
; @Subsection : Line Spacing
; ---------------------------------------------------------------------------
; @Step ......: Single Spaced
; ---------------------------------------------------------------------------
defaultFont()
MainBN10 := MainGui.AddButton("x+10 yp wp hp", "1")
MainBN10.OnEvent("Click", SpacingFN.Bind(1.0))
GuiCtrlSetTip(MainBN10, "Linespacing 1 line (Ctrl+1)")
defaultFont()
; ---------------------------------------------------------------------------
; @Step ......: 1.5 Spaced
; ---------------------------------------------------------------------------
defaultFont()
MainBN15 := MainGui.AddButton("x+0 yp wp hp", "1½")
MainBN15.OnEvent("Click", SpacingFN.Bind(1.5))
GuiCtrlSetTip(MainBN15, "Linespacing 1,5 lines (Ctrl+5)")
defaultFont()
; ---------------------------------------------------------------------------
; @Step ......: Double Spaced
; ---------------------------------------------------------------------------
defaultFont()
MainBN20 := MainGui.AddButton("x+0 yp wp hp", "2")
MainBN20.OnEvent("Click", SpacingFN.Bind(2.0))
GuiCtrlSetTip(MainBN20, "Linespacing 2 lines (Ctrl+2)")
defaultFont()
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
; @Step ......: Save Button
; ---------------------------------------------------------------------------
bSave()
bSave(){
	global MainBNSV, MainGui
	local x := (editw / 2) - (MarginX * 5)
	defaultFont()
	; MainBNSV := MainGui.AddButton('x' x ' yp wp+30 hp Center +Disabled', '&Save')
	MainBNSV := MainGui.AddButton('x' x ' yp wp+30 hp Center ', '&Save')
	MainBNSV.OnEvent('Click', FileSaveAsFN)
	defaultFont()
	return MainBNSV
}
;! ---------------------------------------------------------------------------
; @Section ...: Rich Edit #2
; @function ..: The Rich Edit Editor Section
;! ---------------------------------------------------------------------------
RE2_RichEditor()
RE2_RichEditor(){
	Global RE2, MainSB, FontName, FontSize
	Options := ''
	MainFNAME.Text := FontName
	MainFSIZE.Text := FontSize
	static EN_SELCHANGE := 1794 ; 0x0702
	static EN_LINK := 1803 ; 0x070B
	; MainGui.SetFont('s11 Q5', FontName)
	MainGui.SetFont('Q5', FontName)
	; Options := "xm y+5 w" . EditW . " r20"
	; Options := "xm y+5 w" (EditW-MarginX) ' h' (EditH-MarginY)
	Options := (
			" xm"
			" y+5"
			" w" EditW
			' h' EditH
			' Redraw'
			)
	If !IsObject(RE2 := RichEdit(MainGui, Options)){
		Throw("Could not create the RE2 RichEdit control!", -1)
	}
	; RE2.SetBkgndColor(0xFFFF00) ;? yup, that's yellow
	RE2.SetFont(FontSize ' ' FontName)
	RE2.SetOptions(["SELECTIONBAR"])
	RE2.AutoURL(True)
	RE2.SetEventMask(["SELCHANGE", "LINK"])
	RE2.OnNotify(EN_SELCHANGE, RE2_SelChange)
	RE2.OnNotify(EN_LINK, RE2_Link)
	DPI.ControlGetPos(,,&REW, &REH, RE2)
	; RE2.GetPos( , , &REW, &REH)
	defaultFont()
	; ---------------------------------------------------------------------------
	;? The rest
	; ---------------------------------------------------------------------------
	MainSB := MainGui.AddStatusbar()
	MainSB.SetParts(10, 200)
	MainGui.Show()
	RE2.Focus()
	RE_SetHotkeys()
	RE2.WordWrap(True)
	UpdateGui()
	MainGui.Show()
	MainGui.Show()
	; Return RE2.Hwnd
}
; EN_SELCHANGE := 1794 ; 0x0702
; EN_LINK := 1803 ; 0x070B
; EVENT_OBJECT_VALUECHANGE := 32782 ; 0x800E
; MainFNAME.Text := FontName
; MainFSIZE.Text := FontSize
; ; MainGui.SetFont('Q5', FontName)
; defaultFont()
; ; Options := "xm y+5 w" . EditW . " r20"
; Options := (" xm" " y+5" " w" EditW ' h' EditH ' +Redraw')
; If !IsObject(RE2 := RichEdit(MainGui, Options)){
; 	Throw("Could not create the RE2 RichEdit control!", -1)
; }
; defaultFont()
; RE2.SetOptions(["SELECTIONBAR"])
; RE2.AutoURL(True)
; RE2.SetEventMask(["SELCHANGE", "LINK"])
; RE2.OnNotify(EN_SELCHANGE, RE2_SelChange)
; RE2.OnNotify(EN_LINK, RE2_Link)
; DPI.ControlGetPos(&REX,&REY,&REW, &REH, RE2)
; ; RE2.GetPos( , , &REW, &REH)
; defaultFont()
; ; ---------------------------------------------------------------------------
; ;? The rest
; ; ---------------------------------------------------------------------------
; MainSB := MainGui.AddStatusbar()
; MainSB.SetParts(10, 200)
; MainGui.Show()
; RE2.Focus()
; RE_SetHotkeys()
; RE2.WordWrap(True)
; UpdateGui()
; RE2.WordWrap(True)
; MainGui.Show()
; MainGui.Show('AutoSize NA')
; RE2.SaveFile(rtfPath)
; RE2.LoadFile(rtfPath)
; Return RE2.Hwnd
; ---------------------------------------------------------------------------
; End of auto-execute section
; ---------------------------------------------------------------------------
; defaultFont(GuiObj := '', FontName := '', FontSize := 0){
defaultFont(&GuiObj := ''){
	Global MainGui, FontName, FontSize
	GuiObj := MainGui
	GuiObj.SetFont("Norm")
	GuiObj.SetFont('s' FontSize ' Q5', FontName)
	return GuiObj
}
; ---------------------------------------------------------------------------
#HotIf RE2
RE_SetHotkeys(){
	HotKey('^b', ModifierToggle, 'On') ;? bold
	HotKey('^i', ModifierToggle, 'On') ;? italic
	HotKey('^u', ModifierToggle, 'On') ;? underline
	HotKey('^=', ModifierToggle, 'On') ;? superscript
	HotKey('^+=', ModifierToggle, 'On') ;? subscript
	HotKey('^n', ModifierToggle, 'On') ;? normal
	HotKey('^p', ModifierToggle, 'On') ;? protected
	HotKey('!s', ModifierToggle, 'On') ;? strikeout
	HotKey('Delete', (*) => (Send('+{Right}'), Send('{vk2Esc153}')), 'On') ;? delete
}

; HotIf()
; #HotIf RE2.Focused
; FontStyles
; ^!b::  ; bold
; ^!h::  ; superscript
; ^!i::  ; italic
; ^!l::  ; subscript
; ^!n::  ; normal
; ^!p::  ; protected
; ^!s::  ; strikeout
; ^!u::  ; underline
; ^b::  ; bold
; ^h::  ; superscript
; ^i::  ; italic
; ^l::  ; subscript
; ^n::  ; normal
; ^p::  ; protected
; ^s::  ; strikeout
; ^u::  ; underline
ModifierToggle(*){
	; global RE2
	; RE2.ToggleFontStyle(SubStr(A_ThisHotkey, 3))
	RE2.ToggleFontStyle(SubStr(A_ThisHotkey, -1, 1))
	UpdateGui()
	return RE2
}
#HotIf

; #HotIf RE2.Focused
; ; FontStyles
; ; ^!b::  ; bold
; ; ^!h::  ; superscript
; ; ^!i::  ; italic
; ; ^!l::  ; subscript
; ; ^!n::  ; normal
; ; ^!p::  ; protected
; ; ^!s::  ; strikeout
; ; ^!u::  ; underline
; ^b::  ; bold
; ; ^h::  ; superscript
; ^=::  ; superscript
; ^i::  ; italic
; ^+=::  ; subscript
; ^n::  ; normal
; ^p::  ; protected
; !s::  ; strikeout
; ^u::  ; underline
; {
; 	; RE2.ToggleFontStyle(SubStr(A_ThisHotkey, 3))
; 	RE2.ToggleFontStyle(SubStr(A_ThisHotkey, -1, 1))
; 	UpdateGui()
; }
; #HotIf
; ---------------------------------------------------------------------------
; Testing <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; ---------------------------------------------------------------------------
RE2_SelChange(RE, L) {
	SetTimer(UpdateGui, -10)
}
RE2_Link(RE, L) {
	If (NumGet(L, A_PtrSize * 3, "Int") = 0x0202) { ; WM_LBUTTONUP
		wParam  := NumGet(L, (A_PtrSize * 3) + 4, "UPtr")
		lParam  := NumGet(L, (A_PtrSize * 4) + 4, "UPtr")
		cpMin   := NumGet(L, (A_PtrSize * 5) + 4, "Int")
		cpMax   := NumGet(L, (A_PtrSize * 5) + 8, "Int")
		URLtoOpen := RE2.GetTextRange(cpMin, cpMax)
		ToolTip( "0x0202 - " wParam " - " lParam " - " cpMin " - " cpMax " - " URLtoOpen)
		; Info( "0x0202 - " wParam " - " lParam " - " cpMin " - " cpMax " - " URLtoOpen)
		Run( '"' URLtoOpen '"')
	}
}
;! --------------------------------------------------------------------------------
;!					UpdateGui
;! --------------------------------------------------------------------------------
UpdateGui(*) {
	AE._DPIAwareness()
	Global MainSB, RE1, RE2, FontSize, FontName, FontStyle, FontCharSet, TextColor, TextBkColor
	; Static FontName := "", FontCharset := 0, FontStyle := 0, FontSize := 0, TextColor := 0, TxBkColor := 0
	Static TxBkColor := 0
	Global DPI_Conversion
	Local Font := RE2.GetFont()
	text := RE2.GetText()
	WriteFile(rtfPath, text)
	If (FontName != Font.Name || FontCharset != Font.CharSet 
		|| FontStyle != Font.Style || FontSize != Font.Size 
		|| TextColor != Font.Color || TxBkColor != Font.BkColor) {
		; FontStyle := Font.Style
		FontStyle := FontStyle
		; TextColor := Font.Color
		TextColor := TextColor
		TxBkColor := TxBkColor
		FontCharSet := FontCharSet
		; -------------------------------------------------------------------------
		MainFNAME.Text := FontName
		; -------------------------------------------------------------------------
		MainFSIZE.Text := FontSize
		Font.Size := FontSize
		RE1.SetSel(0, -1) ; select all
		RE1.SetFont(Font)
		RE1.SetSel(0, 0)  ; deselect all
	}
	RE_MainSB()
	RE_MainSB(){
		Local Stats := RE2.GetStatistics()
		MainSB.SetText('')
		MainSB.SetText('Ln (' Stats.Line ':' Stats.LinePos ')' " #Lns (" Stats.LineCount ")" ' Chs[' Stats.CharCount ']', 2)

	}
	MainGui.Show()
	MainGuiSize(MainGui,,EditW * DPI_Conversion, EditH * DPI_Conversion)
	MainGui.Show()
}
; ---------------------------------------------------------------------------
; Gui related
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
;?              GuiClose:
; ---------------------------------------------------------------------------
MainGuiClose(*) {
	
	; -------------
	Send('^{sc1E}') ; Send('^a')
	; SelAllFN()
	; -------------
	Send('^{sc2E}') ; Send('^c')
	; SndMsgCopy()
	; -------------
	Global RE1, RE2
	If IsObject(RE1){
		RE1 := ""
	}
	If IsObject(RE2){
		RE2 := ""
	}
	MainGui.Destroy()
	; ToolTip(A_Clipboard)
	ExitApp()
}
; ---------------------------------------------------------------------------
;! ---------------------------------------------------------------------------
; @Section ...: Main Gui Size
;! ---------------------------------------------------------------------------
MainGuiSize(GuiObj?, MinMax?, Width?, Height?) {
	AE._DPIAwareness()
	Global GuiW, GuiH, REW, REH, MarginX, MarginY, EditH, EditW
	Width := 0, Height := 0
	Critical()
	; If (MinMax = 1){
	; 	Return
	; }
	If (GuiW = 0) {
		GuiW := (Width + MarginX)
		GuiH := (Height + MarginY)
	}
	If (Width != GuiW || Height != GuiH) {
		WinA := WinActive('A')
		MainGui.GetPos(&REX, &REY, &REW, &REH)
		; DPI.WinGetPos(&REX, &REY, &REW, &REH)
		; (Infos(DPI.WinGetDpi(MainGui.Hwnd)))
		REW += (EditW - GuiW)-(46)
		REH += (EditH - GuiH)
		RE2.Move( , , REW, REH)
		GuiW := (EditW + MarginX)
		GuiH := (EditH + MarginY)
	}
	MainGui.Show()
}
; ---------------------------------------------------------------------------
; @function ...: GuiContextMenu
; ---------------------------------------------------------------------------
MainContextMenu(GuiObj, GuiCtrlObj, *) {
	If (GuiCtrlObj = RE2){
		ContextMenu.Show()
	}
}
; ---------------------------------------------------------------------------
; @section ...: Text operations
; ---------------------------------------------------------------------------
; @function ...: SetFontStyle
; ---------------------------------------------------------------------------
SetFontStyleFN(Style, GuiCtrl, *) {
	RE2.ToggleFontStyle(Style)
	UpdateGui()
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; @function ...: ChangeSize
; ---------------------------------------------------------------------------
ChangeSize(IncDec, GuiCtrl, *) {
	Global FontSize := RE2.ChangeFontSize(IncDec)
	MainFSIZE.Text := Round(FontSize)
	RE2.Focus()
	; return MainFSIZE.Text := FontSize
	return FontSize := MainFSIZE.Text
}
; ---------------------------------------------------------------------------
; @section ...: Menu File
; ---------------------------------------------------------------------------
; @function ...: FileAppend
; @function ...: FileOpen
; @function ...: FileInsert
; ---------------------------------------------------------------------------
FileLoadFN(Mode, *) {
	Global Open_File
	If (File := RichEditDlgs.FileDlg(RE2, "O")) {
		RE2.LoadFile(File, Mode)
		If (Mode = "O") {
			MainGui.Opt("+LastFound")
			Title := WinGetTitle()
			Title := StrSplit(Title, "-", " ")
			WinSetTitle(Title[1] . " - " . File)
			Open_File := File
		}
		UpdateGui()
	}
	RE2.SetModified()
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; FileClose
FileCloseFN(*) {
	Global Open_File
	If (Open_File) {
		If RE2.IsModified() {
			MainGui.Opt("+OwnDialogs")
			Switch MsgBox(35, "Close File", "Content has been modified!`nDo you want to save changes?") {
				Case "Cancel":
					RE2.Focus()
					Return
				Case "Yes":
					FileSaveFN()
			}
		}
		If RE2.SetText() {
			MainGui.Opt("+LastFound")
			Title := WinGetTitle()
			Title := StrSplit(Title, "-", " ")
			WinSetTitle(Title[1])
			Open_File := ""
		}
		UpdateGui()
	}
	RE2.SetModified()
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; @function ...: FileSave
; ---------------------------------------------------------------------------
FileSaveFN(*) {
	If !(Open_File){
		Return FileSaveAsFN()
	}
	RE2.SaveFile(Open_File)
	RE2.SetModified()
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; @function ...: FileSaveAs
; ---------------------------------------------------------------------------
FileSaveAsFN(*) {
	If (File := RichEditDlgs.FileDlg(RE2, "S")) {
		RE2.SaveFile(File)
		MainGui.Opt("+LastFound")
		Title := WinGetTitle()
		Title := StrSplit(Title, "-", " ")
		WinSetTitle(Title[1] . " - " . File)
		Global Open_File := File
	}
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; @function ...: PageSetup
; ---------------------------------------------------------------------------
PageSetupFN(*) {
	RichEditDlgs.PageSetup(RE2)
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; @function ...: Print
; ---------------------------------------------------------------------------
PrintFN(*) {
	RE2.Print()
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; @section ...: Menu Edit
; ---------------------------------------------------------------------------
; @function ...: Undo
; ---------------------------------------------------------------------------
UndoFN(*) {
	RE2.Undo()
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; @function ...: Redo
; ---------------------------------------------------------------------------
RedoFN(*) {
	RE2.Redo()
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; @function ...: Cut
; ---------------------------------------------------------------------------
CutFN(*) {
	RE2.Cut()
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; @function ...: Copy
; ---------------------------------------------------------------------------
CopyFN(*) {
	RE2.Copy()
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; @function ...: Paste
; ---------------------------------------------------------------------------
PasteFN(*) {
	RE2.Paste()
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; @function ...: Clear
; ---------------------------------------------------------------------------
ClearFN(*) {
	RE2.Clear()
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; @function ...: SelAll
; ---------------------------------------------------------------------------
SelAllFN(*) {
	RE2.SelAll()
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; @function ...: Deselect
; ---------------------------------------------------------------------------
DeselectFN(*) {
	RE2.Deselect()
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; Menu View
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
; @function ...: WordWrap
; ---------------------------------------------------------------------------
WordWrapFN(Item, *) {
	Global WordWrap ^= True
	RE2.WordWrap(WordWrap)
	ViewMenu.ToggleCheck(Item)
	If (WordWrap){
		ViewMenu.Disable(MenuWysiwyg)
	}
	Else {
		ViewMenu.Enable(MenuWysiwyg)
	}
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; @function ...: Zoom
; ---------------------------------------------------------------------------
Zoom100FN(*) => ZoomFN(100, "100 %")
; ---------------------------------------------------------------------------
ZoomFN(Ratio, Item, *) {
	Global Zoom
	ZoomMenu.UnCheck(Zoom)
	Zoom := Item
	ZoomMenu.Check(Zoom)
	RE2.SetZoom(Ratio)
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; @function ...: WYSIWYG
; ---------------------------------------------------------------------------
WYSIWYGFN(Item, *) {
	Global ShowWysiwyg ^= True
	If (ShowWysiwyg){
		Zoom100FN()
	}
	RE2.WYSIWYG(ShowWysiwyg)
	ViewMenu.ToggleCheck(Item)
	If (ShowWysiwyg){
		ViewMenu.Disable(MenuWordWrap)
	}
	Else {
		ViewMenu.Enable(MenuWordWrap)
	}
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; @function ...: BackgroundColor
; ---------------------------------------------------------------------------
BackgroundColorFN(Mode, *) {
	Global BackColor
	Switch Mode {
		Case "Auto": 	RE2.BackColor := "Auto"
		Case "Choose":	RE2.SetBkgndColor("cYellow")
			; If RE2.BackColor != "Auto"
			; 	Color := RE2.BackColor
			; Else
			; 	Color := RE2.GetRGB(DllCall("GetSysColor", "Int", 5, "UInt")) ; COLOR_WINDOW
			; NC := RichEditDlgs.ChooseColor(RE2, Color)
			; If (NC != "") {
			; 	RE2.SetBkgndColor(NC)
			; 	RE2.BackColor := NC
			; }
	}
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; @function ...: AutoURLDetection
; ---------------------------------------------------------------------------
AutoURLDetectionFN(ItemName, ItemPos, MenuObj) {
	RE2.AutoURL(AutoURL ^= True)
	MenuObj.ToggleCheck(ItemName)
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; @section ...: Menu Character
; ---------------------------------------------------------------------------
; @function ...: ChooseFont
; ---------------------------------------------------------------------------
ChooseFontFN(*) {
	Global FontName, FontSize
	RichEditDlgs.ChooseFont(RE2)
	Font := RE2.GetFont()
	FontName := Font.Name
	FontSize := Font.Size
	MainFNAME.Text := FontName
	MainFSIZE.Text := Round(FontSize)
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; @function ...: MTextColor - menu label
; ---------------------------------------------------------------------------
TextColorFN(Mode, *) {
	Global TextColor
	Switch Mode {
		Case "Auto":	RE2.SetFont({Color: "cBlack"})
		Case "Choose":	RE2.SetFont({Color: "cBlack"})
		; Case "Auto":
		; 	RE2.SetFont({Color: "Auto"})
		; 	RE2.TextColor := "Auto"
		; Case "Choose":
		; 	If (RE2.TextColor != "Auto"){
		; 		Color := RE2.TextColor
		; 	}
		; 	Else{
		; 		Color := RE2.GetRGB(DllCall("GetSysColor", "Int", 8, "UInt")) ; COLOR_WINDOWTEXT
		; 	}
		; 	NC := RichEditDlgs.ChooseColor(RE2, Color)
		; 	If (NC != "") {
		; 		RE2.SetFont({Color: NC})
		; 		RE2.TextColor := NC
		; 	}
	}
	UpdateGui()
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; @function ...: BTextColor - button label
; ---------------------------------------------------------------------------
TextBkColorFN(Mode, *) {
	Global TextBkColor
	Switch Mode {
		Case "Auto":
			RE2.SetFont({BkColor: "Auto"})
			Color := RE2.GetRGB(DllCall("GetSysColor", "Int", 5, "UInt")) ; COLOR_WINDOW
		Case "Choose":
			RE2.SetFont({BkColor: "Auto"})
			; If RE2.TxBkColor != "Auto"
			; 	Color := RE2.TxBkColor
			; Else
			; 	Color := RE2.GetRGB(DllCall("GetSysColor", "Int", 5, "UInt")) ; COLOR_WINDOW
			; NC := RichEditDlgs.ChooseColor(RE2, Color)
			; If (NC != "") {
			; 	RE2.SetFont({BkColor: NC})
			; 	RE2.TxBkColor := NC
			; }
	}
	UpdateGui()
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; @section ...: Menu Paragraph
; ---------------------------------------------------------------------------
; @function ...: AlignLeft
; @function ...: AlignCenter
; @function ...: AlignRight
; @function ...: AlignJustify
; ---------------------------------------------------------------------------
AlignFN(Alignment, *) {
Static Align := {Left: 1, Right: 2, Center: 3, Justify: 4}
	If Align.HasProp(Alignment){
		RE2.AlignText(Align.%Alignment%)
	}
	RE2.Focus()
}
; ---------------------------------------------------------------------------
IndentationFN(Mode, *) {
	Switch Mode {
		Case "Set": ParaIndentGui(RE2)
		Case "Reset": RE2.SetParaIndent()
	}
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; @function ...: Numbering
NumberingFN(Mode, *) {
	Switch Mode {
		Case "Set": ParaNumberingGui(RE2)
		Case "Reset": RE2.SetParaNumbering()
	}
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; @function ...: ParaSpacing
; @function ...: ResetParaSpacing
ParaSpacingFN(Mode, *) {
	Switch Mode {
		Case "Set": ParaSpacingGui(RE2)
		Case "Reset": RE2.SetParaSpacing()
	}
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; @function ...: Spacing10
; @function ...: Spacing15
; @function ...: Spacing20
SpacingFN(Val, *) {
	RE2.SetLineSpacing(Val)
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; @function ...: SetTabStops
; @function ...: ResetTabStops
; @function ...: SetDefTabs
SetTabStopsFN(Mode, *) {
	Switch Mode {
		Case "Set": SetTabStopsGui(RE2)
		Case "Reset": RE2.SetTabStops()
		Case "Default": RE2.SetDefaultTabs(1)
	}
	RE2.Focus()
}
; ---------------------------------------------------------------------------
; @function ...: Menu Search
; ---------------------------------------------------------------------------
FindFN(*) {
	RichEditDlgs.FindText(RE2)
}
; ---------------------------------------------------------------------------
ReplaceFN(*) {
	RichEditDlgs.ReplaceText(RE2)
}
; ---------------------------------------------------------------------------
; @section ...: ParaIndentation GUI
; ---------------------------------------------------------------------------
ParaIndentGui(RE) {
	Static Owner := "", Success := False

	Metrics := RE.GetMeasurement()
	PF2 := RE.GetParaFormat()
	Owner := RE.Gui.Hwnd
	ParaIndentGui := Gui("+Owner" . Owner . " +ToolWindow +LastFound", "Paragraph Indentation")
	ParaIndentGui.OnEvent("Close", ParaIndentGuiClose)
	ParaIndentGui.MarginX := 20
	ParaIndentGui.MarginY := 10
	ParaIndentGui.AddText("Section h20 0x200", "First line left indent (absolute):")
	ParaIndentGui.AddText("xs hp 0x200", "Other lines left indent (relative):")
	ParaIndentGui.AddText("xs hp 0x200", "All lines right indent (absolute):")
	EDLeft1 := ParaIndentGui.AddEdit("ys hp Limit5")
	EDLeft2 := ParaIndentGui.AddEdit("hp Limit6")
	EDRight := ParaIndentGui.AddEdit("hp Limit5")
	CBStart := ParaIndentGui.AddCheckBox("ys x+5 hp", "Apply")
	CBOffset := ParaIndentGui.AddCheckBox("hp", "Apply")
	CBRight := ParaIndentGui.AddCheckBox("hp", "Apply")
	Left1 := Round((PF2.StartIndent / 1440) * Metrics, 2)
	If (Metrics = 2.54)
		Left1 := RegExReplace(Left1, "\.", ",")
	EDLeft1.Text := Left1
	Left2 := Round((PF2.Offset / 1440) * Metrics, 2)
	If (Metrics = 2.54)
		Left2 := RegExReplace(Left2, "\.", ",")
	EDLeft2.Text := Left2
	Right := Round((PF2.RightIndent / 1440) * Metrics, 2)
	If (Metrics = 2.54)
		Right := RegExReplace(Right, "\.", ",")
	EDRight.Text := Right
	BN1 := ParaIndentGui.AddButton("xs", "Apply")
	BN1.OnEvent("Click", ParaIndentGuiApply)
	BN2 := ParaIndentGui.AddButton("x+10 yp", "Cancel")
	BN2.OnEvent("Click", ParaIndentGuiClose)
	BN2.GetPos( , , &BW := 0)
	BN1.Move( , , BW)
	CBRight.GetPos(&CX := 0, , &CW := 0)
	BN2.Move(CX + CW - BW)
	RE.Gui.Opt("+Disabled")
	ParaIndentGui.Show()
	WinWaitActive()
	WinWaitClose()
	Return Success
	; -------------------------------------------------------------------------------------------------------------------
	ParaIndentGuiClose(*) {
		Success := False
		RE.Gui.Opt("-Disabled")
		ParaIndentGui.Destroy()
	}
	; -------------------------------------------------------------------------------------------------------------------
	ParaIndentGuiApply(*) {
		ApplyStart := CBStart.Value
		ApplyOffset := CBOffset.Value
		ApplyRight := CBRight.Value
		Indent := {}
		If ApplyStart {
			Start := EDLeft1.Text
			If (Start = "")
				Start := 0
			If !RegExMatch(Start, "^\d{1,2}((\.|,)\d{1,2})?$") {
				EDLeft1.Text := ""
				EDLeft1.Focus()
				Return
			}
			Indent.Start := StrReplace(Start, ",", ".")
		}
		If (ApplyOffset) {
			Offset := EDLeft2.Text
			If (Offset = "")
				Offset := 0
			If !RegExMatch(Offset, "^(-)?\d{1,2}((\.|,)\d{1,2})?$") {
				EDLeft2.Text := ""
				EDLeft2.Focus()
				Return
			}
			Indent.Offset := StrReplace(Offset, ",", ".")
		}
		If (ApplyRight) {
			Right := EDRight.Text
			If (Right = "")
				Right := 0
			If !RegExMatch(Right, "^\d{1,2}((\.|,)\d{1,2})?$") {
				EDRight.Text := ""
				EDRight.Focus()
				Return
			}
			Indent.Right := StrReplace(Right, ",", ".")
		}
		Success := RE.SetParaIndent(Indent)
		RE.Gui.Opt("-Disabled")
		ParaIndentGui.Destroy()
	}
}
; ---------------------------------------------------------------------------
; @function ...: ParaNumbering GUI
; ---------------------------------------------------------------------------
ParaNumberingGui(RE) {
Static Owner := "",
		Bullet := "•",
		StyleArr := ["1)", "(1)", "1.", "1", "w/o"],
		TypeArr := [Bullet, "0, 1, 2", "a, b, c", "A, B, C", "i, ii, iii", "I, I, III"],
		PFN := ["Bullet", "Arabic", "LCLetter", "UCLetter", "LCRoman", "UCRoman"],
		PFNS := ["Paren", "Parens", "Period", "Plain", "None"],
		Success := False
	Metrics := RE.GetMeasurement()
	PF2 := RE.GetParaFormat()
	Owner := RE.Gui.Hwnd
	ParaNumberingGui := Gui("+Owner" . Owner . " +ToolWindow +LastFound", "Paragraph Numbering")
	ParaNumberingGui.OnEvent("Close", ParaNumberingGuiClose)
	ParaNumberingGui.MarginX := 20
	ParaNumberingGui.MarginY := 10
	ParaNumberingGui.AddText("Section h20 w100 0x200", "Type:")
	DDLType := ParaNumberingGui.AddDDL("xp y+0 wp AltSubmit", TypeArr)
	If (PF2.Numbering)
		DDLType.Choose(PF2.Numbering)
	ParaNumberingGui.AddText("xs h20 w100 0x200", "Start with:")
	EDStart := ParaNumberingGui.AddEdit("y+0 wp hp Limit5", PF2.NumberingStart)
	ParaNumberingGui.AddText("ys h20 w100 0x200", "Style:")
	DDLStyle := ParaNumberingGui.AddDDL("y+0 wp AltSubmit Choose1", StyleArr)
	If (PF2.NumberingStyle)
		DDLStyle.Choose((PF2.NumberingStyle // 0x0100) + 1)
	ParaNumberingGui.AddText("h20 w100 0x200", "Distance:  (" . (Metrics = 1.00 ? "in." : "cm") . ")")
	EDDist := ParaNumberingGui.AddEdit("y+0 wp hp Limit5")
	Tab := Round((PF2.NumberingTab / 1440) * Metrics, 2)
	If (Metrics = 2.54)
		Tab := RegExReplace(Tab, "\.", ",")
	EDDist.Text := Tab
	BN1 := ParaNumberingGui.AddButton("xs", "Apply") ; gParaNumberingGuiApply hwndhBtn1, Apply
	BN1.OnEvent("Click", ParaNumberingGuiApply)
	BN2 := ParaNumberingGui.AddButton("x+10 yp", "Cancel") ;  gParaNumberingGuiClose hwndhBtn2, Cancel
	BN2.OnEvent("Click", ParaNumberingGuiClose)
	BN2.GetPos( , , &BW := 0)
	BN1.Move( , , BW)
	DDLStyle.GetPos(&DX := 0, , &DW := 0)
	BN2.Move(DX + DW - BW)
	RE.Gui.Opt("+Disabled")
	ParaNumberingGui.Show()
	WinWaitActive()
	WinWaitClose()
	Return Success
	; -------------------------------------------------------------------------------------------------------------------
	ParaNumberingGuiClose(*) {
		Success := False
		RE.Gui.Opt("-Disabled")
		ParaNumberingGui.Destroy()
	}
	; -------------------------------------------------------------------------------------------------------------------
	ParaNumberingGuiApply(*) {
		Type := DDLType.Value
		Style := DDLStyle.Value
		Start := EDStart.Text
		Tab := EDDist.Text
		If !RegExMatch(Tab, "^\d{1,2}((\.|,)\d{1,2})?$") {
			EDDist.Text := ""
			EDDist.Focus()
			Return
		}
		Numbering := {Type: PFN[Type], Style: PFNS[Style]}
		Numbering.Tab := RegExReplace(Tab, ",", ".")
		Numbering.Start := Start
		Success := RE.SetParaNumbering(Numbering)
		RE.Gui.Opt("-Disabled")
		ParaNumberingGui.Destroy()
	}
}
; ---------------------------------------------------------------------------
; @function ...: ParaSpacing GUI
; ---------------------------------------------------------------------------
ParaSpacingGui(RE) {
Static  Owner := "",
		Success := False
	PF2 := RE.GetParaFormat()
	Owner := RE.Gui.Hwnd
	ParaSpacingGui := Gui("+Owner" . Owner . " +ToolWindow +LastFound", "Paragraph Spacing") ; +LabelParaSpacingGui
	ParaSpacingGui.OnEvent("Close", ParaSpacingGuiClose)
	ParaSpacingGui.MarginX := 20
	ParaSpacingGui.MarginY := 10
	ParaSpacingGui.AddText("Section h20 0x200", "Space before in points:")
	ParaSpacingGui.AddText("xs y+10 hp 0x200", "Space after in points:")
	EDBefore := ParaSpacingGui.AddEdit("ys hp Number Limit2 Right", "00")
	EDBefore.Text := PF2.SpaceBefore // 20
	EDAfter := ParaSpacingGui.AddEdit("xp y+10 hp Number Limit2 Right", "00")
	EDAfter.Text := PF2.SpaceAfter // 20
	BN1 := ParaSpacingGui.AddButton("xs", "Apply")
	BN1.OnEvent("Click", ParaSpacingGuiApply)
	BN2 := ParaSpacingGui.AddButton("x+10 yp", "Cancel")
	BN2.OnEvent("Click", ParaSpacingGuiClose)
	BN2.GetPos( , ,&BW := 0)
	BN1.Move( , ,BW)
	EDAfter.GetPos(&EX := 0, , &EW := 0)
	X := EX + EW - BW
	BN2.Move(X)
	RE.Gui.Opt("+Disabled")
	ParaSpacingGui.Show()
	WinWaitActive()
	WinWaitClose()
	Return Success
	; -------------------------------------------------------------------------------------------------------------------
	ParaSpacingGuiClose(*) {
		Success := False
		RE.Gui.Opt("-Disabled")
		ParaSpacingGui.Destroy()
	}
	; -------------------------------------------------------------------------------------------------------------------
	ParaSpacingGuiApply(*) {
		Before := EDBefore.Text
		After := EDAfter.Text
		Success := RE.SetParaSpacing({Before: Before, After: After})
		RE.Gui.Opt("-Disabled")
		ParaSpacingGui.Destroy()
	}
}
; ---------------------------------------------------------------------------
; @function ...: SetTabStops GUI
; ---------------------------------------------------------------------------
SetTabStopsGui(RE) {
	; Set paragraph's tabstobs
	; Call with parameter mode = "Reset" to reset to default tabs
	; EM_GETPARAFORMAT = 0x43D, EM_SETPARAFORMAT = 0x447
	; PFM_TABSTOPS = 0x10
	Static  Owner   := "",
			Metrics := 0,
			MinTab  := 0.30,     ; minimal tabstop in inches
			MaxTab  := 8.30,     ; maximal tabstop in inches
			AL := 0x00000000,    ; left aligned (default)
			AC := 0x01000000,    ; centered
			AR := 0x02000000,    ; right aligned
			AD := 0x03000000,    ; decimal tabstop
			Align := {0x00000000: "L", 0x01000000: "C", 0x02000000: "R", 0x03000000: "D"},
			TabCount := 0,       ; tab count
			MAX_TAB_STOPS := 32,
			Success := False     ; return value
	Metrics := RE.GetMeasurement()
	PF2 := RE.GetParaFormat()
	TabCount := PF2.TabCount
	Tabs := []
	Tabs.Length := PF2.Tabs.Length
	For I, V In PF2.Tabs
		Tabs[I] := [Format("{:.2f}", Round(((V & 0x00FFFFFF) * Metrics) / 1440, 2)), V & 0xFF000000]
	Owner := RE.Gui.Hwnd
	SetTabStopsGui := Gui("+Owner" . Owner . " +ToolWindow +LastFound", "Set Tabstops")
	SetTabStopsGui.OnEvent("Close", SetTabStopsGuiClose)
	SetTabStopsGui.MarginX := 10
	SetTabStopsGui.MarginY := 10
	SetTabStopsGui.AddText("Section", "Position: (" . (Metrics = 1.00 ? "in." : "cm") . ")")
	CBBTabs := SetTabStopsGui.AddComboBox("xs y+2 w120 r6 Simple +0x800 AltSubmit")
	CBBTabs.OnEvent("Change", SetTabStopsGuiSelChanged)
	If (TabCount) {
		For T In Tabs {
			I := SendMessage(0x0143, 0, StrPtr(T[1]), CBBTabs.Hwnd)  ; CB_ADDSTRING
			SendMessage(0x0151, I, T[2], CBBTabs.Hwnd)               ; CB_SETITEMDATA
		}
	}
	SetTabStopsGui.AddText("ys Section", "Alignment:")
	RBL := SetTabStopsGui.AddRadio("xs w60 Section y+2 Checked Group", "Left")
	RBC := SetTabStopsGui.AddRadio("wp", "Center")
	RBR := SetTabStopsGui.AddRadio("ys wp", "Right")
	RBD := SetTabStopsGui.AddRadio("wp", "Decimal")
	BNAdd := SetTabStopsGui.AddButton("xs Section w60 Disabled", "&Add")
	BNAdd.OnEvent("Click", SetTabStopsGuiAdd)
	BNRem := SetTabStopsGui.AddButton("ys w60 Disabled", "&Remove")
	BNRem.OnEvent("Click", SetTabStopsGuiRemove)
	BNAdd.GetPos(&X1 := 0)
	BNRem.GetPos(&X2 := 0, , &W2 := 0)
	W := X2 + W2 - X1
	BNClr := SetTabStopsGui.AddButton("xs w" . W, "&Clear all")
	BNClr.OnEvent("Click", SetTabStopsGuiRemoveAll)
	SetTabStopsGui.AddText("xm h5")
	BNApply := SetTabStopsGui.AddButton("xm y+0 w60", "&Apply")
	BNApply.OnEvent("Click", SetTabStopsGuiApply)
	X := X2 + W2 - 60
	BNCancel := SetTabStopsGui.AddButton("x" . X . " yp wp", "&Cancel")
	BNCancel.OnEvent("Click", SetTabStopsGuiClose)
	RE.Gui.Opt("+Disabled")
	SetTabStopsGui.Show()
	WinWaitActive()
	WinWaitClose()
	Return Success
	; -------------------------------------------------------------------------------------------------------------------
	SetTabStopsGuiClose(*) {
		Success := False
		RE.Gui.Opt("-Disabled")
		SetTabStopsGui.Destroy()
	}
	; -------------------------------------------------------------------------------------------------------------------
	SetTabStopsGuiSelChanged(*) {
		If (TabCount < MAX_TAB_STOPS)
			BNAdd.Enabled := !!RegExMatch(CBBTabs.Text, "^\d*[.,]?\d+$")
		If !(I := CBBTabs.Value) {
			BNRem.Enabled := False
			Return
		}
		BNRem.Enabled := True
		A := SendMessage(0x0150, I - 1, 0, CBBTabs.Hwnd) ; CB_GETITEMDATA
		C := A = AC ? RBC : A = AR ? RBR : A = AD ? RBD : RBl
		C.Value := 1
	}
	; -------------------------------------------------------------------------------------------------------------------
	SetTabStopsGuiAdd(*) {
		T := CBBTabs.Text
		If !RegExMatch(T, "^\d*[.,]?\d+$") {
			CBBTabs.Focus()
			Return
		}
		T := Round(StrReplace(T, ",", "."), 2)
		RT := Round(T / Metrics, 2)
		If (RT < MinTab) || (RT > MaxTab){
			CBBTabs.Focus()
			Return
		}
		A := RBC.Value ? AC : RBR.Value ? AR : RBD.Value ? AD : AL
		TabArr := ControlGetItems(CBBTabs.Hwnd)
		P := -1
		T := Format("{:.2f}", T)
		For I, V In TabArr {
			If (T < V) {
				P := I - 1
				Break
			}
			IF (T = V) {
				P := I - 1
				CBBTabs.Delete(I)
				Break
			}
		}
		I := SendMessage(0x014A, P, StrPtr(T), CBBTabs.Hwnd)  ; CB_INSERTSTRING
		SendMessage(0x0151, I, A, CBBTabs.Hwnd)               ; CB_SETITEMDATA
		TabCount++
		If !(TabCount < MAX_TAB_STOPS)
			BNAdd.Enabled := False
		CBBTabs.Text := ""
		CBBTabs.Focus()
	}
	; -------------------------------------------------------------------------------------------------------------------
	SetTabStopsGuiRemove(*) {
		If (I := CBBTabs.Value) {
			CBBTabs.Delete(I)
			CBBTabs.Text := ""
			TabCount--
			RBL.Value := 1
		}
		CBBTabs.Focus()
	}
	; -------------------------------------------------------------------------------------------------------------------
	SetTabStopsGuiRemoveAll(*) {
		CBBTabs.Text := ""
		CBBTabs.Delete()
		RBL.Value := 1
		CBBTabs.Focus()
	}
	; -------------------------------------------------------------------------------------------------------------------
	SetTabStopsGuiApply(*) {
		TabCount := SendMessage(0x0146, 0, 0, CBBTabs.Hwnd) << 32 >> 32 ; CB_GETCOUNT
		If (TabCount < 1)
			Return
		TabArr := ControlGetItems(CBBTabs.HWND)
		TabStops := {}
		For I, T In TabArr {
			Alignment := Format("0x{:08X}", SendMessage(0x0150, I - 1, 0, CBBTabs.HWND)) ; CB_GETITEMDATA
			TabPos := Format("{:i}", T * 100)
			TabStops.%TabPos% := Align.%Alignment%
		}
		Success := RE.SetTabStops(TabStops)
		RE.Gui.Opt("-Disabled")
		SetTabStopsGui.Destroy()
	}
}
; ---------------------------------------------------------------------------
; Sets multi-line tooltips for any Gui control.
; Parameters:
;     GuiCtrl     -  A Gui.Control object
;     TipText     -  The text for the tooltip. If you pass an empty string for a formerly added control,
;                    its tooltip will be removed.
;     UseAhkStyle -  If set to true, the tooltips will be shown using the visual styles of AHK ToolTips.
;                    Otherwise, the current theme settings will be used.
;                    Default: True
;     CenterTip   -  If set to true, the tooltip will be shown centered below/above the control.
;                    Default: False
;  Return values:
;     True on success, otherwise False.
; Remarks:
;     Text and Picture controls require the SS_NOTIFY (+0x0100) style.
; MSDN:
;     https://learn.microsoft.com/en-us/windows/win32/controls/tooltip-control-reference
; ---------------------------------------------------------------------------
GuiCtrlSetTip(GuiCtrl, TipText, UseAhkStyle := True, CenterTip := False) {
	Static SizeOfTI := 24 + (A_PtrSize * 6)
	Static Tooltips := Map()
	Local Flags, HGUI, HCTL, HTT, TI
	; Check the passed GuiCtrl
	If !(GuiCtrl Is Gui.Control)
		Return False
	HGUI := GuiCtrl.Gui.Hwnd
	; Create the TOOLINFO structure -> msdn.microsoft.com/en-us/library/bb760256(v=vs.85).aspx
	Flags := 0x11 | (CenterTip ? 0x02 : 0x00) ; TTF_SUBCLASS | TTF_IDISHWND [| TTF_CENTERTIP]
	TI := Buffer(SizeOfTI, 0)
	NumPut("UInt", SizeOfTI, "UInt", Flags, "UPtr", HGUI, "UPtr", HGUI, TI) ; cbSize, uFlags, hwnd, uID
	; Create a tooltip control for this Gui, if needed
	If !ToolTips.Has(HGUI) {
		If !(HTT := DllCall("CreateWindowEx", "UInt", 0, "Str", "tooltips_class32", "Ptr", 0, "UInt", 0x80000003
											, "Int", 0x80000000, "Int", 0x80000000, "Int", 0x80000000, "Int", 0x80000000
											, "Ptr", HGUI, "Ptr", 0, "Ptr", 0, "Ptr", 0, "UPtr"))
			Return False
		If (UseAhkStyle)
			DllCall("Uxtheme.dll\SetWindowTheme", "Ptr", HTT, "Ptr", 0, "Ptr", 0)
		SendMessage(0x0432, 0, TI.Ptr, HTT) ; TTM_ADDTOOLW
		Tooltips[HGUI] := {HTT: HTT, Ctrls: Map()}
	}
	HTT := Tooltips[HGUI].HTT
	HCTL := GuiCtrl.HWND
	; Add / remove a tool for this control
	NumPut("UPtr", HCTL, TI, 8 + A_PtrSize) ; uID
	NumPut("UPtr", HCTL, TI, 24 + (A_PtrSize * 4)) ; uID
	If !Tooltips[HGUI].Ctrls.Has(HCTL) { ; add the control
		If (TipText = "")
			Return False
		SendMessage(0x0432, 0, TI.Ptr, HTT) ; TTM_ADDTOOLW
		SendMessage(0x0418, 0, -1, HTT) ; TTM_SETMAXTIPWIDTH
		Tooltips[HGUI].Ctrls[HCTL] := True
	}
	Else If (TipText = "") { ; remove the control
		SendMessage(0x0433, 0, TI.Ptr, HTT) ; TTM_DELTOOLW
		Tooltips[HGUI].Ctrls.Delete(HCTL)
		Return True
	}
	; Set / Update the tool's text.
	NumPut("UPtr", StrPtr(TipText), TI, 24 + (A_PtrSize * 3))  ; lpszText
	SendMessage(0x0439, 0, TI.Ptr, HTT) ; TTM_UPDATETIPTEXTW
	Return True
}
; Testing >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
^+1:: {
	RC := Buffer(16, 0)
	DllCall("SendMessage", "Ptr", RE2.HWND, "UInt", 0x00B2, "Ptr", 0, "Ptr", RC.Ptr) ; EM_GETRECT
	CharIndex := DllCall("SendMessage", "Ptr", RE2.HWND, "UInt", 0x00D7, "Ptr", 0, "Ptr", RC.Ptr, "Ptr") ; EM_CHARFROMPOS
	LineIndex := DllCall("SendMessage", "Ptr", RE2.HWND, "UInt", 0x0436, "Ptr", 0, "Ptr", Charindex, "Ptr") ; EM_EXLINEFROMCHAR
	MsgBox("First visible line = " . LineIndex)
}
^+f:: {
	CS := RE2.GetSel()
	SP := RE2.GetScrollPos()
	RE2.Opt("-Redraw")
	CF2 := RichEdit.CHARFORMAT2()
	;    CF2 := RE2.GetCharFormat()                   ; retrieve a CHARFORMAT2 object for the current selection
	CF2.Mask := 0x40000001                       ; CFM_COLOR = 0x40000000, CFM_BOLD = 0x00000001
	CF2.TextColor := 0xFF0000                    ; colors are BGR
	CF2.Effects := 0x01                          ; CFE_BOLD := 0x00000001
	RE2.SetSel(0, 0)                             ; start searching at the begin of the text
	While (RE2.FindText("Lorem", ["Down"]) != 0) ; find the specific phrase
		RE2.SetCharFormat(CF2)                    ; apply the new settings
	CF2 := ""
	RE2.SetScrollPos(SP.X, SP.Y)
	RE2.SetSel(CS.X, CS.Y)
	RE2.Opt("+Redraw")
}
^+l:: {
	Sel := DllCall("SendMessage", "Ptr", RE2.HWND, "UInt", 0x00BB, "Ptr", 18, "Ptr", 0, "Ptr")
	RE2.SetSel(Sel, Sel)
	RE2.ScrollCaret()
}
^+b:: {
	RE2.SetBorder([10], [2])
}