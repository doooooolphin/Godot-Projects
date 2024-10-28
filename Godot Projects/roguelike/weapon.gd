extends Node2D

class_name Weapon #Super epic line of code, remember this in the future PLEASE

var max_uses
var uses
var use_delay

enum FLIP {NONE, M_FLIP_X, M_FLIP_Y, M_FLIP}

@export var flip_type: FLIP #How does this weapon flip
@export var display_name: String #Name of weapon shown

var damage

var in_use = false #true during attack animation
var use_time = 0

static func instantiate_weapon(weapon_id: int):
	var weapon_path = Weapon.get_weapon_class(weapon_id)
	if weapon_path == null:
		return null
	return load(weapon_path).instantiate()

static func get_weapon_class(weapon_id: int):
	var path = ""
	match weapon_id:
		0:
			path = "basic_sword"
		1:
			path = "big_sword"
		_:
			print("Missing weapon could not load / " + str(weapon_id))
			return null
	return "res://scenes/weapons/" + path + ".tscn"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if in_use:
		use_time += delta
		weapon_process(delta)
	
	if !in_use:
		var mouse_distance = sign(get_global_mouse_position() - global_position)
		match flip_type:
			FLIP.M_FLIP_X:
				scale.x = mouse_distance.x * abs(scale.x)
			FLIP.M_FLIP_Y:
				scale.y = -mouse_distance.y * abs(scale.y)
			FLIP.M_FLIP:
				scale.x = mouse_distance.x * abs(scale.x)
				scale.y = -mouse_distance.y * abs(scale.y)
			_:
				pass

	
func weapon_process(delta):
	pass

func start_attack():
	in_use = true
	await use_weapon()
	end_attack()

func use_weapon():
	pass

func end_attack():
	in_use = false
	use_time = 0
