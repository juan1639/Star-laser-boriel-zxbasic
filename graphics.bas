' ---- Graficos (UDG) y dibujo ----

DIM udg(9, 7) AS UByte => { _
    {96, 120, 63, 255, 255, 63, 120, 96}, _
    {0, 0, 216, 254, 254, 216, 0, 0}, _
    {7, 31, 54, 255, 127, 25, 48, 96}, _
    {224, 248, 220, 255, 254, 152, 12, 6}, _
    {0, 0, 0, 255, 0, 0, 0, 0}, _
    {254, 130, 186, 170, 186, 130, 254, 0}, _
    {0, 0, 0, 16, 0, 0, 0, 0}, _
    {64, 0, 0, 0, 0, 0, 0, 0}, _
    {0, 0, 0, 0, 0, 2, 0, 0}, _
    {0, 0, 8, 28, 8, 0, 0, 0} _
}

SUB initGraphics()
    POKE UINTEGER 23675, @udg(0, 0)
END SUB

' Repinta una celda con su fondo (vacio o estrella)
SUB drawBgCell(r AS UByte, c AS UByte)
    DIM v AS UByte = bg(r, c)
    IF v = 0 THEN
        PRINT AT r, c; PAPER 0; INK 7; BRIGHT 0; " ";
    ELSE
        PRINT AT r, c; PAPER 0; INK (v SHR 4); BRIGHT 1; CHR$(144 + UDG_STAR0 + (v bAND 15) - 1);
    END IF
END SUB

' Genera un nuevo campo de estrellas
SUB generateStars()
    DIM r, c AS UByte
    FOR r = 0 TO 23
        FOR c = 0 TO 31
            bg(r, c) = 0
        NEXT c
    NEXT r
    FOR r = PLAY_TOP TO PLAY_BOTTOM
        FOR c = PLAY_LEFT TO PLAY_RIGHT
            IF RND < STAR_CHANCE THEN
                bg(r, c) = rndInt(1, NUM_STAR_TYPES) + starInks(rndInt(0, NUM_STAR_INKS - 1)) * 16
            END IF
        NEXT c
    NEXT r
END SUB

SUB drawStars()
    DIM r, c AS UByte
    FOR r = PLAY_TOP TO PLAY_BOTTOM
        FOR c = PLAY_LEFT TO PLAY_RIGHT
            drawBgCell(r, c)
        NEXT c
    NEXT r
END SUB

' Pieza metalica alternando dos tonos
SUB drawMetal(r AS UByte, c AS UByte)
    IF ((r + c) bAND 1) = 0 THEN
        PRINT AT r, c; PAPER 0; INK COL_METAL_A; BRIGHT 1; CHR$(144 + UDG_METAL);
    ELSE
        PRINT AT r, c; PAPER 0; INK COL_METAL_B; BRIGHT 0; CHR$(144 + UDG_METAL);
    END IF
END SUB

SUB drawBorders()
    DIM r, c AS UByte
    FOR c = LEFT_BORDER TO RIGHT_BORDER
        drawMetal(TOP_BORDER, c)
        drawMetal(BOTTOM_BORDER, c)
    NEXT c
    FOR r = PLAY_TOP TO PLAY_BOTTOM
        drawMetal(r, LEFT_BORDER)
        drawMetal(r, RIGHT_BORDER)
    NEXT r
END SUB

SUB drawShip()
    PRINT AT shipRow, SHIP_COL; PAPER 0; INK COL_SHIP; BRIGHT 1; CHR$(144 + UDG_SHIP_L); CHR$(144 + UDG_SHIP_R);
END SUB

SUB eraseShip()
    drawBgCell(shipRow, SHIP_COL)
    drawBgCell(shipRow, SHIP_COL + 1)
END SUB

SUB drawEnemy()
    PRINT AT enemyRow, enemyCol; PAPER 0; INK enemyColor; BRIGHT 1; CHR$(144 + UDG_ENEMY_L); CHR$(144 + UDG_ENEMY_R);
END SUB

SUB eraseEnemy()
    drawBgCell(enemyRow, enemyCol)
    drawBgCell(enemyRow, enemyCol + 1)
END SUB

' Repinta el fondo de un rectangulo recortado al area de juego
SUB restoreArea(r1 AS Integer, c1 AS Integer, r2 AS Integer, c2 AS Integer)
    DIM r, c AS Integer
    IF r1 < PLAY_TOP THEN r1 = PLAY_TOP
    IF r2 > PLAY_BOTTOM THEN r2 = PLAY_BOTTOM
    IF c1 < PLAY_LEFT THEN c1 = PLAY_LEFT
    IF c2 > PLAY_RIGHT THEN c2 = PLAY_RIGHT
    FOR r = r1 TO r2
        FOR c = c1 TO c2
            drawBgCell(r, c)
        NEXT c
    NEXT r
END SUB

' Explosion de particulas que se separan desde (cx, cy) en pixeles
SUB explosion(cx AS Integer, cy AS Integer)
    DIM t, i, k AS UByte
    DIM x, y AS Integer
    FOR t = 1 TO EXPLOSION_FRAMES
        k = partInk(t - 1)
        FOR i = 0 TO NUM_PARTICLES - 1
            x = cx + CAST(Integer, partDx(i)) * t
            y = cy + CAST(Integer, partDy(i)) * t
            IF x >= PIX_LEFT AND x <= PIX_RIGHT AND y >= PIX_BOTTOM AND y <= PIX_TOP THEN
                PLOT INK k; BRIGHT 1; OVER 1; x, y
            END IF
        NEXT i
        sndExplosionStep(t)
        PAUSE 1
        FOR i = 0 TO NUM_PARTICLES - 1
            x = cx + CAST(Integer, partDx(i)) * t
            y = cy + CAST(Integer, partDy(i)) * t
            IF x >= PIX_LEFT AND x <= PIX_RIGHT AND y >= PIX_BOTTOM AND y <= PIX_TOP THEN
                PLOT INK k; BRIGHT 1; OVER 1; x, y
            END IF
        NEXT i
    NEXT t
END SUB

' Texto centrado dentro del area de juego
SUB showMessage(r AS UByte, msg$ AS String, k AS UByte)
    PRINT AT r, (32 - LEN(msg$)) SHR 1; PAPER 0; INK k; BRIGHT 1; msg$;
END SUB

SUB clearMessage(r AS UByte)
    restoreArea(r, PLAY_LEFT, r, PLAY_RIGHT)
END SUB
