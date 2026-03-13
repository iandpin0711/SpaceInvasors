extends Powerup

# Duration of shield in seconds
const SHIELD_TIME = 15

# Apply shield to player when collected
func applyPowerup(player):
	player.applyShield(SHIELD_TIME)
