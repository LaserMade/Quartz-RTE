/************************************************************************
 * @description Rich Text Editor using AHK and JS/HTML/CSS
 * @file Quartz.ahk
 * @author Laser Made
 * @date 2024/08/02
 * @version 0.5
 * @versioncodename Alpha 5
 ***********************************************************************/

#SingleInstance Force
#Requires AutoHotkey v2.0+
#Include <WebView2>
#Include <javascript_strings>
/*You must have WebView2.ahk, Comvar.ahk, and WebView2.dll in the proper directories.
For instance, my WebView2.ahk file is located at: My Documents\AutoHotkey\lib\WebView2.ahk
The "Documents/AutoHotkey/lib" directory is a valid AHK library path that AutoHotkey.exe looks in when including files with <brackets>
*/
Version := "0.4"
Title := A_ScriptName
CodeName := "Alpha " SubStr(Version, 3, 1)
Description := "Rich Text Editor using AHK and JS/HTML/CSS"
A_RootDir := StrReplace(A_ScriptDir, "\src", "")
path := {}
path.src := A_RootDir '/src/'
path.html := path.src 'index.html'
path.css := path.src 'style.css'
path.js := path.src 'script.js'
path.splash := path.src 'splash.mp4'
path.settings := path.src 'settings.ini'

TraySetIcon("shell32.dll", "166")

RTE := Gui()
RTE.Opt(" +Border +Resize")
RTE.Title := "Quartz"
RTE.BackColor := "Black"
RTE.Show("w915 h445")
WV2 := WebView2.create(RTE.Hwnd)
HTML := WV2.CoreWebView2
HTML.Navigate('file:///' path.html)
HTML.AddHostObjectToScript('ahk', { about: about, OpenFile: OpenFile, SaveFile: SaveFile, get: getText, getHTML: getHTML, saveHTML: saveHTML, close: gui_close, minimize: gui_minimize, maximize: gui_maximize, drag: DragTitleBar})
RTE.OnEvent('Close', gui_close)

gui_close(thisgui){
    if MsgBox("Are you sure you want to close Quartz?", 'Close Quartz', "y/n") = "No" {
        return true     ;true means keep it open
    } else {
        HTML := WV2 := 0
        RTE.Destroy()
        ExitApp()
        return false    ;false means close it
    }
}

gui_minimize(thisgui){
    RTE.Minimize()
}

gui_maximize(thisgui){
    RTE.Maximize()
}

/**
 * Function borrowed from Neutron.ahk and modified slightly for use in Quartz.ahk
 * See original usage in Neutron.ahk lines 581 and 126 for use as a class method
 */
DragTitleBar() {
    PostMessage(WM_NCLBUTTONDOWN := 0xA1, 2, 0, , "ahk_id " RTE.Hwnd)
    return RTE
}


/**
 * @API
 * To learn how to use the delta format in JavaScript (which all of the following AHK methods interact with) you need to learn about Deltas, and how to use them.
 * https://quilljs.com/docs/delta
 * Then you have to learn how to go about getting and modifying the contents of the editor.
 * https://quilljs.com/docs/api#content
 */


/**
 * @description
 * There are multiple ways to handle document formatting. One way is to use ComObjects and Query the document class in windows.
 * You can load a document from a file as a ComObject using ComObjGet.
 * @example doc := ComObjGet('document.rtf')
 * ;then you can use the properties of the document to determine it's formatting:
 * doc.characters.item(1).text ;this will give you the first character in the document
 * doc.characters.item(1).italic ;this will return 1 if the character is italic or 0 if it is not
 * doc.sentences.item(1).text ;this will return the first sentence in the document, no formatting
 * doc.content.text ;this will return the entirety of text in the document without any formatting
 * doc.content.WordOpenXML ;this will return the entire document in Word Open XML format. It contains the formatting in XML
 * @info
 * {@link https://learn.microsoft.com/en-us/dotnet/api/microsoft.office.interop.word.range?view=word-pia|This Microsoft page} shows the properties of the Range object that can be used
 * 
 * You can also get more info about the com object using:
 * @example MsgBox "Interface name: " ComObjType(doc, "name") "And value : " ComObjValue(doc)
 */
