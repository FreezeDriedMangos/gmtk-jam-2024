class_name CthonicClient extends Entity

@export var camera_that_wont_leave_like_dad : Camera3D
@export var throat:AudioStreamPlayer3D
@export var move_target : Node3D

func _ready():
	super()

func _process(delta: float) -> void:
	base_move_speed = 0.1
	if move_target:
		var dir = move_target.position - self.position
		self.position += dir.normalized() * base_move_speed * delta


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is ToothFairy or body is ToothMech:
		GamestateManagerGlobal.apply_damage(100, body, self)
