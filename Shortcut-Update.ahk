; Shortcut-Update.ahk
; Author: 		Alex Paarfus <stewie410@gmail.com>
; 
; Simple AHK utility to migrate shortcut files from one prefix path to another

update(path, search, replace, recurse := false) {
	; 
	wshell := ComObjCreate("WScript.Shell")
	loop, files, %path%\*.lnk, % "F" (recurse ? "R" : "")
	{
		FileGetShortcut, %A_LoopFileFullPath%, target, working
		if RegExMatch(target, search)
			redirect(A_LoopFileFullPath, target, working, search, replace, wshell)
	}
}

redirect(link, dest, dir, pOld, pNew, ByRef wsh) {
	lnk := wsh.CreateShortcut(link)
	lnk.TargetPath := RegExReplace(dest, pOld, pNew)
	lnk.WorkingDir := RegExReplace(dir, pOld, pNew)
	lnk.Save()
}