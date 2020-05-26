; gui.ahk
; 
; GUI front-end for Shortcut-Update utility

; --------------------------------------------------------
; -- 					Environment 					--
; --------------------------------------------------------
#SingleInstance Force
#Persistent
#NoEnv
#Warn All
#Warn UseUnsetLocal, Off
SetWorkingDir, %A_ScriptDir%
FileEncoding UTF-8
SetBatchLines, -1
SetWinDelay, -1
SetControlDelay, -1
SendMode, Input
DetectHiddenWindows, On

; --------------------------------------------------------
; -- 					Include 						--
; --------------------------------------------------------
#Include %A_ScriptDir%
#Include embed.ahk
#Include Shortcut-Update.ahk

; --------------------------------------------------------
; -- 					Message Hooks 					--
; --------------------------------------------------------
OnExit("cleanup")

; --------------------------------------------------------
; -- 						Run 						--
; --------------------------------------------------------
; Build GUI
Gui, +HWNDhParent +LastFound -Resize +OwnDialogs
Gui, Margin, 0, 0
Gui, Color, F7F7F7
Gui, Font, c000000, Arial
Gui, Add, Text, x8 y8 w120 h23 +0x200 +BackgroundTrans, Path
Gui, Add, Edit, x136 y8 w120 h23 +vPathRoot
Gui, Add, Button, x264 y8 w120 h23 +gBrowseBtn +AltSubmit, &Browse...
Gui, Add, Text, x8 y32 w120 h23 +0x200 +vPrefixPattern, Prefix Pattern
Gui, Add, Edit, x136 y32 w120 h23
Gui, Add, Text, x8 y56 w120 h23 +0x200 +vPrefixReplace, Prefix Replace
Gui, Add, Edit, x136 y56 w120 h23
Gui, Add, CheckBox, x136 y80 w120 h23 +vRecursiveSearch, &Recurse
Gui, Add, Button, x264 y80 w120 h23 +gUpdateBtn +AltSubmit, &Run

; Extract Icon
setIcon()

; Display GUI
Gui, Show, w400 h120, Shortcut-Update
return

; --------------------------------------------------------
; -- 					Backend 						--
; --------------------------------------------------------
; Cleanup Environment
cleanup() {
	FileRemoveDir, %A_Temp%\Shortcut-Update, 1
}

; Extract & Set Tray/Application Icon
setIcon() {
	FileCreateDir, %A_Temp%\Shortcut-Update
	extractFavicon(A_Temp "\Shortcut-Update\favicon.ico")
	Menu, Tray, Icon, %A_Temp%\Shortcut-Update\favicon.ico
}

; Display Error Message
errBox(message) {
	MsgBox, 4112, Shortcut-Update Error, %message%
}

; Display Toast Notification
toast(message) {
	TrayTip, Shortcut-Update, %message%,, 33
}

GuiEscape(GuiHwnd) {
	ExitApp
}

GuiClose(GuiHwnd) {
	ExitApp
}

; --------------------------------------------------------
; -- 					G-Labels 						--
; --------------------------------------------------------
; Browse for the root path
BrowseBtn(hwnd, event, info, err := "") {
	; Import PathRoot global
	Gui, Submit, NoHide
	global PathRoot
	try {
		FileSelectFolder, path,, 1, Select Root Directory
		if (path)
			GuiControl,, PathRoot, %path%
	}
}

; Update Shortcuts
UpdateBtn() {
	; Retrieve GUI Values
	Gui, Submit, NoHide
	global RecursiveSearch, PathRoot, PrefixPattern, PrefixReplace

	; Check search path
	if ((!PathRoot) || (!FileExist(PathRoot))) {
		errBox("No path selected")
		return
	}

	; Check prefix regex's
	if (!PrefixPattern) {
		errBox("No prefix regex defined")
		return
	}
	if (!PrefixReplace) {
		errBox("No prefix replacement regex/string defined")
		return
	}
	
	; Update links
	update(PathRoot, PrefixPattern, PrefixReplace, RecursiveSearch)
	toast("Update process completed")
}