OpenFile(fileName?) {
    if IsSet(fileName) {
        selected := fileName
    } else {
        selected := FileSelect(,, 'Select a file to open', 'Text Files (*.txt; *.rtf; *.html; *.css; *.js; *.ahk; *.ah2; *.ahk2; *.md; *.ini;)')
    }
    ;selected := FileSelect(,, 'Select a file to open', 'Text Files (*.txt; *.rtf; *.html; *.css; *.js; *.ahk; *.ah2; *.ahk2; *.md; *.ini;)')
    if selected = "" || !FileExist(selected) {
        throw TargetError("File not found: " selected)
    }
    
    if selected.includes('.rtf') {          ;manually handle rtf file insert using clipboard and ComObjects
        doc := ComObjGet(selected)
        tempClip := ClipboardAll()
        ClipWait
        doc.content.formattedText.copy      ;Win32 API copy ComObj _Document content to Clipboard
        ClipWait
        Sleep 300                           ;wait for the copy to finish, alternatively use ClipWait?
        WinActivate(RTE.Hwnd)
        Eval('quill.focus()')
        SendMode("Input")                   ;Edge (and, by extension, WebView2) only support Input mode
        Send('{ctrl down}{v}{ctrl up}{ctrl down}{home}{ctrl up}')   ;paste the contents of the clipboard and go to the top
        Sleep 500
        A_Clipboard := tempClip
        Sleep 300
        tempClip := ''
        return
    } ;else 
    script := 'quill.setContents(['
    userFile := FileOpen(selected, "rw")
    while (!userFile.AtEOF) {
        line := userFile.ReadLine()
        script := script '{insert: "' line '\n"},'
    }
    script := script '{insert: "\n"}]);'                ;new lines must be added at the end of a delta
    Eval(script)
}

OpenRTF() {
    ;https://github.com/iarna/rtf-to-html
}

;not functional yet
copyformattedText() {
    FileOpen('temp.rtf', 'w').Write(HTML.ExecuteScript('quill.getFormattedText()'))
}

pasteFormattedText() {
    WinActivate(RTE.Hwnd)
    Eval('quill.focus()')                  ;Edge (and by extension, WebView2) only support Input mode
    Send('{ctrl down}{v}{ctrl up}{ctrl down}{home}{ctrl up}') 
}

SaveFile(content){
    selected := FileSelect('S',, 'Select a file to save', 'Text Files (*.txt; *.html; *.css; *.js; *.ahk; *.ah2; *.ahk2; *.md; *.ini;)')
    if selected = ""
        return
    if FileExist(selected) {
        overwrite := MsgBox("File already exists, overwrite?", "Overwrite", "YesNo")
        if overwrite.result = 'No'
            return
    }
    FileAppend(content, selected, 'UTF-8-RAW')
}

getText(text) {
    MsgBox(text)
}

getHTML(HtmlStr) {
    return HtmlStr
}

saveHTML(htmlText){
    SaveFile(htmlText)
}

setText(str) {
    Eval('quill.setText("' str '")')
}

about() {
    MsgBox(A_RootDir '\README.md')
    AboutFile := FileOpen(A_RootDir '\README.md', "r")
    script := 'quill.setContents(['
    while (!AboutFile.AtEOF) {
        line := AboutFile.ReadLine()
        script := script '{insert: "' line '\n"},'
    }
    script := script '{insert: "\n"}]);'
    Eval(script)
}

Exit() {
    HTML := WV2 := 0
    RTE.Destroy()
    ExitApp()
}

log(str) {
    HTML.ExecuteScript('console.log(``' str '``);'
    , handlerObj := WebView2.Handler(EvalCompletedHandler))

    EvalCompletedHandler(handler, errorCode, resultObjectAsJson) {
        if errorCode != 0 {
            MsgBox 'Error Code: ' errorCode '`nResult: ' StrGet(resultObjectAsJson)
        }
    }
}

#J::{
    input := InputBox('Enter what you would like to change the editor contents to: ', 'Change Editor Content')
    if input.result != 'cancel'
        setText(input.value)
}
#k::{
    input := InputBox('Log a message to the JS console', 'Console.log')
    if input.result != 'cancel'
        log(str := input.value)
}

#o::{
    Eval('saveAsHTML()')
}

NavigationCompletedEventHandler(handler, ICoreWebView2, NavigationCompletedEventArgs) {
    script :=
        (

        )            ;JS code that AHK executes when the page is loaded

    handlerObj := WebView2.Handler(ExecuteScriptCompletedHandler)
    HTML.ExecuteScript(script, handlerObj)

    ExecuteScriptCompletedHandler(handler, errorCode, resultObjectAsJson) {
        ;MsgBox 'errorCode: ' errorCode '`nresult: ' StrGet(resultObjectAsJson)
    }
}

RTE.OnEvent("Size", gui_size)

/*This function exists to move AHK gui elements when resizing the window and 
to also change the size of the WebView2 container */
gui_size(GuiObj, MinMax, Width, Height) {
    CoordMode("Menu", "Client")
    RTE.GetPos(, , &w, &h)
    HTML.height := h, HTML.width := w
    if (MinMax != -1) {
        try WV2.Fill()
    }
}

OnMessage(WM_SIZE := 0x0005, MinSizing)

MinSizing(wParam, *) {
    if !wParam {
        WinGetPos(,, &w, &h, RTE.Hwnd)
        if w <= 910
            RTE.show('w910')
        if h <= 345
            RTE.show('h345')
    }
}

