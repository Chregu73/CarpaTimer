; Timer mit Runterzähler auf Sieben-Segment-Anzeige

Global grau = RGB(40, 40, 40)
Global rot = RGB(255, 0, 0)
Global sekunden.l = 0

;           ---a---
;         /       /
;        f       b
;       /---g---/
;      e       c
;     /       /
;     ---d---
; Daten für Zehner Minuten, für
;           Einer  Minuten  X+(1*76)
;           Zehner Sekunden X+(2*76)
;           Einer  Sekunden X+(3*76)

;Koordinaten Segmente:
Global Dim segmenteX.w(7)  ;X-Achse
segmenteX.w(0) = 35 ;a
segmenteX.w(1) = 56 ;b
segmenteX.w(2) = 54 ;c
segmenteX.w(3) = 35 ;d
segmenteX.w(4) = 13 ;e
segmenteX.w(5) = 15 ;f
segmenteX.w(6) = 35 ;g

Global Dim segmenteY.a(7)  ;Y-Achse
segmenteY.a(0) =  9 ;a
segmenteY.a(1) = 42 ;b
segmenteY.a(2) = 54 ;c
segmenteY.a(3) = 86 ;d
segmenteY.a(4) = 54 ;e
segmenteY.a(5) = 42 ;f
segmenteY.a(6) = 48 ;g

Global Dim zahl.a(10)
;Segment:    -gfedcba
zahl.a(0) = %00111111
zahl.a(1) = %00000110
zahl.a(2) = %01011011
zahl.a(3) = %01001111
zahl.a(4) = %01100110
zahl.a(5) = %01101101
zahl.a(6) = %01111101
zahl.a(7) = %00000111
zahl.a(8) = %01111111
zahl.a(9) = %01101111

Procedure.a GetBit ( Value.a, Bit.a )
  ProcedureReturn ( Value & ( 1 << Bit ) )
EndProcedure

Procedure.a SetBit ( Value.a, Bit.a )
  ProcedureReturn ( Value | ( 1 << Bit ) )
EndProcedure

Procedure.a ClrBit ( Value.a, Bit.a )
  ProcedureReturn ( Value &~ ( 1 << Bit ) )
EndProcedure

Procedure.a TglBit ( Value.a, Bit.a )
  ProcedureReturn ( Value ! ( 1 << Bit ) )
EndProcedure

Procedure display()
  If sekunden.l > 5999
    sekunden.l = 5999
  EndIf
  If sekunden.l < 0
    sekunden.l = 0
  EndIf
  Dim sec.a(4)
  sec.a(3) = (sekunden.l % 10)      ;Sekunden Einer
  sec.a(2) = (sekunden.l / 10) %6  ;Sekunden Zehner
  sec.a(1) = (sekunden.l / 60) %10  ;Minuten  Einer
  sec.a(0) = (sekunden.l / 600) ;Minuten  Zehner
  If StartDrawing(ImageOutput(10))
    For stelle.a = 0 To 3
      For segment.a = 0 To 6
        ;Debug "Stelle/Segment: "+Str(stelle.a)+"/"+Str(segment.a)
        ;Debug GetBit(zahl.a(sec.a(stelle.a)), segment.a)
        If GetBit(zahl.a(sec.a(stelle.a)), segment.a) > 0
          FillArea(segmenteX.w(segment.a)+(stelle.a*76), segmenteY.a(segment.a), -1, rot) ;Segment aktiv
          ;Debug "rot"  
        Else
          FillArea(segmenteX.w(segment.a)+(stelle.a*76), segmenteY.a(segment.a), -1, grau) ;Segment inaktiv
          ;Debug "grau"
        EndIf
      Next segment.a
    Next stelle.a
    StopDrawing()
  EndIf
  ImageGadget(10, 0, 106, 30, 95, ImageID(10))
EndProcedure

