class_name CameraController extends Node3D

# needs two modes: tracking mech and tracking fairy
# needs to be able to transition between those modes
# tracking code should be essentially the same, the only difference being the offset from the target object

@export var speed: float = 100
@export var height: float = 10
@export var fairy: ToothFairy
@export var fairy_mode: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fairy_mode:
		self.position = fairy.position - fairy.velocity + Vector3(0, 0, height)
		self.look_at(Vector3(fairy.position.x, fairy.position.y, 0), Vector3(0, 0, 1))
		#self.basis = Basis(Quaternion.from_euler(0, atan2(height, fairy.velocity.length())), fairy.velocity.angle())
		
		#self.origin = lerp(self.origin, fairy.global_transform.origin, delta*speed)
		#var current_rotation = Quaternion(self.basis)
		#var next_rotation = self.slerp(Quaternion(fairy.basis), delta*speed)
		#self.basis = Basis(next_rotation)
