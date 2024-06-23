; ---------------------------------------------------------------------------
; @Section....: Rich Text Editor - Customized for Horizon
; ---------------------------------------------------------------------------

#Requires AutoHotkey v2+
; #Include *i <Directives\__AE.v2>
; #Include *i <Includes\Includes_Standard>
#Include <Directives\__AE.v2>
#Include <Class\RTE\RichEdit> ;? Merged RichEditDlgs into a this script
; #Include <Class\RTE\RichEditDlgs>
Persistent(1)
; #Include *i <Includes\Includes_Runner>
; TraySetIcon('HICON:' Create_HznHorizon_ico())

; ---------------------------------------------------------------------------
; @Section...: Create a Gui with RichEdit controls
; ---------------------------------------------------------------------------

^+t::{
	hzn := RTEdit()
	; hzn.Show()

}

; ---------------------------------------------------------------------------
; @Class...: Rich Text Editor Class
; ---------------------------------------------------------------------------
Class RTEdit {


	__New() {
	; ---------------------------------------------------------------------------
	; @function....: Rich Text Editor - Customized for Horizon
	; ---------------------------------------------------------------------------

	; ---------------------------------------------------------------------------
	; @i...: Create a Gui with RichEdit controls
	; ---------------------------------------------------------------------------
	; @i...: Initial values
	; ---------------------------------------------------------------------------
    EditW := (A_ScreenWidth / 3)
    EditH := (A_ScreenHeight / 3)
    GuiW := 0
    GuiH := 0
    ; REW := 0
    ; REH := 0
    REW := EditW
    REH := EditH
    MarginX := 10
    MarginY := 10
    GuiTitle := 'Horizon Rich Text Editor - hznRTE -- A Rich Text Editor for Horizon --'
    BackColor := "Auto"
    FontName := "Times New Roman"
    FontSize := "11"
    FontStyle := "Norm"
    FontCharSet := 1
    TextColor := "Auto"
    TextBkColor := "Auto"
    WordWrap := True
    AutoURL := False
    Zoom := "100 %"
    ShowWysiwyg := False
    CurrentLine := 0
    CurrentLineCount := 0
    HasFocus := False
	; ---------------------------------------------------------------------------
	; @i...: Initial values
	; ---------------------------------------------------------------------------
	static Settings := {
		GuiTitle : 'Horizon Rich Text Editor - hznRTE -- A Rich Text Editor for Horizon',
		FontCharSet : 1,
		FontName : 'Times New Roman',
		FontSize : 11,
		FontStyle : "Norm",
		BackColor : "cYellow",
		TextColor : "cBlack",
		TextBkColor : "Auto",
		WordWrap : True,
		AutoURL : False,
		ShowWysiwyg : true,
		HasFocus : true ,
		Zoom : "100 %",
		CurrentLine : 0,
		CurrentLineCount : 0,
		hMult : 5,
		wMult : 2,
		gHmult : 2,
		div : 5,
		MarginX : 10,
		MarginY : 10,
		EditW : (A_ScreenHeight / 2),
		EditH : 1000,
		REW : EditW,
		REH : EditH,
		GuiW : Round(A_ScreenWidth * (1/4)),
		GuiH : Round(A_ScreenHeight * (1/4))
	}
	Open_File := ''
	; ---------------------------------------------------------------------------
	; @i...: Menus
	; ---------------------------------------------------------------------------
	; @i...: FileMenu
	; ---------------------------------------------------------------------------
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
	; ---------------------------------------------------------------------------
	; @i...: EditMenu
	; ---------------------------------------------------------------------------
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
	; ---------------------------------------------------------------------------
	; @i...: SearchMenu
	; ---------------------------------------------------------------------------
	SearchMenu := Menu()
	SearchMenu.Add("&Find", FindFN)
	SearchMenu.Add("&Replace", ReplaceFN)
	; ---------------------------------------------------------------------------
	; @i...: FormatMenu
	; ---------------------------------------------------------------------------
	; @i...: Paragraph
	; ---------------------------------------------------------------------------
	AlignMenu := Menu()
	AlignMenu.Add("Align &left`tCtrl+L", AlignFN.Bind("Left"))
	AlignMenu.Add("Align &center`tCtrl+E", AlignFN.Bind("Center"))
	AlignMenu.Add("Align &right`tCtrl+R", AlignFN.Bind("Right"))
	AlignMenu.Add("Align &justified", AlignFN.Bind("Justify"))
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
	; @i...: Character
	; ---------------------------------------------------------------------------
	TxColorMenu := Menu()
	TxColorMenu.Add("&Choose", TextColorFN.Bind("Choose"))
	TxColorMenu.Add("&Auto", TextColorFN.Bind("Auto"))
	BkColorMenu := Menu()
	BkColorMenu.Add("&Choose", TextBkColorFN.Bind("Choose"))
	BkColorMenu.Add("&Auto", TextBkColorFN.Bind("Auto"))
	CharacterMenu := Menu()
	CharacterMenu.Add("&Font", ChooseFontFN)
	CharacterMenu.Add("&Text color", TxColorMenu)
	CharacterMenu.Add("Text &Backcolor", BkColorMenu)
	; ---------------------------------------------------------------------------
	; @i...: Format
	; ---------------------------------------------------------------------------
	FormatMenu := Menu()
	FormatMenu.Add("&Character", CharacterMenu)
	FormatMenu.Add("&Paragraph", ParagraphMenu)
	; ---------------------------------------------------------------------------
	; @i...: ViewMenu
	; ---------------------------------------------------------------------------
	; @i...: Background
	; ---------------------------------------------------------------------------
	BackgroundMenu := Menu()
	BackgroundMenu.Add("&Choose", BackGroundColorFN.Bind("Choose"))
	BackgroundMenu.Add("&Auto", BackgroundColorFN.Bind("Auto"))
	; ---------------------------------------------------------------------------
	; @i...: Zoom
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
	; @i...: View
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
	; @i...: ContextMenu
	; ---------------------------------------------------------------------------
	ContextMenu := Menu()
	ContextMenu.Add("&File", FileMenu)
	ContextMenu.Add("&Edit", EditMenu)
	ContextMenu.Add("&Search", SearchMenu)
	ContextMenu.Add("F&ormat", FormatMenu)
	ContextMenu.Add("&View", ViewMenu)
	; ---------------------------------------------------------------------------
	; @i...: MainMenuBar
	; ---------------------------------------------------------------------------
	MainMenuBar := MenuBar()
	MainMenuBar.Add("&File", FileMenu)
	MainMenuBar.Add("&Edit", EditMenu)
	MainMenuBar.Add("&Search", SearchMenu)
	MainMenuBar.Add("F&ormat", FormatMenu)
	MainMenuBar.Add("&View", ViewMenu)
	; ---------------------------------------------------------------------------
	; ---------------------------------------------------------------------------
	; @i...: Main Gui
	; ---------------------------------------------------------------------------
	; ---------------------------------------------------------------------------
	GuiNum := 1
	MainGui := Gui("+ReSize +MinSize", GuiTitle)
	MainGui.OnEvent("Size", MainGuiSize)
	MainGui.OnEvent("Close", MainGuiClose)
	MainGui.OnEvent("ContextMenu", MainContextMenu)
	MainGui.MenuBar := MainMenuBar
	MainGui.MarginX := MarginX
	MainGui.MarginY := MarginY
	; ---------------------------------------------------------------------------
	; @i...: Style buttons
	; ---------------------------------------------------------------------------
	; MainGui.SetFont("Bold", "Arial")
	MainGui.SetFont('Bold', FontName)
	MainBNSB := MainGui.AddButton("xm y3 w20 h20", "&B")
	MainBNSB.OnEvent("Click", SetFontStyleFN.Bind("B"))
	; GuiCtrlSetTip(MainBNSB, "Bold (Alt+B)")
	GuiCtrlSetTip(MainBNSB, "Bold (Clt+B)")
	MainGui.SetFont("Norm Italic")
	MainBNSI := MainGui.AddButton("x+0 yp wp hp", "&I")
	MainBNSI.OnEvent("Click", SetFontStyleFN.Bind("I"))
	GuiCtrlSetTip(MainBNSI, "Italic (Clt+I)")
	MainGui.SetFont("Norm Underline")
	MainBNSU := MainGui.AddButton("x+0 yp wp hp", "&U")
	MainBNSU.OnEvent("Click", SetFontStyleFN.Bind("U"))
	GuiCtrlSetTip(MainBNSU, "Underline (Clt+U)")
	MainGui.SetFont("Norm Strike")
	MainBNSS := MainGui.AddButton("x+0 yp wp hp", "&S")
	MainBNSS.OnEvent("Click", SetFontStyleFN.Bind("S"))
	GuiCtrlSetTip(MainBNSS, "Strikeout (Alt+S)")
	; MainGui.SetFont(FontStyle, "Arial")
	MainGui.SetFont(FontStyle, FontName)
	MainBNSH := MainGui.AddButton("x+0 yp wp hp", "¯")
	MainBNSH.OnEvent("Click", SetFontStyleFN.Bind("H"))
	GuiCtrlSetTip(MainBNSH, "Superscript (Ctrl+Shift+'+')")
	MainBNSL := MainGui.AddButton("x+0 yp wp hp", "_")
	MainBNSL.OnEvent("Click", SetFontStyleFN.Bind("L"))
	GuiCtrlSetTip(MainBNSL, "Subscript (Ctrl+'+')")
	MainBNSN := MainGui.AddButton("x+0 yp wp hp", "&N")
	MainBNSN.OnEvent("Click", SetFontStyleFN.Bind("N"))
	GuiCtrlSetTip(MainBNSN, "Normal (Alt+N)")
	MainBNTC := MainGui.AddButton("x+10 yp wp hp", "&T")
	MainBNTC.OnEvent("Click", TextColorFN.Bind("Choose"))
	GuiCtrlSetTip(MainBNTC, "Text color (Alt+T)")
	MainColors := MainGui.AddProgress("x+0 yp wp hp BackgroundYellow cNavy Border", 50)
	MainBNBC := MainGui.AddButton("x+0 yp wp hp", "B")
	MainBNBC.OnEvent("Click", TextBkColorFN.Bind("Choose"))
	GuiCtrlSetTip(MainBNBC, "Text backcolor")
	; MainFNAME := MainGui.AddEdit("x+10 yp w150 hp ReadOnly", FontName)
	MainFNAME := MainGui.AddEdit('x+10 yp w150 hp', 'Times New Roman')
	MainBNCF := MainGui.AddButton("x+0 yp w20 hp", "...")
	MainBNCF.OnEvent("Click", ChooseFontFN)
	GuiCtrlSetTip(MainBNCF, "Choose font")
	MainBNFP := MainGui.AddButton("x+5 yp wp hp", "&+")
	MainBNFP.OnEvent("Click", ChangeSize.Bind(1))
	GuiCtrlSetTip(MainBNFP, "Increase size (Alt+'+')")
	; MainFSIZE := MainGui.AddEdit("x+0 yp w30 hp ReadOnly", FontSize)
	MainFSIZE := MainGui.AddEdit('x+0 yp w30 hp', '11')
	MainBNFM := MainGui.AddButton("x+5 yp wp hp", "&-")
	MainBNFM.OnEvent("Click", ChangeSize.Bind(-1))
	GuiCtrlSetTip(MainBNFM, "Decrease size (Alt+'-')")
	; ---------------------------------------------------------------------------
	; ---------------------------------------------------------------------------
	; @i...: RichEdit #1 ; fix [Come up with a better section title]
	; ---------------------------------------------------------------------------
	; MainGui.SetFont("Bold Italic", "Arial")
	MainGui.SetFont("Bold Italic", FontName)
	MainT1 := MainGui.AddText("x+10 yp hp", "WWWWWWWW")
	MainT1.GetPos(&TX := 0, &TY := 0, &TW := 0, &TH := 0)
	TX := EditW - TW + MarginX
	MainT1.Move(TX)
	; MainGui.SetFont(FontStyle, "Arial")
	MainGui.SetFont(FontStyle, FontName)
	Options := "x" . TX . " y" . TY . " w" . TW . " h" . TH
	If !IsObject(RE1 := RichEdit(MainGui, Options, False)) {
		Throw("Could not create the RE1 RichEdit control!", -1)
	}
	RE1.ReplaceSel("")
	RE1.AlignText("CENTER")
	RE1.SetOptions(["READONLY"], "SET")
	RE1.SetParaSpacing({Before: 2})
	; ---------------------------------------------------------------------------
	; @i...: Alignment & line spacing
	; ---------------------------------------------------------------------------
	; MainGui.SetFont(FontStyle, "Arial")
	MainGui.SetFont(FontStyle, FontName)
	MainGui.AddText("0x1000 xm y+2 h2 w" EditW)
	MainBNAL := MainGui.AddButton("x10 y+1 w30 h20",  "|<")
	MainBNAL.OnEvent("Click", AlignFN.Bind("Left"))
	GuiCtrlSetTip(MainBNAL, "Align left (Ctrl+L)")
	MainBNAC := MainGui.AddButton("x+0 yp wp hp", "><")
	MainBNAC.OnEvent("Click", AlignFN.Bind("Center"))
	GuiCtrlSetTip(MainBNAC, "Align center (Ctrl+E)")
	MainBNAR := MainGui.AddButton("x+0 yp wp hp", ">|")
	MainBNAR.OnEvent("Click", AlignFN.Bind("Right"))
	GuiCtrlSetTip(MainBNAR, "Align right (Ctrl+R)")
	MainBNAJ := MainGui.AddButton("x+0 yp wp hp", "|<>|")
	MainBNAJ.OnEvent("Click", AlignFN.Bind("Justify"))
	GuiCtrlSetTip(MainBNAJ, "Align justified")
	MainBN10 := MainGui.AddButton("x+10 yp wp hp", "1")
	MainBN10.OnEvent("Click", SpacingFN.Bind(1.0))
	GuiCtrlSetTip(MainBN10, "Linespacing 1 line (Ctrl+1)")
	MainBN15 := MainGui.AddButton("x+0 yp wp hp", "1½")
	MainBN15.OnEvent("Click", SpacingFN.Bind(1.5))
	GuiCtrlSetTip(MainBN15, "Linespacing 1,5 lines (Ctrl+5)")
	MainBN20 := MainGui.AddButton("x+0 yp wp hp", "2")
	MainBN20.OnEvent("Click", SpacingFN.Bind(2.0))
	GuiCtrlSetTip(MainBN20, "Linespacing 2 lines (Ctrl+2)")
	; ---------------------------------------------------------------------------
	; ---------------------------------------------------------------------------
	; ---------------------------------------------------------------------------
	; @i...: RichEdit #2
	; ---------------------------------------------------------------------------
	; ---------------------------------------------------------------------------
	; ---------------------------------------------------------------------------
	MainFNAME.Text := FontName
	MainFSIZE.Text := FontSize
	MainGui.SetFont('s' FontSize, FontName)
	Options := "xm y+5 w" . EditW . " r20"
	If !IsObject(RE2 := RichEdit(MainGui, Options)){
		Throw("Could not create the RE2 RichEdit control!", -1)
	}
	RE2.SetOptions(["SELECTIONBAR"])
	RE2.AutoURL(True)
	RE2.SetEventMask(["SELCHANGE", "LINK"])
	RE2.OnNotify(0x0702, RE2_SelChange)
	RE2.OnNotify(0x070B, RE2_Link)
	RE2.GetPos( , , &REW, &REH)
	MainGui.SetFont()
	; ---------------------------------------------------------------------------
	; @i...: The rest
	; ---------------------------------------------------------------------------
	MainSB := MainGui.AddStatusbar()
	MainSB.SetParts(10, 200)
	MainGui.Show()
	RE2.Focus()
	UpdateGui()
	Return
	; ---------------------------------------------------------------------------
	; @i...: End of auto-execute section
	; ---------------------------------------------------------------------------
	; Testing
	; ---------------------------------------------------------------------------
	/*
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
		; CF2 := RE2.GetCharFormat()                   ; retrieve a CHARFORMAT2 object for the current selection
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
	; ---------------------------------------------------------------------------
	#HotIf RE2.Focused
	; FontStyles
	^!b::  ; bold
	^!h::  ; superscript
	^!i::  ; italic
	^!l::  ; subscript
	^!n::  ; normal
	^!p::  ; protected
	^!s::  ; strikeout
	^!u::  ; underline
	{
		RE2.ToggleFontStyle(SubStr(A_ThisHotkey, 3))
		UpdateGui()
	}
	#HotIf
	*/
	; ---------------------------------------------------------------------------
	; @i...: Testing
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
			ToolTip("0x0202 - " wParam " - " lParam " - " cpMin " - " cpMax " - " URLtoOpen)
			Run('"' URLtoOpen '"')
		}
	}
	; ---------------------------------------------------------------------------
	; @i...: UpdateGui:
	; ---------------------------------------------------------------------------
	UpdateGui(*) {
		Static FontName := Settings.FontName, FontCharset := Settings.FontCharset, FontStyle := Settings.FontStyle, FontSize := Settings.FontSize, TextColor := Settings.TextColor, TxBkColor := Settings.TextBkColor
		Local Font := RE2.GetFont()
		If (FontName != Font.Name || FontCharset != Font.CharSet || FontStyle != Font.Style || FontSize != Font.Size || TextColor != Font.Color || TxBkColor != Font.BkColor) {
			FontStyle := Font.Style
			TextColor := Font.Color
			TxBkColor := Font.BkColor
			FontCharSet := Font.CharSet
			If (FontName != Font.Name) {
				; FontName := Font.Name
				MainFNAME.Text := FontName
			}
			If (FontSize != Font.Size) {
				; FontSize := Round(Font.Size)
				MainFSIZE.Text := FontSize
			}
			Font.Size := FontSize
			RE1.SetSel(0, -1) ; select all
			RE1.SetFont(Font)
			RE1.SetSel(0, 0)  ; deselect all
		}
		Local Stats := RE2.GetStatistics()
		MainSB.SetText(Stats.Line . " : " . Stats.LinePos . " (" . Stats.LineCount . ")  [" . Stats.CharCount . "]", 2)
		}
	; ---------------------------------------------------------------------------
	; Gui related
	; ---------------------------------------------------------------------------
	RTE_SelectAll(*)
	{
		Static Msg := EM_SETSEL := 177, wParam := 0, lParam := -1
		hCtl := ControlGetFocus('A')
		DllCall('SendMessage', 'UInt', hCtl, 'UInt', Msg, 'UInt', wParam, 'UIntP', lParam)
		return
	}
	; ---------------------------------------------------------------------------
	;@i...: GuiClose:
	; ---------------------------------------------------------------------------
	MainGuiClose(*) {
		; ---------------------------------------------------------------------------
		RTE_SelectAll()
		; ---------------------------------------------------------------------------
		SetKeyDelay(-1, -1)
		SendMode('Event')
		; Send('^c')
		; Send('^{sc2E}')
		Send('{sc1D}{sc2E}') ;? LCtrl & c
		; ---------------------------------------------------------------------------
		; Global RE1, RE2
		If IsObject(RE1){
			RE1 := ""
		}
		If IsObject(RE2){
			RE2 := ""
		}
		MainGui.Destroy()
		; ToolTip(A_Clipboard)
		; ExitApp()
	}
	; ---------------------------------------------------------------------------
	; @i...: GuiSize:
	; ---------------------------------------------------------------------------
	MainGuiSize(GuiObj, MinMax, Width, Height) {
		; Global GuiW, GuiH, REW, REH
		GuiW := GuiW
		GuiH := GuiH
		REW := REW
		REH := REH
		Critical()
		If (MinMax = 1)
			Return
		If (GuiW = 0) {
			GuiW := Width
			GuiH := Height
			Return
		}
		If (Width != GuiW || Height != GuiH) {
			REW += Width - GuiW
			REH += Height - GuiH
			RE2.Move( , , REW, REH)
			GuiW := Width
			GuiH := Height
		}
	}
	; ---------------------------------------------------------------------------
	; @i...: GuiContextMenu
	; ---------------------------------------------------------------------------
	MainContextMenu(GuiObj, GuiCtrlObj, *) {
		If (GuiCtrlObj = RE2)
			ContextMenu.Show()
	}
	; ---------------------------------------------------------------------------
	; @i...: Text operations
	; ---------------------------------------------------------------------------
	; @i...: SetFontStyle
	; ---------------------------------------------------------------------------
	SetFontStyleFN(Style, GuiCtrl, *) {
		RE2.ToggleFontStyle(Style)
		UpdateGui()
		RE2.Focus()
	}
	; ---------------------------------------------------------------------------
	; @i...: hangeSize
	; ---------------------------------------------------------------------------
	ChangeSize(IncDec, GuiCtrl, *) {
		FontSize := RE2.ChangeFontSize(IncDec)
		MainFSIZE.Text := Round(FontSize)
		RE2.Focus()
	}
	; ---------------------------------------------------------------------------
	; @i...: Menu File
	; ---------------------------------------------------------------------------
	; @i...: FileAppend
	; @i...: FileOpen
	; @i...: FileInsert
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
	; @i...: FileClose
	; ---------------------------------------------------------------------------
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
	; @i...: FileSave
	; ---------------------------------------------------------------------------
	FileSaveFN(*) {
		If !(Open_File)
			Return FileSaveAsFN()
		RE2.SaveFile(Open_File)
		RE2.SetModified()
		RE2.Focus()
	}
	; ---------------------------------------------------------------------------
	; @i...: FileSaveAs:
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
	; @i...: PageSetup
	; ---------------------------------------------------------------------------
	PageSetupFN(*) {
		RichEditDlgs.PageSetup(RE2)
		RE2.Focus()
	}
	; ---------------------------------------------------------------------------
	; @i...: Print
	; ---------------------------------------------------------------------------
	PrintFN(*) {
		RE2.Print()
		RE2.Focus()
	}
	; ---------------------------------------------------------------------------
	; @i...: Menu Edit
	; ---------------------------------------------------------------------------
	; @i...: Undo
	; ---------------------------------------------------------------------------
	UndoFN(*) {
		RE2.Undo()
		RE2.Focus()
	}
	; ---------------------------------------------------------------------------
	; @i...: Redo
	; ---------------------------------------------------------------------------
	RedoFN(*) {
		RE2.Redo()
		RE2.Focus()
	}
	; ---------------------------------------------------------------------------
	; @i...: Cut
	; ---------------------------------------------------------------------------
	CutFN(*) {
		RE2.Cut()
		RE2.Focus()
	}
	; ---------------------------------------------------------------------------
	; @i...: Copy
	; ---------------------------------------------------------------------------
	CopyFN(*) {
		RE2.Copy()
		RE2.Focus()
	}
	; ---------------------------------------------------------------------------
	; @i...: Paste:
	; ---------------------------------------------------------------------------
	PasteFN(*) {
		RE2.Paste()
		RE2.Focus()
	}
	; ---------------------------------------------------------------------------
	; @i...: Clear
	; ---------------------------------------------------------------------------
	ClearFN(*) {
		RE2.Clear()
		RE2.Focus()
	}
	; ---------------------------------------------------------------------------
	; @i...: SelAll
	; ---------------------------------------------------------------------------
	SelAllFN(*) {
		RE2.SelAll()
		RE2.Focus()
	}
	; ---------------------------------------------------------------------------
	; @i...: Deselect
	; ---------------------------------------------------------------------------
	DeselectFN(*) {
		RE2.Deselect()
		RE2.Focus()
	}
	; ---------------------------------------------------------------------------
	; @i...: Menu View
	; ---------------------------------------------------------------------------
	; @i...: WordWrap
	; ---------------------------------------------------------------------------
	WordWrapFN(Item, *) {
		; Global WordWrap ^= True
		WordWrap ^= True
		RE2.WordWrap(WordWrap)
		ViewMenu.ToggleCheck(Item)
		If (WordWrap){
			ViewMenu.Disable(MenuWysiwyg)
		}
		Else{
			ViewMenu.Enable(MenuWysiwyg)
		}
		RE2.Focus()
	}
	; ---------------------------------------------------------------------------
	; @i...: Zoom
	; ---------------------------------------------------------------------------
	Zoom100FN(*) => ZoomFN(100, "100 %")
	ZoomFN(Ratio, Item, *) {
		Global Zoom
		ZoomMenu.UnCheck(Zoom)
		Zoom := Item
		ZoomMenu.Check(Zoom)
		RE2.SetZoom(Ratio)
		RE2.Focus()
	}
	; ---------------------------------------------------------------------------
	; @i...: WYSIWYG
	; ---------------------------------------------------------------------------
	WYSIWYGFN(Item, *) {
		; Global ShowWysiwyg ^= True
		ShowWysiwyg ^= True
		If (ShowWysiwyg)
			Zoom100FN()
		RE2.WYSIWYG(ShowWysiwyg)
		ViewMenu.ToggleCheck(Item)
		If (ShowWysiwyg){
			ViewMenu.Disable(MenuWordWrap)
		}
		Else{
			ViewMenu.Enable(MenuWordWrap)
		}
		RE2.Focus()
	}
	; ---------------------------------------------------------------------------
	; @i...: BackgroundColor
	; ---------------------------------------------------------------------------
	BackgroundColorFN(Mode, *) {
		; Global BackColor
		BackColor := BackColor
		Switch Mode {
			Case "Auto":
				RE2.SetBkgndColor("Auto")
				RE2.BackColor := "Auto"
			Case "Choose":
				If RE2.BackColor != "Auto"{
					Color := RE2.BackColor
				}
				Else{
					Color := RE2.GetRGB(DllCall("GetSysColor", "Int", 5, "UInt")) ; COLOR_WINDOW
				}
				NC := RichEditDlgs.ChooseColor(RE2, Color)
				If (NC != "") {
					RE2.SetBkgndColor(NC)
					RE2.BackColor := NC
				}
		}
		RE2.Focus()
	}
	; ---------------------------------------------------------------------------
	; @i...: AutoURLDetection
	; ---------------------------------------------------------------------------
	AutoURLDetectionFN(ItemName, ItemPos, MenuObj) {
		RE2.AutoURL(AutoURL ^= True)
		MenuObj.ToggleCheck(ItemName)
		RE2.Focus()
	}
	; ---------------------------------------------------------------------------
	; @i...: Menu Character
	; ---------------------------------------------------------------------------
	; @i...: ChooseFont
	; ---------------------------------------------------------------------------
	ChooseFontFN(*) {
		;Global FontName, FontSize
		RichEditDlgs.ChooseFont(RE2)
		Font := RE2.GetFont()
		; FontName := Font.Name
		; FontSize := Font.Size
		FontName := FontName
		FontSize := FontSize
		MainFNAME.Text := FontName
		MainFSIZE.Text := Round(FontSize)
		RE2.Focus()
	}
	; ---------------------------------------------------------------------------
	; @i...: MTextColor    ; menu label
	; @i...: BTextColor    ; button label
	TextColorFN(Mode, *) {
		; Global TextColor
		TextColor := TextColor
		Switch Mode {
			Case "Auto":
				RE2.SetFont({Color: "Auto"})
				RE2.TextColor := "Auto"
			Case "Choose":
				If RE2.TextColor != "Auto"{
					Color := RE2.TextColor
				}
				Else{
					Color := RE2.GetRGB(DllCall("GetSysColor", "Int", 8, "UInt")) ; COLOR_WINDOWTEXT
				}
				NC := RichEditDlgs.ChooseColor(RE2, Color)
				If (NC != "") {
					RE2.SetFont({Color: NC})
					RE2.TextColor := NC
				}
		}
		UpdateGui()
		RE2.Focus()
	}
	; ---------------------------------------------------------------------------
	; @i...: MTextBkColor  ; menu label
	; @i...: BTextBkColor  ; button label
	TextBkColorFN(Mode, *) {
		; Global TextBkColor
		TextBkColor := TextBkColor
		Switch Mode {
			Case "Auto":
				RE2.SetFont({BkColor: "Auto"})
				; Color := RE2.GetRGB(DllCall("GetSysColor", "Int", 5, "UInt")) ; COLOR_WINDOW
			Case "Choose":
				If RE2.TxBkColor != "Auto"{
					Color := RE2.TxBkColor
				}
				Else{
					Color := RE2.GetRGB(DllCall("GetSysColor", "Int", 5, "UInt")) ; COLOR_WINDOW
				}
				NC := RichEditDlgs.ChooseColor(RE2, Color)
				If (NC != "") {
					RE2.SetFont({BkColor: NC})
					RE2.TxBkColor := NC
				}
		}
		UpdateGui()
		RE2.Focus()
	}
	; ---------------------------------------------------------------------------
	; @i...: Menu Paragraph
	; ---------------------------------------------------------------------------
	; @i...: AlignLeft
	; @i...: AlignCenter
	; @i...: AlignRight:
	; @i...: AlignJustify
	AlignFN(Alignment, *) {
		Static Align := {Left: 1, Right: 2, Center: 3, Justify: 4}
		If Align.HasProp(Alignment)
			RE2.AlignText(Align.%Alignment%)
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
	; @i...: Numbering
	; ---------------------------------------------------------------------------
	NumberingFN(Mode, *) {
		Switch Mode {
			Case "Set": ParaNumberingGui(RE2)
			Case "Reset": RE2.SetParaNumbering()
		}
		RE2.Focus()
	}
	; ---------------------------------------------------------------------------
	; @i...: ParaSpacing
	; ---------------------------------------------------------------------------
	; @i...: ResetParaSpacing
	ParaSpacingFN(Mode, *) {
		Switch Mode {
			Case "Set": ParaSpacingGui(RE2)
			Case "Reset": RE2.SetParaSpacing()
		}
		RE2.Focus()
	}
	; ---------------------------------------------------------------------------
	; @i...: Spacing1.0
	; @i...: Spacing1.5
	; @i...: Spacing2.0
	; ---------------------------------------------------------------------------
	SpacingFN(Val, *) {
		RE2.SetLineSpacing(Val)
		RE2.Focus()
	}
	; ---------------------------------------------------------------------------
	; @i...: SetTabStops
	; @i...: ResetTabStops
	; @i...: SetDefTabs
	; ---------------------------------------------------------------------------
	SetTabStopsFN(Mode, *) {
		Switch Mode {
			Case "Set": SetTabStopsGui(RE2)
			Case "Reset": RE2.SetTabStops()
			Case "Default": RE2.SetDefaultTabs(1)
		}
		RE2.Focus()
	}
	; ---------------------------------------------------------------------------
	; @i...: Menu Search
	; ---------------------------------------------------------------------------
	FindFN(*) {
		RichEditDlgs.FindText(RE2)
	}
	; ---------------------------------------------------------------------------
	ReplaceFN(*) {
		RichEditDlgs.ReplaceText(RE2)
	}
	; ---------------------------------------------------------------------------
	; @i...: ParaIndentation GUI
	; ---------------------------------------------------------------------------
	ParaIndentGui(RE) {
		Static   Owner := "", Success := False
		Metrics := RE.GetMeasurement()
		PF2 := RE.GetParaFormat()
		Owner := RE.Gui.Hwnd
		gParaIndentGui := Gui("+Owner" . Owner . " +ToolWindow +LastFound", "Paragraph Indentation")
		gParaIndentGui.OnEvent("Close", ParaIndentGuiClose)
		gParaIndentGui.MarginX := 20
		gParaIndentGui.MarginY := 10
		gParaIndentGui.AddText("Section h20 0x200", "First line left indent (absolute):")
		gParaIndentGui.AddText("xs hp 0x200", "Other lines left indent (relative):")
		gParaIndentGui.AddText("xs hp 0x200", "All lines right indent (absolute):")
		EDLeft1 := gParaIndentGui.AddEdit("ys hp Limit5")
		EDLeft2 := gParaIndentGui.AddEdit("hp Limit6")
		EDRight := gParaIndentGui.AddEdit("hp Limit5")
		CBStart := gParaIndentGui.AddCheckBox("ys x+5 hp", "Apply")
		CBOffset := gParaIndentGui.AddCheckBox("hp", "Apply")
		CBRight := gParaIndentGui.AddCheckBox("hp", "Apply")
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
		BN1 := gParaIndentGui.AddButton("xs", "Apply")
		BN1.OnEvent("Click", ParaIndentGuiApply)
		BN2 := gParaIndentGui.AddButton("x+10 yp", "Cancel")
		BN2.OnEvent("Click", ParaIndentGuiClose)
		BN2.GetPos( , , &BW := 0)
		BN1.Move( , , BW)
		CBRight.GetPos(&CX := 0, , &CW := 0)
		BN2.Move(CX + CW - BW)
		RE.Gui.Opt("+Disabled")
		gParaIndentGui.Show()
		WinWaitActive()
		WinWaitClose()
		Return Success
		; ---------------------------------------------------------------------------
		ParaIndentGuiClose(*) {
			Success := False
			RE.Gui.Opt("-Disabled")
			gParaIndentGui.Destroy()
		}
		; ---------------------------------------------------------------------------
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
			gParaIndentGui.Destroy()
		}
	}
	; ---------------------------------------------------------------------------
	; @i...: ParaNumbering GUI
	; ---------------------------------------------------------------------------
	ParaNumberingGui(RE) {
		Static	Owner := "",
				Bullet := "•",
				StyleArr := ["1)", "(1)", "1.", "1", "w/o"],
				TypeArr := [Bullet, "0, 1, 2", "a, b, c", "A, B, C", "i, ii, iii", "I, I, III"],
				PFN := ["Bullet", "Arabic", "LCLetter", "UCLetter", "LCRoman", "UCRoman"],
				PFNS := ["Paren", "Parens", "Period", "Plain", "None"],
				Success := False
		Metrics := RE.GetMeasurement()
		PF2 := RE.GetParaFormat()
		Owner := RE.Gui.Hwnd
		gParaNumberingGui := Gui("+Owner" . Owner . " +ToolWindow +LastFound", "Paragraph Numbering")
		gParaNumberingGui.OnEvent("Close", ParaNumberingGuiClose)
		gParaNumberingGui.MarginX := 20
		gParaNumberingGui.MarginY := 10
		gParaNumberingGui.AddText("Section h20 w100 0x200", "Type:")
		DDLType := gParaNumberingGui.AddDDL("xp y+0 wp AltSubmit", TypeArr)
		If (PF2.Numbering)
			DDLType.Choose(PF2.Numbering)
		gParaNumberingGui.AddText("xs h20 w100 0x200", "Start with:")
		EDStart := gParaNumberingGui.AddEdit("y+0 wp hp Limit5", PF2.NumberingStart)
		gParaNumberingGui.AddText("ys h20 w100 0x200", "Style:")
		DDLStyle := gParaNumberingGui.AddDDL("y+0 wp AltSubmit Choose1", StyleArr)
		If (PF2.NumberingStyle)
			DDLStyle.Choose((PF2.NumberingStyle // 0x0100) + 1)
		gParaNumberingGui.AddText("h20 w100 0x200", "Distance:  (" . (Metrics = 1.00 ? "in." : "cm") . ")")
		EDDist := gParaNumberingGui.AddEdit("y+0 wp hp Limit5")
		Tab := Round((PF2.NumberingTab / 1440) * Metrics, 2)
		If (Metrics = 2.54)
			Tab := RegExReplace(Tab, "\.", ",")
		EDDist.Text := Tab
		BN1 := gParaNumberingGui.AddButton("xs", "Apply") ; gParaNumberingGuiApply hwndhBtn1, Apply
		BN1.OnEvent("Click", ParaNumberingGuiApply)
		BN2 := gParaNumberingGui.AddButton("x+10 yp", "Cancel") ;  gParaNumberingGuiClose hwndhBtn2, Cancel
		BN2.OnEvent("Click", ParaNumberingGuiClose)
		BN2.GetPos( , , &BW := 0)
		BN1.Move( , , BW)
		DDLStyle.GetPos(&DX := 0, , &DW := 0)
		BN2.Move(DX + DW - BW)
		RE.Gui.Opt("+Disabled")
		gParaNumberingGui.Show()
		WinWaitActive()
		WinWaitClose()
		Return Success
		; ---------------------------------------------------------------------------
		ParaNumberingGuiClose(*) {
			Success := False
			RE.Gui.Opt("-Disabled")
			gParaNumberingGui.Destroy()
		}
		; ---------------------------------------------------------------------------
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
		gParaNumberingGui.Destroy()
		}
	}
	; ---------------------------------------------------------------------------
	; @i...: ParaSpacing GUI
	; ---------------------------------------------------------------------------
	ParaSpacingGui(RE) {
		Static Owner := "",
				Success := False
		PF2 := RE.GetParaFormat()
		Owner := RE.Gui.Hwnd
		gParaSpacingGui := Gui("+Owner" . Owner . " +ToolWindow +LastFound", "Paragraph Spacing") ; +LabelParaSpacingGui
		gParaSpacingGui.OnEvent("Close", ParaSpacingGuiClose)
		gParaSpacingGui.MarginX := 20
		gParaSpacingGui.MarginY := 10
		gParaSpacingGui.AddText("Section h20 0x200", "Space before in points:")
		gParaSpacingGui.AddText("xs y+10 hp 0x200", "Space after in points:")
		EDBefore := gParaSpacingGui.AddEdit("ys hp Number Limit2 Right", "00")
		EDBefore.Text := PF2.SpaceBefore // 20
		EDAfter := gParaSpacingGui.AddEdit("xp y+10 hp Number Limit2 Right", "00")
		EDAfter.Text := PF2.SpaceAfter // 20
		BN1 := gParaSpacingGui.AddButton("xs", "Apply")
		BN1.OnEvent("Click", ParaSpacingGuiApply)
		BN2 := gParaSpacingGui.AddButton("x+10 yp", "Cancel")
		BN2.OnEvent("Click", ParaSpacingGuiClose)
		BN2.GetPos( , ,&BW := 0)
		BN1.Move( , ,BW)
		EDAfter.GetPos(&EX := 0, , &EW := 0)
		X := EX + EW - BW
		BN2.Move(X)
		RE.Gui.Opt("+Disabled")
		gParaSpacingGui.Show()
		WinWaitActive()
		WinWaitClose()
		Return Success
		; ---------------------------------------------------------------------------
		ParaSpacingGuiClose(*) {
			Success := False
			RE.Gui.Opt("-Disabled")
			gParaSpacingGui.Destroy()
		}
		; ---------------------------------------------------------------------------
		ParaSpacingGuiApply(*) {
			Before := EDBefore.Text
			After := EDAfter.Text
			Success := RE.SetParaSpacing({Before: Before, After: After})
			RE.Gui.Opt("-Disabled")
			gParaSpacingGui.Destroy()
		}
	}
	; ---------------------------------------------------------------------------
	; @i...: SetTabStops GUI
	; ---------------------------------------------------------------------------
	SetTabStopsGui(RE) {
		; Set paragraph's tabstobs
		; Call with parameter mode = "Reset" to reset to default tabs
		; EM_GETPARAFORMAT = 0x43D, EM_SETPARAFORMAT = 0x447
		; PFM_TABSTOPS = 0x10
		Static Owner   := "",
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
		For I, V In PF2.Tabs {
			Tabs[I] := [Format("{:.2f}", Round(((V & 0x00FFFFFF) * Metrics) / 1440, 2)), V & 0xFF000000]
		}
		Owner := RE.Gui.Hwnd
		gSetTabStopsGui := Gui("+Owner" . Owner . " +ToolWindow +LastFound", "Set Tabstops")
		gSetTabStopsGui.OnEvent("Close", SetTabStopsGuiClose)
		gSetTabStopsGui.MarginX := 10
		gSetTabStopsGui.MarginY := 10
		gSetTabStopsGui.AddText("Section", "Position: (" . (Metrics = 1.00 ? "in." : "cm") . ")")
		CBBTabs := gSetTabStopsGui.AddComboBox("xs y+2 w120 r6 Simple +0x800 AltSubmit")
		CBBTabs.OnEvent("Change", SetTabStopsGuiSelChanged)
		If (TabCount) {
			For T In Tabs {
				I := SendMessage(0x0143, 0, StrPtr(T[1]), CBBTabs.Hwnd)  ; @i...: CB_ADDSTRING
				SendMessage(0x0151, I, T[2], CBBTabs.Hwnd)               ;@i...: CB_SETITEMDATA
			}
		}
		gSetTabStopsGui.AddText("ys Section", "Alignment:")
		RBL := gSetTabStopsGui.AddRadio("xs w60 Section y+2 Checked Group", "Left")
		RBC := gSetTabStopsGui.AddRadio("wp", "Center")
		RBR := gSetTabStopsGui.AddRadio("ys wp", "Right")
		RBD := gSetTabStopsGui.AddRadio("wp", "Decimal")
		BNAdd := gSetTabStopsGui.AddButton("xs Section w60 Disabled", "&Add")
		BNAdd.OnEvent("Click", SetTabStopsGuiAdd)
		BNRem := gSetTabStopsGui.AddButton("ys w60 Disabled", "&Remove")
		BNRem.OnEvent("Click", SetTabStopsGuiRemove)
		BNAdd.GetPos(&X1 := 0)
		BNRem.GetPos(&X2 := 0, , &W2 := 0)
		W := X2 + W2 - X1
		BNClr := gSetTabStopsGui.AddButton("xs w" . W, "&Clear all")
		BNClr.OnEvent("Click", SetTabStopsGuiRemoveAll)
		gSetTabStopsGui.AddText("xm h5")
		BNApply := gSetTabStopsGui.AddButton("xm y+0 w60", "&Apply")
		BNApply.OnEvent("Click", SetTabStopsGuiApply)
		X := X2 + W2 - 60
		BNCancel := gSetTabStopsGui.AddButton("x" . X . " yp wp", "&Cancel")
		BNCancel.OnEvent("Click", SetTabStopsGuiClose)
		RE.Gui.Opt("+Disabled")
		gSetTabStopsGui.Show()
		WinWaitActive()
		WinWaitClose()
		Return Success
		; ---------------------------------------------------------------------------
		SetTabStopsGuiClose(*) {
			Success := False
			RE.Gui.Opt("-Disabled")
			gSetTabStopsGui.Destroy()
		}
		; ---------------------------------------------------------------------------
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
		; ---------------------------------------------------------------------------
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
		; ---------------------------------------------------------------------------
		SetTabStopsGuiRemove(*) {
			If (I := CBBTabs.Value) {
				CBBTabs.Delete(I)
				CBBTabs.Text := ""
				TabCount--
				RBL.Value := 1
			}
			CBBTabs.Focus()
		}
		; ---------------------------------------------------------------------------
		SetTabStopsGuiRemoveAll(*) {
			CBBTabs.Text := ""
			CBBTabs.Delete()
			RBL.Value := 1
			CBBTabs.Focus()
		}
		; ---------------------------------------------------------------------------
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
			gSetTabStopsGui.Destroy()
		}
	}
		; ---------------------------------------------------------------------------
		; @i...: Sets multi-line tooltips for any Gui control.
		; @i...: Parameters:
		; @i...: 	GuiCtrl: A Gui.Control object
		; @i...: 	TipText : The text for the tooltip.
		; @i...: 		If you pass an empty string for a formerly added control, its tooltip will be removed.
		; @i...: UseAhkStyle:
		; @i...: 	If set to true, the tooltips will be shown using the visual styles of AHK ToolTips.
		; @i...: 	Otherwise, the current theme settings will be used.
		; @i...: 	Default: True
		; @i...: CenterTip: If set to true, the tooltip will be shown centered below/above the control.
		; @i...: 	Default: False
		; @i...: Return values:
		; @i...: 	True on success, otherwise False.
		; @i...: Remarks:
		; @i...: 	Text and Picture controls require the SS_NOTIFY (+0x0100) style.
		; @i...: MSDN:
		; @link...: https://learn.microsoft.com/en-us/windows/win32/controls/tooltip-control-reference
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
				If !(HTT := DllCall("CreateWindowEx",
									"UInt", 0, "Str", "tooltips_class32", 
									"Ptr", 0, "UInt", 0x80000003,
									"Int", 0x80000000, "Int", 0x80000000,
									"Int", 0x80000000, "Int", 0x80000000,
									"Ptr", HGUI, "Ptr", 0,
									"Ptr", 0, "Ptr", 0, "UPtr")
								){
					Return False
				}
				If (UseAhkStyle){
					DllCall("Uxtheme.dll\SetWindowTheme", "Ptr", HTT, "Ptr", 0, "Ptr", 0)
				}
				SendMessage(0x0432, 0, TI.Ptr, HTT) ; TTM_ADDTOOLW
				Tooltips[HGUI] := {HTT: HTT, Ctrls: Map()}
			}
			HTT := Tooltips[HGUI].HTT
			HCTL := GuiCtrl.HWND
			; ---------------------------------------------------------------------------
			; @i...: Add / remove a tool for this control
			; ---------------------------------------------------------------------------
			NumPut("UPtr", HCTL, TI, 8 + A_PtrSize) ; uID
			NumPut("UPtr", HCTL, TI, 24 + (A_PtrSize * 4)) ; uID
			If !Tooltips[HGUI].Ctrls.Has(HCTL) { ; add the control
				If (TipText = ""){
					Return False
				}
				SendMessage(0x0432, 0, TI.Ptr, HTT) ; TTM_ADDTOOLW
				SendMessage(0x0418, 0, -1, HTT) ; TTM_SETMAXTIPWIDTH
				Tooltips[HGUI].Ctrls[HCTL] := True
			}
			Else If (TipText = "") { ; remove the control
				SendMessage(0x0433, 0, TI.Ptr, HTT) ; TTM_DELTOOLW
				Tooltips[HGUI].Ctrls.Delete(HCTL)
				Return True
			}
			; ---------------------------------------------------------------------------
			; @i...: Set / Update the tool's text.
			; ---------------------------------------------------------------------------
			NumPut("UPtr", StrPtr(TipText), TI, 24 + (A_PtrSize * 3))  ; lpszText
			SendMessage(0x0439, 0, TI.Ptr, HTT) ; TTM_UPDATETIPTEXTW
			Return True
		}
	}


    
	; Settings := {
	; 	GuiTitle: 'Horizon Rich Text Editor - hznRTE -- A Rich Text Editor for Horizon',
	; 	FontCharSet : 1,
	; 	FontName : 'Times New Roman',
	; 	FontSize : 11,
	; 	FontStyle : "Norm",
	; 	BackColor : "cYellow",
	; 	TextColor : "cBlack",
	; 	TextBkColor : "Auto",
	; 	WordWrap : True,
	; 	AutoURL : False,
	; 	; this.ShowWysiwyg : False, this.HasFocus : False, 
	; 	ShowWysiwyg : true,
	; 	HasFocus : true ,
	; 	Zoom : "100 %",
	; 	CurrentLine : 0,
	; 	CurrentLineCount : 0,
	; 	hMult : 5,
	; 	wMult : 2,
	; 	gHmult : 2,
	; 	div : 5,
	; 	MarginX : 10,
	; 	MarginY : 10,
	; 	EditW : (A_ScreenHeight / 2),
	; 	EditH : 1000,
	; 	; REW : w := this.EditW,
	; 	; REH : h := this.EditH,
	; 	GuiW : Round(A_ScreenWidth * (1/4)),
	; 	GuiH : Round(A_ScreenHeight * (1/4))
	; }
	; static Settings := {
		
	; 	GuiTitle: 'Horizon Rich Text Editor - hznRTE -- A Rich Text Editor for Horizon',
	; 	FontCharSet : 1,
	; 	FontName : 'Times New Roman',
	; 	FontSize : 11,
	; 	FontStyle : "Norm",
	; 	BackColor : "cYellow",
	; 	TextColor : "cBlack",
	; 	TextBkColor : "Auto",
	; 	WordWrap : True,
	; 	AutoURL : False,
	; 	; this.ShowWysiwyg : False, this.HasFocus : False, 
	; 	ShowWysiwyg : true,
	; 	HasFocus : true ,
	; 	Zoom : "100 %",
	; 	CurrentLine : 0,
	; 	CurrentLineCount : 0,
	; 	hMult : 5,
	; 	wMult : 2,
	; 	gHmult : 2,
	; 	div : 5,
	; 	MarginX : 10,
	; 	MarginY : 10,
	; 	EditW : (A_ScreenHeight / 2),
	; 	EditH : 1000,
	; 	; REW : w := this.EditW,
	; 	; REH : h := this.EditH,
	; 	GuiW : Round(A_ScreenWidth * (1/4)),
	; 	GuiH : Round(A_ScreenHeight * (1/4))
	; }
	
	; Focus() => This.RE.Focus()
	; GetPos(&X?, &Y?, &W?, &H?) => This.RE.GetPos(&X?, &Y?, &W?, &H?)
	; Move(X?, Y?, W?, H?) => This.RE.Move(X?, Y?, W?, H?)
	; OnCommand(Code, Callback, AddRemove?) => This.RE.OnCommand(Code, Callback, AddRemove?)
	; OnNotify(Code, Callback, AddRemove?) => This.RE.OnNotify(Code, Callback, AddRemove?)
	; Opt(Options) => This.RE.Opt(Options)
	; Redraw() => This.RE.Redraw()
	; ---------------------------------------------------------------------------
	; @Section ...:			Create a New Gui
	; @i ...:	When a new instance of the RTEdit Class is called, a new Gui is made
	; ---------------------------------------------------------------------------
	; __New() {
	; 	; defaultFont(this.MainGui)
	; 	this.Make_Buttons()
	; 	this.Make_Menus()
	; 	GuiNum := 1
	; 	Options := (
	; 			' +Resize'
	; 			' +Border'
	; 			' +DPIScale'
	; 			' +Caption'
	; 			)
	; 	this.MainGui := Gui(Options , RTEdit.Settings.GuiTitle)
	; 	this.MainGui.OnEvent("Size", this.MainGuiSize)
	; 	this.MainGui.OnEvent("Close", this.MainGuiClose)
	; 	this.MainGui.OnEvent("ContextMenu", this.RE_MainContextMenu)
	; 	this.MainGui.MenuBar := this.MainMenuBar
	; 	this.MainGui.MarginX := RTEdit.Settings.MarginX
	; 	this.MainGui.MarginY := RTEdit.Settings.MarginY

	; 	;! ---------------------------------------------------------------------------
	; 	; @Section ...: 	RichEdit #1 (RE1) - Gui Toolbar
	; 	; @f ...: 			RE1_Gui_ToolBar()
	; 	; @p ...: 			this.RE1
	; 	;! ---------------------------------------------------------------------------
	; 	defaultFont(this.MainGui)
			
	; 	this.MainT1 := this.MainGui.AddText("x+10 yp hp", "WWWWWWWW")
	; 	this.MainT1.GetPos(&TX := 0, &TY := 0, &TW := 0, &TH := 0)
	; 	TX := (RTEdit.Settings.EditW - TW) - (RTEdit.Settings.MarginX * 5.75)
	; 	this.MainT1.Move(TX)
	; 	; ---------------------------------------------------------------------------
	; 	Options := (
	; 				' x' TX ' y' TY ' w' TW ' h' TH
	; 				' Redraw'
	; 			)
	; 	this.RE1 := RichEdit(this.MainGui, Options, False)
	; 	; RE1 := this.RE1
	; 	defaultFont(this.RE1)
	; 	; ---------------------------------------------------------------------------
	; 	If !IsObject(this.RE1) {
	; 		Throw("Could not create the RE1 RichEdit control!", -1)
	; 	}
	; 	this.RE1.ReplaceSel("AaBbYyZz")
	; 	this.RE1.AlignText("CENTER")
	; 	this.RE1.SetOptions(["READONLY"], "SET")
	; 	this.RE1.SetParaSpacing({Before: 2})
	; 	; ---------------------------------------------------------------------------
	; 	; @i ...:	Set buttons
	; 	; ---------------------------------------------------------------------------
	; 	defaultFont(this.RE1)
	; 	this.bAlign_Left()
	; 	this.bAlign_Center()
	; 	this.bAlign_Right()
	; 	this.bAlign_Justified()
	; 	this.bLineSpacing_Single()
	; 	this.bLineSpacing_OnePtFive()
	; 	this.bLineSpacing_Double()
	; 	this.bSave()	
	; 	;! --------------------------------------------------------------------------------
	; 	; @Section ...:					RichEdit #2
	; 	; @i ...:					  Rich Text Editor
	; 	;! --------------------------------------------------------------------------------
	; 	Options := ''
	; 	this.MainFNAME.Text := RTEdit.Settings.FontName
	; 	this.MainFSIZE.Text := RTEdit.Settings.FontSize
	; 	static EN_SELCHANGE := 1794 ; 0x0702
	; 	static EN_LINK := 1803 ; 0x070B
	; 	; MainGui.SetFont('s11 Q5', FontName)
	; 	this.MainGui.SetFont('s' RTEdit.Settings.FontSize ' Q5', RTEdit.Settings.FontName)
	; 	; Options := "xm y+5 w" . EditW . " r20"
	; 	; Options := "xm y+5 w" (EditW-MarginX) ' h' (EditH-MarginY)
	; 	Options := (
	; 			" xm"
	; 			" y+5"
	; 			" w" RTEdit.Settings.EditW
	; 			' h' RTEdit.Settings.EditH
	; 			' Redraw'
	; 	)
	; 	If !IsObject(this.RE2 := RichEdit(this.MainGui, Options)){
	; 		Throw("Could not create the RE2 RichEdit control!", -1)
	; 	}
	; 	this.RE2.SetFont(RTEdit.Settings.FontSize ' ' RTEdit.Settings.FontName)
	; 	this.RE2.SetOptions(["SELECTIONBAR"])
	; 	this.RE2.AutoURL(True)
	; 	this.RE2.SetEventMask(["SELCHANGE", "LINK"])
	; 	this.RE2.OnNotify(EN_SELCHANGE, this.RE2_SelChange)
	; 	this.RE2.OnNotify(EN_LINK, this.RE2_Link)
	; 	; DPI.ControlGetPos(,,&REW, &REH, this.RE2)
	; 	this.RE2.GetPos( , , &REW, &REH)
	; 	defaultFont(this.MainGui)
	; 	; ---------------------------------------------------------------------------
	; 	;? The rest
	; 	; ---------------------------------------------------------------------------
	; 	this.MainSB := this.MainGui.AddStatusbar()
	; 	this.MainSB.SetParts(10, 200)
	; 	this.MainGui.Show()
	; 	this.RE2.Focus()
	; 	this.RE_SetHotkeys()
	; 	this.RE2.WordWrap(True)
	; 	this.UpdateGui()
	; 	this.MainGui.Show()
	; 	this.MainGui.Show()
	; 	; ---------------------------------------------------------------------------
	; 	; @i ...: 	Default Font
	; 	; ---------------------------------------------------------------------------
	; 	; defaultFont(GuiObj){
	; 	; 	GuiObj.SetFont("Norm")
	; 	; 	return GuiObj.SetFont('s' RTEdit.Settings.FontSize ' Q5', RTEdit.Settings.FontName)
	; 	; }
	; 	static defaultFont(GuiObj){
	; 		GuiObj.SetFont("Norm")
	; 		return GuiObj.SetFont('s' RTEdit.Settings.FontSize ' Q5', RTEdit.Settings.FontName)
	; 	}
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...: Make Menus
	; ; ---------------------------------------------------------------------------
	; Make_Menus(){
	; 	this.RE_FileMenu()
	; 	this.RE_EditMenu()
	; 	this.RE_SearchMenu()
	; 	this.RE_AlignMenu()
	; 	this.RE_IndentMenu()
	; 	this.RE_LineSpacingMenu()
	; 	this.RE_NumberingMenu()
	; 	this.RE_TabstopsMenu()
	; 	this.RE_ParaSpacingMenu()
	; 	this.RE_ParagraphMenu()
	; 	this.RE_TxColorMenu()
	; 	this.RE_BkColorMenu()
	; 	this.RE_CharacterMenu()
	; 	this.RE_FormatMenu()
	; 	this.RE_BackgroundMenu()
	; 	this.RE_ZoomMenu()
	; 	this.RE_ViewMenu()
	; 	this.RE_ContextMenu()
	; 	this.RE_MainMenuBar()
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...: Make Buttons
	; ; ---------------------------------------------------------------------------
	; Make_Buttons(){
	; 	; ---------------------------------------------------------------------------
	; 	this.bBold()
	; 	this.bItalic()
	; 	this.bUnderline()
	; 	this.bStrikeout()
	; 	; ---------------------------------------------------------------------------
	; 	this.bSuperscript()
	; 	this.bSubscript()
	; 	; ---------------------------------------------------------------------------
	; 	this.bNormal()
	; 	this.bTextColor()
	; 	this.bTextBkColor()
	; 	; ---------------------------------------------------------------------------
	; 	this.bChooseFont()
	; 	this.bFontSize_Increase()
	; 	this.bFontSize_Decrease()
	; 	; ---------------------------------------------------------------------------
	; }
	; ;! ---------------------------------------------------------------------------
	; ; @Section ...:					Main Gui
	; ;! ---------------------------------------------------------------------------

	; ; RE_MainGui(){
	; ; 	GuiNum := 1
	; ; 	Options := (
	; ; 			' +Resize'
	; ; 			' +Border'
	; ; 			' +DPIScale'
	; ; 			' +Caption'
	; ; 			)
	; ; 	this.MainGui := Gui(Options , this.Settings.GuiTitle)
	; ; 	this.MainGui.OnEvent("Size", this.MainGuiSize)
	; ; 	this.MainGui.OnEvent("Close", this.MainGuiClose)
	; ; 	this.MainGui.OnEvent("ContextMenu", this.RE_MainContextMenu)
	; ; 	this.MainGui.MenuBar := this.MainMenuBar
	; ; 	this.MainGui.MarginX := this.Settings.MarginX
	; ; 	this.MainGui.MarginY := this.Settings.MarginY
	; ; 	this.Make_Buttons()
	; 	; defaultFont()
	; 	; ; ---------------------------------------------------------------------------
	; 	; this.bBold()
	; 	; this.bItalic()
	; 	; this.bUnderline()
	; 	; this.bStrikeout()
	; 	; ; ---------------------------------------------------------------------------
	; 	; this.bSuperscript()
	; 	; this.bSubscript()
	; 	; ; ---------------------------------------------------------------------------
	; 	; this.bNormal()
	; 	; this.bTextColor()
	; 	; this.bTextBkColor()
	; 	; ; ---------------------------------------------------------------------------
	; 	; this.bChooseFont()
	; 	; this.bFontSize_Increase()
	; 	; this.bFontSize_Decrease()
	; 	; ; ---------------------------------------------------------------------------
	; 	; defaultFont()
	; 	; ---------------------------------------------------------------------------
	; 	; this.RE1_Gui_ToolBar() ; RE_1()
	; 	; ---------------------------------------------------------------------------
	; 	; this.RE2_RichEditor() ; RE_2()
	; 	; ---------------------------------------------------------------------------
	; 	; return this.MainGui
	; ; }
	; ;! ---------------------------------------------------------------------------
	; ; @Section ...: 	RichEdit #1 (RE1) - Gui Toolbar
	; ; @f ...: 			RE1_Gui_ToolBar()
	; ; @p ...: 			this.RE1
	; ;! ---------------------------------------------------------------------------
	; ; RE1_Gui_ToolBar(){	; RE_1(){
	; ; 	; global this.RE1
	; ; 	defaultFont()
		
	; ; 	this.MainT1 := this.MainGui.AddText("x+10 yp hp", "WWWWWWWW")
	; ; 	this.MainT1.GetPos(&TX := 0, &TY := 0, &TW := 0, &TH := 0)
	; ; 	TX := (this.Settings.EditW - TW) - (this.Settings.MarginX * 5.75)
	; ; 	this.MainT1.Move(TX)
	; ; 	; ---------------------------------------------------------------------------
	; ; 	Options := (
	; ; 				' x' TX ' y' TY ' w' TW ' h' TH
	; ; 				' Redraw'
	; ; 			)
	; ; 	this.RE1 := RichEdit(this.MainGui, Options, False)
	; ; 	; RE1 := this.RE1
	; ; 	defaultFont()
	; ; 	; ---------------------------------------------------------------------------
	; ; 	If !IsObject(this.RE1) {
	; ; 		Throw("Could not create the RE1 RichEdit control!", -1)
	; ; 	}
	; ; 	this.RE1.ReplaceSel("AaBbYyZz")
	; ; 	this.RE1.AlignText("CENTER")
	; ; 	this.RE1.SetOptions(["READONLY"], "SET")
	; ; 	this.RE1.SetParaSpacing({Before: 2})
	; ; 	; ---------------------------------------------------------------------------
	; ; 	; @i ...:	Set buttons
	; ; 	; ---------------------------------------------------------------------------
	; ; 	defaultFont()
	; ; 	this.bAlign_Left()
	; ; 	this.bAlign_Center()
	; ; 	this.bAlign_Right()
	; ; 	this.bAlign_Justified()
	; ; 	this.bLineSpacing_Single()
	; ; 	this.bLineSpacing_OnePtFive()
	; ; 	this.bLineSpacing_Double()
	; ; 	this.bSave()
	; ; 	; this.RE1 := RE1
	; ; 	; return RE1
	; ; }

	; ;! --------------------------------------------------------------------------------
	; ; @Section ...:					RichEdit #2
	; ; @i ...:					  Rich Text Editor
	; ;! --------------------------------------------------------------------------------
	; ; RE_2(){
	; ; static RE2() => () => this.RE2_RichEditor()
	; ; RE2_RichEditor(){
		
	; ; 	; Global RE2, MainSB, FontName, FontSize
	; ; 	Options := ''
	; ; 	this.MainFNAME.Text := this.Settings.FontName
	; ; 	this.MainFSIZE.Text := this.Settings.FontSize
	; ; 	static EN_SELCHANGE := 1794 ; 0x0702
	; ; 	static EN_LINK := 1803 ; 0x070B
	; ; 	; MainGui.SetFont('s11 Q5', FontName)
	; ; 	this.MainGui.SetFont('s' this.Settings.FontSize ' Q5', this.Settings.FontName)
	; ; 	; Options := "xm y+5 w" . EditW . " r20"
	; ; 	; Options := "xm y+5 w" (EditW-MarginX) ' h' (EditH-MarginY)
	; ; 	Options := (
	; ; 			" xm"
	; ; 			" y+5"
	; ; 			" w" this.Settings.EditW
	; ; 			' h' this.Settings.EditH
	; ; 			' Redraw'
	; ; 	)
	; ; 	If !IsObject(this.RE2 := RichEdit(this.MainGui, Options)){
	; ; 		Throw("Could not create the RE2 RichEdit control!", -1)
	; ; 	}
	; ; 	this.RE2.SetFont(this.Settings.FontSize ' ' this.Settings.FontName)
	; ; 	this.RE2.SetOptions(["SELECTIONBAR"])
	; ; 	this.RE2.AutoURL(True)
	; ; 	this.RE2.SetEventMask(["SELCHANGE", "LINK"])
	; ; 	this.RE2.OnNotify(EN_SELCHANGE, this.RE2_SelChange)
	; ; 	this.RE2.OnNotify(EN_LINK, this.RE2_Link)
	; ; 	; DPI.ControlGetPos(,,&REW, &REH, this.RE2)
	; ; 	this.RE2.GetPos( , , &REW, &REH)
	; ; 	this.defaultFont(this.MainGui)
	; ; 	; ---------------------------------------------------------------------------
	; ; 	;? The rest
	; ; 	; ---------------------------------------------------------------------------
	; ; 	this.MainSB := this.MainGui.AddStatusbar()
	; ; 	this.MainSB.SetParts(10, 200)
	; ; 	this.MainGui.Show()
	; ; 	this.RE2.Focus()
	; ; 	this.RE_SetHotkeys()
	; ; 	this.RE2.WordWrap(True)
	; ; 	this.UpdateGui()
	; ; 	this.MainGui.Show()
	; ; 	this.MainGui.Show()

	; ; 	; this.RE2 := RE2

	; ; 	; Return RE2.Hwnd
	; ; }
	; ; ---------------------------------------------------------------------------
	; static Focus() => RTEdit.Focus()
	; static GetPos(&X?, &Y?, &W?, &H?) => RTEdit.GetPos(&X?, &Y?, &W?, &H?)
	; static Move(X?, Y?, W?, H?) => RTEdit.Move(X?, Y?, W?, H?)
	; static OnCommand(Code, Callback, AddRemove?) => RTEdit.OnCommand(Code, Callback, AddRemove?)
	; static OnNotify(Code, Callback, AddRemove?) => RTEdit.OnNotify(Code, Callback, AddRemove?)
	; static Opt(Options) => RTEdit.Opt(Options)
	; static Redraw() => RTEdit.Redraw()
	
	; ; ---------------------------------------------------------------------------
	; ; @Section ...: 					Menus
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	FileMenu
	; ; ---------------------------------------------------------------------------
	; RE_FileMenu(){
	; 	FileMenu := Menu()
	; 	FileMenu.Add("&Open", 			this.FileLoadFN.Bind("Open"))
	; 	FileMenu.Add("&Append", 		this.FileLoadFN.Bind("Append"))
	; 	FileMenu.Add("&Insert", 		this.FileLoadFN.Bind("Insert"))
	; 	FileMenu.Add("&Close", 			this.FileCloseFN)
	; 	FileMenu.Add("&Save", 			this.FileSaveFN)
	; 	FileMenu.Add("Save &as", 		this.FileSaveAsFN)
	; 	FileMenu.Add()
	; 	FileMenu.Add("Page &Margins", 	this.PageSetupFN)
	; 	FileMenu.Add("&Print", 			this.PrintFN)
	; 	FileMenu.Add()
	; 	FileMenu.Add("&Exit", 			this.MainGuiClose)
	; 	this.FileMenu := FileMenu
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	EditMenu
	; ; ---------------------------------------------------------------------------
	; RE_EditMenu() {
	; 	EditMenu := Menu()
	; 	EditMenu.Add("&Undo`tCtrl+Z", 		 this.UndoFN)
	; 	EditMenu.Add("&Redo`tCtrl+Y", 		 this.RedoFN)
	; 	EditMenu.Add()
	; 	EditMenu.Add("C&ut`tCtrl+X", 		 this.CutFN)
	; 	EditMenu.Add("&Copy`tCtrl+C", 		 this.CopyFN)
	; 	EditMenu.Add("&Paste`tCtrl+V", 		 this.PasteFN)
	; 	EditMenu.Add("C&lear`tDel", 		 this.ClearFN)
	; 	EditMenu.Add()
	; 	EditMenu.Add("Select &all `tCtrl+A", this.SelAllFN)
	; 	EditMenu.Add("&Deselect all", 		 this.DeselectFN)
	; 	this.EditMenu := EditMenu
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	SearchMenu
	; ; ---------------------------------------------------------------------------
	; RE_SearchMenu(){
	; 	SearchMenu := Menu()
	; 	SearchMenu.Add("&Find", 	this.FindFN)
	; 	SearchMenu.Add("&Replace",  this.ReplaceFN)
	; 	this.SearchMenu := SearchMenu
	; }
	; ; ---------------------------------------------------------------------------
	; ; @Section ...: 					FormatMenu
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	Paragraph
	; ; ---------------------------------------------------------------------------
	; RE_AlignMenu(){
	; 	AlignMenu := Menu()
	; 	AlignMenu.Add("Align &left`tCtrl+L", 	this.AlignFN.Bind("Left"))
	; 	AlignMenu.Add("Align &center`tCtrl+E",  this.AlignFN.Bind("Center"))
	; 	AlignMenu.Add("Align &right`tCtrl+R",   this.AlignFN.Bind("Right"))
	; 	AlignMenu.Add("Align &justified", 		this.AlignFN.Bind("Justify"))
	; 	this.AlignMenu := AlignMenu
	; }
	; ; ---------------------------------------------------------------------------
	; RE_IndentMenu(){
	; 	IndentMenu := Menu()
	; 	IndentMenu.Add("&Set", 	 this.IndentationFN.Bind("Set"))
	; 	IndentMenu.Add("&Reset", this.IndentationFN.Bind("Reset"))
	; 	this.IndentMenu := IndentMenu
	; }
	; ; ---------------------------------------------------------------------------
	; RE_LineSpacingMenu(){
	; 	LineSpacingMenu := Menu()
	; 	LineSpacingMenu.Add("1 line`tCtrl+1", 	 this.SpacingFN.Bind(1.0))
	; 	LineSpacingMenu.Add("1.5 lines`tCtrl+5", this.SpacingFN.Bind(1.5))
	; 	LineSpacingMenu.Add("2 lines`tCtrl+2", 	 this.SpacingFN.Bind(2.0))
	; 	this.LineSpacingMenu := LineSpacingMenu
	; }
	; ; ---------------------------------------------------------------------------
	; RE_NumberingMenu(){
	; 	NumberingMenu := Menu()
	; 	NumberingMenu.Add("&Set", 	this.NumberingFN.Bind("Set"))
	; 	NumberingMenu.Add("&Reset", this.NumberingFN.Bind("Reset"))
	; 	this.NumberingMenu := NumberingMenu
	; }
	; ; ---------------------------------------------------------------------------
	; RE_TabstopsMenu() {
	; 	TabstopsMenu := Menu()
	; 	TabstopsMenu.Add("&Set Tabstops", 	  this.SetTabstopsFN.Bind("Set"))
	; 	TabstopsMenu.Add("&Reset to Default", this.SetTabstopsFN.Bind("Reset"))
	; 	TabstopsMenu.Add()
	; 	TabstopsMenu.Add("Set &Default Tabs", this.SetTabstopsFN.Bind("Default"))
	; 	this.TabstopsMenu := TabstopsMenu
	; }
	; ; ---------------------------------------------------------------------------
	; RE_ParaSpacingMenu(){
	; 	ParaSpacingMenu := Menu()
	; 	ParaSpacingMenu.Add("&Set",   this.ParaSpacingFN.Bind("Set"))
	; 	ParaSpacingMenu.Add("&Reset", this.ParaSpacingFN.Bind("Reset"))
	; 	this.ParaSpacingMenu := ParaSpacingMenu
	; }
	; ; ---------------------------------------------------------------------------
	; RE_ParagraphMenu() {
	; 	ParagraphMenu := Menu()
	; 	ParagraphMenu.Add("&Alignment",   this.RE_AlignMenu)
	; 	ParagraphMenu.Add("&Indentation", this.RE_IndentMenu)
	; 	ParagraphMenu.Add("&Numbering",   this.RE_NumberingMenu)
	; 	ParagraphMenu.Add("&Linespacing", this.RE_LineSpacingMenu)
	; 	ParagraphMenu.Add("&Space before/after", this.RE_ParaSpacingMenu)
	; 	ParagraphMenu.Add("&Tabstops", 	 this.RE_TabstopsMenu)
	; 	this.ParagraphMenu := ParagraphMenu
	; }
	; ; ---------------------------------------------------------------------------
	; ; @Section ...: 					Character
	; ; ---------------------------------------------------------------------------
	; RE_TxColorMenu() {
	; 	TxColorMenu := Menu()
	; 	TxColorMenu.Add("&Choose", this.TextColorFN.Bind("Choose"))
	; 	TxColorMenu.Add("&Auto",   this.TextColorFN.Bind("Auto"))
	; 	this.TxColorMenu := TxColorMenu
	; }
	; ; ---------------------------------------------------------------------------
	; RE_BkColorMenu(){
	; 	BkColorMenu := Menu()
	; 	BkColorMenu.Add("&Choose", this.TextBkColorFN.Bind("Choose"))
	; 	BkColorMenu.Add("&Auto",   this.TextBkColorFN.Bind("Auto"))
	; 	this.BkColorMenu := BkColorMenu
	; }
	; ; ---------------------------------------------------------------------------
	; RE_CharacterMenu(){
	; 	CharacterMenu := Menu()
	; 	CharacterMenu.Add("&Font", this.ChooseFontFN)
	; 	CharacterMenu.Add("&Text color", this.TxColorMenu)
	; 	CharacterMenu.Add("Text &Backcolor", this.BkColorMenu)
	; 	this.CharacterMenu := CharacterMenu
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	Format
	; ; ---------------------------------------------------------------------------
	; RE_FormatMenu(){
	; 	FormatMenu := Menu()
	; 	FormatMenu.Add("&Character", this.CharacterMenu)
	; 	FormatMenu.Add("&Paragraph", this.ParagraphMenu)
	; 	this.FormatMenu := FormatMenu
	; }
	; ; ---------------------------------------------------------------------------
	; ; @Section ...: 					ViewMenu
	; ; ---------------------------------------------------------------------------
	; ; @i ...: Background
	; ; ---------------------------------------------------------------------------
	; RE_BackgroundMenu() {
	; 	BackgroundMenu := Menu()
	; 	BackgroundMenu.Add("&Choose", this.BackGroundColorFN.Bind("Choose"))
	; 	BackgroundMenu.Add("&Auto", this.BackgroundColorFN.Bind("Auto"))
	; 	this.BackgroundMenu := BackgroundMenu
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...: Zoom
	; ; ---------------------------------------------------------------------------
	; RE_ZoomMenu() {
	; 	ZoomMenu := Menu()
	; 	ZoomMenu.Add("200 %", this.ZoomFN.Bind(200))
	; 	ZoomMenu.Add("150 %", this.ZoomFN.Bind(150))
	; 	ZoomMenu.Add("125 %", this.ZoomFN.Bind(125))
	; 	ZoomMenu.Add("100 %", this.Zoom100FN)
	; 	ZoomMenu.Check("100 %")
	; 	ZoomMenu.Add("75 %", this.ZoomFN.Bind(75))
	; 	ZoomMenu.Add("50 %", this.ZoomFN.Bind(50))
	; 	this.ZoomMenu := ZoomMenu
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...: 	View
	; ; ---------------------------------------------------------------------------
	; RE_ViewMenu() {
	; 	; Global ViewMenu, MenuWordWrap, MenuWysiwyg
	; 	ViewMenu := Menu()
	; 	MenuWordWrap := "&Word-wrap"
	; 	ViewMenu.Add(MenuWordWrap, this.WordWrapFN)
	; 	MenuWysiwyg := "Wrap as &printed"
	; 	ViewMenu.Add(MenuWysiwyg, this.WysiWygFN)
	; 	ViewMenu.Add("&Zoom", this.RE_ZoomMenu)
	; 	ViewMenu.Add()
	; 	ViewMenu.Add("&Background Color", this.RE_BackgroundMenu)
	; 	; ViewMenu.Add("&URL Detection", this.AutoURLDetectionFN)
	; 	this.ViewMenu := ViewMenu
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...: 	ContextMenu
	; ; ---------------------------------------------------------------------------
	; RE_ContextMenu(){
	; 	ContextMenu := Menu()
	; 	ContextMenu.Add("&File", this.RE_FileMenu)
	; 	ContextMenu.Add("&Edit", this.RE_EditMenu)
	; 	ContextMenu.Add("&Search", this.RE_SearchMenu)
	; 	ContextMenu.Add("F&ormat", this.RE_FormatMenu)
	; 	ContextMenu.Add("&View", this.ViewMenu)
	; 	this.ContextMenu := ContextMenu
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...: 	MainMenuBar
	; ; ---------------------------------------------------------------------------
	; RE_MainMenuBar(){
	; 	MainMenuBar := MenuBar()
	; 	MainMenuBar.Add("&File", 	this.RE_FileMenu)
	; 	MainMenuBar.Add("&Edit", 	this.RE_EditMenu)
	; 	MainMenuBar.Add("&Search",  this.RE_SearchMenu)
	; 	MainMenuBar.Add("F&ormat", 	this.RE_FormatMenu)
	; 	MainMenuBar.Add("&View", 	this.RE_ViewMenu)
	; 	this.MainMenuBar := MainMenuBar
	; }

	; ; ---------------------------------------------------------------------------
	; ; @Section ...: 					Style Buttons
	; ; ---------------------------------------------------------------------------
	; ; @i ...: 	Bold
	; ; ---------------------------------------------------------------------------
    ; this.MainGui.SetFont("Norm Bold", RTEdit.Settings.FontName)
    ; ; this.MainGui.SetFont("Bold", FontName)
    ; MainBNSB := this.MainGui.AddButton("xm y3 w20 h20", "&B")
    ; MainBNSB.OnEvent("Click", this.SetFontStyleFN.Bind("B"))
    ; GuiCtrlSetTip(MainBNSB, "Bold (Ctl+B)")
    ; ; RTEdit.defaultFont()
    ; ; this.MainBNSB := MainBNSB
	; bBold(){
	; }	
	; ; ---------------------------------------------------------------------------
	; ; @i ...: 	Italic
	; ; ---------------------------------------------------------------------------
	; bItalic(){
	; 	this.MainGui.SetFont("Norm Italic")
	; 	; this.MainGui.SetFont("Italic")
	; 	MainBNSI := this.MainGui.AddButton("x+0 yp wp hp", "&I")
	; 	MainBNSI.OnEvent("Click", this.SetFontStyleFN.Bind("I"))
	; 	this.GuiCtrlSetTip(MainBNSI, "Italic (Ctl+I)")
	; 	this.defaultFont(this.MainGui)
	; 	this.MainBNSI := MainBNSI
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...: 	Underline
	; ; ---------------------------------------------------------------------------
	; bUnderline(){
	; 	this.MainGui.SetFont("Norm Underline")
	; 	; this.MainGui.SetFont("Underline")
	; 	MainBNSU := this.MainGui.AddButton("x+0 yp wp hp", "&U")
	; 	MainBNSU.OnEvent("Click", this.SetFontStyleFN.Bind("U"))
	; 	this.GuiCtrlSetTip(MainBNSU, "Underline (Ctl+U)")
	; 	this.defaultFont(this.MainGui)
	; 	this.MainBNSU := MainBNSU
	; }	
	; ; ---------------------------------------------------------------------------
	; ; @i ...: 	Strikeout
	; ; ---------------------------------------------------------------------------
	; bStrikeout(){
	; 	this.MainGui.SetFont("Norm Strike")
	; 	; this.MainGui.SetFont("Strike")
	; 	MainBNSS := this.MainGui.AddButton("x+0 yp wp hp", "&S")
	; 	MainBNSS.OnEvent("Click", this.SetFontStyleFN.Bind("S"))
	; 	this.GuiCtrlSetTip(MainBNSS, "Strikeout (Alt+S)")
	; 	this.defaultFont(this.MainGui)
	; 	this.MainBNSS := MainBNSS
	; }	
	; ; ---------------------------------------------------------------------------
	; ; @i ...: 	Superscript
	; ; ---------------------------------------------------------------------------
	; bSuperscript(){
	; 	this.MainGui.SetFont("Norm s" this.Settings.FontSize, this.Settings.FontName)
	; 	MainBNSH := this.MainGui.AddButton("x+0 yp wp hp", "¯")
	; 	MainBNSH.OnEvent("Click", this.SetFontStyleFN.Bind("H"))
	; 	this.GuiCtrlSetTip(MainBNSH, "Superscript (Ctrl+Shift+'+')")
	; 	this.defaultFont(this.MainGui)
	; 	this.MainBNSH := MainBNSH
	; }	
	; ; ---------------------------------------------------------------------------
	; ; @i ...: 	Subscript
	; ; ---------------------------------------------------------------------------
	; bSubscript(){

	; 	MainBNSL := this.MainGui.AddButton("x+0 yp wp hp", "_")
	; 	MainBNSL.OnEvent("Click", this.SetFontStyleFN.Bind("L"))
	; 	this.GuiCtrlSetTip(MainBNSL, "Subscript (Ctrl+'+')")
	; 	this.defaultFont(this.MainGui)
	; 	this.MainBNSL := MainBNSL
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...: 	Normal
	; ; ---------------------------------------------------------------------------
	; bNormal(){
	; 	MainBNSN := this.MainGui.AddButton("x+0 yp wp hp", "&N")
	; 	MainBNSN.OnEvent("Click", this.SetFontStyleFN.Bind("N"))
	; 	this.GuiCtrlSetTip(MainBNSN, "Normal (Alt+N)")
	; 	this.defaultFont(this.MainGui)
	; 	this.MainBNSN := MainBNSN
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...: 	Text Color
	; ; ---------------------------------------------------------------------------
	; bTextColor(){
	; 	MainBNTC := this.MainGui.SetFont('s10')
	; 	MainBNTC := this.MainGui.AddButton("x+10 yp wp+70 hp", "&Text Color")
	; 	MainBNTC.OnEvent("Click", this.TextColorFN.Bind("Choose"))
	; 	this.GuiCtrlSetTip(MainBNTC, "Text color (Alt+T)")
	; 	; MainBNTC := this.MainGui.SetFont('s' FontSize, FontName)
	; 	this.defaultFont(this.MainGui)
	; 	this.MainBNTC := MainBNTC
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...: 	Text Back Color
	; ; ---------------------------------------------------------------------------
	; bTextBkColor(){
	; 	MainColors 	:= this.MainGui.AddProgress("x+0 yp wp hp BackgroundYellow cNavy Border", 50)
	; 	MainBNBC 	:= this.MainGui.SetFont('s10')
	; 	MainBNBC 	:= this.MainGui.AddButton("x+0 yp wp hp", "Txt Bkg Color")
	; 	; 
	; 	if (WinActive() = 'ahk_exe hznHorizon.exe'){
	; 		MainBNBC.OnEvent("Click", this.MainGuiSize)
	; 	} else {
	; 		MainBNBC.OnEvent("Click", this.TextBkColorFN.Bind("Choose"))
	; 	}
	; 	this.GuiCtrlSetTip(MainBNBC, "Text backcolor")
	; 	this.defaultFont(this.MainGui)
	; 	this.MainBNBC := MainBNBC
	; }	
	; ; ---------------------------------------------------------------------------
	; ; @i ...: 	Choose Font
	; ; ---------------------------------------------------------------------------
	; bChooseFont(){
	; 	; MainFNAME := this.MainGui.AddEdit("x+10 yp w150 hp ", FontName)
	; 	this.MainFNAME := this.MainGui.AddEdit("x+10 yp w150 hp +ReadOnly", this.Settings.FontName)
	; 	; MainFNAME := this.MainGui.AddText("x+10 yp w150 hp Center", FontName)
	; 	MainBNCF := this.MainGui.AddButton("x+0 yp w20 hp", "...")
	; 	MainBNCF.OnEvent("Click", this.ChooseFontFN)
	; 	this.GuiCtrlSetTip(MainBNCF, "Choose Font")
	; 	this.defaultFont(this.MainGui)
	; 	this.MainBNCF := MainBNCF
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...: 	Font Size - Increase
	; ; ---------------------------------------------------------------------------
	; bFontSize_Increase(){
	; 	MainBNFP := this.MainGui.AddButton("x+5 yp wp hp", "&+")
	; 	MainBNFP.OnEvent("Click", this.ChangeSize.Bind(1))
	; 	this.GuiCtrlSetTip(MainBNFP, "Increase size (Alt+'+')")
	; 	this.defaultFont(this.MainGui)
	; 	this.MainBNFP := MainBNFP
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...: 	Font Size - Decrease
	; ; ---------------------------------------------------------------------------
	; bFontSize_Decrease(){
	; 	; MainFSIZE := this.MainGui.AddEdit("x+0 yp w30 hp", FontSize)
	; 	this.MainFSIZE := this.MainGui.AddEdit("x+0 yp w30 hp +ReadOnly", this.Settings.FontSize)
	; 	; MainFSIZE := this.MainGui.AddText("x+0 yp w30 hp Center", FontSize)
	; 	this.MainFSIZE.SetFont('s' this.Settings.FontSize, this.Settings.FontName)
	; 	MainBNFM := this.MainGui.AddButton("x+5 yp wp hp", "&-")
	; 	MainBNFM.OnEvent("Click", this.ChangeSize.Bind(-1))
	; 	this.GuiCtrlSetTip(MainBNFM, "Decrease size (Alt+'-')")
	; 	this.MainBNFM := MainBNFM
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...: 	Save
	; ; ---------------------------------------------------------------------------
	; bSave(){
	; 	local x := (this.Settings.EditW / 2) - (this.Settings.MarginX * 5)
	; 	MainBNSV := this.MainGui.AddButton('x' x ' yp wp+30 hp Center', '&Save')
	; 	this.defaultFont(this.MainGui)
	; 	this.MainBNSV := MainBNSV
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...: 	Send To Horizon
	; ; @i ...: 	!!!EXPERIMENTAL!!!
	; ; ---------------------------------------------------------------------------
	; SendToHzn(){
	; 	try WinA := WinActive('ahk_exe hznHorizon')
	; 	if WinA = true {
	; 		try hCtl := receiver.rMap['hCtl']
	; 		Infos(hCtl ' I exist')
	; 		try nCtl := receiver.nect['nCtl']
	; 	}
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...: 	Default Font
	; ; ---------------------------------------------------------------------------
	; ; defaultFont(){
	; ; 	this.MainGui.SetFont("Norm")
	; ; 	this.MainGui.SetFont('s' this.Settings.FontSize ' Q5', this.Settings.FontName)
	; ; }
	; ; ---------------------------------------------------------------------------
	; ; @Section ...:						Alignment
	; ; ---------------------------------------------------------------------------
	; ; @i ...: 	Align - Left
	; ; ---------------------------------------------------------------------------
	; bAlign_Left(){
	; 	this.MainGui.AddText("+Wrap 0x1000 xm y+2 h2 w" this.Settings.EditW)
	; 	MainBNAL := this.MainGui.AddButton("x10 y+1 w30 h20",  "|<")
	; 	MainBNAL.OnEvent("Click", this.AlignFN.Bind("Left"))
	; 	this.GuiCtrlSetTip(MainBNAL, "Align left (Ctrl+L)")
	; 	this.defaultFont(this.MainGui)
	; 	this.MainBNAL := MainBNAL
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...: 	Align - Center
	; ; ---------------------------------------------------------------------------
	; bAlign_Center(){
	; 	MainBNAC := this.MainGui.AddButton("x+0 yp wp hp", "><")
	; 	MainBNAC.OnEvent("Click", this.AlignFN.Bind("Center"))
	; 	this.GuiCtrlSetTip(MainBNAC, "Align center (Ctrl+E)")
	; 	this.defaultFont(this.MainGui)
	; 	this.MainBNAC := MainBNAC
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...: 	Align - Right
	; ; ---------------------------------------------------------------------------
	; bAlign_Right(){
	; 	MainBNAR := this.MainGui.AddButton("x+0 yp wp hp", ">|")
	; 	MainBNAR.OnEvent("Click", this.AlignFN.Bind("Right"))
	; 	this.GuiCtrlSetTip(MainBNAR, "Align right (Ctrl+R)")
	; 	this.defaultFont(this.MainGui)
	; 	this.MainBNAR := MainBNAR
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...: 	Align - Justified
	; ; ---------------------------------------------------------------------------
	; bAlign_Justified(){
	; 	MainBNAJ := this.MainGui.AddButton("x+0 yp wp hp", "|<>|")
	; 	MainBNAJ.OnEvent("Click", this.AlignFN.Bind("Justify"))
	; 	this.GuiCtrlSetTip(MainBNAJ, "Align justified")
	; 	this.defaultFont(this.MainGui)
	; 	this.MainBNAJ := MainBNAJ
	; }
	; ; ---------------------------------------------------------------------------
	; ; @Section ...: 			Line Spacing
	; ; ---------------------------------------------------------------------------
	; ; @i ...: 	Spacing - Single
	; ; ---------------------------------------------------------------------------
	; bLineSpacing_Single(){
	; 	MainBN10 := this.MainGui.AddButton("x+10 yp wp hp", "1")
	; 	MainBN10.OnEvent("Click", this.SpacingFN.Bind(1.0))
	; 	this.GuiCtrlSetTip(MainBN10, "Linespacing 1 line (Ctrl+1)")
	; 	this.defaultFont(this.MainGui)
	; 	this.MainBN10 := MainBN10
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...: 	Spacing - One and a Half
	; ; ---------------------------------------------------------------------------
	; bLineSpacing_OnePtFive(){
	; 	MainBN15 := this.MainGui.AddButton("x+0 yp wp hp", "1½")
	; 	MainBN15.OnEvent("Click", this.SpacingFN.Bind(1.5))
	; 	this.GuiCtrlSetTip(MainBN15, "Linespacing 1,5 lines (Ctrl+5)")
	; 	this.defaultFont(this.MainGui)
	; 	this.MainBN15 := MainBN15
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...: 	Spacing - Double
	; ; ---------------------------------------------------------------------------
	; bLineSpacing_Double(){
	; 	MainBN20 := this.MainGui.AddButton("x+0 yp wp hp", "2")
	; 	MainBN20.OnEvent("Click", this.SpacingFN.Bind(2.0))
	; 	this.GuiCtrlSetTip(MainBN20, "Linespacing 2 lines (Ctrl+2)")
	; 	this.defaultFont(this.MainGui)
	; 	this.MainBN20 := MainBN20
	; }
	; ; ---------------------------------------------------------------------------
	; ; @Section ...: 		End of auto-execute section
	; ; ---------------------------------------------------------------------------
	; ; @i ...: 	Set Hotkeys for the Gui
	; ; ---------------------------------------------------------------------------
	; ; #HotIf RE2.Focused
	; RE_SetHotkeys(){
	; 	HotKey('^b', this.ModifierToggle, 'On')
	; 	HotKey('^i', this.ModifierToggle, 'On')
	; 	HotKey('^u', this.ModifierToggle, 'On')
	; 	HotKey('^h', this.ModifierToggle, 'On')
	; 	; HotKey('^l', ModifierToggle, 'On')
	; 	HotKey('^n', this.ModifierToggle, 'On')
	; 	HotKey('^p', this.ModifierToggle, 'On')
	; 	HotKey('!s', this.ModifierToggle, 'On')
	; }
	; ModifierToggle(){
	; 	this.RE2.ToggleFontStyle(SubStr(A_ThisHotkey, -1, 1))
	; 	this.UpdateGui()
	; }
	; ; #HotIf
	; RE2_SelChange(RE, L) {
	; 	SetTimer(this.UpdateGui, -10)
	; }
	; ; ---------------------------------------------------------------------------
	; RE2_Link(RE, L) {
	; 	wParam := 0, lParam := 0, cpMin := 0, cpMax := 0, URLtoOpen := ''
	; 	If (NumGet(L, A_PtrSize * 3, "Int") = 0x0202) { ; WM_LBUTTONUP
	; 		wParam  := NumGet(L, (A_PtrSize * 3) + 4, "UPtr")
	; 		lParam  := NumGet(L, (A_PtrSize * 4) + 4, "UPtr")
	; 		cpMin   := NumGet(L, (A_PtrSize * 5) + 4, "Int")
	; 		cpMax   := NumGet(L, (A_PtrSize * 5) + 8, "Int")
	; 		URLtoOpen := this.RE2.GetTextRange(cpMin, cpMax)
	; 		ToolTip("0x0202 - " wParam " - " lParam " - " cpMin " - " cpMax " - " URLtoOpen)
	; 		Run('"' URLtoOpen '"')
	; 	}
	; }
	; ;! --------------------------------------------------------------------------------
	; ; ---------------------------------------------------------------------------
	; ; @Section ...: 		UpdateGui
	; ; ---------------------------------------------------------------------------
	; ;! --------------------------------------------------------------------------------
	; UpdateGui() {
	; 	_AE_PerMonitor_DPIAwareness()
	; 	; Global MainSB, this.RE1, RE2, FontSize, FontName, FontStyle, FontCharSet, TextColor
	; 	; Static FontName := "", FontCharset := 0, FontStyle := 0, FontSize := 0, TextColor := 0, TxBkColor := 0
	; 	; RE1 := this.RE1
	; 	Static TxBkColor := 0
	; 	Local Font := RTEdit.RE2()
	; 	If (this.Settings.FontName != Font.Name || this.Settings.FontCharset != Font.CharSet || this.Settings.FontStyle != Font.Style || this.Settings.FontSize != Font.Size || this.Settings.TextColor != Font.Color || this.TxBkColor != Font.BkColor) {
	; 		; FontStyle := Font.Style
	; 		FontStyle := this.Settings.FontStyle
	; 		; TextColor := Font.Color
	; 		TextColor := this.Settings.TextColor
	; 		TxBkColor := this.Settings.TextBkColor
	; 		FontCharSet := this.Settings.FontCharSet
	; 		; ---------------------------------------------------------------------------
	; 		; If (FontName != Font.Name) {
	; 		; 	; FontName := Font.Name
	; 		; 	MainFNAME.Text := FontName
	; 		; }
	; 		; ---------------------------------------------------------------------------
	; 		this.MainFNAME.Text := this.Settings.FontName
	; 		; ---------------------------------------------------------------------------
	; 		; If (FontSize != Font.Size) {
	; 			; 	; FontSize := Round(Font.Size)
	; 			; 	MainFSIZE.Text := FontSize
	; 			; }
	; 		; ---------------------------------------------------------------------------
	; 		this.MainFSIZE.Text := this.Settings.FontSize
	; 		Font.Size := this.Settings.FontSize
	; 		this.RE1.SetSel(0, -1) ; select all
	; 		this.RE1.SetFont(Font)
	; 		this.RE1.SetSel(0, 0)  ; deselect all
	; 	}
	; 	; ---------------------------------------------------------------------------
	; 	; @i ...:	Was Working Before Changing to a Class
	; 	; ---------------------------------------------------------------------------
	; 	; RE_MainSB()
	; 	; RE_MainSB(){
	; 		; 	Local Stats := RichEdit.Prototype.GetStatistics()
	; 		; 	this.MainSB.SetText('')
	; 		; 	this.MainSB.SetText('Ln (' Stats.Line ':' Stats.LinePos ')' " #Lns (" Stats.LineCount ")" ' Chs[' Stats.CharCount ']', 2)
			
	; 		; }
	; 	; ---------------------------------------------------------------------------
	; 	this.MainGui.Show()
	; 	this.MainGuiSize()
	; 	this.MainGui.Show()
	; }
	; ; ---------------------------------------------------------------------------
	; ; @Section ...:				Gui related
	; ; ---------------------------------------------------------------------------
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	GuiClose
	; ; ---------------------------------------------------------------------------
	; MainGuiClose() {
	; 	; Global RE1, RE2
	; 	; ---------------------------------------------------------------------------
	; 	; SelAllFN(),	CopyFN() ;, Sleep(100)
	; 	Send('^a')
	; 	Send('^c')

	; 	If IsObject(this.RE1){
	; 		this.RE1 := ""
	; 	}
	; 	If IsObject(this.RE2){
	; 		this.RE2 := ""
	; 	}
	; 	this.MainGui.Destroy()
	; 	ExitApp()
	; }
	; ; ---------------------------------------------------------------------------
	; ;! ---------------------------------------------------------------------------
	; ; @i ...:	GuiSize
	; ;! ---------------------------------------------------------------------------
	; MainGuiSize(GuiObj?, MinMax?, Width?, Height?, *) {
	; 	_AE_PerMonitor_DPIAwareness()
	; 	this.Width := 0, this.Height := 0
	; 	Critical()
	; 	; If (MinMax = 1){
	; 	; 	Return
	; 	; }
	; 	; If (this.GuiW = 0) {
	; 	; 	this.GuiW := (this.Width + this.MarginX)
	; 	; 	this.GuiH := (this.Height + this.MarginY)
	; 	; }
	; 	; If (this.Width != this.GuiW || this.Height != this.GuiH) {
	; 	; 	WinA := WinActive('A')
	; 	; 	; DPI.WinGetPos(&REX, &REY, &REW, &REH)
	; 	; 	this.MainGui.GetPos(&REX, &REY, &REW, &REH)
	; 	; 	REW += (this.EditW - this.GuiW)-(46)
	; 	; 	REH += (this.EditH - this.GuiH)
	; 	; 	this.RE2.Move( , , REW, REH)
	; 	; 	this.GuiW := (this.EditW + this.MarginX)
	; 	; 	this.GuiH := (this.EditH + this.MarginY)
	; 	; }
	; 	; ---------------------------------------------------------------------------
	; 	; @i ...:	Just Trying To Make It Work - Above Stuff is the Best/Origional
	; 	; ---------------------------------------------------------------------------
	; 	DPI.WinGetPos(&REX, &REY, &REW, &REH)
	; 	this.EditW := RTEdit.Settings.EditW
	; 	this.EditH := RTEdit.Settings.EditH
	; 	this.GuiW := RTEdit.Settings.GuiW
	; 	this.GuiH := RTEdit.Settings.GuiH
	; 	this.MarginX := RTEdit.Settings.MarginX
	; 	this.MarginY := RTEdit.Settings.MarginY
	; 	; this.GetPos(&REX, &REY, &REW, &REH)
	; 	REW += (this.EditW - this.GuiW)-(46)
	; 	REH += (this.EditH - this.GuiH)
	; 	this.Move( , , REW, REH)
	; 	this.GuiW := (this.EditW + this.MarginX)
	; 	this.GuiH := (this.EditH + this.MarginY)
	; 	; ---------------------------------------------------------------------------
	; 	this.Show()
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	GuiContextMenu
	; ; ---------------------------------------------------------------------------
	; RE_MainContextMenu(GuiObj, GuiCtrlObj, *) {
	; 	If (GuiCtrlObj = this.RE2){
	; 		this.ContextMenu.Show()
	; 	}
	; 	; this.ContextMenu := ContextMenu
	; 	; return ContextMenu
	; }
	; ;! --------------------------------------------------------------------------------
	; ; @Section ...:						Text operations
	; ;! --------------------------------------------------------------------------------
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	SetFontStyle
	; ; ---------------------------------------------------------------------------
	; SetFontStyleFN(Style, GuiCtrl, *) {
	; 	this.RE2.ToggleFontStyle(Style)
	; 	this.UpdateGui()
	; 	this.RE2.Focus()
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	ChangeSize
	; ; ---------------------------------------------------------------------------
	; ChangeSize(IncDec, GuiCtrl, *) {
	; 	this.FontSize := this.RE2.ChangeFontSize(IncDec)
	; 	this.MainFSIZE.Text := Round(this.FontSize)
	; 	this.RE2.Focus()
	; 	; return MainFSIZE.Text := FontSize
	; 	this.FontSize := this.MainFSIZE.Text
	; }
	; ; ---------------------------------------------------------------------------
	; ; @Section ...:					Menu File
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	FileAppend
	; ; @i ...:	FileOpen
	; ; @i ...:	FileInsert
	; ; ---------------------------------------------------------------------------
	; FileLoadFN(Mode, *) {
	; 	Global Open_File
	; 	If (File := RichEditDlgs.FileDlg(this.RE2, "O")) {
	; 		this.RE2.LoadFile(File, Mode)
	; 		If (Mode = "O") {
	; 			this.MainGui.Opt("+LastFound")
	; 			Title := WinGetTitle()
	; 			Title := StrSplit(Title, "-", " ")
	; 			WinSetTitle(Title[1] . " - " . File)
	; 			Open_File := File
	; 		}
	; 		this.UpdateGui()
	; 	}
	; 	this.RE2.SetModified()
	; 	this.RE2.Focus()
	; 	return Open_File
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	FileClose
	; ; ---------------------------------------------------------------------------
	; FileCloseFN() {
	; 	Global Open_File
	; 	If (Open_File) {
	; 		If this.RE2.IsModified() {
	; 			this.MainGui.Opt("+OwnDialogs")
	; 			Switch MsgBox(35, "Close File", "Content has been modified!`nDo you want to save changes?") {
	; 				Case "Cancel": 	this.RE2.Focus()
	; 				Case "Yes": 	this.FileSaveFN()
	; 			}
	; 		}
	; 		If this.RE2.SetText() {
	; 			this.MainGui.Opt("+LastFound")
	; 			Title := WinGetTitle()
	; 			Title := StrSplit(Title, "-", " ")
	; 			WinSetTitle(Title[1])
	; 			Open_File := ""
	; 		}
	; 		this.UpdateGui()
	; 	}
	; 	this.RE2.SetModified()
	; 	this.RE2.Focus()
	; 	return Open_File
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	FileSave
	; ; ---------------------------------------------------------------------------
	; FileSaveFN() {
	; 	If !(Open_File){
	; 		this.FileSaveAsFN()
	; 		; Return 
	; 	}
	; 	this.RE2.SaveFile(Open_File)
	; 	this.RE2.SetModified()
	; 	this.RE2.Focus()
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	FileSaveAs
	; ; ---------------------------------------------------------------------------
	; FileSaveAsFN() {
	; 	; Global Open_File := File
	; 	If (File := RichEditDlgs.FileDlg(this.RE2, "S")) {
	; 		this.RE2.SaveFile(File)
	; 		this.MainGui.Opt("+LastFound")
	; 		Title := WinGetTitle()
	; 		Title := StrSplit(Title, "-", " ")
	; 		WinSetTitle(Title[1] . " - " . File)
	; 	}
	; 	this.RE2.Focus()
	; 	; return Open_File
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	PageSetup
	; ; ---------------------------------------------------------------------------
	; PageSetupFN() {
	; 	RichEditDlgs.PageSetup(this.RE2)
	; 	this.RE2.Focus()
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	Print
	; ; ---------------------------------------------------------------------------
	; PrintFN() {
	; 	this.RE2.Print()
	; 	this.RE2.Focus()
	; }
	; ; ---------------------------------------------------------------------------
	; ; @Section ...:				Menu Edit
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	Undo
	; ; ---------------------------------------------------------------------------
	; UndoFN() {
	; 	this.RE2.Undo()
	; 	this.RE2.Focus()
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	Redo
	; ; ---------------------------------------------------------------------------
	; RedoFN() {
	; 	this.RE2.Redo()
	; 	this.RE2.Focus()
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	Cut
	; ; ---------------------------------------------------------------------------
	; CutFN() {
	; 	this.RE2.Cut()
	; 	this.RE2.Focus()
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	Copy
	; ; ---------------------------------------------------------------------------
	; CopyFN() {
	; 	this.RE2.Copy()
	; 	this.RE2.Focus()
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	Paste:
	; ; ---------------------------------------------------------------------------
	; PasteFN() {
	; 	this.RE2.Paste()
	; 	this.RE2.Focus()
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	Clear
	; ; ---------------------------------------------------------------------------
	; ClearFN() {
	; 	this.RE2.Clear()
	; 	this.RE2.Focus()
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	Select All
	; ; ---------------------------------------------------------------------------
	; SelAllFN() {
	; 	this.RE2.SelAll()
	; 	this.RE2.Focus()
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	Deselect
	; ; ---------------------------------------------------------------------------
	; DeselectFN() {
	; 	this.RE2.Deselect()
	; 	this.RE2.Focus()
	; }
	; ; ---------------------------------------------------------------------------
	; ; @Section ...:				Menu View
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	WordWrap
	; ; ---------------------------------------------------------------------------
	; WordWrapFN(Item, *) {
	; 	Global WordWrap ^= True
	; 	this.RE2.WordWrap(WordWrap)
	; 	this.ViewMenu.ToggleCheck(Item)
	; 	If (WordWrap)
	; 		this.ViewMenu.Disable(this.MenuWysiwyg)
	; 	Else
	; 		this.ViewMenu.Enable(this.MenuWysiwyg)
	; 	this.RE2.Focus()
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	Zoom
	; ; ---------------------------------------------------------------------------
	; Zoom100FN() => this.ZoomFN(100, "100 %")
	; ZoomFN(Ratio, Item, *) {
	; 	this.ZoomMenu.UnCheck(Zoom)
	; 	Zoom := Item
	; 	this.ZoomMenu.Check(Zoom)
	; 	this.RE2.SetZoom(Ratio)
	; 	this.RE2.Focus()
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	WYSIWYG
	; ; ---------------------------------------------------------------------------
	; WYSIWYGFN(Item, *) {
	; 	; Global ShowWysiwyg ^= True
	; 	If (this.ShowWysiwyg){
	; 		this.Zoom100FN()
	; 	}
	; 	this.RE2.WYSIWYG(this.ShowWysiwyg)
	; 	this.RE_ViewMenu.ToggleCheck(Item)
	; 	If (this.ShowWysiwyg){
	; 		this.ViewMenu.Disable(this.MenuWordWrap)
	; 	}
	; 	Else {
	; 		this.ViewMenu.Enable(this.MenuWordWrap)
	; 	}
	; 	this.RE2.Focus()
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	BackgroundColor
	; ; ---------------------------------------------------------------------------
	; BackgroundColorFN(Mode, *) {
	; 	; Global this.BackColor
	; 	Switch Mode {
	; 		Case "Auto": 	this.RE2.BackColor := "Auto"
	; 		Case "Choose":	this.RE2.SetBkgndColor("cYellow")
	; 			; If this.RE2.BackColor != "Auto"
	; 			; 	Color := this.RE2.BackColor
	; 			; Else
	; 			; 	Color := this.RE2.GetRGB(DllCall("GetSysColor", "Int", 5, "UInt")) ; COLOR_WINDOW
	; 			; NC := RichEditDlgs.ChooseColor(this.RE2, Color)
	; 			; If (NC != "") {
	; 			; 	this.RE2.SetBkgndColor(NC)
	; 			; 	this.RE2.BackColor := NC
	; 			; }
	; 	}
	; 	this.RE2.Focus()
	; }
	; ; ---------------------------------------------------------------------------
	; ; @Section ...:				AutoURLDetection
	; ; ---------------------------------------------------------------------------
	; AutoURLDetectionFN(ItemName, ItemPos, MenuObj, *) {
	; 	this.RE2.AutoURL(AutoURL ^= True)
	; 	MenuObj.ToggleCheck(ItemName)
	; 	this.RE2.Focus()
	; }
	; ; ---------------------------------------------------------------------------
	; ; @Section ...:				Menu Character
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	ChooseFont
	; ; ---------------------------------------------------------------------------
	; ChooseFontFN() {
	; 	; Global FontName, FontSize
	; 	RichEditDlgs.ChooseFont(this.RE2)
	; 	Font := this.RE2.GetFont()
	; 	this.FontName := Font.Name
	; 	this.FontSize := Font.Size
	; 	this.MainFNAME.Text := this.FontName
	; 	this.MainFSIZE.Text := Round(this.FontSize)
	; 	this.RE2.Focus()
	; 	this.Font := Font
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	MTextColor    ; menu label
	; ; ---------------------------------------------------------------------------
	; TextColorFN(Mode, *) {
	; 	Switch Mode {
	; 		Case "Auto":	this.RE2.SetFont({Color: "cBlack"})
	; 		; RE2.TextColor := "Auto"
	; 		Case "Choose":	this.RE2.SetFont({Color: "cBlack"})
	; 			; If RE2.TextColor != "Auto"
	; 			; 	Color := RE2.TextColor
	; 			; Else
	; 			; 	Color := RE2.GetRGB(DllCall("GetSysColor", "Int", 8, "UInt")) ; COLOR_WINDOWTEXT
	; 			; NC := RichEditDlgs.ChooseColor(RE2, Color)
	; 			; If (NC != "") {
	; 			; 	RE2.SetFont({Color: NC})
	; 			; 	RE2.TextColor := NC
	; 			; }
	; 		}
	; 		this.UpdateGui()
	; 		this.RE2.Focus()
	; 	}
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	BTextBkColor  ; button label
	; ; ---------------------------------------------------------------------------
	; TextBkColorFN(Mode, *) {
	; 	Switch Mode {
	; 		Case "Auto":
	; 			this.RE2.SetFont({BkColor: "Auto"})
	; 			Color := this.RE2.GetRGB(DllCall("GetSysColor", "Int", 5, "UInt")) ; COLOR_WINDOW
	; 			Case "Choose":
	; 			this.RE2.SetFont({BkColor: "Auto"})
	; 			; If this.RE2.TxBkColor != "Auto"
	; 			; 	Color := this.RE2.TxBkColor
	; 			; Else
	; 			; 	Color := this.RE2.GetRGB(DllCall("GetSysColor", "Int", 5, "UInt")) ; COLOR_WINDOW
	; 			; NC := RichEditDlgs.ChooseColor(this.RE2, Color)
	; 			; If (NC != "") {
	; 			; 	this.RE2.SetFont({BkColor: NC})
	; 			; 	this.RE2.TxBkColor := NC
	; 			; }
	; 		}
	; 	this.UpdateGui()
	; 	this.RE2.Focus()
	; }
	; ; ---------------------------------------------------------------------------
	; ; @Section ...: 			Menu Paragraph
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	AlignLeft
	; ; @i ...:	AlignCenter
	; ; @i ...:	AlignRight
	; ; @i ...:	AlignJustify
	; ; ---------------------------------------------------------------------------
	; AlignFN(Alignment, *) {
	; 	Static Align := {Left: 1, Right: 2, Center: 3, Justify: 4}
	; 	If Align.HasProp(Alignment){
	; 		this.RE2.AlignText(Align.%Alignment%)
	; 	}
	; 	this.RE2.Focus()
	; }
	; ; ---------------------------------------------------------------------------
	; IndentationFN(Mode, *) {
	; 	Switch Mode {
	; 		Case "Set": this.RE_ParaIndentGui(this.RE2)
	; 		Case "Reset": this.RE2.SetParaIndent()
	; 	}
	; 	this.RE2.Focus()
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	Numbering
	; ; ---------------------------------------------------------------------------
	; NumberingFN(Mode, *) {
	; 	Switch Mode {
	; 		Case "Set": this.RE_ParaNumberingGui(this.RE2)
	; 		Case "Reset": this.RE2.SetParaNumbering()
	; 	}
	; 	this.RE2.Focus()
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	ParaSpacing
	; ; @i ...:	ResetParaSpacing
	; ; ---------------------------------------------------------------------------
	; ParaSpacingFN(Mode, *) {
	; 	Switch Mode {
	; 		Case "Set": this.RE_ParaSpacingGui(this.RE2)
	; 		Case "Reset": this.RE2.SetParaSpacing()
	; 	}
	; 	this.RE2.Focus()
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	Spacing10
	; ; @i ...:	Spacing15
	; ; @i ...:	Spacing20
	; ; ---------------------------------------------------------------------------
	; SpacingFN(Val, *) {
	; 	this.RE2.SetLineSpacing(Val)
	; 	this.RE2.Focus()
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	SetTabStops
	; ; @i ...:	ResetTabStops
	; ; @i ...:	SetDefTabs
	; ; ---------------------------------------------------------------------------
	; SetTabStopsFN(Mode, *) {
	; 	Switch Mode {
	; 		Case "Set": this.RE_SetTabStopsGui(this.RE2)
	; 		Case "Reset": this.RE2.SetTabStops()
	; 		Case "Default": this.RE2.SetDefaultTabs(1)
	; 	}
	; 	this.RE2.Focus()
	; }
	; ; ---------------------------------------------------------------------------
	; ; @i ...:	Menu Search
	; ; ---------------------------------------------------------------------------
	; FindFN() {
	; 	RichEditDlgs.FindText(this.RE2)
	; }
	; ; ---------------------------------------------------------------------------
	; ReplaceFN() {
	; 	RichEditDlgs.ReplaceText(this.RE2)
	; }
	; ; ---------------------------------------------------------------------------
	; ; @Section ...: 			ParaIndentation GUI
	; ; ---------------------------------------------------------------------------
	; RE_ParaIndentGui(RE) {
	; 	Static  Owner := "",
	; 	Success := False
	; 	Metrics := RE.GetMeasurement()
	; 	PF2 := RE.GetParaFormat()
	; 	Owner := RE.Gui.Hwnd
	; 	ParaIndentGui := Gui("+Owner" . Owner . " +ToolWindow +LastFound", "Paragraph Indentation")
	; 	ParaIndentGui.OnEvent("Close", ParaIndentGuiClose)
	; 	ParaIndentGui.MarginX := 20
	; 	ParaIndentGui.MarginY := 10
	; 	ParaIndentGui.AddText("Section h20 0x200", "First line left indent (absolute):")
	; 	ParaIndentGui.AddText("xs hp 0x200", "Other lines left indent (relative):")
	; 	ParaIndentGui.AddText("xs hp 0x200", "All lines right indent (absolute):")
	; 	EDLeft1 	:= ParaIndentGui.AddEdit("ys hp Limit5")
	; 	EDLeft2 	:= ParaIndentGui.AddEdit("hp Limit6")
	; 	EDRight 	:= ParaIndentGui.AddEdit("hp Limit5")
	; 	CBStart 	:= ParaIndentGui.AddCheckBox("ys x+5 hp", "Apply")
	; 	CBOffset 	:= ParaIndentGui.AddCheckBox("hp", "Apply")
	; 	CBRight 	:= ParaIndentGui.AddCheckBox("hp", "Apply")
	; 	Left1 := Round((PF2.StartIndent / 1440) * Metrics, 2)
	; 	If (Metrics = 2.54)
	; 		Left1 := RegExReplace(Left1, "\.", ",")
	; 	EDLeft1.Text := Left1
	; 	Left2 := Round((PF2.Offset / 1440) * Metrics, 2)
	; 	If (Metrics = 2.54)
	; 		Left2 := RegExReplace(Left2, "\.", ",")
	; 	EDLeft2.Text := Left2
	; 	Right := Round((PF2.RightIndent / 1440) * Metrics, 2)
	; 	If (Metrics = 2.54)
	; 		Right := RegExReplace(Right, "\.", ",")
	; 	EDRight.Text := Right
	; 	BN1 := ParaIndentGui.AddButton("xs", "Apply")
	; 	BN1.OnEvent("Click", ParaIndentGuiApply)
	; 	BN2 := ParaIndentGui.AddButton("x+10 yp", "Cancel")
	; 	BN2.OnEvent("Click", ParaIndentGuiClose)
	; 	BN2.GetPos( , , &BW := 0)
	; 	BN1.Move( , , BW)
	; 	CBRight.GetPos(&CX := 0, , &CW := 0)
	; 	BN2.Move(CX + CW - BW)
	; 	RE.Gui.Opt("+Disabled")
	; 	ParaIndentGui.Show()
	; 	WinWaitActive()
	; 	WinWaitClose()
	; 	Return Success
	; 	; ---------------------------------------------------------------------------
	; 	ParaIndentGuiClose() {
	; 		Success := False
	; 		RE.Gui.Opt("-Disabled")
	; 		ParaIndentGui.Destroy()
	; 	}
	; 	; ---------------------------------------------------------------------------
	; 	ParaIndentGuiApply() {
	; 		ApplyStart := CBStart.Value
	; 		ApplyOffset := CBOffset.Value
	; 		ApplyRight := CBRight.Value
	; 		Indent := {}
	; 		If ApplyStart {
	; 			Start := EDLeft1.Text
	; 			If (Start = "")
	; 				Start := 0
	; 			If !RegExMatch(Start, "^\d{1,2}((\.|,)\d{1,2})?$") {
	; 				EDLeft1.Text := ""
	; 				EDLeft1.Focus()
	; 				Return
	; 			}
	; 			Indent.Start := StrReplace(Start, ",", ".")
	; 		}
	; 		If (ApplyOffset) {
	; 			Offset := EDLeft2.Text
	; 			If (Offset = "")
	; 				Offset := 0
	; 			If !RegExMatch(Offset, "^(-)?\d{1,2}((\.|,)\d{1,2})?$") {
	; 				EDLeft2.Text := ""
	; 				EDLeft2.Focus()
	; 				Return
	; 			}
	; 			Indent.Offset := StrReplace(Offset, ",", ".")
	; 		}
	; 		If (ApplyRight) {
	; 			Right := EDRight.Text
	; 			If (Right = "")
	; 				Right := 0
	; 			If !RegExMatch(Right, "^\d{1,2}((\.|,)\d{1,2})?$") {
	; 				EDRight.Text := ""
	; 				EDRight.Focus()
	; 				Return
	; 			}
	; 			Indent.Right := StrReplace(Right, ",", ".")
	; 		}
	; 		Success := RE.SetParaIndent(Indent)
	; 		RE.Gui.Opt("-Disabled")
	; 		ParaIndentGui.Destroy()
	; 	}
	; }
	; ; ---------------------------------------------------------------------------
	; ; @Section ...: 			ParaNumbering GUI
	; ; ---------------------------------------------------------------------------
	; RE_ParaNumberingGui(RE) {
	; 	Static	Owner := "", Bullet := "•",
	; 			StyleArr := ["1)", "(1)", "1.", "1", "w/o"],
	; 			TypeArr := [Bullet, "0, 1, 2", "a, b, c", "A, B, C", "i, ii, iii", "I, I, III"],
	; 			PFN := ["Bullet", "Arabic", "LCLetter", "UCLetter", "LCRoman", "UCRoman"],
	; 			PFNS := ["Paren", "Parens", "Period", "Plain", "None"],
	; 			Success := False
	; 	Metrics := RE.GetMeasurement()
	; 	PF2 := RE.GetParaFormat()
	; 	Owner := RE.Gui.Hwnd
	; 	ParaNumberingGui := Gui("+Owner" . Owner . " +ToolWindow +LastFound", "Paragraph Numbering")
	; 	ParaNumberingGui.OnEvent("Close", ParaNumberingGuiClose)
	; 	ParaNumberingGui.MarginX := 20
	; 	ParaNumberingGui.MarginY := 10
	; 	ParaNumberingGui.AddText("Section h20 w100 0x200", "Type:")
	; 	DDLType := ParaNumberingGui.AddDDL("xp y+0 wp AltSubmit", TypeArr)
	; 	If (PF2.Numbering){
	; 		DDLType.Choose(PF2.Numbering)
	; 	}
	; 	ParaNumberingGui.AddText("xs h20 w100 0x200", "Start with:")
	; 	EDStart := ParaNumberingGui.AddEdit("y+0 wp hp Limit5", PF2.NumberingStart)
	; 	ParaNumberingGui.AddText("ys h20 w100 0x200", "Style:")
	; 	DDLStyle := ParaNumberingGui.AddDDL("y+0 wp AltSubmit Choose1", StyleArr)
	; 	If (PF2.NumberingStyle){
	; 		DDLStyle.Choose((PF2.NumberingStyle // 0x0100) + 1)
	; 	}
	; 	ParaNumberingGui.AddText("h20 w100 0x200", "Distance:  (" . (Metrics = 1.00 ? "in." : "cm") . ")")
	; 	EDDist := ParaNumberingGui.AddEdit("y+0 wp hp Limit5")
	; 	Tab := Round((PF2.NumberingTab / 1440) * Metrics, 2)
	; 	If (Metrics = 2.54){
	; 		Tab := RegExReplace(Tab, "\.", ",")
	; 	}
	; 	EDDist.Text := Tab
	; 	BN1 := ParaNumberingGui.AddButton("xs", "Apply") ; gParaNumberingGuiApply hwndhBtn1, Apply
	; 	BN1.OnEvent("Click", ParaNumberingGuiApply)
	; 	BN2 := ParaNumberingGui.AddButton("x+10 yp", "Cancel") ;  gParaNumberingGuiClose hwndhBtn2, Cancel
	; 	BN2.OnEvent("Click", ParaNumberingGuiClose)
	; 	BN2.GetPos( , , &BW := 0)
	; 	BN1.Move( , , BW)
	; 	DDLStyle.GetPos(&DX := 0, , &DW := 0)
	; 	BN2.Move(DX + DW - BW)
	; 	RE.Gui.Opt("+Disabled")
	; 	ParaNumberingGui.Show()
	; 	WinWaitActive()
	; 	WinWaitClose()
	; 	Return Success
	; 	; ---------------------------------------------------------------------------
	; 	ParaNumberingGuiClose() {
	; 		Success := False
	; 		RE.Gui.Opt("-Disabled")
	; 		ParaNumberingGui.Destroy()
	; 	}
	; 	; ---------------------------------------------------------------------------
	; 	ParaNumberingGuiApply() {
	; 		Type := DDLType.Value
	; 		Style := DDLStyle.Value
	; 		Start := EDStart.Text
	; 		Tab := EDDist.Text
	; 		If !RegExMatch(Tab, "^\d{1,2}((\.|,)\d{1,2})?$") {
	; 			EDDist.Text := ""
	; 			EDDist.Focus()
	; 			Return
	; 		}
	; 		Numbering := {Type: PFN[Type], Style: PFNS[Style]}
	; 		Numbering.Tab := RegExReplace(Tab, ",", ".")
	; 		Numbering.Start := Start
	; 		Success := RE.SetParaNumbering(Numbering)
	; 		RE.Gui.Opt("-Disabled")
	; 		ParaNumberingGui.Destroy()
	; 	}
	; }
	; ; ---------------------------------------------------------------------------
	; ; @Section ...: 			ParaSpacing GUI
	; ; ---------------------------------------------------------------------------
	; RE_ParaSpacingGui(RE) {
	; 	Static Owner := "",
	; 	Success := False
	; 	PF2 := RE.GetParaFormat()
	; 	Owner := RE.Gui.Hwnd
	; 	ParaSpacingGui := Gui("+Owner" . Owner . " +ToolWindow +LastFound", "Paragraph Spacing") ; +LabelParaSpacingGui
	; 	ParaSpacingGui.OnEvent("Close", ParaSpacingGuiClose)
	; 	ParaSpacingGui.MarginX := 20
	; 	ParaSpacingGui.MarginY := 10
	; 	ParaSpacingGui.AddText("Section h20 0x200", "Space before in points:")
	; 	ParaSpacingGui.AddText("xs y+10 hp 0x200", "Space after in points:")
	; 	EDBefore := ParaSpacingGui.AddEdit("ys hp Number Limit2 Right", "00")
	; 	EDBefore.Text := PF2.SpaceBefore // 20
	; 	EDAfter := ParaSpacingGui.AddEdit("xp y+10 hp Number Limit2 Right", "00")
	; 	EDAfter.Text := PF2.SpaceAfter // 20
	; 	BN1 := ParaSpacingGui.AddButton("xs", "Apply")
	; 	BN1.OnEvent("Click", ParaSpacingGuiApply)
	; 	BN2 := ParaSpacingGui.AddButton("x+10 yp", "Cancel")
	; 	BN2.OnEvent("Click", ParaSpacingGuiClose)
	; 	BN2.GetPos( , ,&BW := 0)
	; 	BN1.Move( , ,BW)
	; 	EDAfter.GetPos(&EX := 0, , &EW := 0)
	; 	X := EX + EW - BW
	; 	BN2.Move(X)
	; 	RE.Gui.Opt("+Disabled")
	; 	ParaSpacingGui.Show()
	; 	WinWaitActive()
	; 	WinWaitClose()
	; 	Return Success
	; 	; ---------------------------------------------------------------------------
	; 	ParaSpacingGuiClose() {
	; 		Success := False
	; 		RE.Gui.Opt("-Disabled")
	; 		ParaSpacingGui.Destroy()
	; 	}
	; 	; ---------------------------------------------------------------------------
	; 	ParaSpacingGuiApply() {
	; 		Before := EDBefore.Text
	; 		After := EDAfter.Text
	; 		Success := RE.SetParaSpacing({Before: Before, After: After})
	; 		RE.Gui.Opt("-Disabled")
	; 		ParaSpacingGui.Destroy()
	; 	}
	; }
	; ; ---------------------------------------------------------------------------
	; ; @Section ...: 			SetTabStops GUI
	; ; ---------------------------------------------------------------------------
	; RE_SetTabStopsGui(RE) {
	; 	; Set paragraph's tabstobs
	; 	; Call with parameter mode = "Reset" to reset to default tabs
	; 	; EM_GETPARAFORMAT = 0x43D, EM_SETPARAFORMAT = 0x447
	; 	; PFM_TABSTOPS = 0x10
	; 	Static  Owner   := "",
	; 			Metrics := 0,
	; 			MinTab  := 0.30,     ;? minimal tabstop in inches
	; 			MaxTab  := 8.30,     ;? maximal tabstop in inches
	; 			AL := 0x00000000,    ;? left aligned (default)
	; 			AC := 0x01000000,    ;? centered
	; 			AR := 0x02000000,    ;? right aligned
	; 			AD := 0x03000000,    ;? decimal tabstop
	; 			Align := {0x00000000: "L", 0x01000000: "C", 0x02000000: "R", 0x03000000: "D"},
	; 			TabCount := 0,       ;? tab count
	; 			MAX_TAB_STOPS := 32,
	; 			Success := False     ;? return value
	; 	Metrics := RE.GetMeasurement()
	; 	PF2 := RE.GetParaFormat()
	; 	TabCount := PF2.TabCount
	; 	Tabs := []
	; 	Tabs.Length := PF2.Tabs.Length
	; 	For I, V In PF2.Tabs{
	; 		Tabs[I] := [Format("{:.2f}", Round(((V & 0x00FFFFFF) * Metrics) / 1440, 2)), V & 0xFF000000]
	; 	}
	; 	Owner := RE.Gui.Hwnd
	; 	SetTabStopsGui := Gui("+Owner" . Owner . " +ToolWindow +LastFound", "Set Tabstops")
	; 	SetTabStopsGui.OnEvent("Close", SetTabStopsGuiClose)
	; 	SetTabStopsGui.MarginX := 10
	; 	SetTabStopsGui.MarginY := 10
	; 	SetTabStopsGui.AddText("Section", "Position: (" . (Metrics = 1.00 ? "in." : "cm") . ")")
	; 	CBBTabs := SetTabStopsGui.AddComboBox("xs y+2 w120 r6 Simple +0x800 AltSubmit")
	; 	CBBTabs.OnEvent("Change", SetTabStopsGuiSelChanged)
	; 	If (TabCount) {
	; 		For T In Tabs {
	; 			I := SendMessage(0x0143, 0, StrPtr(T[1]), CBBTabs.Hwnd)  ; CB_ADDSTRING
	; 			SendMessage(0x0151, I, T[2], CBBTabs.Hwnd)               ; CB_SETITEMDATA
	; 		}
	; 	}
	; 	SetTabStopsGui.AddText("ys Section", "Alignment:")
	; 	RBL := SetTabStopsGui.AddRadio("xs w60 Section y+2 Checked Group", "Left")
	; 	RBC := SetTabStopsGui.AddRadio("wp", "Center")
	; 	RBR := SetTabStopsGui.AddRadio("ys wp", "Right")
	; 	RBD := SetTabStopsGui.AddRadio("wp", "Decimal")
	; 	BNAdd := SetTabStopsGui.AddButton("xs Section w60 Disabled", "&Add")
	; 	BNAdd.OnEvent("Click", SetTabStopsGuiAdd)
	; 	BNRem := SetTabStopsGui.AddButton("ys w60 Disabled", "&Remove")
	; 	BNRem.OnEvent("Click", SetTabStopsGuiRemove)
	; 	BNAdd.GetPos(&X1 := 0)
	; 	BNRem.GetPos(&X2 := 0, , &W2 := 0)
	; 	W := X2 + W2 - X1
	; 	BNClr := SetTabStopsGui.AddButton("xs w" . W, "&Clear all")
	; 	BNClr.OnEvent("Click", SetTabStopsGuiRemoveAll)
	; 	SetTabStopsGui.AddText("xm h5")
	; 	BNApply := SetTabStopsGui.AddButton("xm y+0 w60", "&Apply")
	; 	BNApply.OnEvent("Click", SetTabStopsGuiApply)
	; 	X := X2 + W2 - 60
	; 	BNCancel := SetTabStopsGui.AddButton("x" . X . " yp wp", "&Cancel")
	; 	BNCancel.OnEvent("Click", SetTabStopsGuiClose)
	; 	RE.Gui.Opt("+Disabled")
	; 	SetTabStopsGui.Show()
	; 	WinWaitActive()
	; 	WinWaitClose()
	; 	Return Success
	; 	; ---------------------------------------------------------------------------
	; 	SetTabStopsGuiClose() {
	; 		Success := False
	; 		RE.Gui.Opt("-Disabled")
	; 		SetTabStopsGui.Destroy()
	; 	}
	; 	; ---------------------------------------------------------------------------
	; 	SetTabStopsGuiSelChanged() {
	; 		If (TabCount < MAX_TAB_STOPS)
	; 			BNAdd.Enabled := !!RegExMatch(CBBTabs.Text, "^\d*[.,]?\d+$")
	; 		If !(I := CBBTabs.Value) {
	; 			BNRem.Enabled := False
	; 			Return
	; 		}
	; 		BNRem.Enabled := True
	; 		A := SendMessage(0x0150, I - 1, 0, CBBTabs.Hwnd) ; CB_GETITEMDATA
	; 		C := A = AC ? RBC : A = AR ? RBR : A = AD ? RBD : RBl
	; 		C.Value := 1
	; 	}
	; 	; ---------------------------------------------------------------------------
	; 	SetTabStopsGuiAdd() {
	; 		T := CBBTabs.Text
	; 		If !RegExMatch(T, "^\d*[.,]?\d+$") {
	; 			CBBTabs.Focus()
	; 			Return
	; 		}
	; 		T := Round(StrReplace(T, ",", "."), 2)
	; 		RT := Round(T / Metrics, 2)
	; 		If (RT < MinTab) || (RT > MaxTab){
	; 			CBBTabs.Focus()
	; 			Return
	; 		}
	; 		A := RBC.Value ? AC : RBR.Value ? AR : RBD.Value ? AD : AL
	; 		TabArr := ControlGetItems(CBBTabs.Hwnd)
	; 		P := -1
	; 		T := Format("{:.2f}", T)
	; 		For I, V In TabArr {
	; 			If (T < V) {
	; 				P := I - 1
	; 				Break
	; 			}
	; 			IF (T = V) {
	; 				P := I - 1
	; 				CBBTabs.Delete(I)
	; 				Break
	; 			}
	; 		}
	; 		I := SendMessage(0x014A, P, StrPtr(T), CBBTabs.Hwnd)  ; CB_INSERTSTRING
	; 		SendMessage(0x0151, I, A, CBBTabs.Hwnd)               ; CB_SETITEMDATA
	; 		TabCount++
	; 		If !(TabCount < MAX_TAB_STOPS)
	; 			BNAdd.Enabled := False
	; 		CBBTabs.Text := ""
	; 		CBBTabs.Focus()
	; 	}
	; 	; ---------------------------------------------------------------------------
	; 	SetTabStopsGuiRemove() {
	; 		If (I := CBBTabs.Value) {
	; 			CBBTabs.Delete(I)
	; 			CBBTabs.Text := ""
	; 			TabCount--
	; 			RBL.Value := 1
	; 		}
	; 		CBBTabs.Focus()
	; 	}
	; 	; ---------------------------------------------------------------------------
	; 	SetTabStopsGuiRemoveAll() {
	; 		CBBTabs.Text := ""
	; 		CBBTabs.Delete()
	; 		RBL.Value := 1
	; 		CBBTabs.Focus()
	; 	}
	; 	; ---------------------------------------------------------------------------
	; 	SetTabStopsGuiApply() {
	; 		TabCount := SendMessage(0x0146, 0, 0, CBBTabs.Hwnd) << 32 >> 32 ; CB_GETCOUNT
	; 		If (TabCount < 1)
	; 			Return
	; 		TabArr := ControlGetItems(CBBTabs.HWND)
	; 		TabStops := {}
	; 		For I, T In TabArr {
	; 			Alignment := Format("0x{:08X}", SendMessage(0x0150, I - 1, 0, CBBTabs.HWND)) ; CB_GETITEMDATA
	; 			TabPos := Format("{:i}", T * 100)
	; 			TabStops.%TabPos% := Align.%Alignment%
	; 		}
	; 		Success := RE.SetTabStops(TabStops)
	; 		RE.Gui.Opt("-Disabled")
	; 		SetTabStopsGui.Destroy()
	; 	}
	; }
	
	; ---------------------------------------------------------------------------
	; @i ...: Sets multi-line tooltips for any Gui control
	; @i ...: Parameters
	; @i ...: param GuiCtrl ...: 	A Gui.Control object
	; @i ...: param TipText ...: 	The text for the tooltip. If you pass an empty string for a formerly added control, its tooltip will be removed
	; @i ...: param UseAhkStyle ...: 	If set to true, the tooltips will be shown using the visual styles of AHK ToolTips. Otherwise, the current theme settings will be used
	; @i ...: example Default: True
	; @i ...: param CenterTip ...:		If set to true, the tooltip will be shown centered below/above the control
	; @i ...: example Default: False
	; @i ...: example
	; @i ...: Return values
	; @i ...: True on success, otherwise False
	; @i ...: Remarks
	; @i ...: Text and Picture controls require the SS_NOTIFY (+0x0100) style
	; @link : MSDN: https://learn.microsoft.com/en-us/windows/win32/controls/tooltip-control-reference
	; ---------------------------------------------------------------------------
	
	GuiCtrlSetTip(GuiCtrl, TipText, UseAhkStyle := True, CenterTip := False) {
		Static SizeOfTI := 24 + (A_PtrSize * 6)
		Static Tooltips := Map()
		Local Flags, HGUI, HCTL, HTT, TI
		; ---------------------------------------------------------------------------
		static  TTM_ADDTOOLW := 1074, 		; 0x0432
		TTM_SETMAXTIPWIDTH := 1048, ; 0x0418
				TTF_SUBCLASS := 16, 		; 0x00000010
				TTF_IDISHWND := 1, 			; 0x00000001
				TTF_CENTERTIP := 2 			; 0x00000002
				TTM_UPDATETIPTEXTW := 1081	; 0x0439
		; ---------------------------------------------------------------------------
		; @i ...: 			Check the passed GuiCtrl
		; ---------------------------------------------------------------------------
		If !(GuiCtrl Is Gui.Control)
			Return False
		HGUI := GuiCtrl.Gui.Hwnd
		; ---------------------------------------------------------------------------
		; @i ...: 		Create the TOOLINFO structure 
		; @link ...: 	msdn.microsoft.com/en-us/library/bb760256(v=vs.85).aspx
		; ---------------------------------------------------------------------------
		; @i ...: 		TTF_SUBCLASS | TTF_IDISHWND [| TTF_CENTERTIP]
		; ---------------------------------------------------------------------------
		Flags := 0x11 | (CenterTip ? 0x02 : 0x00)
		TI := Buffer(SizeOfTI, 0)
		; ---------------------------------------------------------------------------
		; @param cbSize
		; @param uFlags
		; @param hwnd
		; @param uID
		; ---------------------------------------------------------------------------
		NumPut("UInt", SizeOfTI, "UInt", Flags, "UPtr", HGUI, "UPtr", HGUI, TI) 
		; ---------------------------------------------------------------------------
		; @i ...: 	Create a tooltip control for this Gui, if needed
		; ---------------------------------------------------------------------------
		If !ToolTips.Has(HGUI) {
			If !(HTT := DllCall(
				"CreateWindowEx", "UInt", 0, "Str", "tooltips_class32", "Ptr", 0, "UInt", 0x80000003, "Int", 0x80000000, "Int", 0x80000000, "Int", 0x80000000, "Int", 0x80000000, "Ptr", HGUI, "Ptr", 0, "Ptr", 0, "Ptr", 0, "UPtr")){
					Return False
			}
			If (UseAhkStyle){
				DllCall("Uxtheme.dll\SetWindowTheme", "Ptr", HTT, "Ptr", 0, "Ptr", 0)
			}
			SendMessage(TTM_ADDTOOLW, 0, TI.Ptr, HTT)
			Tooltips[HGUI] := {HTT: HTT, Ctrls: Map()}
		}
		HTT := Tooltips[HGUI].HTT
		HCTL := GuiCtrl.HWND
		; ---------------------------------------------------------------------------
		; @i ...: Add / remove a tool for this control
		; ---------------------------------------------------------------------------
		NumPut("UPtr", HCTL, TI, 8 + A_PtrSize) ; uID
		NumPut("UPtr", HCTL, TI, 24 + (A_PtrSize * 4)) ; uID
		; ---------------------------------------------------------------------------
		; @i ...: add the control
		; ---------------------------------------------------------------------------
		If !Tooltips[HGUI].Ctrls.Has(HCTL) { 
			If (TipText = ""){
				Return False
			}
			SendMessage(TTM_ADDTOOLW, 0, TI.Ptr, HTT)
			SendMessage(0x0418, 0, -1, HTT) 
			Tooltips[HGUI].Ctrls[HCTL] := True
		}
		; ---------------------------------------------------------------------------
		; @i ...: remove the control
		; ---------------------------------------------------------------------------
		Else If (TipText = "") { 
			SendMessage(0x0433, 0, TI.Ptr, HTT) ; TTM_DELTOOLW
			Tooltips[HGUI].Ctrls.Delete(HCTL)
			Return True
		}
		; ---------------------------------------------------------------------------
		; @i ...: Set / Update the tool's text.
		; ---------------------------------------------------------------------------
		NumPut("UPtr", StrPtr(TipText), TI, 24 + (A_PtrSize * 3))  ; lpszText
		SendMessage(TTM_UPDATETIPTEXTW, 0, TI.Ptr, HTT) ; 
		Return True
	}
	;! ---------------------------------------------------------------------------
	;! ---------------------------------------------------------------------------
	;! ---------------------------------------------------------------------------
	;! ---------------------------------------------------------------------------
	;! ---------------------------------------------------------------------------
	;! ---------------------------------------------------------------------------
	
}
/*
; ---------------------------------------------------------------------------
; @Section ...: 		Testing
; ---------------------------------------------------------------------------
#HotIf WinActive(A_ScriptName)	
	^+1:: {
		RC := Buffer(16, 0)
		DllCall("SendMessage", "Ptr", RTEdit.RE2.HWND, "UInt", 0x00B2, "Ptr", 0, "Ptr", RC.Ptr) ; EM_GETRECT
		CharIndex := DllCall("SendMessage", "Ptr", RTEdit.RE2.HWND, "UInt", 0x00D7, "Ptr", 0, "Ptr", RC.Ptr, "Ptr") ; EM_CHARFROMPOS
		LineIndex := DllCall("SendMessage", "Ptr", RTEdit.RE2.HWND, "UInt", 0x0436, "Ptr", 0, "Ptr", Charindex, "Ptr") ; EM_EXLINEFROMCHAR
		MsgBox("First visible line = " . LineIndex)
	}
	^+f:: {
		static CFM_COLOR := 0x40000000, CFM_BOLD := 0x00000001, CFE_BOLD := 0x00000001
		CS := RTEdit.RE2.GetSel()
		SP := RTEdit.RE2.GetScrollPos()
		RTEdit.RE2.Opt("-Redraw")
		; CF2 := RichEdit.CHARFORMAT2()
		;? retrieve a CHARFORMAT2 object for the current selection
		CF2 := RTEdit.RE2.GetCharFormat()
		CF2.Mask := 0x40000001
		;? colors are BGR
		CF2.TextColor := 0xFF0000
		CF2.Effects := 0x01
		;? start searching at the begin of the text
		RTEdit.RE2.SetSel(0, 0)
		; While (RTEdit.RE2.FindText("Lorem", ["Down"]) != 0) ; find the specific phrase
		; RTEdit.RE2.SetCharFormat(CF2)                    ; apply the new settings
		;? apply the new settings
		RTEdit.RE2.SetCharFormat(CF2)
		CF2 := ""
		; RTEdit.RE2.SetScrollPos(SP.X, SP.Y)
		; RTEdit.RE2.SetSel(CS.X, CS.Y)
		RTEdit.RE2.Opt("+Redraw")
	}
	^+l:: {
		Sel := DllCall("SendMessage", "Ptr", RTEdit.RE2.HWND, "UInt", 0x00BB, "Ptr", 18, "Ptr", 0, "Ptr")
		RTEdit.RE2.SetSel(Sel, Sel)
		RTEdit.RE2.ScrollCaret()
	}
	^+b:: {
		RTEdit.RE2.SetBorder([10], [2])
	}
	; ---------------------------------------------------------------------------
#HotIf