If OpenWindow(0, 100, 200, 300, 276, "CarpaTimer")
  If CreateToolBar(0, WindowID(0), #PB_ToolBar_Large)
    ToolBarImageButton(0, LoadImage(0, GetCurrentDirectory() + "Icons/Play.ico"), #PB_ToolBar_Toggle)
    ToolBarToolTip(0, 0, "Start")
    ToolBarImageButton(1, LoadImage(0, GetCurrentDirectory() + "Icons/Pause.ico"), #PB_ToolBar_Toggle)
    ToolBarToolTip(0, 1, "Pause")
    ToolBarImageButton(2, LoadImage(0, GetCurrentDirectory() + "Icons/Stop.ico"))
    ToolBarToolTip(0, 2, "Stop")
    ToolBarImageButton(3, LoadImage(0, GetCurrentDirectory() + "Icons/Undo.ico"))
    ToolBarToolTip(0, 3, "Reset Timer")
    ToolBarSeparator()
    
    ToolBarImageButton(4, LoadImage(0, GetCurrentDirectory() + "Icons/Help.ico"))
    ToolBarToolTip(0, 4, "Hilfe...")
    ToolBarImageButton(5, LoadImage(0, GetCurrentDirectory() + "Icons/Info.ico"))
    ToolBarToolTip(0, 5, "Über")
  EndIf
  ButtonImageGadget(0, 8, 42, 56, 56, LoadImage(0, GetCurrentDirectory() + "Icons/Stock Index Up.ico"))
  ButtonImageGadget(1, 84, 42, 56, 56, LoadImage(1, GetCurrentDirectory() + "Icons/Stock Index Up.ico"))
  ButtonImageGadget(2, 160, 42, 56, 56, LoadImage(2, GetCurrentDirectory() + "Icons/Stock Index Up.ico"))
  ButtonImageGadget(3, 236, 42, 56, 56, LoadImage(3, GetCurrentDirectory() + "Icons/Stock Index Up.ico"))
  LoadImage(10, GetCurrentDirectory() + "4stellig_300x95.bmp")
  If StartDrawing(ImageOutput(10))
    FillArea(153, 27, -1, rot) ;Segment oben
    FillArea(149, 67, -1, rot) ;Segment oben
    StopDrawing()
  EndIf
  display()

  ImageGadget(10, 0, 106, 30, 95, ImageID(10))
  ButtonImageGadget(4, 8, 210, 56, 56, LoadImage(4, GetCurrentDirectory() + "Icons/Stock Index Down.ico"))
  ButtonImageGadget(5, 84, 210, 56, 56, LoadImage(5, GetCurrentDirectory() + "Icons/Stock Index Down.ico"))
  ButtonImageGadget(6, 160, 210, 56, 56, LoadImage(6, GetCurrentDirectory() + "Icons/Stock Index Down.ico"))
  ButtonImageGadget(7, 236, 210, 56, 56, LoadImage(7, GetCurrentDirectory() + "Icons/Stock Index Down.ico"))
  If InitSound() = 0
    MessageRequester("Error", "Sound System nicht verfügbar",  0)
    End
  Else
    UseOGGSoundDecoder()   ; Verwenden von Ogg-Dateien
    If LoadSound(0, "Boxing-bell-sound-effect.ogg") = 0
      MessageRequester("Error", "Sound kann nicht geladen werden",  0)
      End
    EndIf
  EndIf

Repeat
    Event = WaitWindowEvent()
    Select Event
      Case #PB_Event_Menu ;ToolBarButton
        Select EventMenu()
          Case 0 ;Start
            If sekunden.l > 0
              AddWindowTimer(0, 0, 1000)
            EndIf
          Case 1 ;Pause
          Case 2 ;Stop
            SetToolBarButtonState(0, 0, 0) 
            RemoveWindowTimer(0, 0)
          Case 3 ;Reset Timer
            SetToolBarButtonState(0, 0, 0) 
            RemoveWindowTimer(0, 0)
            sekunden.l=0
            display()
          Case 4 ;Hilfe...
          Case 5 ;Über
        EndSelect
      Case #PB_Event_Gadget ;Button
        Select EventGadget()
          Case 0
            sekunden.l+600
            display()
          Case 1
            sekunden.l+60
            display()
          Case 2
            sekunden.l+10
            display()
          Case 3
            sekunden.l+1
            display()
          Case 4
            sekunden.l-600
            display()
          Case 5
            sekunden.l-60
            display()
          Case 6
            sekunden.l-10
            display()
          Case 7
            sekunden.l-1
            display()

        EndSelect
      Case #PB_Event_Timer
        If GetToolBarButtonState(0, 1) = 0
          sekunden.l-1
          display()
          If sekunden.l = 0
            SetToolBarButtonState(0, 0, 0) 
            RemoveWindowTimer(0, 0)
            PlaySound(0)
          EndIf
        EndIf
      Case #PB_Event_CloseWindow  ; If the user has pressed on the close button
        Quit = 1
    EndSelect
  Until Event = #PB_Event_CloseWindow    ; If the user has pressed on the close button
Else
  MessageRequester("Error", "Kann Fenster nicht öffnen", 0)
EndIf
FreeSound(0) ; Der Sound wird freigegeben
End

; IDE Options = PureBasic 6.12 LTS (Windows - x64)
; CursorPosition = 121
; FirstLine = 104
; Folding = -
; EnableXP
; UseIcon = Icons\Play.ico
; Executable = CarpaTimer.exe
; Watchlist = display()>sec(0)