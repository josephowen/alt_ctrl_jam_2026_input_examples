extends Control

@onready var cursor: Sprite2D = $Cursor

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func _process(_delta: float) -> void:
	cursor.position = get_global_mouse_position()
	
	if Input.is_action_just_pressed("next"):
		get_tree().change_scene_to_file("res://tilt_example/tilt_example.tscn")
		
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
