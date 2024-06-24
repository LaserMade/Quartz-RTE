/************************************************************************
 * @description Rich Text Editor using AHK and JS/HTML/CSS
 * @file Quartz.ahk
 * @author Laser Made
 * @date 2024/06/20
 * @version 0.4
 * @versioncodename Alpha 4
 ***********************************************************************/
#Requires AutoHotkey v2.0+
#Include <WebView2\WebView2>
#Include <Extensions\javascript_strings>
#Include <Directives\__AE.v2>
/*You must have WebView2.ahk, Comvar.ahk, and WebView2.dll in the proper directories.
For instance, my WebView2.ahk file is located at: My Documents\AutoHotkey\lib\WebView2.ahk
The "Documents/AutoHotkey/lib" directory is a valid AHK library path that AutoHotkey.exe looks in when including files with <brackets>
*/

/**
Now you can use the `Quartz` class like this:

text := "This is the text"
editor := Quartz(text)

; To get the text
currentText := editor.GetText()

; To set new text
editor.SetText("New text content")

; To open a file
editor.OpenFile()

; To save the current content
editor.SaveFile(editor.GetText())
```

This class encapsulates the functionality of the rich text editor and provides methods to manipulate the text. The GUI is created when you instantiate the class, and you can interact with it using the provided methods.

Key changes and considerations:

1. The class is initialized with an optional text parameter.
2. Most of the original functions are now methods of the class.
3. The GUI setup is done in the constructor (`__New` method).
4. The WebView2 functionality is retained, allowing for rich text editing.
5. File operations (open and save) are included as methods.
6. The class maintains internal `text` and `html` properties that can be accessed and modified.

Note that this class requires the WebView2 library and assumes that the necessary HTML, CSS, and JS files are present in the correct locations. You may need to adjust file paths and ensure all dependencies are correctly set up for this to work in your environment.

Would you like me to explain any part of this implementation in more detail?
*/
; Global Version := "0.4"
; Global Title := A_ScriptName
; Global CodeName := "Alpha " SubStr(Version, 3, 1)
; Global Description := "Rich Text Editor using AHK and JS/HTML/CSS"
; Global RootDir := StrReplace(A_ScriptDir, "\src", "")
; Global path := {}
; ; path.src := A_RootDir '/src/'
; Global path.src := RootDir '\src'
; Global path.html := path.src '\index.html'
; Global path.css := path.src '\style.css'
; Global path.js := path.src '\script.js'
; Global path.splash := path.src '\splash.mp4'
; Global path.settings := path.src '\settings.ini'

; TraySetIcon("shell32.dll", "166")

;     /**
;      * @API
;      * To learn how to use the delta format in JavaScript (which all of the following AHK methods interact with) you need to learn about Deltas, and how to use them.
;      * https://quilljs.com/docs/delta
;      * Then you have to learn how to go about getting and modifying the contents of the editor.
;      * https://quilljs.com/docs/api#content
;      */


;     /**
;      * @description
;      * There are multiple ways to handle document formatting. One way is to use ComObjects and Query the document class in windows.
;      * You can load a document from a file as a ComObject using ComObjGet.
;      * @example doc := ComObjGet('document.rtf')
;      * ;then you can use the properties of the document to determine it's formatting:
;      * doc.characters.item(1).text ;this will give you the first character in the document
;      * doc.characters.item(1).italic ;this will return 1 if the character is italic or 0 if it is not
;      * doc.sentences.item(1).text ;this will return the first sentence in the document, no formatting
;      * doc.content.text ;this will return the entirety of text in the document without any formatting
;      * doc.content.WordOpenXML ;this will return the entire document in Word Open XML format. It contains the formatting in XML
;      * @info
;      * {@link https://learn.microsoft.com/en-us/dotnet/api/microsoft.office.interop.word.range?view=word-pia|This Microsoft page} shows the properties of the Range object that can be used
;      * 
;      * You can also get more info about the com object using:
;      * @example MsgBox "Interface name: " ComObjType(doc, "name") "And value : " ComObjValue(doc)
;      */
class Quartz {



	filetypes := 'Text Files (*.txt; *.rtf; *.html; *.css; *.js; *.ahk; *.ah2; *.ahk2; *.md; *.ini;)'
	selected := ''
	userfile := ''
	savedfile := ''

    __New(text := "") {
        this.text := text
		TraySetIcon("shell32.dll", "166")
		this.Version := "0.4"
		this.Title := A_ScriptName
		this.CodeName := "Alpha " SubStr(this.Version, 3, 1)
		this.Description := "Rich Text Editor using AHK and JS/HTML/CSS"
		this.A_RootDir := StrReplace(A_ScriptDir, "\src", "")
		this.path := {}
		; path.src := A_RootDir '/src/'
		this.path.src := this.A_RootDir '\src\'
		this.path.html := this.path.src 'index.html'
		this.path.css := this.path.src 'style.css'
		this.path.js := this.path.src 'script.js'
		this.path.splash := this.path.src 'splash.mp4'
		this.path.settings := this.path.src 'settings.ini'
        this.SetupGUI()
    }

