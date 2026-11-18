' ---- Sonidos ----

SUB sndLaser()
    DIM i AS UByte
    FOR i = 0 TO 5
        BEEP 0.004, 60 - i * 3
    NEXT i
END SUB

SUB sndExplosionStep(t AS UByte)
    BEEP 0.012, -10 - t * 4
END SUB

SUB sndLoseLife()
    ' Byte con signo: el tono baja a negativo (con UByte daba 245 -> error de BEEP)
    DIM i AS Byte
    FOR i = 0 TO 7
        BEEP 0.03, 10 - i * 3
    NEXT i
END SUB

SUB sndPhaseClear()
    BEEP 0.08, 12
    BEEP 0.08, 16
    BEEP 0.08, 19
    BEEP 0.2, 24
END SUB

SUB sndExtraLife()
    DIM i AS UByte
    FOR i = 0 TO 2
        BEEP 0.03, 24
        BEEP 0.03, 28
        BEEP 0.03, 31
    NEXT i
    BEEP 0.12, 36
END SUB

SUB sndGameOver()
    BEEP 0.2, 0
    BEEP 0.2, -3
    BEEP 0.2, -7
    BEEP 0.5, -12
END SUB

' ---- Melodias ----
' Cada nota: tono en semitonos (0 = Do central) y duracion en unidades
' de TUNE_UNIT segundos. El tono TUNE_REST es un silencio.

' Titulo (~6 s): fanfarria en Do menor con arpegios
#define TITLE_NOTES 54
DIM tuneTitleP(53) AS Byte => { _
    0, 3, 7, 12, 15, 12, 15, 19, _
    17, 15, 14, 12, 10, 12, 14, _
    8, 12, 15, 20, 19, 17, 15, _
    10, 14, 17, 22, 20, 19, 17, _
    19, 17, 15, 14, 12, 10, 8, 7, _
    7, 11, 14, 17, _
    12, 15, 19, 24, 22, 24, 22, 24, _
    99, 19, 24, 27, 24 _
}
DIM tuneTitleD(53) AS UByte => { _
    1, 1, 1, 1, 2, 1, 1, 4, _
    2, 2, 2, 2, 2, 2, 4, _
    1, 1, 1, 1, 2, 2, 4, _
    1, 1, 1, 1, 2, 2, 4, _
    1, 1, 1, 1, 1, 1, 1, 1, _
    2, 2, 2, 2, _
    1, 1, 1, 1, 1, 1, 1, 1, _
    1, 1, 1, 1, 10 _
}

' Preparado (~3 s): llamada rapida que sube hasta un Do agudo
#define READY_NOTES 29
DIM tuneReadyP(28) AS Byte => { _
    7, 7, 7, 99, 7, 12, _
    10, 10, 10, 99, 10, 15, _
    12, 15, 19, 24, 19, 24, 27, 31, _
    27, 26, 24, 26, _
    24, 27, 31, 99, 36 _
}
DIM tuneReadyD(28) AS UByte => { _
    1, 1, 1, 1, 1, 3, _
    1, 1, 1, 1, 1, 3, _
    1, 1, 1, 1, 1, 1, 1, 1, _
    2, 2, 2, 2, _
    1, 1, 1, 1, 8 _
}

' Victoria (~3 s): arpegio mayor ascendente y final brillante
#define VICTORY_NOTES 23
DIM tuneVictoryP(22) AS Byte => { _
    0, 4, 7, 12, 16, 19, 24, _
    22, 19, 21, 24, _
    17, 21, 24, 29, 28, 26, 28, _
    99, 24, 28, 31, 36 _
}
DIM tuneVictoryD(22) AS UByte => { _
    1, 1, 1, 1, 1, 1, 4, _
    2, 2, 2, 4, _
    1, 1, 1, 3, 1, 1, 4, _
    1, 1, 1, 1, 8 _
}

' Toca una melodia a partir de las direcciones de sus tablas de tonos y duraciones.
' Si canSkip <> 0, ESPACIO la corta entre nota y nota.
' Devuelve 1 si se ha cortado, 0 si ha sonado entera.
FUNCTION playTune(pAddr AS UInteger, dAddr AS UInteger, n AS UByte, canSkip AS UByte) AS UByte
    DIM i, d AS UByte
    DIM p AS Byte
    FOR i = 0 TO n - 1
        IF canSkip <> 0 THEN
            IF keyFire() THEN RETURN 1
        END IF
        p = PEEK(Byte, pAddr + i)
        d = PEEK(dAddr + i)
        IF p = TUNE_REST THEN
            PAUSE d * 3
        ELSE
            BEEP CAST(Float, d) * TUNE_UNIT, p
        END IF
    NEXT i
    RETURN 0
END FUNCTION

' Devuelve 1 si el jugador la ha cortado con ESPACIO
FUNCTION sndTitle() AS UByte
    RETURN playTune(@tuneTitleP(0), @tuneTitleD(0), TITLE_NOTES, 1)
END FUNCTION

FUNCTION sndVictory() AS UByte
    RETURN playTune(@tuneVictoryP(0), @tuneVictoryD(0), VICTORY_NOTES, 1)
END FUNCTION

SUB sndReady()
    playTune(@tuneReadyP(0), @tuneReadyD(0), READY_NOTES, 0)
END SUB
