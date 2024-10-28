extends Node2D
class_name TreeTower

var age = 0
var exp = 0.0

var bark = 0
var leaves = 0
var moss = 0
var branches = 0
var roots = 0

var damage = Stat.new() #Projectile damage
var attack_velocity = Stat.new() #Speed projectiles move at
var pierce = 0 #Number of targets projectile can pass through
var rebounds = 0 #Number of times projectile can re-aim after rebounding

var range = Stat.new() #Maximum attack range
var attack_delay = Stat.new() #Time (sec) between attacks
var projectile_count = Stat.new() #Amount of projectiles created per attack
var bonus_attack_speed = 0 #Speed multiplier while waiting to attack

var attack_timer = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	range.set_stat(350)
	damage.set_stat(10)
	attack_delay.set_stat(1)
	attack_velocity.set_stat(700)
	projectile_count.set_stat(1)

func round_start():
	age += 1
	exp += get_age_exp_value(age)


#Amount of upgrades available each round
func get_age_exp_value(age):
	return 3 / age

#Returns a spirit node or null to target
func get_target():
	var spirits = get_parent().get_spirits()
	var target = null
	
	for s in spirits:
		if position.distance_to(s.position) >= range.value():
			continue
		var priority = false #Set to true if this spirit should be targeted instead of last set target
		if target == null:
			priority = true
		elif s.progress > target.progress:
			priority = true
		
		if priority:
			target = s
		
		
	return target

#Attempts to start an attack. Returns true if successful
func attempt_attack():
	var target = get_target()
	if target == null:
		return false
	
	for i in projectile_count.value(): 
		var new_proj = Projectile.create_projectile(target, damage.value(), attack_velocity.value())
		add_child(new_proj)
		#WIP NOTE: add spread to extra projectiles
	
	return true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	attack_timer += delta if (attack_timer < attack_delay.value()) else (delta * bonus_attack_speed)
	
	if attack_timer >= attack_delay.value():
		if attempt_attack():
			attack_timer -= attack_delay.value()
