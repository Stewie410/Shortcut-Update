; cli.ahk
;
; CLI front-end for Shortcut-Update utility

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
#Include Shortcut-Update.ahk

; --------------------------------------------------------
; -- 					Declare Globals 				--
; --------------------------------------------------------
rootPath := ""
prefixPattern := ""
prefixReplace := ""
recurse := false

; --------------------------------------------------------
; -- 						Run 						--
; --------------------------------------------------------
main()
ExitApp

; --------------------------------------------------------
; -- 					Backend							--
; --------------------------------------------------------
main() {
	; Declare variables
	path := ""
	search := ""
	replace := ""
	recurse := false

	; Parse Arguments
	parseArgs(path, search, replace, recurse)
	if (!checkOpts)
		ExitApp

	; Update links
	update(path, search, replace, recurse)
}

; Parse Arguments
parseArgs(ByRef path, ByRef search, ByRef replace, ByRef recurse) {
	; Parse
	for i, j in A_Args {
		if (j ~= "^-(h|-help)") {
			showHelp()
			ExitApp
		} else if (j ~= "^-(r|-recurse)")
			recurse := true
		else if (j ~= "^-(d|-dir)")
			path := A_Args[i + 1]
		else if (j ~= "^-(x|-regex)")
			search := A_Args[i + 1]
		else if (j ~= "^-(p|-prefix)")
			replace := A_Args[i + 1]
	}
}

; Check Options
checkOpts() {
	; Import Globals
	global rootPath, prefixPath, prefixReplace, recurse

	; Check Variables
	if (!rootPath) {
		printMsg("null", "rootPath")
		return false
	}
	if (!prefixPath) {
		printMsg("null", "prefixPath")
		return false
	}
	if (!prefixReplace) {
		printMsg("null", "prefixReplace")
		return false
	}
	if (!replace) {
		printMsg("null", "replace")
		return false
	}

	; Check Directories
	if (!FileExist(rootPath)) {
		printMsg("dir", rootPath)
		return false
	}

	; Return Success
	return true
}

; --------------------------------------------------------
; -- 					Getters 						--
; --------------------------------------------------------
; Get Date and/or time
getStamp(getTime := false) {
	stamp := A_YYYY "-" A_MM "-" A_DD
	if (getTime)
		stamp .= "@" A_Hour ":" A_Min ":" A_Sec
	return stamp
}

; --------------------------------------------------------
; -- 					Printing 						--
; --------------------------------------------------------
; Show Help
showHelp() {
	help =
(
Shortcut-Update-CLI
Migrate Shortcuts from one path prefix to another

Options:
	-h, --help 						Show this help message
	-r, --recurse 					Allow recursive searching
	-d, --dir <PATH> 				Define the path to search
	-x, --regex <REGEX> 			Define the AHK Regex to search for (supports groups)
	-p, --prefix <REGEX> 			Define the replacement (supports groups)
)
	stdout(help "`n")
}

; Print Message to Terminal
printMsg(t, p) {
	; Determine message from (t)ype
	msg := ""
	
	; Print Separator
	if (t = "sep") {
		loop, 80
			msg .= p
		stdout(msg "`n")
		return
	}
	
	; Errors
	if (t = "null")
		msg := "ERROR: Variable is not defined"
	else if ( t = "dir")
		msg := "ERROR: Cannot locate directory"

	; Print Message
	stdout("[" getStamp(true) "] " msg ": " p)
}

; Print Message to stdout
stdout(msg) {
	DllCall("AttachConsole", "UInt", 0x0ffffffff)
	FileAppend, %msg%, con
	DllCall("FreeConsole")
}