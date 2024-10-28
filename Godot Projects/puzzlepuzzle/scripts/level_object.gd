class_name LevelObject
extends Node2D

var map_position
var level

#Where this object is move to visually -- does not impact collisions
var goal_position
var old_position
var time_since_move = 0

var t = 0

@export_category("Toggles")
#Does this object block other objects' movement?
@export var collision = true
#Can this object be pushed by some other objects?
@export var pushable = false
#Can this object be controlled through the keyboard?
@export var player_control = false
#Does this object do something special when walked on or walked into?
@export var interactable = false

@export_category("Other")

@export var default_animation = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	if player_control:
		z_index+=1
	if collision:
		z_index+=1
	level = get_level(self)
	
	map_position = level.get_map_position(position)
	
	goal_position = Vector2(position)
	old_position = Vector2(position)
	
	if default_animation != "":
		$AnimatedSprite2D.play(default_animation)
	
	if player_control:
		Level.add_camera_follow(self)

#Attempt to move in a given direction.
#If applicable, will push other objects
func move(amt:Vector2):
	#Ignore non-movement
	if amt.length() == 0:
		return false
	
	#Disable diagonal movement
	if amt.length() != abs(amt.x + amt.y):
		amt.y = 0
	
	var next_map_position = map_position + amt
	#Check if wall
	if level.is_nightmare_at(next_map_position):
		level.reset_step()
	
	if level.is_wall_at(next_map_position):
		return false
	
	#Check for other objects
	for o in level.get_object_list():
		if o == self:
			continue
		
		if next_map_position == o.map_position:
			
			if o.interactable:
				level.reset_step()
				o.on_interaction(self)
			
			#Push objects
			if o.pushable:
				var can_move = o.move(amt)
				if !can_move && o.collision:
					return false
			#Collide with objects
			elif o.collision:
				return false
	#Move
	old_position = Vector2(position)
	goal_position += amt * level.tile_size
	time_since_move = 0
	
	map_position = next_map_position
	
	#Apply move delay
	if player_control && amt.length() > 0:
		level.reset_step()
	
	if player_control:
		Level.add_camera_follow(self)
	
	return true

func on_interaction(other):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func active_process(delta):
	t += delta
	
	if player_control && level.step_time < delta:
		move(Vector2(Input.get_axis("left","right"),Input.get_axis("up","down")))
	

func _process(delta):
	time_since_move += delta
	update_visual_position(delta)

func update_visual_position(delta):
	var t = clamp(time_since_move, 0, .25) * 4
	position = old_position * (1-t) + goal_position * t
	return
	var lerp_amt = pow(.77, delta*60)
	position = goal_position * (1-lerp_amt) + position * (lerp_amt)

func _to_string():
	return "LvObj" + " c: " + str(collision) + " p: " + str(pushable) + " pc: " + str(player_control)

static func get_level(obj):
	var parent = obj.get_parent()
	
	if parent is Level:
		return parent
	else:
		return get_level(parent)
