extends Powerup

# --------------------------------------------------
# Power-up configuration
# --------------------------------------------------
# Duration (in seconds) that the triple shot ability lasts
var TRIPLESHOT_TIME = 10


# --------------------------------------------------
# Power-up application
# --------------------------------------------------
# Called when the player collects or activates this power-up
func applyPowerup(player):

	# Apply the triple shot ability to the player
	# for the configured duration
	player.applyTripleShot(TRIPLESHOT_TIME)
