extends Node3D

var speed
var mouse_sensitivity = 0.1

@onready var player = get_parent().get_node("/root/Test/Player")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta: float) -> void:
	rotation_degrees.z = 0
	position = player.position

func _input(event):
	if event is InputEventMouseMotion:
		speed = Input.get_last_mouse_velocity()
		rotation_degrees.y -= deg_to_rad(speed.x * mouse_sensitivity)
		rotation_degrees.x = clamp(rotation_degrees.x - event.relative.y * mouse_sensitivity, -90, 90)
