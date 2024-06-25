#Requires AutoHotkey v2+
#Include <Directives\__AE.v2>

; Thank you for providing that example. Based on your code, I can see that you want to use the RTF formatting directly on a string variable. Let's modify our implementation slightly to make this work exactly as you've shown. Here's an updated version of the String class extension:

; ```autohotkey
class rtfString extends String {
    class RTF {
        __New(text) {
            this.text := text
            this.attributes := []
        }

        __Call(method, params) {
            if (method != "b" && method != "i" && method != "u" && method != "s") {
                return this.Generate()
            }
            this.attributes.Push(method)
            return this
        }

        __ToString() {
            return this.Generate()
        }

        b => (this.attributes.Push("bold"), this)
        i => (this.attributes.Push("italic"), this)
        u => (this.attributes.Push("underline"), this)
        s => (this.attributes.Push("strikeout"), this)

        Generate() {
            static FontFace := "Times New Roman"
            static FontSize := 11

            rtfHeader := "{\rtf1\ansi\deff0 {\fonttbl{\f0\fnil " . FontFace . ";}}"
            rtfSize := "\fs" . (FontSize * 2)
            rtfColor := "\cf0"
            rtfBold := this.attributes.HasValue("b") || this.attributes.HasValue("bold") ? "\b" : ""
            rtfItalic := this.attributes.HasValue("i") || this.attributes.HasValue("italic") ? "\i" : ""
            rtfUnderline := this.attributes.HasValue("u") || this.attributes.HasValue("underline") ? "\ul" : ""
            rtfStrikeOut := this.attributes.HasValue("s") || this.attributes.HasValue("strikeout") ? "\strike" : ""
            
            rtfText := rtfHeader . rtfColor . rtfSize . rtfBold . rtfItalic . rtfUnderline . rtfStrikeOut . " " . this.text . "}"
            
            return rtfText
        }
    }

    rtf {
        get => rtfString.RTF(this)
    }

    static SetClipboard(rtfText) {
        plainText := rtfString.StripRTF(rtfText)
        
        cf_rtf := DllCall("RegisterClipboardFormat", "Str", "Rich Text Format")
        A_Clipboard := "" ; Clear the clipboard
        A_Clipboard := plainText ; Set plain text

        if DllCall("OpenClipboard", "Ptr", A_ScriptHwnd) {
            DllCall("EmptyClipboard")
            DllCall("SetClipboardData", "UInt", 1, "Ptr", &plainText)
            hMem := DllCall("GlobalAlloc", "UInt", 0x42, "Ptr", StrLen(rtfText) + 1, "Ptr")
            pMem := DllCall("GlobalLock", "Ptr", hMem, "Ptr")
            StrPut(rtfText, pMem, "CP0")
            DllCall("GlobalUnlock", "Ptr", hMem)
            DllCall("SetClipboardData", "UInt", cf_rtf, "Ptr", hMem)
            DllCall("CloseClipboard")
        }
    }

    static StripRTF(rtfText) {
        ; Simple RTF stripping, might need improvement for complex RTF
        plainText := RegExReplace(rtfText, "^\{.*?\}\s*", "")
        plainText := RegExReplace(plainText, "\\\w+\s?", "")
        plainText := RegExReplace(plainText, "\{|\}", "")
        return Trim(plainText)
    }
}
/**
```

The main change here is that we've made `rtf` a property of the String class instead of a method. This allows you to use it exactly as you've shown in your example:

```autohotkey
text := 'This is text that we are formatting'
text := text.rtf.b.u
```

Now, when you access `text.rtf`, it returns a new RTF object initialized with the current string. You can then chain the formatting methods (`b`, `i`, `u`, `s`) as desired.

This implementation allows you to:

1. Start with a plain string
2. Convert it to an RTF object using the `rtf` property
3. Apply formatting using chained method calls
4. The result is automatically converted back to a string (which is now RTF-formatted)

You can still use the `SetClipboard` method to put the RTF-formatted text on the clipboard:

```autohotkey
String.SetClipboard(text)
```

This approach gives you the exact syntax you requested while maintaining the functionality of the RTF formatting system.​​​​​​​​​​​​​​​​
*/