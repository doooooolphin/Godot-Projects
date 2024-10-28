extends Node2D
class_name Upgrade

#NOTE: display name of node is the node's name in its scene!!!!!!

#Written information about the upgrade
#Is not necessary for an upgrade to function
#Displayed to user
@export_category("Upgrade Info")
@export_multiline var description = ""
@export var is_root = false

#Stats required to unlock the upgrade
#Index[0] -> minimum stat to unlock this upgrade
#Index[1] -> maximum stat to unlock this upgrade
#Either index set < 0 will ignore that portion of the limit
#Global stat bounds are adjusted on purchase to reflect stat bounds
@export_category("Requirements")
@export var bark_bounds = [-1, -1]
@export var leaves_bounds = [-1, -1]
@export var moss_bounds = [-1, -1]
@export var branches_bounds = [-1, -1]
@export var roots_bounds = [-1, -1]

@export var min_age = 0

#Stats granted upon unlocking upgrade
#Upgrade cannot be purchased if these stats would exceed the global stat bounds
@export_category("Synergy Stats")
@export var bark = 0
@export var leaves = 0
@export var moss = 0
@export var branches = 0
@export var roots = 0

#Gameplay stats granted upon unlocking upgrade
@export_category("Stats")
@export var damage = 0 #Projectile damage*
@export var attack_velocity = 0 #Speed projectiles move at*
@export var pierce = 0 #Number of targets projectile can pass through
@export var rebounds = 0 #Number of times projectile can re-aim after rebounding

@export var range = 0 #Maximum attack range*
@export var attack_delay = 0 #Time (sec) between attacks*
@export var projectile_count = 0 #Amount of projectiles created per attack*
@export var bonus_attack_speed = 0 #Speed multiplier while waiting to attack

var unlocked = false

#Global bounds to limit future purchases
static var gl_bark_bounds = [-1, -1]
static var gl_leaves_bounds = [-1, -1]
static var gl_moss_bounds = [-1, -1]
static var gl_branches_bounds = [-1, -1]
static var gl_roots_bounds = [-1, -1]

#Recieves an upgrade node and will apply all bounds from node to the global bounds
static func add_global_bounds(u:Upgrade):
	add_global_bound(u.bark_bounds, gl_bark_bounds)
	add_global_bound(u.leaves_bounds, gl_leaves_bounds)
	add_global_bound(u.moss_bounds, gl_moss_bounds)
	add_global_bound(u.branches_bounds, gl_branches_bounds)
	add_global_bound(u.roots_bounds, gl_roots_bounds)

#Recieves one bound set of an upgrade and applies them to one global bound set
static func add_global_bound(upgrade_bounds, global_bounds):
	if upgrade_bounds[0] > global_bounds[0]:
		global_bounds[0] = upgrade_bounds[0]
	
	if (upgrade_bounds[1] < global_bounds[1] && upgrade_bounds[1] > 0) || global_bounds[1] < 0:
		global_bounds[1] = upgrade_bounds[1]

static func print_global_bounds():
	print("Bark: " + str(gl_bark_bounds))
	print("Leaves: " + str(gl_leaves_bounds))
	print("Moss: " + str(gl_moss_bounds))
	print("Branches: " + str(gl_branches_bounds))
	print("Roots: " + str(gl_roots_bounds))

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	print(self)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func attempt_purchase():
	pass

func purchase_upgrade(tree:TreeTower):
	unlocked = true;
	
	#Add functional stats
	if (damage != 0):
		tree.damage.add_base(damage)
	if (attack_velocity != 0):
		tree.attack_velocity.add_base(attack_velocity)
	if (pierce != 0):
		tree.pierce ++ pierce
	if (rebounds != 0):
		tree.rebounds ++ rebounds
	if (range != 0):
		tree.range.add_base(range)
	if (attack_delay != 0):
		tree.attack_delay.add_base(attack_delay)
	if (projectile_count != 0):
		tree.projectile_count.add_base(projectile_count)
	if (bonus_attack_speed != 0):
		tree.bonus_attack_speed ++ bonus_attack_speed
	
	#TODO: add functionality for multipliers
	
	#Add synergy Stats
	if (bark != 0): tree.bark += bark
	if (leaves != 0): tree.leaves += leaves
	if (moss != 0): tree.moss += moss
	if (branches != 0): tree.branches += branches
	if (roots != 0): tree.roots += roots

func _to_string():
	var full_string = "Upgrade: "
	#Info
	full_string += name + "\n" + description
	
	if (bark != 0): full_string += "\nBark: " + str(bark)
	if (leaves != 0): full_string += "\nLeaves: " + str(leaves)
	if (moss != 0): full_string += "\nMoss: " + str(moss)
	if (branches != 0): full_string += "\nBranches: " + str(branches)
	if (roots != 0): full_string += "\nRoots: " + str(roots)
	
	
	return full_string;