    SetupGUI() {


        this.RTE := Gui()
        this.RTE.Opt(" +Border +Resize")
        this.RTE.Title := "Quartz"
        this.RTE.BackColor := "Black"
        this.RTE.Show("w915 h445")
        
        this.WV2 := WebView2.create(this.RTE.Hwnd)
        this.HTML := this.WV2.CoreWebView2
        this.HTML.Navigate('file:///' A_ScriptDir '\src\index.html')
        this.HTML.AddHostObjectToScript('ahk', { 
            about: this.About.Bind(this), 
            OpenFile: this.OpenFile.Bind(this), 
            SaveFile: this.SaveFile.Bind(this), 
            get: this.GetText.Bind(this), 
            getHTML: this.GetHTML.Bind(this), 
            exit: this.Exit.Bind(this) 
        })

        this.RTE.OnEvent('Close', (*) => this.Exit())
        this.RTE.OnEvent("Size", this.GuiSize.Bind(this))

        OnMessage(0x0005, this.MinSizing.Bind(this))  ; WM_SIZE
    }

    SetText(str) {
        this.text := str
        this.Eval('quill.setText("' str '")')
    }

    GetText(str := "") {
        if (str != "")
            this.text := str
        return this.text
    }

    GetHTML(HtmlStr := "") {
        if (HtmlStr != "")
            this.html := HtmlStr
        return this.html
    }

    OpenFile(savedfile := "") {
        if (savedfile = "") {
            selected := FileSelect(,, "Select a file to open", this.filetypes)
        } else {
            selected := savedfile
        }

        if (selected = "" || !FileExist(selected)) {
            return
        }

        this.selected := selected

        if (InStr(selected, ".rtf")) {
            this.OpenRTF(selected)
        } else {
            this.OpenTextFile(selected)
        }
    }

    OpenRTF(file) {
        try {
            doc := ComObject("Word.Document")
            doc.Open(file)
            
            AE.cBakClr(&cBak)
            AE.SM(&sm)
            
            doc.content.formattedText.copy()
            AE.cSleep()
            
            WinActivate(this.RTE.Hwnd)
            this.Eval('quill.focus()')
            
            Send("{Ctrl Down}v{Ctrl Up}")
            
            AE.rSM(sm)
            AE.cRestore(cBak)
            
            doc.Close()
        } catch as err {
            MsgBox("Error opening RTF file: " err.Message)
        }
    }

    OpenTextFile(file) {
        try {
            script := "quill.setContents(["
            userFile := FileOpen(file, "r")
            
            while (!userFile.AtEOF) {
                line := StrReplace(userFile.ReadLine(), '"', '\"')  ; Escape double quotes
                script .= '{insert: "' line '\n"},'
            }
            
            script .= '{insert: "\n"}]);'
            this.Eval(script)
            
            userFile.Close()
        } catch as err {
            MsgBox("Error opening text file: " err.Message)
        }
    }

    SaveFile(content) {
        selected := FileSelect('S',, 'Select a file to save', this.filetypes)
        if (selected = "")
            return
        if FileExist(selected) {
            overwrite := MsgBox("File already exists, overwrite?", "Overwrite", "YesNo")
            if (overwrite != "Yes")
                return
        }
        FileAppend(content, selected)
    }

    About() {
        MsgBox("Quartz " this.Version "`n" this.CodeName "`n" this.Description)
    }

    Exit() {
        this.HTML := this.WV2 := 0
        this.RTE.Destroy()
        ExitApp()
    }

    GuiSize(GuiObj, MinMax, Width, Height) {
        if (MinMax = -1)
            return
        this.RTE.GetPos(, , &w, &h)
        this.HTML.height := h
        this.HTML.width := w
        try this.WV2.Fill()
    }

    MinSizing(wParam, *) {
        if (!wParam) {
            this.RTE.GetPos(, , &w, &h)
            if (w <= 910)
                this.RTE.Show('w910')
            if (h <= 345)
                this.RTE.Show('h345')
        }
    }

    Eval(script) {
        this.HTML.ExecuteScript(script)
    }

    Log(str) {
        this.Eval("console.log(`' str ');")
    }
}



