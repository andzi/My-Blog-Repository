;---------------------------------------------------------------------------
; PM_04.ASM - Nutzung von (einfachen) Tasks, vgl. pm.asm
;---------------------------------------------------------------------------
; Das Programm funktioniert nicht unter Windows oder einem Expanded Memory
; Manager! Beide Programme laufen bereits im Protected Mode, der die
; Ausf�hrung der hier ben�tigten (Betriebssystem-) Befehle verhindert.
;
; (c) Copyright 1996 by Jens Hohmuth. All Rights Reserved.
; email: Jens.Hohmuth@fh-zwickau.de
;
; Erste Version:    05.12.96
; Letze �nderungen: 05.12.96
;                   29.03.97 - Ausgabe einer Meldung
;---------------------------------------------------------------------------

    ; 386 Prozessor und Befehle f�r Protected Mode assemblieren
                    .386p

;-- externals --------------------------------------------------------------
    include         pm.ext

;-- Stack ------------------------------------------------------------------
    stack           segment stack
                    db 1000 dup (?)
    stack           ends

;-- Daten ------------------------------------------------------------------
    daten           segment USE16 public
        back        label word                      ; R�cksprung, CALL-Gate
                    dw 0
                    dw 0
        text        db "Hallo Welt von einem Task aus !!!",0
    daten           ends

;-- Codesegment ------------------------------------------------------------
                    assume  cs:code, ds:daten, ss:stack
    code            segment use16

    start:
    ; protected mode einschalten
                    call pm_init
                    mov [back+2],ax                 ; R�cksprung Selektor
                                                    ; sichern

    ; ab jetzt als eigenst�ndiger Task ... Meldung ausgeben
                    xor esi,esi
                    mov si,offset text
                    mov edi,(80*2)*24

    output:
                    lodsb
                    or al,al                        ; Byte= 0 (Textende) ?
                    je quit

                    stosb
                    inc di
                    jmp output

    ; zur�ck zum Realmode / DOS ("pm_init" Task fortsetzen)
    quit:
                    jmp dword ptr [back]
    code            ends
                    end start

