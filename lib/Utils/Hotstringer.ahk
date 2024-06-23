#Include <Utils\GetInput>
#Include <Extensions\Array>
#Include <Extensions\String>
#Include <Utils\ClipSend>
#Include <Tools\Info>

ih := InputHook

class Hotstringer {

	static DynamicHotstrings := Map()
	static StaticHotstrings  := Map()
	static EndKeys := "{Esc}"
	static CancelEndKeys := ["Escape"]

	static Initiate() {
		this.ih := GetInput('I V E *', this.EndKeys)
		if this.CancelEndKeys.HasValue(this.ih.EndKey) {
			Info("exited", 500)
			return
		}
		
		this.Paste()
	}

	static Paste() {
		if this.DynamicHotstrings.Has(this.ih.Input){
			output := this.DynamicHotstrings[this.ih.Input].Call()
		}
		else if this.StaticHotstrings.Has(this.ih.Input){
			output := this.StaticHotstrings[this.ih.Input]
		}
		else {
			Info('no key: "' this.ih.Input '"')
			return
		}

		len := StrLen(this.ih.Input)
		; Infos(len)
		; Send('^+{Left}')
		Send('^{Backspace}')
		; Send(output)
		ClipSend(output)
	}

}
