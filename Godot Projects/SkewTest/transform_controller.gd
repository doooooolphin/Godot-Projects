extends Node2D

@export var min_x = Vector2(1,0)
@export var max_x = Vector2(1,0)

@export var min_y = Vector2(0,1)
@export var max_y = Vector2(0,1)

@export_range(0,1) var t


var on_player = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_transform_modifier():
	var x = Vector2(lerp(min_x.x, max_x.x, t), lerp(min_x.y, max_x.y, t))
	var y = Vector2(lerp(min_y.x, max_y.x, t), lerp(min_y.y, max_y.y, t))
	return [x, y]

func get_warp_scene():
	return get_parent()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if on_player:
		adjust_slider(delta)

func adjust_slider(delta):
	var input = -Input.get_axis("interact_left","interact_right")
	if input == 0:
		return
	
	t += input * delta / 1
	t = clampf(t, 0, 1)
	
	var modifier = get_transform_modifier()
	get_warp_scene().set_linear_transform(modifier[0], modifier[1])

func on_player_interaction(entered):
	on_player = entered
