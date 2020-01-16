extends RigidBody2D

var size

func _ready():
	pass

func makeRoom(pos, _size):
	position = pos
	size = _size
	var shape = RectangleShape2D.new()
	shape.custom_solver_bias = 1
	shape.extents = size
	$CollisionShape2D.shape = shape
	