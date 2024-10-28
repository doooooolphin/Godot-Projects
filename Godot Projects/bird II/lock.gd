extends StaticBody2D

@export var reverse_states = false

# Called when the node enters the scene tree for the first time.
func _ready():
	set_state(reverse_states)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_state(unlocked):
	set_collision_layer_value(2, !unlocked)
	if unlocked:
		hide()
	else:
		show()

func on_key_collect(key):
	set_state(!reverse_states)
	
func on_key_lost(key):
	set_state(reverse_states)
