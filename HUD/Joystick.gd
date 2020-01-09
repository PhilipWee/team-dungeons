extends Sprite

var radius = Vector2(16, 16)
var boundary = 64
var returnAcc = 20
var threshold = 10

var ongoingDrag = -1

func getButtonPos():
	return $Button.position + radius

func _ready():
	pass

func _process(delta):
	if ongoingDrag == -1:
		var posDiff = (Vector2(0, 0) - radius) - $Button.position
		$Button.position += posDiff * returnAcc * delta
		

func _input(event):
	if event is InputEventScreenDrag or (event is InputEventScreenTouch and event.is_pressed()):
		var eventDistFromCenter = (event.position - position).length()
		
		if eventDistFromCenter <= boundary * global_scale.x or event.get_index() == ongoingDrag:
				
			$Button.set_global_position(event.position - radius * global_scale)
		
			if getButtonPos().length() > boundary:
				$Button.set_position(getButtonPos().normalized() * boundary - radius)
				
			ongoingDrag = event.get_index()
			
	if event is InputEventScreenTouch and !event.is_pressed() and event.get_index() == ongoingDrag:
		ongoingDrag = -1
		
func getValue():
	if getButtonPos().length()> threshold:
		return getButtonPos().normalized()
	return Vector2(0,0)