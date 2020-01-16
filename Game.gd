extends Node2D

func _ready():
	#yield(get_tree().create_timer(8), "timeout")
	pass
	
	
	
func setTargets():
	print ("Setting")
	$ViewportContainer/Viewport/Camera2D.target = get_tree().get_nodes_in_group("Player")[0]
	$ViewportContainer2/Viewport/Camera2D.target = get_tree().get_nodes_in_group("Player")[0]
	$ViewportContainer2/Viewport.world_2d = $ViewportContainer/Viewport.world_2d
