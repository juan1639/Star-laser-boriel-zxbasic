' ---- Constantes de STAR LASER ----

' Area de juego (en caracteres)
#define TOP_BORDER 2
#define BOTTOM_BORDER 22
#define LEFT_BORDER 0
#define RIGHT_BORDER 31
#define PLAY_TOP 3
#define PLAY_BOTTOM 21
#define PLAY_LEFT 1
#define PLAY_RIGHT 30

' Area de juego en pixeles (para las particulas)
#define PIX_LEFT 8
#define PIX_RIGHT 247
#define PIX_BOTTOM 16
#define PIX_TOP 167

' Nave del jugador
#define SHIP_COL 2
#define SHIP_START_ROW 12
#define SHIP_MOVE_FRAMES 3
#define FIRE_COOLDOWN 8

' Enemigos
#define ENEMY_START_COL 29
#define ENEMIES_BASE 8
#define ENEMIES_EXTRA 4
#define ENEMY_DELAY_START 7
#define ENEMY_DELAY_MIN 2
#define SPAWN_FRAMES 25
#define POINTS_PER_ENEMY 10
#define COL_BONUS_MIN 5
#define COL_BONUS_MAX 12

' Partida
#define START_LIVES 2
#define NUM_PHASES 7
#define PHASE_CLEAR_FRAMES 190
#define NUM_BONUS_LIVES 2
#define EXTRA_MSG_FRAMES 150
#define EXTRA_MSG_COL 9
#define STAR_CHANCE 0.12
#define NUM_PARTICLES 16
#define EXPLOSION_FRAMES 6
#define EXPLOSION_CELLS 3

' Melodias
#define TUNE_UNIT 0.0625
#define TUNE_REST 99

' Indices de UDG
#define UDG_SHIP_L 0
#define UDG_SHIP_R 1
#define UDG_ENEMY_L 2
#define UDG_ENEMY_R 3
#define UDG_LASER 4
#define UDG_METAL 5
#define UDG_STAR0 6
#define NUM_STAR_TYPES 4
#define NUM_STAR_INKS 5
#define NUM_RAINBOW_INKS 6

' Colores
#define COL_SHIP 5
#define COL_LASER 2
#define COL_METAL_A 7
#define COL_METAL_B 5
#define COL_LABEL 5
#define COL_VALUE 6
#define NUM_ENEMY_COLORS 6

' Puertos de teclado (bit 0 de cada semifila)
#define PORT_Q 64510
#define PORT_A 65022
#define PORT_SPACE 32766
