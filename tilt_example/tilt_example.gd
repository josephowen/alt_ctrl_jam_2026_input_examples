extends Node3D

# Maximum tilt's mouse movement in pixels per second.
@export var max_mouse_movement: float = 25
@export var rolling_average_window_size: int = 20

# The maximum tilt of the board in degrees.
@export var max_angle: float = 45

# Max tilt change in degrees per second
@export var max_angle_change: float = 90

@onready var board: AnimatableBody3D = $Board

var mouse_movement_x_values: Array[float] = []
var mouse_movement_y_values: Array[float] = []

var x_angle: float = 0
var z_angle: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta: float) -> void:
	#print("Mouse velocity: ", Input.get_last_mouse_velocity())
	if Input.is_action_just_pressed("next"):
		get_tree().change_scene_to_file("res://mouse_example/mouse_example.tscn")

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_movement = event.screen_relative
		#print("FPS: ", Engine.get_frames_per_second())
		#print("Mouse movement: ", mouse_movement)
		mouse_movement_x_values.append(-clamp(mouse_movement.x, -max_mouse_movement, max_mouse_movement))
		if len(mouse_movement_x_values) > rolling_average_window_size:
			mouse_movement_x_values.pop_front()
		mouse_movement_y_values.append(clamp(mouse_movement.y, -max_mouse_movement, max_mouse_movement))
		if len(mouse_movement_y_values) > rolling_average_window_size:
			mouse_movement_y_values.pop_front()


func _physics_process(delta: float) -> void:
	var mouse_movement_x_values_average = 0
	if len(mouse_movement_x_values) > 0:
		var mouse_movement_x_values_sum = 0
		for value in mouse_movement_x_values:
			mouse_movement_x_values_sum += value
		mouse_movement_x_values_average = mouse_movement_x_values_sum / len(mouse_movement_x_values)

	var mouse_movement_y_values_average = 0
	if len(mouse_movement_y_values) > 0:
		var mouse_movement_y_values_sum = 0
		for value in mouse_movement_y_values:
			mouse_movement_y_values_sum += value
		mouse_movement_y_values_average = mouse_movement_y_values_sum / len(mouse_movement_y_values)
		
	var desired_z_angle = mouse_movement_x_values_average
	var desired_x_angle = mouse_movement_y_values_average
	
	x_angle = move_toward(x_angle, desired_x_angle, max_angle_change * delta)
	z_angle = move_toward(z_angle, desired_z_angle, max_angle_change * delta)
	
	#print("Angles: ", "(", z_angle, ", ", x_angle, ")")
	
	board.rotation_degrees = Vector3(x_angle, 0, z_angle)
