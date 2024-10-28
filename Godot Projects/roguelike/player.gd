extends CharacterBody2D


const SPEED = 70.0
const JUMP_VELOCITY = -100.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var base_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var jumping = false


func _ready():
	var test_weapon = Weapon.instantiate_weapon(1)
	print(test_weapon) #Create and print basic sword object (weapon debug)
	$"Weapon Holder".add_weapon(test_weapon)
	$"Weapon Holder".add_weapon_new(0)

func get_gravity():
	var gravity = base_gravity
	
	if jumping:
		var float_length = 50 #Amount of jump where the float takes place (in y-velocity)
		var float_strength = 0.37 # Strength of the float (between 0 - 0.5, greater is stronger)
		var g = velocity.y / float_length
		if abs(g) < 1:
			
			gravity *= 1 - float_strength * ( 1 + cos( PI * g ) )
		
	
	return gravity

func _physics_process(delta):
	# Add the gravity.
	if is_on_floor():
		jumping = false
	else:
		velocity.y += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		jumping = true

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

