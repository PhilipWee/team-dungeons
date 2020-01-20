extends KinematicBody2D

var dirThreshold = 0.1
export var isAttacking:bool
export var isHurt:bool
var attackedDir = Vector2()
var target = null

export var Name: String
export var Health: int
export var Speed: int

onready var joystick = get_parent().get_node("CanvasLayer/HUD/Joystick")
enum STATES{IDLE, MOVE, HURT, ATTACK, DEATH}
var currentState

var Level = 1
var EXP = 0
var Gold = 0

signal updateHealth
signal updateEXP
signal updateLevel


func _ready():
	add_to_group("Player")
	isHurt = false
	isAttacking = false
	$Position2D/Weapon.hide()
	var HUD = get_tree().get_nodes_in_group("HUD")[0]
	connect("updateHealth", HUD, "updateHealth")
	connect("updateEXP", HUD, "updateEXP")
	connect("updateLevel", HUD, "updateLevel")
	
	
	
func _process(delta):
	weaponHandler()
	
	if not isAttacking and not isHurt:
		movementHandler()
	
	if isHurt:
		isAttacking = false
		hurt(attackedDir)
		
	target = attackHandler()

func _input(event):
	if event.is_action_pressed("attack"):
		attack()

func movementHandler():
	var dir = joystick.getValue()

	
	$".".move_and_slide(dir * Speed)
	
	if joystick.ongoingDrag == 0:
		if dir.x > dirThreshold:
			# Right
			$Sprite.flip_h = false
			$Sprite.play("Move")
			

		elif dir.x < dirThreshold:
			# Left
			$Sprite.flip_h = true
			$Sprite.play("Move")

	else:
		# Idle
		$Sprite.play("Idle")
		
func weaponHandler():
	if not isAttacking:
		var dir = joystick.getValue()
		var angle = dir.angle() / PI * 180
		# Update the position2D
	#	if angle > -180 && angle < -90:
	#		$Position2D.scale = Vector2(-1, 1)
	#	else:
	#		$Position2D.scale = Vector2(1, 1)
		$Position2D.rotation_degrees = angle
		#$Position2D/Weapon.rotation_degrees = -angle
		
func attack():

	if not isAttacking:
	#
	#	if not $AnimationPlayer.is_playing():
	#		$Sprite.play("Attack1")
	#		$AnimationPlayer.play("Attack")
	#
		# Check if any enemy within attack region
		if target:
			# Rotate attack area to target direction
			var angle = (target.position - position).angle()/PI * 180
			$Position2D.rotation_degrees = angle
			if target.position.x > position.x:
				$Sprite.flip_h = false
			else:
				$Sprite.flip_h = true
	#
		else:
			# Rotate based on whether joystick is being dragged
			if joystick.ongoingDrag:
				var angle = joystick.getValue().angle()/PI * 180
				$Position2D.rotation_degrees = angle
				if joystick.getValue().x > 0:
					$Sprite.flip_h = false
				else:
					$Sprite.flip_h = true
	
		# Get weapon node
		var weaponNode = $"Position2D/Weapon".get_child(0)
		weaponNode.attack()
	
func attackHandler():
	"""
	Checks the available targets within the Targets group
	and returns the closest target, if not none
	"""
	var targets = get_tree().get_nodes_in_group("Targets")
	#print (len(targets))
	if len(targets) == 0:
		return null
		
	var closestTarget = null
	var closestDist = INF
	for target in targets:
		# Find closest target
		var dist = (target.position - position).length()
		if dist < closestDist:
			closestTarget = target
			closestDist = dist
			
	return closestTarget
	
func hurt(dir):
	if dir.x > 0:
		$Sprite.flip_h = false
	else:
		$Sprite.flip_h = true
	$Sprite.play("Hurt")
	$".".move_and_slide(dir * -150)
	
func getHurt(dir, damage):
	#var animation = $AnimationPlayer.get_animation("Hurt")
	attackedDir = dir
	#animation.track_set_key_value(0, 0, {"method": "hurt", "args":[dir]})
	#print (animation.track_get_key_value(0, 0))
	if not $AnimationPlayer.is_playing():
		#print ("Get Hurt")
		#isHurt = true
		$AnimationPlayer.play("Hurt")
		Health -= damage
		emit_signal("updateHealth")
		
func calcEXP():
	# Function calculates how much exp for level up
	var req = floor(Level * exp(5))
	return req
	
func canLvlUp():
	# Function checks if plyer has levelledup
	var req = calcEXP()
	if EXP > req:
		Level += 1
		lvlUp(req)
	else:
		emit_signal("updateEXP", EXP, req)
		
func lvlUp(prevBound):
	# Funcion levels the player up
	var upperBound = calcEXP()
	
	EXP = EXP - prevBound
	emit_signal("updateEXP", EXP, upperBound)
	emit_signal("updateLevel", Level)

func _on_Sprite_animation_finished():
	if $Sprite.animation == "Attack1":
		isAttacking = false


func _on_Attack_Area_body_entered(body):
	if body.name == "Slime":
	#if not body.name == name:
		body.getHurt()


func _on_Attack_Region_body_entered(body):
	# Get nodes in group
	if not body.name == name:
		body.add_to_group("Targets")
	

func _on_Attack_Region_body_exited(body):
	body.remove_from_group("Targets")
	
	
func onCompleteAttack():
	isAttacking = false
	$Position2D/Weapon.hide()
	
func pickUp(_name, value, expValue):
	#print ("I pick up %s gold and %s exp" %[value, expValue])
	EXP += expValue
	Gold += value 
	canLvlUp()
	