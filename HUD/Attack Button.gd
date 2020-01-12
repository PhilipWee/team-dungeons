extends TouchScreenButton

onready var player = get_tree().get_nodes_in_group("Player")[0]

func _ready():
	pass

func _on_Attack_Button_pressed():
	player.attack()
