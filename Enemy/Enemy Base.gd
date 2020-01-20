extends Node2D

enum STATES{IDLE, CHASE, ATTACK, DAMAGED, DEATH}
var currentState = STATES.IDLE
var lastDir = Vector2(-1, 0)
var currentHealth

export var Name: String
export var BaseHealth: int
export var HealthGrowthRate: float
export var BaseDamage: int
export var DamageGrowthRate: float
export var Speed: int
export var AttackZone: int
export var knockBack:int

var Level
var Health
var Damage

#onready var target = get_tree().get_nodes_in_group("Player")[0]
onready var loot = preload("res://Items/Loot.tscn")
var target = null

func _ready():
	# Set AttackRange
	add_to_group("Enemy")
	$"Position2D/Attack Zone/Area".shape.height = AttackZone
	setup()

	
func _process(delta):
	stateHandler()
	updateHealth()
	
func setup(level = 1):
	# Calculates the relevant stats base on level
	Level = level
	Health = BaseHealth + (level-1) * HealthGrowthRate 
	Damage = BaseDamage + (level-1) * DamageGrowthRate
	
	# Setup the healthbar
	setupHealthBar()
	
func setupHealthBar():
	var bar = $"HealthBar Pos/HealthBar/TextureProgress"
	bar.min_value = 0
	bar.max_value = Health
	bar.value = Health
	currentHealth = Health

func chase():
	if target:
		var dir = (target.position - position).normalized()
		lastDir = dir
		var angle = dir.angle()
		$".".move_and_slide(dir * Speed)
		# Rotate Attack area
		$Position2D.rotation_degrees = angle/PI * 180 - 90
		
		#var nav = $"../MapMaker/YSort/Navigation2D"
		#print(nav.get_simple_path(position, target.position))
	
	
func getHurt(dmg):
	currentState = STATES.DAMAGED
	currentHealth -= dmg
	if currentHealth <= 0:
		currentState = STATES.DEATH
	
func updateHealth():
	$"HealthBar Pos/HealthBar/TextureProgress".value = currentHealth
	
func stateHandler():
		
	match currentState:
		STATES.IDLE:
			# Play IDLE animation
			pass
			
		STATES.CHASE:
			chase()
			$AnimationPlayer.play("Move")
			
		STATES.ATTACK:
			$AnimationPlayer.play("Attack")
			if $"Position2D/Attack Area".overlaps_body(target):
				var dir = (position-target.position).normalized()
				target.getHurt(dir, Damage)
				#target.get_node("Sprite").play("Hurt")
				
		STATES.DAMAGED:
			$AnimationPlayer.play("Hurt")
			var dir = (position-target.position).normalized()
			$".".move_and_slide(dir*knockBack)
			
		STATES.DEATH:
			dropLoot()
			queue_free()
			
func calcLoot():
	# Function calculates loot based on attributes of enemy
	var loot = floor(Health * 0.05 + Damage * 0.2 + Speed * 0.01)
	var EXP = floor(Health * 0.3 + Damage * 0.4 + Speed * 0.15)
	return Vector2(loot, EXP)
	
func dropLoot():
	# Function drops loot at enemy death
	var l = loot.instance()
	var aboveNode = get_parent()
	var ret = calcLoot()
	l.value = ret.x
	l.EXPValue = ret.y
	l.position = position
	aboveNode.add_child(l)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Attack":
		currentState = STATES.CHASE
	elif anim_name == "Hurt":
		currentState = STATES.CHASE

func _on_Attack_Zone_body_entered(body):
	# Change state to Attack
	if body == target:
		currentState = STATES.ATTACK


func _on_Detection_Zone_body_entered(body):
	currentState = STATES.CHASE
	target = body