mid_pos(gui) {
    CoordMode("Menu", "Screen")
    gui.getPos(&x, &y, &w, &h)
    gui_Pos := Map()
    gui_Pos.set("x", x + w / 2)
    gui_Pos.set("y", y + h / 2)
    gui_Pos.set("w", w)
    gui_Pos.set("h", h)
    return gui_Pos
}
;when setting the pos of another window, to base it off of a current gui window's pos you may pass
;modifiers to each x,y,w,h value (+ or -) to offset the new window by.
gui_pos(gui, x_mod?, y_mod?, w_mod?, h_mod?) {
    CoordMode("Menu", "Screen")
    gui.getPos(&x, &y, &w, &h)
    gui_pos := ""
    IsSet(x_mod) ? (gui_pos += "x" . x + x_mod) : (gui_pos += "x" x " ")
    IsSet(y_mod) ? (gui_pos += "y" . y + y_mod) : (gui_pos += "y" y " ")
    IsSet(w_mod) ? (gui_pos += "w" . w + w_mod) : (gui_pos += "w" w " ")
    IsSet(h_mod) ? (gui_pos += "h" . h + h_mod) : (gui_pos += "h" h " ")
    return gui_pos
}

Eval(script) {
    handlerObj := WebView2.Handler(ExecuteScriptCompletedHandler)
    HTML.ExecuteScript(script, handlerObj)
    ExecuteScriptCompletedHandler(handler, errorCode, resultObjectAsJson) {
        if errorCode != 0 {
            MsgBox 'errorCode: ' errorCode '`nresult: ' StrGet(resultObjectAsJson)
        }
    }
}

ToggleOnTop(window) {
    WinSetAlwaysOnTop(-1, window)
}

Settings() {
    initext := ""
    . "(
    (
    [Preferences]

    [Startup]

    [About]
    Version = 
    )"

    if !FileExist(path.settings) {
        try {
            DirCreate(A_ScriptDir "/Resources/")
        }
        catch {
            FileAppend(initext, A_ScriptDir "/Resources/Settings.ini")
        }
    } else {
        ini := iniRead(path.settings, "About")
        if IniRead(path.settings, "About", "Version") != Version
            IniWrite(Version, path.settings, "About", "Version")
        if IniRead(path.settings, "About", "Title") != Title
            IniWrite(Title, path.settings, "About", "Title")
        if IniRead(path.settings, "About", "Status") != CodeName
            IniWrite(CodeName, path.settings, "About", "Status")
        if IniRead(path.settings, "About", "Description") != Description
            IniWrite(Description, path.settings, "About", "Description")
    }
}

;Any Hotkeys in this section will execute only when the script window is active.
#HotIf WinActive(RTE.Hwnd)

^n:: {
    Eval('newFile();')
}

^o::{
    Eval('openFile();')
}

^s:: {
    Eval('saveFile();') 
}

^v::pasteFormattedText()

#HotIf

#+w:: {
    myWindow := WinExist('A')
    myWindowTitle := WinGetTitle(myWindow)
    WinSetAlwaysOnTop(-1, myWindowTitle)
}
^q::{
    HTML := WV2 := 0
    RTE.Destroy()
    ExitApp()
}
    
Num2ABC() {
    Num := InputBox("Enter a number to convert to excel column format").Value
    MsgBox(Num2Alpha(Num))
}
Num2Alpha(num) {
    static ord_A := Ord('A')
    str := ''
    try {
        Loop
            str := Chr(ord_A + Mod(num - 1, 26)) . str
        until !num := (num - 1) // 26
    }
    catch {
        str := "There was an error converting the number."
    }
    return str
}

/**Function to store cursors in a variable for use in {@link |`SetGuiCtrlCursor()`}  
 * @param {Int} cursorId The ID of the cursor
 * @returns {Int} The handle of the cursor image
 * @example C_HAND := LoadCursor(IDC_HAND := 32649) ;loads pointer cursor
 * C_PIN := LoadCursor(IDC_PIN := 32671) ;loads pin cursor
 */
LoadCursor(cursor_ID) {
    static IMAGE_CURSOR := 2, flags := (LR_DEFAULTSIZE := 0x40) | (LR_SHARED := 0x8000)
    return DllCall('LoadImage', 'Ptr', 0, 'UInt', cursor_ID, 'UInt', IMAGE_CURSOR,
        'Int', 0, 'Int', 0, 'UInt', flags, 'Ptr')
}
; -----------------------------------------------------------------------------------------

/**Function to set cursor for a specific gui control. Use {@link |`LoadCursor()`} first.
 * @param {Gui.Control} GuiCtrl The control element on the gui to set the cursor for.
 * @param {Int} CURSOR_HANDLE The handle of the cursor image to set.
 * @example 
 * myBtn := myGui.Add('Button',, 'Testbutton 2')
 * SetGuiCtrlCursor(myBtn, C_HAND) ;sets pointer cursor for Button 'myBtn'
 */
SetGuiCtrlCursor(GuiCtrl, CURSOR_HANDLE) {
    If (A_PtrSize = 8)
        Return DllCall("SetClassLongPtrW", "Ptr", GuiCtrl.Hwnd, "Int", -12, "Ptr", CURSOR_HANDLE, "UPtr")
    Else
        Return DllCall("SetClassLongW", "Ptr", GuiCtrl.Hwnd, "Int", -12, "UInt", CURSOR_HANDLE, "UInt")
}