;     static filetypes := 'Text Files (*.txt; *.rtf; *.html; *.css; *.js; *.ahk; *.ah2; *.ahk2; *.md; *.ini;)'
;     static selected := ''
;     static userfile := ''
;     static savedfile := ''
    

    ; OpenFile(savedfile?) {
    ;     selected    := this.selected
    ;     savedfile   := this.savedfile
    ;     if (savedfile := '') {
    ;         selected := FileSelect(,, 'Select a file to open', this.filetypes)
    ;     } else {
    ;         selected := savedfile
    ;     }
    ;     if (selected = "" || !FileExist(selected)){
    ;         return
    ;     }
    ;     ; ---------------------------------------------------------------------------
    ;     ; @region...: Manually handle rtf file insert using clipboard and ComObjects
    ;     ; ---------------------------------------------------------------------------
    ;     if selected.includes('.rtf') {          
    ;         doc := ComObjGet(selected)
    ;         ; ---------------------------------------------------------------------------
    ;         ; tempClip := ClipboardAll()
    ;         ; ClipWait()
    ;         ;? This one class method replaces both of those, is faster, and more reliable
    ;         ;? The method also includes AE.cSleep()[clipboard sleep]
    ;         ;? Which includes a "wait until the clipboard is not busy" part
    ;         AE.cBakClr(&cBak) 
    ;         ; ---------------------------------------------------------------------------
    ;         ; Edge (and by extension, WebView2) only support Input mode
    ;         ;? AE.SM() stores previous settings, and changes the SendMode() to SendMode('Event')
    ;         ; SendMode("Input")                   
    ;         AE.SM(&sm)
    ;         ; ---------------------------------------------------------------------------
    ;         doc.content.formattedText.copy()
    ;         ; ---------------------------------------------------------------------------
    ;         ; wait for the copy to finish, alternatively use ClipWait?
    ;         ; Sleep(300)                           
    ;         ; ClipWait()
    ;         AE.cSleep()
    ;         ;? AE.cSleep() includes a "wait until the clipboard is not busy" part => ~= ClipWait() but faster
    ;         ; ---------------------------------------------------------------------------
    ;         ; @i...: Activate the RTE window and "ControlFocus()" the edit control
    ;         ; ---------------------------------------------------------------------------
    ;         WinActivate(RTE.Hwnd)
    ;         this.Eval('quill.focus()')
    ;         ; ---------------------------------------------------------------------------
    ;         ; Send('{ctrl down}{v}{ctrl up}{ctrl down}{home}{ctrl up}')   ;paste the contents of the clipboard and go to the top
    ;         ; Send('{ctrl down}v{home}{ctrl up}')   ;paste the contents of the clipboard and go to the top
    ;         Send(key.ctrldown key.v key.ctrlup)
    ;         ; ---------------------------------------------------------------------------
    ;         ; Sleep(500)
    ;         ; AE.cSleep(100)
    ;         ;? I added a SetTimer(AE.cSleep(), -500) to AE.cRestore()
    ;         ; ---------------------------------------------------------------------------
    ;         ; A_Clipboard := tempClip
    ;         ; Sleep(300)
    ;         ; tempClip := ''
    ;         AE.rSM(sm)
    ;         AE.cRestore(cBak)
    ;         ; return
    ;     } ;else 
    ;     script := 'quill.setContents(['
    ;     userFile := FileOpen(selected, "rw")
    ;     this.userfile := userFile
    ;     while (!userFile.AtEOF) {
    ;         line := userFile.ReadLine()
    ;         script := script '{insert: "' line '\n"},'
    ;     }
    ;     ; ---------------------------------------------------------------------------
    ;     ; @i...: new lines must be added at the end of a delta
    ;     ; ---------------------------------------------------------------------------
    ;     script := script '{insert: "\n"}]);'
    ;     this.Eval(script)
    ; }
        
;     static SaveFile(content){
;         if this.userfile := ''{
;             selected := FileSelect('S',, 'Select a file to save', this.filetypes)
;             if selected = ""{
;                 return
;             }
;         } else {
;             selected := FileSelect('S',this.userfile, 'Select a file to save', this.filetypes)
;         }
;         if FileExist(selected) {
;             overwrite := MsgBox("File already exists, overwrite?", "Overwrite", "YesNo")
;             if (overwrite.result = 'No'){
;                 return
;             }
;         }
;         FileAppend(content, selected)
;     }

;     static getText(str) {
;         MsgBox(str)
;     }

;     static getHTML(HtmlStr) {
;         MsgBox(HtmlStr)
;     }

;     static setText(str) {
;         this.Eval('quill.setText("' str '")')
;     }

;     static about() {
;         MsgBox(A_RootDir '\README.md')
;         AboutFile := FileOpen(A_RootDir '\README.md', "r")
;         script := 'quill.setContents(['
;         while (!AboutFile.AtEOF) {
;             line := AboutFile.ReadLine()
;             script := script '{insert: "' line '\n"},'
;         }
;         script := script '{insert: "\n"}]);'
;         QuartzRTE.Eval(script)
;     }

;     static Exit(RTE) {
;         HTML := WV2 := 0
;         RTE.Destroy()
;         ExitApp()
;     }

