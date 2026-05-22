extends ColorRect

@export var time_to_appear: float = 3

@onready var rect: ColorRect = $"."

var _highlight_time: float = 0
var _mouse_over: bool = false
var _locked: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rect.modulate = Color.TRANSPARENT
	rect.mouse_entered.connect(_on_mouse_entered)
	rect.mouse_exited.connect(_on_mouse_exited)
	
func _process(delta: float) -> void:
	if not _locked:
		if _mouse_over:
			_highlight_time = min(_highlight_time + delta, time_to_appear)
		else:
			_highlight_time = max(_highlight_time - delta, 0)
		if _highlight_time == time_to_appear:
			_locked = true
		rect.modulate = Color(1, 1, 1, _highlight_time / time_to_appear)

func _on_mouse_entered():
	_mouse_over = true
	
func _on_mouse_exited():
	_mouse_over = false
