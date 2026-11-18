' ---- Variables globales ----

DIM score AS UInteger
DIM record AS UInteger = 0
DIM lives AS UByte
DIM phase AS UByte
DIM enemiesLeft AS UByte

' Nave
DIM shipRow AS UByte
DIM moveTimer AS UByte
DIM fireTimer AS UByte

' Enemigo (uno a la vez)
DIM enemyActive AS UByte
DIM enemyRow AS UByte
DIM enemyCol AS UByte
DIM enemyTimer AS UByte
DIM enemyDelay AS UByte
DIM enemyColor AS UByte
DIM spawnTimer AS UByte

' Fondo de estrellas: tipo (bits 0-3) + tinta (bits 4-6), 0 = vacio
DIM bg(23, 31) AS UByte

' Vidas extra: puntuaciones a las que se dan y cuantas se han dado ya
' (una partida completa con ~15 enemigos por fase da ~5400 puntos)
DIM bonusScores(1) AS UInteger => {1000, 3000}
DIM nextBonus AS UByte
DIM extraMsgTimer AS UByte

' Tintas de las estrellas: rojo, magenta, cian, amarillo, blanco (sin azul ni verde)
DIM starInks(4) AS UByte => {2, 3, 5, 6, 7}

' Tintas para los textos arcoiris de la pantalla final
DIM rainbowInks(5) AS UByte => {2, 3, 5, 4, 6, 7}

' Colores de los enemigos por fase
DIM enemyColors(5) AS UByte => {6, 4, 3, 2, 7, 5}

' Direcciones de las particulas de la explosion
DIM partDx(15) AS Byte => {3, 3, 2, 1, 0, -1, -2, -3, -3, -3, -2, -1, 0, 1, 2, 3}
DIM partDy(15) AS Byte => {0, 1, 2, 3, 3, 3, 2, 1, 0, -1, -2, -3, -3, -3, -2, -1}
DIM partInk(5) AS UByte => {7, 6, 6, 2, 2, 1}
