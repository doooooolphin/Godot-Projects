extends Area2D

var time = 0
var r_time = 0

var collected = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	r_time += delta * (1 + 4*abs(sin(r_time/4)))
	$Sprite2D.position.y = 5 * sin(time*3)
	$Sprite2D.rotation = .25 * sin(r_time*3)


func _on_body_entered(body):
	collected = true
	set_collision_mask_value(1, false)
	$Sprite2D.hide()
	
	#get_parent().on_key_collect()
	for i in get_children():
		if i.has_method("on_key_collect"):
			i.on_key_collect(self)
	
	await body.on_death
	$Sprite2D.show()
	set_collision_mask_value(1, true)
	collected = false
	
	#get_parent().on_key_lost()
	for i in get_children():
		if i.has_method("on_key_lost"):
			i.on_key_lost(self)
