#Requires AutoHotkey v2+
#Include <Directives\__AE.v2>
Peep(hzTb)
#HotIf WinActive('ahk_exe hznHorizon.exe') && WinActive('TX11')
Class hzTb {

        __New(hTb) {
                this.hCtl := ControlGetFocus('A')
                this.fCtl := ControlGetClassNN(this.hCtl)
                this.fCtlI := SubStr(this.fCtl, -1, 1)
                this.nCtl := 'msvb_lib_toolbar' this.fCtlI
                this.hTb := ControlGethWnd(this.nCtl, 'A')
        }
        ; static hCtl(){
        ;         return ControlGetFocus('A')
        ; }
        ; static fCtl(){
        ;         return ControlGetClassNN(this.hCtl())
        ; }
        ; static fCtlI(){
        ;         return SubStr(this.fCtl(), -1, 1)
        ; }
        ; static nCtl := "msvb_lib_toolbar" this.fCtlI() ; ! => would love to regex this to anything containing 'bar' || toolbar || ?
        ; ; static hTb()    => hTb   := ControlGethWnd(this.nCtl, "A")
        ; static hTb() {
        ;        return ControlGethWnd(this.nCtl, 'A')
        ; }
        ; static hTx(){
        ;         ControlGethWnd(this.fCtl(), "A")
        ; }
        ; static pID(){
        ;         WinGetPID(this.hTb())
        ; }
        ; static tpID(){
        ;         DllCall("GetWindowThreadProcessId", "Ptr", this.hTb(), "UInt*", &tpID:=0)
        ; }
        
}
; ---------------------------------------------------------------------------
hzhCtl(){
        return ControlGetFocus('A')
}
; ---------------------------------------------------------------------------
hzfCtl(){
        return ControlGetClassNN(hzhCtl())
}
; ---------------------------------------------------------------------------
hzfCtlI(){
        return SubStr(hzfCtl(), -1, 1)
}
; ---------------------------------------------------------------------------
hznCtl := "msvb_lib_toolbar" hzfCtlI() ; ! => would love to regex this to anything containing 'bar' || toolbar || ?
; static hTb()    => hTb   := ControlGethWnd(this.nCtl, "A")
; ---------------------------------------------------------------------------
hzhTb() {
       return ControlGethWnd(hznCtl, 'A')
}

hzTb.Prototype.DefineProp('hTb',{Call : hzhTb})

hzhTx(){
        return ControlGethWnd(hzfCtl(), "A")
}
hzpID(){
        return WinGetPID(hzhTb())
}
hztpID(){
        return DllCall("GetWindowThreadProcessId", "Ptr", hzhTb(), "UInt*", &tpID:=0)
}