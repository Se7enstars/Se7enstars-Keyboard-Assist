#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Assets\tray.ico
#AutoIt3Wrapper_Res_Comment=Developer: F49C.38F8
#AutoIt3Wrapper_Res_Description=Se7enstars Keyboard Assist
#AutoIt3Wrapper_Res_Fileversion=1.0.0.22
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=© Se7enstars
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs
	LangDetector by F49C.38F8
		KB Lang Bin_Codes
			0x04090409 >> English (United States)
			0x04190419 >> Russian (Russia)
			0x04280428 >> Tajik (Cyrillic, Tajikistan)
#ce
#include <TrayConstants.au3>
#include <WinAPI.au3>
#include <WinAPISys.au3>
#include <WinAPIvkeysConstants.au3>
#include <APILocaleConstants.au3>
#include <WinAPILocale.au3>
#include "Libs\Notification.au3"

$sAppName = "Se7KB Assist"
$sAssets = @ScriptDir & '\Assets'
$sAutorunCMD = "Autorun"
$iAutoRunSleepTime = 30		; sec
$iUpdateFrequency = 300		; ms
$lastLng = ''				; Remember last lang
$currentLng = ''			; Remember new lang
$lastCapsLock = BitAND(_WinAPI_GetKeyState($VK_CAPITAL), 1); GetCapsLockStatus
$newCapsLock = $lastCapsLock
$bPause = True

If $CmdLine[0] Then
    If StringInStr($CmdLine[1], "/") = 1 And $CmdLine[0] >= 1 Then
        If StringInStr($CmdLine[1], $sAutorunCMD) Then
			TraySetIcon($sAssets & "\Waiting.ico")
			TraySetToolTip($sAppName & " Waiting...")
			Sleep($iAutoRunSleepTime*1000); Waiting $iAutoRunSleepTime(sec) on start via /($sAutorunCMD) cmd
		EndIf
    EndIf
EndIf

Opt("TrayMenuMode", 3)

TraySetIcon($sAssets & "\Tray.ico")
TraySetToolTip($sAppName)
$tAutorun = TrayCreateItem("Autorun")
$tPause = TrayCreateItem("Pause")
$tExit = TrayCreateItem("Exit")

If _Autorun("GET") Then TrayItemSetState($tAutorun, $TRAY_CHECKED)

AdlibRegister("_OnKeyboardLayoutChange", $iUpdateFrequency); Register function for every 500ms checking...

While 1
	If Not $currentLng = 0 Then
		If $currentLng <> $lastLng Then; Optimization
			$sLanguage = _WinAPI_GetLocaleInfo(_WinAPI_LoWord($currentLng), $LOCALE_SLANGUAGE); Bin_Code to simple string
			Switch $currentLng
				Case 0x04090409; >> English (United States)
					_LangChangedUI($sAssets & "\EN.wav", $sAssets & "\EN.png", $sAppName & @LF & $sLanguage)
				Case 0x04190419; >> Russian (Russia)
					_LangChangedUI($sAssets & "\RU.wav", $sAssets & "\RU.png", $sAppName & @LF & $sLanguage)
				Case 0x04280428; >> Tajik (Cyrillic, Tajikistan)
					_LangChangedUI($sAssets & "\TJ.wav", $sAssets & "\TJ.png", $sAppName & @LF & $sLanguage)
			EndSwitch
			$lastLng = $currentLng
		EndIf
	EndIf
	If $newCapsLock <> $lastCapsLock Then
		If $newCapsLock = 1 Then
			SoundPlay($sAssets & "\CapsOn.wav")
			_Notification($sAssets & "\CapsOn.png")
		Else
			SoundPlay($sAssets & "\CapsOff.wav")
			_Notification($sAssets & "\CapsOff.png")
		EndIf
		$lastCapsLock = $newCapsLock
	EndIf
	$tmsg = TrayGetMsg()
	Switch $tmsg
		Case $tExit
			Exit
		Case $tPause
			If $bPause Then
				$bPause = False
				AdlibUnRegister("_OnKeyboardLayoutChange")
				TrayItemSetState($tPause, $TRAY_CHECKED)
			Else
				$bPause = True
				AdlibRegister("_OnKeyboardLayoutChange", $iUpdateFrequency)
				TrayItemSetState($tPause, $TRAY_UNCHECKED)
			EndIf
		Case $tAutorun
			If TrayItemGetState($tAutorun) = $TRAY_CHECKED+$TRAY_ENABLE Then
				TrayItemSetState($tAutorun, $TRAY_UNCHECKED)
				_Autorun("DEL")
			Else
				TrayItemSetState($tAutorun, $TRAY_CHECKED)
				_Autorun("SET")
			EndIf
	EndSwitch
	Sleep(10); Reduce CPU
WEnd

Func _LangChangedUI($sSound, $sIcon, $sTrayTip)
	SoundPlay($sSound)
	_Notification($sIcon)
	TraySetToolTip($sTrayTip)
EndFunc

Func _OnKeyboardLayoutChange()
	$currentLng = _WinAPI_GetKeyboardLayout(WinGetHandle('')); Get current KB Lang (Bin_Code)
	$newCapsLock = BitAND(_WinAPI_GetKeyState($VK_CAPITAL), 1)
EndFunc

Func _Autorun($sState = "GET")
	Local $sKey = "HKCU\Software\Microsoft\Windows\CurrentVersion\Run"
	Local $sGetAutorun = RegRead($sKey, $sAppName)
	Switch $sState
		Case "GET"
			If $sGetAutorun = "" Then
				Return False
			Else
				Return True
			EndIf
		Case "SET"
			RegWrite($sKey, $sAppName, "REG_SZ", @ScriptFullPath & " /" & $sAutorunCMD)
			Return True
		Case "DEL"
			RegDelete($sKey, $sAppName)
			Return False
	EndSwitch
EndFunc

#cs 
	for debug:
	ConsoleWrite("LAST: " & $lastCapsLock &@LF& "NEW: " & $newCapsLock & @LF&">>>>>"&@MIN&":"&@SEC&">>>>>"&@LF)
#ce