extends Node2D

export var Name: String
export var Damage: int
export var AttackSpeed: float

var canAttack: bool

signal completeAttack


func _ready():
	$Cooldown.wait_time = AttackSpeed
	canAttack = true
	
	# Connect the signal
	connect("completeAttack", $"../../../", "onCompleteAttack")
	
	# By default off the collision
	$Area2D/CollisionPolygon2D.disabled = true
	
func _process(delta):
	update()


func update():
	# Updates the visibility of the sprite as it rotates
	if rotation_degrees > 180 or rotation_degrees > -180 && rotation_degrees <= 0:
		$"../".show_behind_parent = true
		
	else:
		$"../".show_behind_parent = false
	if rotation_degrees > 360:
		rotation_degrees = 0
		
func attack():
	if canAttack:
		var player = $"../../../"
		player.get_node("Position2D/Weapon").show()
		player.isAttacking = true
		$AnimationPlayer.play("Attack")
		$Cooldown.start()
		canAttack = false
	else:
		pass
		
		

func _on_Cooldown_timeout():
	canAttack = true
	
func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("completeAttack")


func _on_Area2D_body_entered(body):
	body.getHurt(Damage)
