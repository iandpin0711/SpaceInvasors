extends Powerup

func applyPowerup(player):
	if player.lives < player.MAX_LIVES:
		player.lives += 1
		player.update_ship_sprite()
		Signals.emit_signal("on_player_life_changed", player.lives)
