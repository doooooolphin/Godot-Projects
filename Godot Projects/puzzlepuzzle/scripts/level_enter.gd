class_name LevelEnter
extends LevelObject

var inner_level

var level_open = false

var level_float = 0

@export_global_file() var level_path = "res://scenes/level.tscn"
@export var load_level = true
@export_multiline var text = ""
var level_title

func _ready():
	super()
	z_index += 2
	level_title = Level.get_level_title(level_path)
	$Label.text = level_title
	$Thought.hide()

func on_interaction(other):
	open_level()

func _process(delta):
	super(delta)
	if Input.is_action_just_pressed("level_exit"):
		close_level()
	
	if level_open:
		level_float += delta
		inner_level.position.y += delta * -0.35 * level.tile_size * sin(level_float)

func open_level():
	if level_open:
		return
	
	#Level opens on animation end
	$AnimatedSprite2D.play("open")
	$BloopSFX.play()
	
	level.set_active_state(false)

func full_open_level():
	if level_open:
		return
	
	level_open = true
	level_float = 0
	
	inner_level = load(level_path).instantiate()
	inner_level.z_index += 3
	add_child(inner_level)
	
	
	var size = Vector2(inner_level.get_level_size()) * inner_level.tile_size
	
	inner_level.global_position = global_position + Vector2(-size.x/2, -size.y - inner_level.tile_size * 2)
	

func close_level():
	if !level_open:
		return
	
	if !inner_level.level_active:
		return
	
	$AnimatedSprite2D.play("close")
	$PoofSFX.play()
	
	level_open = false
	
	var gp = Vector2(inner_level.global_position)
	remove_child(inner_level)
	level.add_child(inner_level)
	inner_level.position += gp - inner_level.global_position
	inner_level.set_active_state(false)
	inner_level.freed = true
	
	inner_level = null
	level.set_active_state(true)


func _on_animation_finished():
	match $AnimatedSprite2D.animation:
		"open":
			$AnimatedSprite2D.play("active")
			full_open_level()
			$Thought.show()
		"close":
			$AnimatedSprite2D.play("inactive")
			$Thought.hide()
