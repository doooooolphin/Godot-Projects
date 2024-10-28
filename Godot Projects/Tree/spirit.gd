extends PathFollow2D

@export var speed = 100

@export var health = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	progress += delta * speed
	
