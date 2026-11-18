' ==== STAR LASER - ZX Spectrum 48K (Boriel ZX Basic) ====
' Compilar: zxbc -t -B -a main.bas

#include "constants.bas"
#include "variables.bas"
#include "utils.bas"
#include "sound.bas"
#include "graphics.bas"
#include "hud.bas"
#include "enemies.bas"
#include "game.bas"
#include "screens.bas"

BORDER 0
PAPER 0
INK 7
BRIGHT 0
CLS
initGraphics()

score = 0
lives = START_LIVES
phase = 1
enemiesLeft = 0

DO
    titleScreen()
    IF playGame() THEN
        victoryScreen()
    ELSE
        gameOverScreen()
    END IF
LOOP
