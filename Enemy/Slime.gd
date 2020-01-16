extends "res://Enemy/Enemy Base.gd"

var dir
export var jumpAttack:bool

func _ready():
	jumpAttack = false
	
func _process(delta):
	if jumpAttack:
		jump()	
		pass

func jump():
	
	$".".move_and_slide(lastDir * 300)
