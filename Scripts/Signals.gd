extends Node

# Signal for when the player's lives change
signal on_player_life_changed(life)
# Signal for when the score increases
signal on_score_increment(amount)
# Signal to start the boss fight
signal boss_start

# Current game score
var score = 0
