extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var stopped = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func set_speed(x, y):
	velocity = Vector2(x,y)

func _physics_process(delta):
	var speed = velocity.length()
	speed *= pow(.0002, delta)
	velocity *= speed / velocity.length()
	
	if stopped:
		return
	# Add the gravity.
	if !is_on_floor() && !is_on_wall() && !is_on_ceiling():
		pass
		#velocity.y += gravity * delta
	else:
		stopped = true
		
	move_and_slide()
