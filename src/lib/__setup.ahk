class setup {
	; static user_info := Map(
	static user_info := Map(
		your_name := ''
		your_initials := ''
		your_title := ''
		work_email := '@fmglobal.com'
		aOffice := ['Seattle', 'Walnut Creek']
		your_office := 'FM Global - [' '] Office'
		personal_email := ''
		employee_number := ''
		office_address := 'FM Global: '
		office_phone := ''
		personal_address := ''
		manager_name := ''
		manager_title := ''
		manager_email := ''
	)
	
	static __New() {
		q := ''
		v := ''
		sGui := Gui()
		sGui.Opt('+AlwaysOnTop +Resize +Caption')
		sGui.SetFont('s11 ')
		for q, v in this.user_info {
			sGui.AddText()
		}
		
	}

	static _Office(){
		for each, value in this.user_info.aOffice {
			
		}

	}
	static fontSize     := 11
	static distance     := 3
	; static unit         := A_ScreenDPI / 96
	static unit         := A_ScreenDPI / 144
	static guiWidth     := setup.fontSize * setup.unit * setup.distance
	; static guiWidth     := 30
	static maximumInfos := Floor(A_ScreenHeight / setup.guiWidth)
	static spots        := setup._GeneratePlacesArray()
	static foDestroyAll := (*) => setup.DestroyAll()
	static maxNumberedHotkeys := 12
	; static maxWidthInChars := 110
	static maxWidthInChars := A_ScreenWidth

	static DestroyAll() {
		for index, infoObj in setup.spots {
			if !infoObj
				continue
			infoObj.Destroy()
		}
	}


	static _GeneratePlacesArray() {
		availablePlaces := []
		loop setup.maximumInfos {
			availablePlaces.Push(false)
		}
		return availablePlaces
	}
}
