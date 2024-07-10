extends Control

func _on_player_life_changed(player_hearts, player_hearts_after):
	if player_hearts - 1 >= 0 && player_hearts > player_hearts_after:
		var heart = get_node(str("Heart",player_hearts - 1))
		heart.texture = load("res://art/player_art/heart_empty2.png")
		_on_player_life_changed(player_hearts - 1, player_hearts_after)