;     static log(str) {
;         HTML.ExecuteScript('console.log(``' str '``);'
;         , handlerObj := WebView2.Handler(EvalCompletedHandler))

;         EvalCompletedHandler(handler, errorCode, resultObjectAsJson) {
;             if errorCode != 0 {
;                 MsgBox('Error Code: ' errorCode '`nResult: ' StrGet(resultObjectAsJson))
;             }
;         }
;     }

    
;     static RunRTE(&RTE?){
;         RTE := Gui()
;         RTE.Opt(" +Border +Resize")
;         RTE.Title := "Quartz"
;         RTE.BackColor := "Black"
;         RTE.Show("w915 h445")
;         hWndRTE := RTE.Hwnd
;         global WV2 := WebView2.create(RTE.Hwnd)
;         global HTML := WV2.CoreWebView2
;         HTML.Navigate('file:///' path.html)
;         HTML.AddHostObjectToScript('ahk', {
;             about:      this.about,
;             OpenFile:   this.OpenFile,
;             SaveFile:   this.SaveFile,
;             get:        this.getText,
;             getHTML:    this.getHTML,
;             exit:       this.Exit }
;         )
;         RTE.OnEvent('Close', (*) => {
;             function: (
;                 HTML := WV2 := 0
;                 RTE.Destroy()
;                 ExitApp()
;             )
;         }
;         )
;         RTE.OnEvent("Size", (*) => this.gui_size)
;         OnMessage(WM_SIZE := 0x0005, this.MinSizing)
;         HotIfWinActive(RTE.Hwnd)
;         Hotkey('^n', (*) => this.Eval('newFile();'), 'ON')
;         Hotkey('^o', (*) => this.Eval('openFile();'), 'ON')
;         Hotkey('^s', (*) => this.Eval('saveFile();'), 'ON')
;         Hotkey('^q', (*) => this.Quit(RTE), 'ON')
;         Hotkey('#+w', (*) => this.MyWinOnTop(), 'ON')
;         HotIf()
;         return RTE
;     }

;     static Quit(RTE){
        
;             HTML := WV2 := 0
;             RTE.Destroy()
;             ExitApp()
;     }
;     static MyWinOnTop(){
;             myWindow := WinExist('A')
;             myWindowTitle := WinGetTitle(myWindow)
;             WinSetAlwaysOnTop(-1, myWindowTitle)
;     }
;     __New(&hWndRTE?){
;         QuartzRTE.RunRTE(&RTE)

        
;         ;Any Hotkeys in this section will execute only when the script window is active.
        

    

;     }


;         ; #J::{
;         ;     input := InputBox('Enter what you would like to change the editor contents to: ', 'Change Editor Content')
;         ;     if input.result != 'cancel'
;         ;         setText(input.value)
;         ; }
;         ; #k::{
;         ;     input := InputBox('Log a message to the JS console', 'Console.log')
;         ;     if input.result != 'cancel'
;         ;         log(str := input.value)
;         ; }

;         static NavigationCompletedEventHandler(handler, ICoreWebView2, NavigationCompletedEventArgs) {
;             script :=
;                 (

;                 )            ;JS code that AHK executes when the page is loaded

;             handlerObj := WebView2.Handler(ExecuteScriptCompletedHandler)
;             HTML.ExecuteScript(script, handlerObj)

;             ExecuteScriptCompletedHandler(handler, errorCode, resultObjectAsJson) {
;                 ;MsgBox 'errorCode: ' errorCode '`nresult: ' StrGet(resultObjectAsJson)
;             }
;         }

;         ; RTE.OnEvent("Size", gui_size)

;         /*This function exists to move AHK gui elements when resizing the window and 
;         to also change the size of the WebView2 container */
;         static gui_size(GuiObj, MinMax, Width, Height) {
;             RTE := GuiObj
;             CoordMode("Menu", "Client")
;             RTE.GetPos(, , &w, &h)
;             HTML.height := h, HTML.width := w
;             if (MinMax != -1) {
;                 try WV2.Fill()
;             }
;         }

;         ; OnMessage(WM_SIZE := 0x0005, MinSizing)

;         static MinSizing(wParam, RTE,*) {
;             if !wParam {
;                 WinGetPos(,, &w, &h, RTE.Hwnd)
;                 if w <= 910
;                     RTE.show('w910')
;                 if h <= 345
;                     RTE.show('h345')
;             }
;         }

