extends Powerup

const SHIELD_TIME = 15

func applyPowerup(player):
	player.applyShield(SHIELD_TIME)
