' ---- Enemigos ----

SUB spawnEnemy()
    enemyActive = 1
    enemyRow = rndInt(PLAY_TOP, PLAY_BOTTOM)
    enemyCol = ENEMY_START_COL
    enemyTimer = 0
    drawEnemy()
END SUB

' Devuelve 1 si el enemigo toca la nave
FUNCTION enemyHitsShip() AS UByte
    IF enemyActive = 0 THEN RETURN 0
    IF enemyRow <> shipRow THEN RETURN 0
    IF enemyCol <= SHIP_COL + 1 AND enemyCol + 1 >= SHIP_COL THEN RETURN 1
    RETURN 0
END FUNCTION