;         static mid_pos(gui) {
;             CoordMode("Menu", "Screen")
;             gui.getPos(&x, &y, &w, &h)
;             gui_Pos := Map()
;             gui_Pos.set("x", x + w / 2)
;             gui_Pos.set("y", y + h / 2)
;             gui_Pos.set("w", w)
;             gui_Pos.set("h", h)
;             return gui_Pos
;         }
;         ;when setting the pos of another window, to base it off of a current gui window's pos you may pass
;         ;modifiers to each x,y,w,h value (+ or -) to offset the new window by.
;         static gui_pos(gui, x_mod?, y_mod?, w_mod?, h_mod?) {
;             CoordMode("Menu", "Screen")
;             gui.getPos(&x, &y, &w, &h)
;             gui_pos := ""
;             IsSet(x_mod) ? (gui_pos += "x" . x + x_mod) : (gui_pos += "x" x " ")
;             IsSet(y_mod) ? (gui_pos += "y" . y + y_mod) : (gui_pos += "y" y " ")
;             IsSet(w_mod) ? (gui_pos += "w" . w + w_mod) : (gui_pos += "w" w " ")
;             IsSet(h_mod) ? (gui_pos += "h" . h + h_mod) : (gui_pos += "h" h " ")
;             return gui_pos
;         }

;         static Eval(script) {
;             handlerObj := WebView2.Handler(ExecuteScriptCompletedHandler)
;             HTML.ExecuteScript(script, handlerObj)
;             ExecuteScriptCompletedHandler(handler, errorCode, resultObjectAsJson) {
;                 if errorCode != 0 {
;                     MsgBox('errorCode: ' errorCode '`nresult: ' StrGet(resultObjectAsJson))
;                 }
;             }
;         }

;         static ToggleOnTop(window) {
;             WinSetAlwaysOnTop(-1, window)
;         }

;         static Settings() {
;             initext := ""
;             . "(
;             (
;             [Preferences]

;             [Startup]

;             [About]
;             Version = 
;             )"

;             if !FileExist(path.settings) {
;                 try {
;                     DirCreate(A_ScriptDir "/Resources/")
;                 }
;                 catch {
;                     FileAppend(initext, A_ScriptDir "/Resources/Settings.ini")
;                 }
;             } else {
;                 ini := iniRead(path.settings, "About")
;                 if IniRead(path.settings, "About", "Version") != Version
;                     IniWrite(Version, path.settings, "About", "Version")
;                 if IniRead(path.settings, "About", "Title") != Title
;                     IniWrite(Title, path.settings, "About", "Title")
;                 if IniRead(path.settings, "About", "Status") != CodeName
;                     IniWrite(CodeName, path.settings, "About", "Status")
;                 if IniRead(path.settings, "About", "Description") != Description
;                     IniWrite(Description, path.settings, "About", "Description")
;             }
;         }

;         ; ;Any Hotkeys in this section will execute only when the script window is active.
;         ; HotIfWinActive(RTE.Hwnd)

;         ; ^n:: {
;         ;     Eval('newFile();')
;         ; }

;         ; ^o::{
;         ;     Eval('openFile();')
;         ; }

;         ; ^s:: {
;         ;     Eval('saveFile();') 
;         ; }

;         ; #HotIf

;         ; #+w:: {
;         ;     myWindow := WinExist('A')
;         ;     myWindowTitle := WinGetTitle(myWindow)
;         ;     WinSetAlwaysOnTop(-1, myWindowTitle)
;         ; }
;         ; ^q::{
;         ;     HTML := WV2 := 0
;         ;     RTE.Destroy()
;         ;     ExitApp()
;         ; }
            
;         static Num2ABC() {
;             Num := InputBox("Enter a number to convert to excel column format").Value
;             MsgBox(this.Num2Alpha(Num))
;         }
;         static Num2Alpha(num) {
;             static ord_A := Ord('A')
;             str := ''
;             try {
;                 Loop
;                     str := Chr(ord_A + Mod(num - 1, 26)) . str
;                 until !num := (num - 1) // 26
;             }
;             catch {
;                 str := "There was an error converting the number."
;             }
;             return str
;         }

;         /**Function to store cursors in a variable for use in {@link |`SetGuiCtrlCursor()`}  
;          * @param {Int} cursorId The ID of the cursor
;          * @returns {Int} The handle of the cursor image
;          * @example C_HAND := LoadCursor(IDC_HAND := 32649) ;loads pointer cursor
;          * C_PIN := LoadCursor(IDC_PIN := 32671) ;loads pin cursor
;          */
;         static LoadCursor(cursor_ID) {
;             static IMAGE_CURSOR := 2, flags := (LR_DEFAULTSIZE := 0x40) | (LR_SHARED := 0x8000)
;             return DllCall('LoadImage', 'Ptr', 0, 'UInt', cursor_ID, 'UInt', IMAGE_CURSOR,
;                 'Int', 0, 'Int', 0, 'UInt', flags, 'Ptr')
;         }
;         ; -----------------------------------------------------------------------------------------

