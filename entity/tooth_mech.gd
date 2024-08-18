class_name ToothMech extends Entity

@export var target:Entity
@export var target_locator:Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	base_move_speed = 0.1
	radius = 10
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var direction = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_down", "ui_up"))
	
