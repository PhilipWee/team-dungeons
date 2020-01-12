extends KinematicBody2D

enum STATES{CHASE, ATTACK, DAMAGED, DEATH}
var currentState = STATES.CHASE

export var Name: String
export var Level: int
export var Health: int
export var Damage: int
export var Speed: int
export var AttackZone: int
export var AttackArea: int

onready var target = get_tree().get_nodes_in_group("Player")[0]

func _ready():
	# Set AttackRange
	$"Position2D/Attack Zone/Area".shape.height = AttackZone
	# Set AttackArea
	$"Position2D/Attack Area/Area".position.y = AttackZone + AttackArea
	$"Position2D/Attack Area/Area".shape.radius = AttackArea
	
func _process(delta):
	stateHandler()

func chase():
	var dir = (target.position - position).normalized()
	var angle = dir.angle()
	move_and_slide(dir * Speed)
	# Rotate Attack area
	$"Position2D".rotation_degrees = angle/PI * 180 - 90
	
func stateHandler():
		
	match currentState:
		STATES.CHASE:
			chase()
			
		STATES.ATTACK:
			$AnimationPlayer.play("Attack")
			if $"Position2D/Attack Area".overlaps_body(target):
				var dir = (position-target.position).normalized()
				target.getHurt(dir)
				#target.get_node("Sprite").play("Hurt")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Attack":
		currentState = STATES.CHASE

func _on_Attack_Zone_body_entered(body):
	# Change state to Attack
	if body == target:
		currentState = STATES.ATTACK
