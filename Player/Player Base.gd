extends KinematicBody2D

var dirThreshold = 0.1
var lastDir = 1
export var isAttacking:bool
export var isHurt:bool
var attackDir = Vector2()

export var Name: String
export var Level: int
export var Health: int
export var Damage: int
export var Speed: int

onready var joystick = get_tree().get_nodes_in_group("Control")[0]

func _ready():
	add_to_group("Player")
	isHurt = false
	isAttacking = false

func _process(delta):
	
	if not isAttacking and not isHurt:
		movementHandler()
	
	if isHurt:
		hurt(attackDir)

func getDir():
	return joystick.getValue().x

func movementHandler():
	$".".move_and_slide(joystick.getValue() * Speed)
	if joystick.ongoingDrag == 0:
		var dir = getDir()
		if dir > dirThreshold:
			# Right
			$Sprite.flip_h = false
			$Sprite.play("Move")

		elif dir < dirThreshold:
			# Left
			$Sprite.flip_h = true
			$Sprite.play("Move")

	else:
		# Idle
		$Sprite.play("Idle")

func attack():
	isAttacking = true
	$Sprite.play("Attack1")
	
func hurt(dir):
	if dir.x > 0:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true
	$Sprite.play("Hurt")
	$".".move_and_slide(dir * -150)
	
func getHurt(dir):
	#var animation = $AnimationPlayer.get_animation("Hurt")
	attackDir = dir
	#animation.track_set_key_value(0, 0, {"method": "hurt", "args":[dir]})
	#print (animation.track_get_key_value(0, 0))
	if not $AnimationPlayer.is_playing():
		#print ("Get Hurt")
		#isHurt = true
		$AnimationPlayer.play("Hurt")


func _on_Sprite_animation_finished():
	if $Sprite.animation == "Attack1":
		isAttacking = false
