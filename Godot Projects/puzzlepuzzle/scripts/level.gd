class_name Level
extends Node2D

@export_category("Tile Dimensions")
@export var level_width = 9
@export var level_height = 5

#Allows actions inside when true
var level_active = true

enum OBJ {BLANK, PLAYER, WALL}

#Will probably go unused, delete when sure
var level_map = []

var tile_size = 16;

var step_length = .14#.5
var step_time = step_length

var object_list = []

var freed = false
var free_time = 0

static var follow_camera = []

# Called when the node enters the scene tree for the first time.
func _ready():
	reset_level_map()

#NOTE: maybe remake later maybe -- assumes anything (a lot) is a wall
func is_wall_at(pos:Vector2):
	return $TileMapLayer.get_cell_source_id(pos) > -1

func is_nightmare_at(pos:Vector2):
	var tile = $TileMapLayer.get_cell_tile_data(pos)
	if tile:
		return tile.get_custom_data("nightmare")
	return false

func reset_step():
	step_time = step_length

func reset_level_map():
	level_map = []
	for ix in range(level_width):
		var arr = []
		for iy in range(level_height):
			arr.push_back(OBJ.BLANK)
		level_map.push_back(arr)

#Get the level's objects
func get_object_list():
	if object_list.size() == 0:
		update_object_list()
	
	return object_list

#Update the level's objects
func update_object_list():
	object_list = get_all_objects(self)

#Add an object to the level
func add_object(obj):
	add_child(obj)
	update_object_list()

#deletes an object and removes it from the level
func delete_object(obj):
	obj.queue_free()
	update_object_list()

#Return all LevelObjects that are children or children's children ... of an object
#Will not return objects that are children of LevelObjects or Levels
static func get_all_objects(obj):
	var all_objects = []
	var all_children = obj.get_children()
	
	for c in all_children:
		#ignore levels
		if c is Level:
			continue
		#get level object
		if c is LevelObject:
			all_objects.push_back(c)
		#recursive look for children
		else:
			var recursive_objects = get_all_objects(c)
			if recursive_objects.size() != 0:
				all_objects.append_array(recursive_objects)
	
	return all_objects

func print_level_map():
	for iy in range(level_map[0].size()):
		var str = "";
		for ix in range(level_map.size()):
			str += str(level_map[ix][iy]) + ", "
		print(str)

func get_map_position(pos:Vector2):
	var scaled_pos = pos / tile_size
	scaled_pos.x = floor(scaled_pos.x)
	scaled_pos.y = floor(scaled_pos.y)
	return scaled_pos

func set_active_state(new_state):
	level_active = new_state
	if new_state:
		step_time = step_length * 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	step_time -= delta
	if level_active:
		for o in get_object_list():
			if o is LevelObject:
				o.active_process(delta)
	
	if Input.is_action_just_pressed("level_exit"):
		print(get_level_size())
		print(get_level_offset())
	
	for f in follow_camera:
		if is_instance_valid(f) && !f.level.freed:
			var lerp_amt = pow(.93, delta*60)
			
			$Camera2D.position = Vector2(f.global_position) * (1-lerp_amt) + $Camera2D.position * (lerp_amt)
			break
		else:
			follow_camera.erase(f)
	
	if freed:
		var free_speed = 1
		free_time += delta
		position.y += free_speed * (pow(free_time*free_speed*15,2) - 200) * delta
		position.x += free_speed * delta * 100
		rotation += free_speed * delta
		if free_time > 5.0/free_speed:
			queue_free()

static func add_camera_follow(obj):
	follow_camera.erase(obj)
	follow_camera.push_front(obj)
	


func get_level_size():
	return $TileMapLayer.get_used_rect().size

func get_level_offset():
	return $TileMapLayer.get_used_rect().position


func _on_tile_map_layer_ready():
	$ColorRect.scale = Vector2(get_level_size()) * tile_size / 64

static func get_level_title(path):
	var split_path = path.split("/")
	var scene_name = split_path[split_path.size()-1]
	var name = scene_name.split(".")[0]
	match name:
		_:
			return name
