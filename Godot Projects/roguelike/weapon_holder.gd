extends Node2D

var weapons = []

var active_num = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Add a weapon instance to the holder
func add_weapon(weapon: Weapon):
	weapons.push_back(weapon)
	add_child(weapon)
	
	if get_active_weapon() == null:
		active_num = 0

#Add a weapon to the holder based on weapon ID
func add_weapon_new(weapon_id: int):
	add_weapon(Weapon.instantiate_weapon(weapon_id))

func get_active_weapon():
	if active_num >= weapons.size():
		active_num = weapons.size() - 1
	
	if active_num < 0:
		print("No weapon selected")
		return null
	
	return weapons[active_num]

func can_change_weapon():
	return !get_active_weapon().in_use

func set_active_weapon(weapon_num: int):
	active_num = weapon_num
	if active_num < 0:
		active_num += weapons.size()
	
	if active_num >= weapons.size():
		active_num -= weapons.size()

func change_active_weapon(amt: int):
	set_active_weapon(active_num + amt)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("main_action"):
		get_active_weapon().start_attack()
	
	if can_change_weapon():
		if Input.is_action_just_pressed("weapon_next"):
			change_active_weapon(1)
		if Input.is_action_just_pressed("weapon_last"):
			change_active_weapon(-1)
