appName = World of Warcraft
monitorWidth = 3840
monitorHeight = 2160
horizontalMonitors = 3
verticalMonitors = 1
monitorY = 0 
monitorX = 0

; =============
; Resize window
; =============

windowX := monitorX
windowY := monitorY
windowWidth := horizontalMonitors * monitorWidth
windowHeight := verticalMonitors * monitorHeight

WinMove, %appName%,, %windowX%, %windowY%, %windowWidth%, %windowHeight%