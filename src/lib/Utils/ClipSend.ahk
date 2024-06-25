#Requires AutoHotkey v2.0.11+
#Include <Directives\__AE.v2>

; ---------------------------------------------------------------------------
/**
; @func: A faster send. Sending stuff can take too long, but if you copy and paste it, it's much faster. Retains your clipboard as well.
; @param toSend *String* The text you want to send
; @param endChar *String* The ending character you want after the text you send
; @param isClipReverted *Boolean* Set to false if you want the text sent to become your current clipboard
; @param untilRevert @return {Integer} The time it takes for your clipboard to get reverted to what it was before calling the function.
*/
; ---------------------------------------------------------------------------

ClipSend(toSend, endChar := "", isClipReverted := true, untilRevert := 500) {
    ; ---------------------------------------------------------------------------
	; @i...: Because there is no way to know whether an application has received the input we sent it with ^v. We revert the clipboard after a certain time (untilRevert). If we reverted the clipboard immidiately, we would end up sending not "toSend", but the previous clipboard instead, because we did not give the application enough time to process the action. This time depends on the app, discord seems to be one of the slowest ones (do not break TOS guys), but a safe time for untilRevert seems to be 50ms. This time might be lower or higher on your machine, configure as needed.
    ; @i...: Changed from 50ms to 500ms
    ; ---------------------------------------------------------------------------
    AE.SM(&sm)
    AE.BISL(1)
    ; ---------------------------------------------------------------------------
    isClipReverted ? (prevClip := ClipboardAll()) : 0
	; ---------------------------------------------------------------------------
	; @i...: We free the clipboard...
	; ---------------------------------------------------------------------------
	A_Clipboard := ''
	A_Clipboard := toSend endChar
	; ---------------------------------------------------------------------------
	; @i...: So we can make sure we filled the clipboard with what we want before we send it
	; ---------------------------------------------------------------------------
	; @i...: Now the clipboard is what we want to send + and ending character. I often need a space after so I add a space by default, you can change what it is in the second parameter
    ; ---------------------------------------------------------------------------
    ; Loop 10 {
    ;     Sleep(10)
    ; } Until !DllCall('GetOpenClipboardWindow', 'ptr')
    ; clip_sleep()
    AE.cSleep(100)
    ; Sleep(100)
    SetTimer(()=>Send('^{sc2F}'),-ClipWait(1))
    ; SetTimer(()=>Send('^{sc2F}'),ClipWait(1))
    ; SetTimer(()=>Send("^{sc152}"),-ClipWait(1)) ;! Not ^v because this variant is more consistent {sc152} = Insert => +{Insert}
    ;! Nope for Horizon, Teams

	; Sleep(500)
	; if isClipReverted{
        ; 	SetTimer(() => A_Clipboard := prevClip, -untilRevert)
    ; }
    ; clip_sleep()
    AE.cSleep(100)
    isClipReverted ? SetTimer((*) => A_Clipboard := prevClip, -(untilRevert)) : 0
    ; ---------------------------------------------------------------------------
    ; @i...: We revert the clipboard in 50ms. This does not occupy the thread, so the clipsend itself does not take 50ms, only the revert of the clipboard does.
    ; ---------------------------------------------------------------------------
	AE.BISL(0)
    AE.rSM(sm)
}
