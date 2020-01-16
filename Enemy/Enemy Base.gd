extends Node2D

enum STATES{CHASE, ATTACK, DAMAGED, DEATH}
var currentState = STATES.CHASE
var lastDir = Vector2(-1, 0)
var currentHealth

export var Name: String
export var Level: int
export var Health: int
export var Damage: int
export var Speed: int
export var AttackZone: int
export var AttackArea: int
export var knockBack:int

onready var target = get_tree().get_nodes_in_group("Player")[0]

func _ready():
	# Set AttackRange
	$"Position2D/Attack Zone/Area".shape.height = AttackZone
	setupHealthBar()
	
func _process(delta):
	stateHandler()
	updateHealth()
	
func setupHealthBar():
	var bar = $"HealthBar Pos/HealthBar/TextureProgress"
	bar.min_value = 0
	bar.max_value = Health
	bar.value = Health
	currentHealth = Health

func chase():
	var dir = (target.position - position).normalized()
	lastDir = dir
	var angle = dir.angle()
	$".".move_and_slide(dir * Speed)
	# Rotate Attack area
	$Position2D.rotation_degrees = angle/PI * 180 - 90
	
func getHurt(dmg):
	currentState = STATES.DAMAGED
	currentHealth -= dmg
	
func updateHealth():
	$"HealthBar Pos/HealthBar/TextureProgress".value = currentHealth
	
func stateHandler():
		
	match currentState:
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

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Attack":
		currentState = STATES.CHASE
	elif anim_name == "Hurt":
		currentState = STATES.CHASE

func _on_Attack_Zone_body_entered(body):
	# Change state to Attack
	if body == target:
		currentState = STATES.ATTACK
