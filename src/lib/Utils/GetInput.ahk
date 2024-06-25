; No dependencies

GetInput(options?, endKeys?) {
	inputHookObject := InputHook(options?, endKeys?)
	; inputHookObject := InputHook('I V E *', endKeys?)
	inputHookObject.Start()
	inputHookObject.Wait()
	return inputHookObject
}