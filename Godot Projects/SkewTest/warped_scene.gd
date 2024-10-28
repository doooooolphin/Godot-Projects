extends Node2D

#Save linear transform
var trans_x = Vector2(1,0)
var trans_y = Vector2(0,1)

var time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_linear_transform(x,y):
	trans_x = Vector2(x.x, x.y)
	trans_y = Vector2(y.x, y.y)
	update_linear_transform()


func update_linear_transform():
	var t = Transform2D()
	t.origin = transform.origin
	t.x = trans_x
	t.y = trans_y
	transform = t

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	
	#trans_x.x = cos(time)
	#trans_x.y = atan(time)
	#trans_y.x = -sin(time)
	#trans_y.y = cos(time)
	

	update_linear_transform()
