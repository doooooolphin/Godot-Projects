@tool
extends AnimatableBody2D

@export var end_offset = Vector2(0,0):
	set(new_offset):
		end_offset = new_offset
		$EndPos.position = new_offset / scale
@export var move_time = 0.5

var time = 0

var start #Start position
var speed #Average speed

var player = null

var travelling = false

# Called when the node enters the scene tree for the first time.
func _ready():
	start = Vector2(position.x, position.y)
	speed = end_offset.length() / move_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if travelling:
		time += delta
		if time > move_time:
			time = move_time
		var ease_pos = ease(pow(time / move_time,0.75), -3)
		
		position = Vector2(
			start.x + end_offset.x * ease_pos,
			start.y + end_offset.y * ease_pos
		)
		if time == move_time:
			travelling = false
		if player != null && time / move_time > 0.8:
			#Distance travelled over last frame
			#var ease_add = ease_pos - ease(pow((time-delta) / move_time,0.75), -3)
			#player.velocity += speed * end_offset.normalized() * 80 * ease_add
			#player.add_fling_time(0.5)
			pass

func on_key_collect(key):
	travelling = true
	time = 0
	
func on_key_lost(key):
	travelling = false
	time = 0
	position = Vector2(start.x, start.y)


func _on_player_area_body_entered(body):
	player = body


func _on_player_area_body_exited(body):
	player = null
