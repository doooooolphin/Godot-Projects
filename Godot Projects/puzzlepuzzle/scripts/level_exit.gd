class_name LevelExit
extends LevelObject


func on_interaction(other):
	if other.player_control:
		if level.get_parent() is LevelEnter:
			level.get_parent().close_level()
