extends Powerup

# Apply the power-up to the player
func applyPowerup(player):
	# Only add a life if the player is not at max lives
	if player.lives < player.MAX_LIVES:
		# Increase player's lives
		player.lives += 1
		# Update the ship's visual to match lives
		player.update_ship_sprite()
		# Notify other parts of the game that lives changed
		Signals.emit_signal("on_player_life_changed", player.lives)
