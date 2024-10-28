@tool
extends Sprite2D

@export var hitbox_width = 100.0
@export var hitbox_height = 100.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Engine.is_editor_hint():
		$StaticBody2D.get_child(0).scale.x = hitbox_width / 100.0
		$StaticBody2D.get_child(0).scale.y = hitbox_height / 100.0
	
