#cs
	LangDetector by Odilshoh (F49Cafe)
	KB Lang Bin_Codes
	{
		0x04090409 >> English (United States)
		0x04190419 >> Russian (Russia)
		0x04280428 >> Tajik (Cyrillic, Tajikistan)
	}
#ce

#include <WinAPI.au3>
#include <WinAPISys.au3>
#include <APILocaleConstants.au3>
#include <WinAPILocale.au3>

$lastLng = ''				;Remember last lang
$currentLng = ''			;Remember new lang

AdlibRegister("_OnKeyboardLayoutChange", 500);	Register function for every 500ms checking...

While 1
	If $currentLng <> $lastLng Then; Optimization
		$sLanguage = _WinAPI_GetLocaleInfo(_WinAPI_LoWord($currentLng), $LOCALE_SLANGUAGE); Bin_Code to simple string
		Switch $currentLng
			Case 0x04090409; >> English (United States)
				SoundPlay("EN.wav")
			Case 0x04190419; >> Russian (Russia)
				SoundPlay("RU.wav")
			Case 0x04280428; >> Tajik (Cyrillic, Tajikistan)
				SoundPlay("TJ.wav")
		EndSwitch
		;ConsoleWrite("Lang Changed " & $currentLng & '         OR >>'& $sLanguage & @LF); It's for debug if needed
		$lastLng = $currentLng
	EndIf
	Sleep(10); Reduce CPU
WEnd

Func _OnKeyboardLayoutChange()
	$currentLng = _WinAPI_GetKeyboardLayout(WinGetHandle('')); Get current KB Lang (Bin_Code)
	;ConsoleWrite("$currentLng: " & $currentLng & '     $lastLng: ' & $lastLng & @LF); It's for debug if needed
EndFunc




















Exit

; #FUNCTION# ====================================================================================================================
; Name...........: GetActiveKeyboardLayout() Function
; Description ...: Get Active keyboard layout

; Author ........: Fredj A. Jad (DCCD)
; MSDN  .........: GetWindowThreadProcessId Function  ,http://msdn.microsoft.com/en-us/library/ms633522(VS.85).aspx
; MSDN  .........: GetKeyboardLayout Function         ,http://msdn.microsoft.com/en-us/library/ms646296(VS.85).aspx
; ===============================================================================================================================
$i = 0
While 1
    Sleep(1000)  
	ConsoleWrite('Active!     -- ' & GetActiveKeyboardLayout(WinGetHandle('')) &@LF)
	$i+=1
	if $i = 15 Then Exit
WEnd

Func GetActiveKeyboardLayout($hWnd)
    Local $aRet = DllCall('user32.dll', 'long', 'GetWindowThreadProcessId', 'hwnd', $hWnd, 'ptr', 0)
    $aRet = DllCall('user32.dll', 'long', 'GetKeyboardLayout', 'long', $aRet[0])
    Return '0000' & Hex($aRet[0], 4)
EndFunc   ;==>GetActiveKeyboardLayout
