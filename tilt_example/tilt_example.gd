extends Node3D

# Maximum tilt's mouse movement in pixels per second.
@export var max_mouse_movement: float = 2000
@export var rolling_average_window_size: int = 50

# The maximum tilt of the board in degrees.
@export var max_angle: float = 30

# Max tilt change in degrees per second
@export var max_angle_change: float = 90

@onready var board: AnimatableBody3D = $Board

var mouse_velocity_x_values: Array[float] = []
var mouse_velocity_y_values: Array[float] = []

var x_angle: float = 0
var z_angle: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("next"):
		get_tree().change_scene_to_file("res://debug_example/debug_example.tscn")
		
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	
	var mouse_velocity = Input.get_last_mouse_velocity()
	#print("Mouse velocity ", mouse_velocity)
	var mouse_velocity_x = clamp(-mouse_velocity.x, -max_mouse_movement, max_mouse_movement)
	var mouse_velocity_y = clamp(mouse_velocity.y, -max_mouse_movement, max_mouse_movement)
	mouse_velocity_x_values.append(mouse_velocity_x)
	if len(mouse_velocity_x_values) > rolling_average_window_size:
		mouse_velocity_x_values.pop_front()
	mouse_velocity_y_values.append(mouse_velocity_y)
	if len(mouse_velocity_y_values) > rolling_average_window_size:
		mouse_velocity_y_values.pop_front()


func _physics_process(delta: float) -> void:
	var mouse_velocity_x_values_avg = 0
	if len(mouse_velocity_x_values) > 0:
		var mouse_velocity_x_values_sum = 0
		for value in mouse_velocity_x_values:
			mouse_velocity_x_values_sum += value
		mouse_velocity_x_values_avg = mouse_velocity_x_values_sum / len(mouse_velocity_x_values)
	
	var mouse_velocity_y_values_avg = 0
	if len(mouse_velocity_y_values) > 0:
		var mouse_velocity_y_values_sum = 0
		for value in mouse_velocity_y_values:
			mouse_velocity_y_values_sum += value
		mouse_velocity_y_values_avg = mouse_velocity_y_values_sum / len(mouse_velocity_y_values)
	
	var desired_z_angle = mouse_velocity_x_values_avg / max_mouse_movement * max_angle
	var desired_x_angle = mouse_velocity_y_values_avg / max_mouse_movement * max_angle
	
	x_angle = move_toward(x_angle, desired_x_angle, max_angle_change * delta)
	z_angle = move_toward(z_angle, desired_z_angle, max_angle_change * delta)
	
	#print("Angles: ", "(", z_angle, ", ", x_angle, ")")
	
	board.rotation_degrees = Vector3(x_angle, 0, z_angle)
