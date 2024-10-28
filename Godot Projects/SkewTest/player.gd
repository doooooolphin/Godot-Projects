extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var air_time = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	if is_on_floor():
		air_time = 0
	else:
		air_time += delta
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("player_jump") and air_time < 0.1:
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("player_left", "player_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()
	#print(round(position.x), " , ", round(position.y))


func _on_interact_area_entered(area):
	var node = area.get_parent()
	node.on_player_interaction(true)


func _on_interact_area_exited(area):
	var node = area.get_parent()
	node.on_player_interaction(false)
