' ---- Logica de la partida ----

SUB loseLife()
    lives = lives - 1
    drawHud()
    sndLoseLife()
END SUB

' Suma puntos y da una vida extra al alcanzar cada puntuacion de bonusScores
SUB addScore(pts AS UInteger)
    score = score + pts
    IF nextBonus < NUM_BONUS_LIVES THEN
        IF score >= bonusScores(nextBonus) THEN
            nextBonus = nextBonus + 1
            lives = lives + 1
            drawHud()
            showExtraLifeMsg()
            sndExtraLife()
        END IF
    END IF
END SUB

' Puntos extra (antes de multiplicar por la fase) segun la columna del enemigo:
' 2 puntos por cada 4 columnas de distancia a la nave, de 0 a COL_BONUS_MAX
FUNCTION colBonus(col AS UByte) AS UByte
    IF col <= COL_BONUS_MIN THEN RETURN 0
    RETURN ((col - COL_BONUS_MIN) SHR 2) * 2
END FUNCTION

' El enemigo actual desaparece y cuenta como derribado (por laser, choque o escape)
SUB enemyDown()
    enemyActive = 0
    spawnTimer = SPAWN_FRAMES
    IF enemiesLeft > 0 THEN enemiesLeft = enemiesLeft - 1
END SUB

' La nave choca con el enemigo
SUB shipCrash()
    DIM cx, cy AS Integer
    eraseEnemy()
    enemyDown()
    eraseShip()
    cx = SHIP_COL * 8 + 8
    cy = 187 - CAST(Integer, shipRow) * 8
    explosion(cx, cy)
    restoreArea(CAST(Integer, shipRow) - EXPLOSION_CELLS, CAST(Integer, SHIP_COL) - EXPLOSION_CELLS, CAST(Integer, shipRow) + EXPLOSION_CELLS, CAST(Integer, SHIP_COL) + 1 + EXPLOSION_CELLS)
    loseLife()
    IF lives > 0 THEN drawShip()
END SUB

' El enemigo ha cruzado la pantalla
SUB enemyPassed()
    eraseEnemy()
    enemyDown()
    BORDER 2
    loseLife()
    BORDER 0
END SUB

SUB fireLaser()
    DIM endCol, c AS UByte
    DIM hit AS UByte = 0
    DIM cx, cy AS Integer
    ' IFs anidados: zxbc 1.18.7 compila mal "enemyActive AND ..." (no lee enemyActive)
    endCol = PLAY_RIGHT
    IF enemyActive <> 0 THEN
        IF enemyRow = shipRow THEN
            IF enemyCol >= SHIP_COL + 2 THEN
                hit = 1
                endCol = enemyCol - 1
            END IF
        END IF
    END IF
    ' Dibuja el laser
    IF endCol >= SHIP_COL + 2 THEN
        FOR c = SHIP_COL + 2 TO endCol
            PRINT AT shipRow, c; PAPER 0; INK COL_LASER; BRIGHT 1; CHR$(144 + UDG_LASER);
        NEXT c
    END IF
    sndLaser()
    IF endCol >= SHIP_COL + 2 THEN
        FOR c = SHIP_COL + 2 TO endCol
            drawBgCell(shipRow, c)
        NEXT c
    END IF
    IF hit THEN
        eraseEnemy()
        cx = CAST(Integer, enemyCol) * 8 + 8
        cy = 187 - CAST(Integer, enemyRow) * 8
        explosion(cx, cy)
        restoreArea(CAST(Integer, enemyRow) - EXPLOSION_CELLS, CAST(Integer, enemyCol) - EXPLOSION_CELLS, CAST(Integer, enemyRow) + EXPLOSION_CELLS, CAST(Integer, enemyCol) + 1 + EXPLOSION_CELLS)
        drawShip()
        enemyDown()
        ' Base + extra por derribarlo pronto: en la columna 29 (recien aparecido)
        ' da COL_BONUS_MAX extra, y va bajando hasta 0 en la columna 5 o menos
        addScore(CAST(UInteger, POINTS_PER_ENEMY + colBonus(enemyCol)) * phase)
        drawHud()
    END IF
