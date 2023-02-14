#include-once
#include <GUIConstants.au3>
;_Notification("..\Assets\tjSQR.ico")
Func _Notification($sIcon, $iTimeOut = 500, $bUPPERCASE = True)
	$aMouseGetPosition = MouseGetPos()
	$UI = GUICreate("Notification", 115, 73, @DesktopWidth/2-64, $aMouseGetPosition[1]-40, $WS_POPUP, $WS_EX_TOOLWINDOW+$WS_EX_TOPMOST)
	GUISetBkColor(0x0, $UI)
	$hIcon = GUICtrlCreateIcon($sIcon, -1, -6, -28, 128, 128)
	WinSetTrans($UI, '', 200)
	GUISetState(@SW_SHOWNOACTIVATE, $UI)
	$iTimerStart = TimerInit()
	While 1
		If TimerDiff($iTimerStart) >= $iTimeOut Then
			GUIDelete($UI)
			ExitLoop
		EndIf
	WEnd
EndFunc