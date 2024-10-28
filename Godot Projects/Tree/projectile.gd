extends Node2D

class_name Projectile

var target = null

var angle = null #Angle (rad) the projectile is travelling at

var damage = 1 #Projectile damage
var attack_velocity = 1 #Speed projectiles move at
var pierce = 1 #Number of targets projectile can pass through
var rebounds = 1 #Number of times projectile can re-aim after rebounding
var homing = 0 #Radians that the projectile can turn in a second


static func create_projectile(target, dmg, vel):
	var proj = load("res://projectile.tscn").instantiate()
	
	proj.target = target
	
	proj.damage = dmg
	proj.attack_velocity = vel
	
	return proj

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	print("sick as a fiddle")

#Get the angle to the current target
func get_target_angle():
	var distance = target.position - global_position
	
	var ang = atan(distance.y / distance.x)
	if distance.x < 0:
		ang += PI
	
	return ang

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if angle == null:
		angle = get_target_angle() #Set angle when spawned
	elif homing != 0: #Some of this homing stuff is real buggy
		var current_angle = get_target_angle()
		var angle_direction = int((angle - current_angle) / PI + 2) % 2
		angle += homing * delta * (1 if angle_direction == 1 else -1)
		while angle > 2*PI:
			angle -= 2*PI
		while angle < -2*PI:
			angle += 2*PI 
	#print(angle)
	position.x += cos(angle) * attack_velocity * delta
	position.y += sin(angle) * attack_velocity * delta
	
