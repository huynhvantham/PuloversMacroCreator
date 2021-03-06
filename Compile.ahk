﻿#NoEnv
SetWorkingDir %A_ScriptDir%
SplitPath, A_AhkPath,, AhkDir

FileCreateDir, Compiled
FileCreateDir, Documentation\MacroCreator_Help-doc\Commands

IfWinExist, ahk_exe MacroCreator.exe
{
	WinClose
	WinWaitClose
}
FileDelete, Documentation\MacroCreator_Help-doc\*.html
FileDelete, Documentation\MacroCreator_Help-doc\Commands\*.html
FileCopy, Documentation\License.html, Documentation\MacroCreator_Help-doc, 1

RunWait, Documentation\GenDocs-mod.ahk,, UseErrorLevel
If ErrorLevel
	ExitApp
RunWait, BuildFiles.ahk,, UseErrorLevel
If ErrorLevel
	ExitApp
RunWait, Documentation\MacroCreator_Help-doc\CompileCHM.ahk,, UseErrorLevel
If ErrorLevel
	ExitApp
FileCopy, Documentation\MacroCreator_Help-doc\MacroCreator_Help.chm, Compiled\MacroCreator_Help.chm, 1

FileDelete, Compiled\Resources.dll
FileDelete, Compiled\SciLexer-x64.dll
FileDelete, Compiled\SciLexer-x86.dll
FileCopy, Resources.dll, Compiled\Resources.dll, 1
FileCopy, SciLexer-x64.dll, Compiled\SciLexer-x64.dll, 1
FileCopy, SciLexer-x86.dll, Compiled\SciLexer-x86.dll, 1

RunWait, %AhkDir%\Compiler\Ahk2Exe.exe /in MacroCreator.ahk /out Compiled\MacroCreator.exe /icon Resources\PMC4_Mult.ico /bin "%AhkDir%\Compiler\Unicode 32-bit.bin" /mpress 1,, UseErrorLevel
If ErrorLevel = ERROR
{
	MsgBox, 0x40000, Error, Error code: %A_LastError%
	ExitApp
}
RunWait, %AhkDir%\Compiler\Ahk2Exe.exe /in MacroCreator.ahk /out Compiled\MacroCreator-x64.exe /icon Resources\PMC4_Mult.ico /bin "%AhkDir%\Compiler\Unicode 64-bit.bin" /mpress 1,, UseErrorLevel
If ErrorLevel = ERROR
{
	MsgBox, 0x40000, Error, Error code: %A_LastError%
	ExitApp
}

RunWait, %ProgramFiles%\Inno Setup 5\iscc.exe  %A_ScriptDir%\Installer.iss,, UseErrorLevel
If ErrorLevel = ERROR
{
	MsgBox, 0x40000, Error, Error code: %A_LastError%
	ExitApp
}

TrayTip,, Finished compiling files.
Sleep, 2000
return
