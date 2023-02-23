#include <GDIPlus.au3>
#include <GUIConstants.au3>
#include <WinAPI.au3>

;_Notification("..\Assets\tj.png")

Func _Notification($hImagePath, $iTimeOut = 500, $iTransparent = 220)
	$aMouseGetPosition = MouseGetPos()
	$hNTUI = GUICreate('Notification', 100, 100, @DesktopWidth/2-64, $aMouseGetPosition[1]-40, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TOOLWINDOW, $WS_EX_TOPMOST))
	_GDIPlus_Startup()
	$hImage = _GDIPlus_ImageLoadFromFile($hImagePath)
	$hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
	_SetBitmap($hNTUI, $hBitmap, $iTransparent)
	_GDIPlus_ImageDispose($hImage)
	GUISetState(@SW_SHOWNOACTIVATE, $hNTUI)
	$iTimerStart = TimerInit()
	While 1
		If TimerDiff($iTimerStart) >= $iTimeOut Then
			_WinAPI_DeleteObject($hBitmap)
			_GDIPlus_Shutdown()
			GUIDelete($hNTUI)
			ExitLoop
		EndIf
	WEnd
EndFunc

Func _SetBitmap($hWnd, $hBitmap, $iOpacity)
    Local $hDC, $hMemDC, $tBlend, $tSIZE, $tSource
    $hDC = _WinAPI_GetDC($hWnd)
    $hMemDC = _WinAPI_CreateCompatibleDC($hDC)
    _WinAPI_SelectObject($hMemDC, $hBitmap)
    $tSIZE = _WinAPI_GetBitmapDimension($hBitmap)
    $tSource = DllStructCreate($tagPOINT)
    $tBlend = DllStructCreate($tagBLENDFUNCTION)
    DllStructSetData($tBlend, 'Alpha', $iOpacity)
    DllStructSetData($tBlend, 'Format', 1)
    _WinAPI_UpdateLayeredWindow($hWnd, $hDC, 0, DllStructGetPtr($tSIZE), $hMemDC, DllStructGetPtr($tSource), 0, DllStructGetPtr($tBlend), $ULW_ALPHA)
    _WinAPI_ReleaseDC($hWnd, $hDC)
    _WinAPI_DeleteDC($hMemDC)
EndFunc   ;==>_SetBitmap