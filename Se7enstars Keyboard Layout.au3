#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Assets\tray.ico
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Description=Se7KB Layout
#AutoIt3Wrapper_Res_Fileversion=1.0.0.4
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=© F49C.38F8
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs
	LangDetector by F49C.38F8
		KB Lang Bin_Codes
			0x04090409 >> English (United States)
			0x04190419 >> Russian (Russia)
			0x04280428 >> Tajik (Cyrillic, Tajikistan)
#ce

;#NoTrayIcon
#include <TrayConstants.au3>
#include <WinAPI.au3>
#include <WinAPISys.au3>
#include <WinAPIvkeysConstants.au3>
#include <APILocaleConstants.au3>
#include <WinAPILocale.au3>
#include "Libs\Notification.au3"

Opt("TrayMenuMode", 3)

TraySetIcon("Assets\Tray.ico")
TraySetToolTip("LangDetector")
$tPause = TrayCreateItem("Pause")
$tExit = TrayCreateItem("Exit")

$iUpdateFrequency = 300		; ms
$lastLng = ''				; Remember last lang
$currentLng = ''			; Remember new lang
$lastCapsLock = _WinAPI_GetKeyState($VK_NUMLOCK); GetCapsLockStatus
$newCapsLock = $lastCapsLock
$bPause = True

AdlibRegister("_OnKeyboardLayoutChange", $iUpdateFrequency); Register function for every 500ms checking...

While 1
	If $currentLng <> $lastLng Then; Optimization
		$sLanguage = _WinAPI_GetLocaleInfo(_WinAPI_LoWord($currentLng), $LOCALE_SLANGUAGE); Bin_Code to simple string
		Switch $currentLng
			Case 0x04090409; >> English (United States)
				SoundPlay("Assets\EN.wav")
				_Notification("Assets\enSQR.ico")
			Case 0x04190419; >> Russian (Russia)
				SoundPlay("Assets\RU.wav")
				_Notification("Assets\ruSQR.ico")
			Case 0x04280428; >> Tajik (Cyrillic, Tajikistan)
				SoundPlay("Assets\TJ.wav")
				_Notification("Assets\tjSQR.ico")
		EndSwitch
		;ConsoleWrite("Lang Changed " & $currentLng & '         OR >>'& $sLanguage & @LF); It's for debug if needed
		$lastLng = $currentLng
	EndIf
	If $newCapsLock <> $lastCapsLock Then
		If $newCapsLock = 1 Then
			SoundPlay("Assets\CapsOn.wav")
		Else
			SoundPlay("Assets\CapsOff.wav")
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
	EndSwitch
	Sleep(10); Reduce CPU
WEnd

Func _OnKeyboardLayoutChange()
	$currentLng = _WinAPI_GetKeyboardLayout(WinGetHandle('')); Get current KB Lang (Bin_Code)
	$newCapsLock = _WinAPI_GetKeyState($VK_CAPITAL)
	;ConsoleWrite("$currentLng: " & $currentLng & '     $lastLng: ' & $lastLng & @LF); It's for debug if needed
EndFunc