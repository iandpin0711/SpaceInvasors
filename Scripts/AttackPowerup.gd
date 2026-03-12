extends Powerup

# How long the triple shot lasts (in seconds)
var TRIPLESHOT_TIME = 10

# Called when the player gets power-up
func applyPowerup(player):
	# Give the player triple shot
	player.applyTripleShot(TRIPLESHOT_TIME)
