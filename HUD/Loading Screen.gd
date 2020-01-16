extends Control

onready var maxVal = $"CenterContainer/Loading Bar".max_value
onready var minVal = $"CenterContainer/Loading Bar".min_value

func _ready():
	# Uncomment for testing
	#start()
	pass
	
func start():
	show()
	$"CenterContainer/Loading Bar".value = minVal
	# Start the timer
	$"Load Timer".start()
	
func _process(delta):
	if $"CenterContainer/Loading Bar".value == maxVal:
		hide()
	
func updateProgressBar():
	var newVal = $"CenterContainer/Loading Bar".value + 1
	clamp(newVal, minVal, maxVal)
	$"CenterContainer/Loading Bar".value = newVal

func _on_Load_Timer_timeout():
	updateProgressBar()
