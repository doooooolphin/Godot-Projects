extends Area2D

var active = true
var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if !active:
		return
	player = body
	if player.double_jumps < 1:
		active = false
		player.double_jumps = max(body.double_jumps, 1)
	player.glide_stamina = 1
	$Sprite2D.modulate = Color(1,1,1,.4)
	await player.on_touch_floor
	$Sprite2D.modulate = Color(1,1,1,1)
	active = true
