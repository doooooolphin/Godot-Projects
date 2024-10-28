extends Weapon

@export_category("Sword Customization")
@export var speed_multi = 1.0
@export var strike_up = true
@export var angle_offset = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Slash.hide()
	$"Area2D/Collision Area".disabled = true
	$Area2D.hide()
	
	#Customization
	$Slash.speed_scale = speed_multi
	if !strike_up:
		scale.y *= -1
	

func use_weapon():
	$Slash.show()
	$Slash.play("slash")
	rotation = angle_offset * sign(scale.x)
	await $Slash.animation_finished
	$Slash.hide()

func weapon_process(delta):
	var time = use_time * speed_multi
	
	$Slash.rotation = (1 - cos( 2 * PI * time * (12/6) )) / 2
	$Slash.position.y = -2 - time * 12
	
	if time > 0.25 && $"Area2D/Collision Area".disabled:
		$"Area2D/Collision Area".disabled = false
		$Area2D.show()
	if time > 0.4 && !$"Area2D/Collision Area".disabled:
		$"Area2D/Collision Area".disabled = true
		$Area2D.hide()
