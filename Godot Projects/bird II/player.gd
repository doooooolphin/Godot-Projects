extends CharacterBody2D




const SPEED = 65.0
const FRICTION = 0.0002
const JUMP_VELOCITY = -600.0

const MAX_HOOK_SPEED = 1800

var gravity = 1500

var coyote_time = 0
var last_direction = 1

var jump_time = 0

var last_cam_zoom = 1.0

var gliding = false
var glide_stamina = 1
var glide_max_time = 2

var double_jumps = 0

var fling_time = 0

var hook_time = 0
var hook_distance = 0
var grappled = false
var hook_pos = Vector2.ZERO


var respawn_position

var on_floor = false
signal on_touch_floor()
signal on_death()

func _ready():
	floor_snap_length = 16
	set_respawn_pos()

func set_respawn_pos():
	respawn_position = Vector2(position.x, position.y)

func die():
	gliding = false
	glide_stamina = 1
	position.x = respawn_position.x
	position.y = respawn_position.y
	velocity = Vector2.ZERO
	fling_time = 0
	emit_signal("on_death")
	

func is_flung():
	return fling_time > 0

func add_fling_time(time):
	fling_time = max(time, fling_time)

func get_fling_strength():
	return clamp(fling_time*2, 0.0, 1.0)

func get_gravity():
	var g = gravity
	
	if gliding:
		if velocity.y < JUMP_VELOCITY:
			g *= 1.65
		elif velocity.y < 0:
			g *= 1.15
		else:
			g *= 0.35
	
	
	if is_flung():
		g *= 1.2
	
	return g

func get_friction():
	var f = FRICTION
	
	if gliding:
		f *= 5000
	elif is_flung():
		f *= (get_fling_strength() + 1) * 2500
	
	return f

func get_move_speed():
	var s = SPEED
	
	if grappled:
		return 0
	if gliding:
		s *= 0.14
	elif is_flung():
		s *= (get_fling_strength() + 1) * 0.1
	return s

func end_glide():
	gliding = false
	#glide_stamina = 0

func _physics_process(delta):
	
	#update_hook(delta)
	
	if is_on_wall() || is_on_floor():
		fling_time = 0
	
	# Add the gravity.
	if is_on_floor():
		coyote_time = 0
		gliding = false
		glide_stamina = 1
		double_jumps = max(double_jumps, 1)
	else:
		coyote_time += delta
		velocity.y += get_gravity() * delta
	
	if on_floor != is_on_floor():
		on_floor = is_on_floor()
		if on_floor:
			emit_signal("on_touch_floor")
			
	
	#End glide (by player)
	if gliding && Input.is_action_just_released("player_jump"):
		end_glide()
	
	#Glide stamina + force end glide
	if gliding:
		glide_stamina -= delta / glide_max_time
		if glide_stamina <= 0:
			end_glide()
		if velocity.y > 200:
			velocity.y *= pow(FRICTION, delta)
	
	# Handle Jump.
	if Input.is_action_just_pressed("player_jump"):
		if grappled:
			velocity.y += JUMP_VELOCITY + sqrt(abs(velocity.x))*3 + abs(velocity.y) * -0.5
			velocity *= 1.2
			grappled = false
		#regular jump
		elif coyote_time < 0.16:
			velocity.y = JUMP_VELOCITY * 0.75
			coyote_time = 1
			jump_time = 0.3
			velocity.x *= 1.25
		#Glide jump (begin glide)
		elif glide_stamina > 0:
			gliding = true
			if double_jumps > 0:
				velocity.y = -abs(velocity.y) * 0.45 + JUMP_VELOCITY * 0.9
				double_jumps -= 1
	
	
	if jump_time > 0 && !is_on_floor():
		jump_time -= min(delta, jump_time)
		if Input.is_action_pressed("player_jump"):
			velocity.y += JUMP_VELOCITY * delta * 1.45
		
	
	var direction = Input.get_axis("player_left", "player_right")
	if direction:
		velocity.x += direction * get_move_speed()
	
	velocity.x *= pow(get_friction(),delta)

	move_and_slide()
	
	if is_flung():
		fling_time -= delta

func update_hook(delta):
	
	#Start
	if Input.is_action_just_pressed("player_hook"):
		var direction = Vector2(Input.get_axis("player_left","player_right"), Input.get_axis("player_up", "player_down"))
		direction = direction.normalized() * 500
		$Hook.target_position = direction
		$Hook.force_raycast_update()
		grappled = $Hook.is_colliding()
		if grappled:
			hook_pos = $Hook.get_collision_point()
			hook_distance = global_position.distance_to(hook_pos)
	
	#End
	if Input.is_action_just_released("player_hook"):
		grappled = false
	
	#Process
	if Input.is_action_pressed("player_hook") && grappled:
		var dist = (hook_pos - global_position)
		print(dist)
		var extra_dist = dist.length() - hook_distance
		dist *= delta * (600)
		if extra_dist > 0 || true:
			velocity = dist
		double_jumps = 1
func _process(delta):
	update_camera(delta)
	
	update_animation()


func update_camera(delta):
	var t = pow(0.02,delta)
	
	var desired_zoom = 900 / (500 + abs(velocity.x))
	desired_zoom = clamp(desired_zoom, 0.75, 1.0)
	desired_zoom =  lerp(desired_zoom,last_cam_zoom, t)
	last_cam_zoom = desired_zoom
	$Camera.zoom.x = desired_zoom * 0.8
	$Camera.zoom.y = desired_zoom * 0.8
	
	var offset = (1 / desired_zoom - 1) * 1400
	var normal_vel = velocity.normalized()
	normal_vel *= offset
	
	$Camera.position.x = lerp(normal_vel.x, $Camera.position.x, t)
	$Camera.position.y = lerp(normal_vel.y, $Camera.position.y, t)
	
	var desired_angle = (1 - desired_zoom) * sign(velocity.x) * 0.45
	if !gliding:
		desired_angle *= 0.25
	$Camera.rotation = lerp(desired_angle, $Camera.rotation, t)

func update_animation():
	if gliding:
		$Sprite.play("glide")
	elif !is_on_floor():
		if velocity.y > 0:
			$Sprite.play("air fall")
		else:
			$Sprite.play("air rise")	
	elif abs(velocity.x) > 200:
		$Sprite.play("walk")
	else:
		$Sprite.play("idle")
	
	if abs(velocity.x) > 0.1:
		last_direction = sign(velocity.x)
		$Sprite.flip_h = last_direction < 0
		
	$Camera.get_child(0).value = glide_stamina


func _on_death_check_body_entered(body):
	die()

#Add wiggles
func _on_shuffle_timer_timeout():
	$Sprite.position.x = randf_range(-1,1)
	$Sprite.position.y = randf_range(-1,1)
