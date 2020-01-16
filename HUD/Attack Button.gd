extends TouchScreenButton

var player = null

func _ready():
	pass
	
func setup():
	"""
	Function binds all the relevant keys and targets
	"""
	player = get_tree().get_nodes_in_group("Player")[0]

func _on_Attack_Button_pressed():
	player.attack()
