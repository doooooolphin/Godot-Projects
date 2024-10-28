extends Node2D

@export var selected_level : Node

# Called when the node enters the scene tree for the first time.
func _ready():
	for c in get_children():
		if c != selected_level:
			c.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
