class_name ToothMech extends Entity


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_down", "ui_up"))
	