END SUB

SUB moveEnemy()
    IF enemyActive = 0 THEN
        IF enemiesLeft > 0 THEN
            IF spawnTimer > 0 THEN
                spawnTimer = spawnTimer - 1
            ELSE
                spawnEnemy()
            END IF
        END IF
        RETURN
    END IF
    enemyTimer = enemyTimer + 1
    IF enemyTimer < enemyDelay THEN RETURN
    enemyTimer = 0
    IF enemyCol <= PLAY_LEFT THEN
        enemyPassed()
        RETURN
    END IF
    drawBgCell(enemyRow, enemyCol + 1)
    enemyCol = enemyCol - 1
    IF enemyHitsShip() THEN
        shipCrash()
        RETURN
    END IF
    drawEnemy()
END SUB

SUB moveShip()
    IF moveTimer > 0 THEN
        moveTimer = moveTimer - 1
        RETURN
    END IF
    IF keyUp() AND shipRow > PLAY_TOP THEN
        eraseShip()
        shipRow = shipRow - 1
        moveTimer = SHIP_MOVE_FRAMES
    ELSEIF keyDown() AND shipRow < PLAY_BOTTOM THEN
        eraseShip()
        shipRow = shipRow + 1
        moveTimer = SHIP_MOVE_FRAMES
    ELSE
        RETURN
    END IF
    IF enemyHitsShip() THEN
        shipCrash()
    ELSE
        drawShip()
    END IF
END SUB

' Prepara la pantalla de una fase
SUB startPhase()
    DIM d AS Integer
    enemiesLeft = ENEMIES_BASE + rndInt(0, ENEMIES_EXTRA)
    d = ENEMY_DELAY_START - (phase - 1)
    IF d < ENEMY_DELAY_MIN THEN d = ENEMY_DELAY_MIN
    enemyDelay = d
    enemyColor = enemyColors((phase - 1) MOD NUM_ENEMY_COLORS)
    enemyActive = 0
    spawnTimer = SPAWN_FRAMES
    shipRow = SHIP_START_ROW
    moveTimer = 0
    fireTimer = 0
    extraMsgTimer = 0
    CLS
    generateStars()
    drawBorders()
    drawStars()
    drawHud()
    drawShip()
    showMessage(8, "FASE " + padNum(phase, 2), 6)
    showMessage(10, "PREPARADO", 7)
    sndReady()
    waitFrames(15)
    clearMessage(8)
    clearMessage(10)
END SUB

' Juega una fase: devuelve 1 si se supera, 0 si se acaban las vidas
FUNCTION playPhase() AS UByte
    DO
        PAUSE 1
        tickExtraLifeMsg()
        moveShip()
        IF lives = 0 THEN RETURN 0
        IF fireTimer > 0 THEN
            fireTimer = fireTimer - 1
        ELSEIF keyFire() THEN
            fireLaser()
            fireTimer = FIRE_COOLDOWN
        END IF
        moveEnemy()
        IF lives = 0 THEN RETURN 0
        IF enemiesLeft = 0 AND enemyActive = 0 THEN RETURN 1
    LOOP
    RETURN 0
END FUNCTION

' Juega una partida: devuelve 1 si se superan todas las fases, 0 si se acaban las vidas
FUNCTION playGame() AS UByte
    score = 0
    lives = START_LIVES
    phase = 1
    nextBonus = 0
    DO
        startPhase()
        IF playPhase() = 0 THEN RETURN 0
        'showMessage(10, "FASE SUPERADA", 4)
        printBig(10, 3, "FASE SUPERADA", 6, 4)
        sndPhaseClear()
        waitFrames(PHASE_CLEAR_FRAMES)
        IF phase >= NUM_PHASES THEN RETURN 1
        phase = phase + 1
    LOOP
    RETURN 0
END FUNCTION
