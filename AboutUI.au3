#include <GUIConstants.au3>
$sAppName = "Keyboard Assist"
$sAssets = @ScriptDir & '\Assets'

$iUITimeOut = 5000
$taskPOS = WinGetPos("[Class:Shell_TrayWnd]")
Local $ui_w = 250, $ui_h = 80
$ui = GUICreate($sAppName, $ui_w, $ui_h, @DesktopWidth-$ui_w, @DesktopHeight-$taskPOS[3]-$ui_h, $WS_POPUP, BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST))
GUISetBkColor(0x0, $ui)

GUICtrlCreateLabel('', 0, 0, 5, $ui_h)
GUICtrlSetBkColor(-1, 0x75D00F)

GUICtrlCreateIcon($sAssets & "\Success.ico", 0,  7, $ui_h/2 - 10, 32, 32)

GUICtrlCreateLabel("Keyboard Assist", 5, 3, $ui_w-5, 20, $SS_CENTER)
GUICtrlSetFont(-1, 11, 600, Default, 'Microsoft Sans Serif')
GUICtrlSetColor(-1, 0x75D00F)

$sText = "Developer F49C:38F8" & @LF & _
		"GitHub://Se7enstars/" & @LF & _
		"All Right Reserved!"
GUICtrlCreateLabel($sText, 41, 23, $ui_w-9, 55)
GUICtrlSetFont(-1, 10, 600, Default, 'Microsoft Sans Serif')
GUICtrlSetColor(-1, 0xFFFFFF)

WinSetTrans($ui, '', 200)
DllCall("User32.dll","long","AnimateWindow","hwnd", $ui,"long",80,"long",0x2+0x40000)
GUISetState(@SW_SHOW, $ui)

$iTimerStart = TimerInit()
	While 1
		If TimerDiff($iTimerStart) >= $iUITimeOut Then
			DllCall("User32.dll","long","AnimateWindow","hwnd", $ui,"long",80,"long",0x00050001)
			GUIDelete($ui)
			ExitLoop
		EndIf
		If Not WinActive($ui) Then
			DllCall("User32.dll","long","AnimateWindow","hwnd", $ui,"long",80,"long",0x00050001)
			GUIDelete($ui)
			ExitLoop
		EndIf
	WEnd
