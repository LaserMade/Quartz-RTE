#Include <Abstractions\GetFileTimes>
#Include <Tools\FileSystemSearch>

GetFilesSortedByDate(pattern := '', newToOld := true) {
	files := Map()
	loop files pattern {
		modificationTime := GetFileTimes(A_LoopFileFullPath).ModificationTime
		if (newToOld)
			modificationTime *= -1
		files.Set(modificationTime, A_LoopFileFullPath)
	}
	arr := []
	for , fullPath in files
		arr.SafePush(fullPath)
	return arr
}
; FindFile(pattern := '', newToOld := true) => GetFilesSortedByDate(pattern := '', newToOld := true)