;         /**Function to set cursor for a specific gui control. Use {@link |`LoadCursor()`} first.
;          * @param {Gui.Control} GuiCtrl The control element on the gui to set the cursor for.
;          * @param {Int} CURSOR_HANDLE The handle of the cursor image to set.
;          * @example 
;          * myBtn := myGui.Add('Button',, 'Testbutton 2')
;          * SetGuiCtrlCursor(myBtn, C_HAND) ;sets pointer cursor for Button 'myBtn'
;          */
;         static SetGuiCtrlCursor(GuiCtrl, CURSOR_HANDLE) {
;             If (A_PtrSize = 8)
;                 Return DllCall("SetClassLongPtrW", "Ptr", GuiCtrl.Hwnd, "Int", -12, "Ptr", CURSOR_HANDLE, "UPtr")
;             Else
;                 Return DllCall("SetClassLongW", "Ptr", GuiCtrl.Hwnd, "Int", -12, "UInt", CURSOR_HANDLE, "UInt")
;         }
    
; }

; ; RunRTE(){
; ;     RTE := Gui()
; ;     RTE.Opt(" +Border +Resize")
; ;     RTE.Title := "Quartz"
; ;     RTE.BackColor := "Black"
; ;     RTE.Show("w915 h445")
; ;     WV2 := WebView2.create(RTE.Hwnd)
; ;     global HTML := WV2.CoreWebView2
; ;     HTML.Navigate('file:///' path.html)
; ;     HTML.AddHostObjectToScript('ahk', { about: about, OpenFile: OpenFile, SaveFile: SaveFile, get: getText, getHTML: QgetHTML, exit: Exit })
; ;     RTE.OnEvent('Close', (*) => {function: (
; ;         HTML := WV2 := 0
; ;         RTE.Destroy()
; ;         ExitApp()
; ;     )})
; ; }


; ; OpenFile() => Quartz.OpenFile()
; ; OpenFile() {
; ; 	selected := QVars.selected
; ; 	selected := FileSelect(,, 'Select a file to open', QVars.filetypes)
; ; 	if (selected = "" || !FileExist(selected)){
; ; 		return
; ; 	}
; ; 	; ---------------------------------------------------------------------------
; ; 	; @region...: Manually handle rtf file insert using clipboard and ComObjects
; ; 	; ---------------------------------------------------------------------------
; ; 	if selected.includes('.rtf') {          
; ; 		doc := ComObjGet(selected)
; ; 		; ---------------------------------------------------------------------------
; ; 		; tempClip := ClipboardAll()
; ; 		; ClipWait()
; ; 		;? This one class method replaces both of those, is faster, and more reliable
; ; 		;? The method also includes AE.cSleep()[clipboard sleep]
; ; 		;? Which includes a "wait until the clipboard is not busy" part
; ; 		AE.cBakClr(&cBak) 
; ; 		; ---------------------------------------------------------------------------
; ; 		AE.SM(&sm)
; ; 		doc.content.formattedText.copy()
; ; 		; ClipWait()
; ; 		AE.cSleep()
; ; 		; Sleep(300)                           ;wait for the copy to finish, alternatively use ClipWait?
; ; 		WinActivate(RTE.Hwnd)
; ; 		Eval('quill.focus()')
; ; 		; SendMode("Input")                   ;Edge (and by extension, WebView2) only support Input mode
; ; 		Send('{ctrl down}{v}{ctrl up}{ctrl down}{home}{ctrl up}')   ;paste the contents of the clipboard and go to the top
; ; 		Send(key.ctrldown key.v key.ctrl)
; ; 		; Sleep(500)
; ; 		; AE.cSleep(100)
; ; 		; A_Clipboard := tempClip
; ; 		; Sleep(300)
; ; 		; tempClip := ''
; ; 		AE.rSM(sm)
; ; 		AE.cRestore(cBak)
; ; 		return
; ; 	} ;else 
; ; 	script := 'quill.setContents(['
; ; 	userFile := FileOpen(selected, "rw")
; ;     QVars.userfile := userFile
; ; 	while (!userFile.AtEOF) {
; ; 		line := userFile.ReadLine()
; ; 		script := script '{insert: "' line '\n"},'
; ; 	}
; ; 	; ---------------------------------------------------------------------------
; ; 	; @i...: new lines must be added at the end of a delta
; ; 	; ---------------------------------------------------------------------------
; ; 	script := script '{insert: "\n"}]);'
; ; 	Eval(script)
; ; }

; ; SaveFile(content){
; ;     if QVars.userfile := ''{
; ;         selected := FileSelect('S',, 'Select a file to save', QVars.filetypes)
; ;         if selected = ""{
; ;             return
; ;         }
; ;     } else {
; ;         selected := FileSelect('S',QVars.userfile, 'Select a file to save', QVars.filetypes)
; ;     }
; ; 	if FileExist(selected) {
; ; 		overwrite := MsgBox("File already exists, overwrite?", "Overwrite", "YesNo")
; ; 		if (overwrite.result = 'No'){
; ; 			return
; ; 		}
; ; 	}
; ; 	FileAppend(content, selected)
; ; }

