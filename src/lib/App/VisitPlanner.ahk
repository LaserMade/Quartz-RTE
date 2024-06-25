#Requires AutoHotkey v2.0

; #Include <Includes\Includes_Runner>

; static visitplanner(search := '') {
visitplanner() {
	static WaitElement_timeDelay := 3000
	static link := 'https://app.fmglobal.com/polaris/assignments/workload?nav_open=true'
	WinEa := 0, WinEs := 0, WinE := 0, WinA := 0, hCtl := 0, fCtl := 0
	WinT := '',  pA := 'Polaris - Assignments', pS  := 'Sign In'
	static aPolaris := []
	; static mPolaris := Map('a', pA := 'Polaris - Assignments', 's', pS  := 'Sign In -')
	static oPolaris := {a: pA := 'Polaris - Assignments ', s: pS  := 'Sign In -'}
	tryActivate()
	static tryActivate(){
		try {
			for key, value in oPolaris {
				WinActivate(value)
				WinA := WinActive('A')
				WinT := WinGetTitle(WinA)
				(WinT ~= value) ? aPolaris.SafePush(value) : false
			}
		}
		; if (aPolaris.HasValue(mPolaris['a'])) {
		if (aPolaris.HasValue(oPolaris.a)) {
			WinActivate(oPolaris.a)
		}
		; else if (aPolaris.HasValue(mPolaris['s'])) {
		else if (aPolaris.HasValue(oPolaris.s)) {
			login()
            return
		}
		else {
			Browser.RunLink(link)
			WinWaitActive(oPolaris.s)
			login()
            ; return
		}
	}
	static login(){
		mBox := vL := vpN := vpC := vp := fvL := '', fvLT := false
		WinEa := WinEa := 0
		vp := UIA.ElementFromChromium('A',false, WaitElement_timeDelay)
		vp.WaitElement({AutomationId: 'signInName'},WaitElement_timeDelay).Value := 'adam.bacon@fmglobal.com'
		vpC := UIA.ElementFromChromium('A',false,WaitElement_timeDelay)
		; vpC.WaitElement({Name:'Continue', AutomationId:'next'},WaitElement_timeDelay).Invoke()
		vpC.WaitElement({Name:'Continue', AutomationId:'next'},WaitElement_timeDelay).Click(,,,,true)
		; tryActivate()
        ; return
	}
}

visitplannerdocs(classobj := '', account := 0, index := 0){
    wwA := 0, eList := list := [], vp := e := l := ''
    static WaitElement_timeDelay := 3000
    ; list := WinGetList(' ' classobj.i ' - Google Chrome')
    vp := UIA.ElementFromChromium(' ' classobj.i ' - Google Chrome')
    if (vp) {
        vp.SetFocus()
        ; Infos('Site Tab is open')
    }
    else {
        vp := UIA.ElementFromChromium('Polaris - Assignments - Google Chrome')
        if vp {
            vp.SetFocus()
            ; Infos('I activated')
            ; docs(classobj)
        }
    } 
    ; WinExist('Polaris - Assignments - Google Chrome') ? docs(classobj) : polaris(classobj)
    docs(classobj)
    ; polaris(classobj)
    polaris(classobj){
        visitplanner()
        wwA := WinWaitActive('Polaris ',,5)
        Sleep(3000)
        ; Send('^{F4}')
        docs(classobj)
    }
    docs(classObj){
        wE := 0
        classobj ? (account := classobj.a, index := classobj.i) : 0
        docsObj := Object() ; docsObj := {}
        docsObj.d := (Paths.OneDrive '\Polaris')
        docsObj.i := index
        docsObj.doc := (docsObj.d '\' docsObj.i)
        ; d := (Paths.OneDrive '\Polaris') ; , list := [], l := ''
        ; docsObj := {d:(Paths.OneDrive '\Polaris'), i:index, docs: (docsObj.d '\' docsObj.i)}
        ; Infos('Does the Tab ' classobj.sName ' already Exist? ' (WinExist(classobj.sName) ? 'Yes' : 'No'))
        Run('https://app.fmglobal.com/polaris/documents/' account '/' index '?nav_open=true')
        WinWaitActive(classobj.sName,,5)
        Sleep(3000)
        ; !(DirExist(Paths.OneDrive '\Polaris\' index)) ? (Run(Paths.OneDrive '\Polaris\'), MsgBox(Paths.OneDrive '\Polaris\' index ', does not exist.')) : 0
        (!DirExist(docsObj.doc)) ? (Run(docsObj.d), MsgBox(docsObj.doc, ' does not exist.')) : ;0

        ; (wE := WinExist(Paths.OneDrive '\Polaris\' index)) ? WinActivate(wE) : 0
        ((wE := WinExist(docsObj.doc)) ? WinActivate(wE) : Run(docsObj.doc))
        ; DirExist(Paths.OneDrive '\Polaris\' index) ? Run(Paths.OneDrive '\Polaris\' index) : (Run(Paths.OneDrive '\Polaris\'), MsgBox(Paths.OneDrive '\Polaris\' index ', does not exist.'))
    }
    ; return
}

exitvp(){
	ehW := WinExist('Polaris ')
	WaitElement_timeDelay := 30000
	WinActivate(ehW)
	exitV := UIA.ElementFromChromium('A',false,WaitElement_timeDelay).WaitElement({Type:'MenuItem', Name: 'Profile'}, WaitElement_timeDelay).ControlClick()
	UIA.ElementFromChromium('A',false,WaitElement_timeDelay).WaitElement({Type:'MenuItem', Name: 'Log Out'}, WaitElement_timeDelay).ControlCLick()
	wE := WinExist('FM Global - Google Chrome')
	WinActivate(wE)
	wWwE := WinWaitActive(wE)
	wA := WinActive()
	Infos(wWwE '`n' WinGetTitle(Wa))
	Sleep(1000)
	ControlSend('{Ctrl down}{F4}{Ctrl up}',,WinGetTitle(winactive('A')))
	ControlSend('F4',,WinGetTitle(winactive('A')))
	ControlSend('{Ctrl up}',,WinGetTitle(winactive('A')))
	ControlSend('{Ctrl down}{F4}{Ctrl up}',,wA)
	ControlSend('F4',,wA)
	ControlSend('{Ctrl up}',,wA)
}