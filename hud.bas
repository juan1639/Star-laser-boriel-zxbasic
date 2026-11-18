' ---- Marcadores ----

SUB drawHud()
    PRINT AT 0, 0; PAPER 0; BRIGHT 1; INK COL_LABEL; "PUNTOS "; INK COL_VALUE; padNum(score, 5);
    PRINT AT 0, 21; PAPER 0; BRIGHT 1; INK COL_LABEL; "REC "; INK COL_VALUE; padNum(record, 5);
    PRINT AT 1, 0; PAPER 0; BRIGHT 1; INK COL_LABEL; "FASE   "; INK COL_VALUE; padNum(phase, 2);
    PRINT AT 1, 21; PAPER 0; BRIGHT 1; INK COL_LABEL; "VID "; INK COL_VALUE; lives; " ";
END SUB

' Aviso "VIDA EXTRA!" en el hueco central de la segunda linea del marcador.
' Se quita solo cuando extraMsgTimer llega a 0 (ver tickExtraLifeMsg).
SUB showExtraLifeMsg()
    PRINT AT 1, EXTRA_MSG_COL; PAPER 0; INK 4; BRIGHT 1; FLASH 1; "VIDA EXTRA!";
    extraMsgTimer = EXTRA_MSG_FRAMES
END SUB

' Llamar una vez por fotograma durante la partida
SUB tickExtraLifeMsg()
    IF extraMsgTimer = 0 THEN RETURN
    extraMsgTimer = extraMsgTimer - 1
    IF extraMsgTimer = 0 THEN PRINT AT 1, EXTRA_MSG_COL; PAPER 0; INK 7; BRIGHT 0; FLASH 0; "           ";
END SUB