; ; getText(str) {
; ;     MsgBox(str)
; ; }

; ; QgetHTML(HtmlStr) {
; ;     MsgBox(HtmlStr)
; ; }

; ; setText(str) {
; ;     Eval('quill.setText("' str '")')
; ; }

; ; about() {
; ;     MsgBox(A_RootDir '\README.md')
; ;     AboutFile := FileOpen(A_RootDir '\README.md', "r")
; ;     script := 'quill.setContents(['
; ;     while (!AboutFile.AtEOF) {
; ;         line := AboutFile.ReadLine()
; ;         script := script '{insert: "' line '\n"},'
; ;     }
; ;     script := script '{insert: "\n"}]);'
; ;     Eval(script)
; ; }

; ; Exit() {
; ;     HTML := WV2 := 0
; ;     RTE.Destroy()
; ;     ExitApp()
; ; }

; ; log(str) {
; ;     HTML.ExecuteScript('console.log(``' str '``);'
; ;     , handlerObj := WebView2.Handler(EvalCompletedHandler))

; ;     EvalCompletedHandler(handler, errorCode, resultObjectAsJson) {
; ;         if errorCode != 0 {
; ;             MsgBox('Error Code: ' errorCode '`nResult: ' StrGet(resultObjectAsJson))
; ;         }
; ;     }
; ; }

; ; #J::{
; ;     input := InputBox('Enter what you would like to change the editor contents to: ', 'Change Editor Content')
; ;     if input.result != 'cancel'
; ;         setText(input.value)
; ; }
; ; #k::{
; ;     input := InputBox('Log a message to the JS console', 'Console.log')
; ;     if input.result != 'cancel'
; ;         log(str := input.value)
; ; }

; ; NavigationCompletedEventHandler(handler, ICoreWebView2, NavigationCompletedEventArgs) {
; ;     script :=
; ;         (

; ;         )            ;JS code that AHK executes when the page is loaded

; ;     handlerObj := WebView2.Handler(ExecuteScriptCompletedHandler)
; ;     HTML.ExecuteScript(script, handlerObj)

; ;     ExecuteScriptCompletedHandler(handler, errorCode, resultObjectAsJson) {
; ;         ;MsgBox 'errorCode: ' errorCode '`nresult: ' StrGet(resultObjectAsJson)
; ;     }
; ; }

; ; RTE.OnEvent("Size", gui_size)

; ; /*This function exists to move AHK gui elements when resizing the window and 
; ; to also change the size of the WebView2 container */
; ; gui_size(GuiObj, MinMax, Width, Height) {
; ;     CoordMode("Menu", "Client")
; ;     RTE.GetPos(, , &w, &h)
; ;     HTML.height := h, HTML.width := w
; ;     if (MinMax != -1) {
; ;         try WV2.Fill()
; ;     }
; ; }

; ; OnMessage(WM_SIZE := 0x0005, MinSizing)

; ; MinSizing(wParam, *) {
; ;     if !wParam {
; ;         WinGetPos(,, &w, &h, RTE.Hwnd)
; ;         if w <= 910
; ;             RTE.show('w910')
; ;         if h <= 345
; ;             RTE.show('h345')
; ;     }
; ; }

; ; mid_pos(gui) {
; ;     CoordMode("Menu", "Screen")
; ;     gui.getPos(&x, &y, &w, &h)
; ;     gui_Pos := Map()
; ;     gui_Pos.set("x", x + w / 2)
; ;     gui_Pos.set("y", y + h / 2)
; ;     gui_Pos.set("w", w)
; ;     gui_Pos.set("h", h)
; ;     return gui_Pos
; ; }
; ; ;when setting the pos of another window, to base it off of a current gui window's pos you may pass
; ; ;modifiers to each x,y,w,h value (+ or -) to offset the new window by.
; ; gui_pos(gui, x_mod?, y_mod?, w_mod?, h_mod?) {
; ;     CoordMode("Menu", "Screen")
; ;     gui.getPos(&x, &y, &w, &h)
; ;     gui_pos := ""
; ;     IsSet(x_mod) ? (gui_pos += "x" . x + x_mod) : (gui_pos += "x" x " ")
; ;     IsSet(y_mod) ? (gui_pos += "y" . y + y_mod) : (gui_pos += "y" y " ")
; ;     IsSet(w_mod) ? (gui_pos += "w" . w + w_mod) : (gui_pos += "w" w " ")
; ;     IsSet(h_mod) ? (gui_pos += "h" . h + h_mod) : (gui_pos += "h" h " ")
; ;     return gui_pos
; ; }

