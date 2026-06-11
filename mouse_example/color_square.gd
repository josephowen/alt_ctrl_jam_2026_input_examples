extends ColorRect

@export var time_to_appear: float = 3
@export var flash_time: float = 0.1

@onready var rect: ColorRect = $"."

var _highlight_time: float = 0
var _mouse_over: bool = false
var _locked: bool = false
var _original_color: Color
var _flashing: float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rect.modulate = Color.TRANSPARENT
	rect.mouse_entered.connect(_on_mouse_entered)
	rect.mouse_exited.connect(_on_mouse_exited)
	_original_color = rect.color
	
func _process(delta: float) -> void:
	if not _locked:
		if _mouse_over:
			_highlight_time = min(_highlight_time + delta, time_to_appear)
		else:
			_highlight_time = max(_highlight_time - delta, 0)
		if _highlight_time == time_to_appear:
			rect.modulate = Color(1, 1, 1, 1);
			rect.color = Color(1, 1, 1)
			_flashing = flash_time
			_locked = true
		else:
			rect.modulate = Color(1, 1, 1, _highlight_time / time_to_appear)
	else:
		_flashing = max(_flashing - delta, 0)
		if _flashing == 0:
			rect.color = _original_color
		

func _on_mouse_entered():
	_mouse_over = true
	
func _on_mouse_exited():
	_mouse_over = false
