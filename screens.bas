' ---- Pantallas de titulo y fin ----

' Direccion en pantalla de la linea de pixeles y (0-191) y la columna c (0-31)
FUNCTION scrAddr(y AS UByte, c AS UByte) AS UInteger
    RETURN 16384 + (CAST(UInteger, y bAND 192) SHL 5) + (CAST(UInteger, y bAND 7) SHL 8) + (CAST(UInteger, y bAND 56) SHL 2) + c
END FUNCTION

' Texto a doble tamano con la fuente de la ROM: cada letra ocupa 2x2
' caracteres. Fila de arriba con tinta inkTop, fila de abajo con inkBot.
SUB printBig(row AS UByte, col AS UByte, t AS String, inkTop AS UByte, inkBot AS UByte)
    DIM i, k, b, bit, bL, bR, y, c AS UByte
    DIM fnt, attr AS UInteger
    FOR i = 0 TO LEN(t) - 1
        fnt = 15360 + CAST(UInteger, CODE(t(i TO i))) * 8
        c = col + i * 2
        FOR k = 0 TO 7
            ' Duplica cada pixel en horizontal: 8 bits -> 2 bytes
            b = PEEK(fnt + k)
            bL = 0
            bR = 0
            FOR bit = 0 TO 3
                IF b bAND (128 SHR bit) THEN bL = bL bOR (192 SHR (bit * 2))
                IF b bAND (8 SHR bit) THEN bR = bR bOR (192 SHR (bit * 2))
            NEXT bit
            ' ...y en vertical: cada linea se pinta dos veces
            y = row * 8 + k * 2
            POKE scrAddr(y, c), bL
            POKE scrAddr(y, c + 1), bR
            POKE scrAddr(y + 1, c), bL
            POKE scrAddr(y + 1, c + 1), bR
        NEXT k
        attr = 22528 + CAST(UInteger, row) * 32 + c
        POKE attr, inkTop + 64
        POKE attr + 1, inkTop + 64
        POKE attr + 32, inkBot + 64
        POKE attr + 33, inkBot + 64
    NEXT i
END SUB

' Linea de control centrada: tecla en amarillo, guion blanco y descripcion en color
SUB printControl(r AS UByte, key$ AS String, desc$ AS String, k AS UByte)
    DIM c AS UByte
    c = (32 - LEN(key$) - 3 - LEN(desc$)) SHR 1
    PRINT AT r, c; PAPER 0; BRIGHT 1; INK 6; key$; INK 7; " - "; INK k; desc$;
END SUB

SUB titleScreen()
    CLS
    generateStars()
    drawBorders()
    drawStars()
    drawHud()
    printBig(4, 6, "STAR LASER", 6, 4)
    printControl(7, "Boriel", "Basic", 4)
    printControl(10, "Q", "ARRIBA", 5)
    printControl(12, "A", "ABAJO", 4)
    printControl(14, "ESPACIO", "DISPARO", 3)
    'PRINT AT 17, 12; PAPER 0; BRIGHT 1; INK 5; "REC "; INK 6; padNum(record, 5);
    PRINT AT 17, 7; PAPER 0; BRIGHT 0; INK 2; "By Juan Eguia 2026" 
    PRINT AT 19, 9; PAPER 0; INK 7; BRIGHT 1; FLASH 1; "PULSA ESPACIO";
    IF sndTitle() THEN
        ' Melodia cortada con ESPACIO: basta con esperar a que se suelte
        DO
            PAUSE 1
        LOOP UNTIL keyFire() = 0
    ELSE
        waitFire()
    END IF
    RANDOMIZE PEEK(UInteger, 23672)
END SUB

SUB gameOverScreen()
    'showMessage(10, "  GAME OVER  ", 2)
    printBig(10, 8, "GAME OVER", 6, 2)    
    sndGameOver()
    IF score > record THEN
        record = score
        drawHud()
        showMessage(14, " NUEVO RECORD ", 6)
    END IF
    PAUSE 100
    waitFire()
END SUB

' Texto centrado con cada letra de un color (los espacios no gastan color)
SUB printRainbow(r AS UByte, t AS String)
    DIM i, n, c AS UByte
    c = (32 - LEN(t)) SHR 1
    n = 0
    FOR i = 0 TO LEN(t) - 1
        PRINT AT r, c + i; PAPER 0; BRIGHT 1; INK rainbowInks(n); t(i TO i);
        IF t(i TO i) <> " " THEN
            n = n + 1
            IF n = NUM_RAINBOW_INKS THEN n = 0
        END IF
    NEXT i
END SUB

' Pantalla final al superar la ultima fase
SUB victoryScreen()
    DIM newRec AS UByte = 0
    CLS
    generateStars()
    drawBorders()
    drawStars()
    IF score > record THEN
        record = score
        newRec = 1
    END IF
    drawHud()
    printBig(4, 4, "ENHORABUENA!", 6, 2)
    printRainbow(8, "HAS SUPERADO EL JUEGO")
    showMessage(10, "LA GALAXIA ESTA A SALVO", 5)
    PRINT AT 12, 10; PAPER 0; BRIGHT 1; INK 5; "PUNTOS "; INK 6; padNum(score, 5);
    IF newRec THEN showMessage(13, "NUEVO RECORD", 4)
    printRainbow(15, "GRACIAS POR JUGAR")
    PRINT AT 17, 3; PAPER 0; BRIGHT 1; INK 2; "Programado por "; INK 2; "Juan Eguia";
    PRINT AT 20, 9; PAPER 0; INK 7; BRIGHT 1; FLASH 1; "PULSA ESPACIO";
    IF sndVictory() THEN
        DO
            PAUSE 1
        LOOP UNTIL keyFire() = 0
    ELSE
        waitFire()
    END IF
END SUB
