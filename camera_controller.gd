class_name CameraController extends Node3D

# needs two modes: tracking mech and tracking fairy
# needs to be able to transition between those modes
# tracking code should be essentially the same, the only difference being the offset from the target object

@export var followed_entity:Entity

@export var fairy_follow_speed: float = 0.3
@export var fairy_follow_rotation_speed: float = 0.6
@export var fairy_target: Node3D

@export var height = 17.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if followed_entity is ToothFairy:
		self.position = followed_entity.position + 0.15*followed_entity.velocity + Vector3(0, height, 0)
	elif followed_entity is ToothMech:
		self.position = followed_entity.position + 5*followed_entity.velocity + Vector3(0, height, 0)
