#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\Assets\tray.ico
#AutoIt3Wrapper_Res_Description=Se7KBAutoRun
#AutoIt3Wrapper_Res_Fileversion=0.0.0.2
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=© Se7enstars
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#NoTrayIcon
If $CmdLine[0] Then
    If StringInStr($CmdLine[1], "/") = 1 And $CmdLine[0] >= 3 Then ;I check if the first parameter is a command and if it has the correct parameters
        Local $sMyFunction = StringReplace($CmdLine[1], "/", "_") ;Convert to correct function name
        Local $sAppFullPath = $CmdLine[2] ;App full path to start (with *.exe)
		Local $sWaitingTime = $CmdLine[3] ;Waiting time by seconds
        Call($sMyFunction, $sAppFullPath, $sWaitingTime) ;Call the function
    EndIf
Else
;show -help file
EndIf

Func _Autorun($sAppFullPath, $sWaitingTime)
    Sleep($sWaitingTime*1000)
	Run($sAppFullPath)
EndFunc

#cs Example:
	Se7KBAssistAutorun.exe /Autorun Se7KBAssist.exe 30
	---This_app_name---   --param-- --RunningApp--  --Waiting---
#ce