; ; Eval(script) {
; ;     handlerObj := WebView2.Handler(ExecuteScriptCompletedHandler)
; ;     HTML.ExecuteScript(script, handlerObj)
; ;     ExecuteScriptCompletedHandler(handler, errorCode, resultObjectAsJson) {
; ;         if errorCode != 0 {
; ;             MsgBox('errorCode: ' errorCode '`nresult: ' StrGet(resultObjectAsJson))
; ;         }
; ;     }
; ; }

; ; ToggleOnTop(window) {
; ;     WinSetAlwaysOnTop(-1, window)
; ; }

; ; Settings() {
; ;     initext := ""
; ;     . "(
; ;     (
; ;     [Preferences]

; ;     [Startup]

; ;     [About]
; ;     Version = 
; ;     )"

; ;     if !FileExist(path.settings) {
; ;         try {
; ;             DirCreate(A_ScriptDir "/Resources/")
; ;         }
; ;         catch {
; ;             FileAppend(initext, A_ScriptDir "/Resources/Settings.ini")
; ;         }
; ;     } else {
; ;         ini := iniRead(path.settings, "About")
; ;         if IniRead(path.settings, "About", "Version") != Version
; ;             IniWrite(Version, path.settings, "About", "Version")
; ;         if IniRead(path.settings, "About", "Title") != Title
; ;             IniWrite(Title, path.settings, "About", "Title")
; ;         if IniRead(path.settings, "About", "Status") != CodeName
; ;             IniWrite(CodeName, path.settings, "About", "Status")
; ;         if IniRead(path.settings, "About", "Description") != Description
; ;             IniWrite(Description, path.settings, "About", "Description")
; ;     }
; ; }

; ; ;Any Hotkeys in this section will execute only when the script window is active.
; ; #HotIf WinActive(RTE.Hwnd)

; ; ^n:: {
; ;     Eval('newFile();')
; ; }

; ; ^o::{
; ;     Eval('openFile();')
; ; }

; ; ^s:: {
; ;     Eval('saveFile();') 
; ; }

; ; #HotIf

; ; #+w:: {
; ;     myWindow := WinExist('A')
; ;     myWindowTitle := WinGetTitle(myWindow)
; ;     WinSetAlwaysOnTop(-1, myWindowTitle)
; ; }
; ; ^q::{
; ;     HTML := WV2 := 0
; ;     RTE.Destroy()
; ;     ExitApp()
; ; }
    
; ; Num2ABC() {
; ;     Num := InputBox("Enter a number to convert to excel column format").Value
; ;     MsgBox(Num2Alpha(Num))
; ; }
; ; Num2Alpha(num) {
; ;     static ord_A := Ord('A')
; ;     str := ''
; ;     try {
; ;         Loop
; ;             str := Chr(ord_A + Mod(num - 1, 26)) . str
; ;         until !num := (num - 1) // 26
; ;     }
; ;     catch {
; ;         str := "There was an error converting the number."
; ;     }
; ;     return str
; ; }

; ; /**Function to store cursors in a variable for use in {@link |`SetGuiCtrlCursor()`}  
; ;  * @param {Int} cursorId The ID of the cursor
; ;  * @returns {Int} The handle of the cursor image
; ;  * @example C_HAND := LoadCursor(IDC_HAND := 32649) ;loads pointer cursor
; ;  * C_PIN := LoadCursor(IDC_PIN := 32671) ;loads pin cursor
; ;  */
; ; LoadCursor(cursor_ID) {
; ;     static IMAGE_CURSOR := 2, flags := (LR_DEFAULTSIZE := 0x40) | (LR_SHARED := 0x8000)
; ;     return DllCall('LoadImage', 'Ptr', 0, 'UInt', cursor_ID, 'UInt', IMAGE_CURSOR,
; ;         'Int', 0, 'Int', 0, 'UInt', flags, 'Ptr')
; ; }
; ; ; -----------------------------------------------------------------------------------------

; ; /**Function to set cursor for a specific gui control. Use {@link |`LoadCursor()`} first.
; ;  * @param {Gui.Control} GuiCtrl The control element on the gui to set the cursor for.
; ;  * @param {Int} CURSOR_HANDLE The handle of the cursor image to set.
; ;  * @example 
; ;  * myBtn := myGui.Add('Button',, 'Testbutton 2')
; ;  * SetGuiCtrlCursor(myBtn, C_HAND) ;sets pointer cursor for Button 'myBtn'
; ;  */
; ; SetGuiCtrlCursor(GuiCtrl, CURSOR_HANDLE) {
; ;     If (A_PtrSize = 8)
; ;         Return DllCall("SetClassLongPtrW", "Ptr", GuiCtrl.Hwnd, "Int", -12, "Ptr", CURSOR_HANDLE, "UPtr")
; ;     Else
; ;         Return DllCall("SetClassLongW", "Ptr", GuiCtrl.Hwnd, "Int", -12, "UInt", CURSOR_HANDLE, "UInt")
; ; }