' ---- Utilidades ----

FUNCTION rndInt(a AS UByte, b AS UByte) AS UByte
    RETURN a + CAST(UByte, INT(RND * (b - a + 1)))
END FUNCTION

FUNCTION keyUp() AS UByte
    RETURN (IN(PORT_Q) bAND 1) = 0
END FUNCTION

FUNCTION keyDown() AS UByte
    RETURN (IN(PORT_A) bAND 1) = 0
END FUNCTION

FUNCTION keyFire() AS UByte
    RETURN (IN(PORT_SPACE) bAND 1) = 0
END FUNCTION

' Espera n fotogramas (1/50 s). A diferencia de PAUSE (rutina de la ROM),
' no se corta al pulsar una tecla.
SUB waitFrames(n AS UByte)
    DIM i AS UByte
    FOR i = 1 TO n
        ASM
            halt
        END ASM
    NEXT i
END SUB

' Espera a que se suelte y se pulse ESPACIO
SUB waitFire()
    DO
        PAUSE 1
    LOOP UNTIL keyFire() = 0
    DO
        PAUSE 1
    LOOP UNTIL keyFire()
    DO
        PAUSE 1
    LOOP UNTIL keyFire() = 0
END SUB

' Numero con ceros a la izquierda
FUNCTION padNum(n AS UInteger, digits AS UByte) AS String
    DIM s$ AS String
    s$ = STR$(n)
    WHILE LEN(s$) < digits
        s$ = "0" + s$
    WEND
    RETURN s$
END FUNCTION
