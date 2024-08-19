class_name CameraController extends Node3D

# needs two modes: tracking mech and tracking fairy
# needs to be able to transition between those modes
# tracking code should be essentially the same, the only difference being the offset from the target object

@export var fairy_mode: bool = true

@export var fairy_follow_speed: float = 0.3
@export var fairy_follow_rotation_speed: float = 0.6
@export var fairy_target: Node3D

@export var height = 17.5
@export var fairy: ToothFairy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fairy_mode:
		#self.position = self.position.lerp(fairy_target.global_position, fairy_follow_speed)
		
		#var ownQuat = Quaternion(transform.basis)
		#var targetQuat = Quaternion(fairy_target.global_basis)
		#self.basis = Basis(ownQuat.slerp(targetQuat, fairy_follow_rotation_speed))
		
		#print(fairy.velocity)
		self.position = fairy.position - 0.15*fairy.velocity + Vector3(0, height, 0)
		#self.position.x = fairy.position.x
		#self.position.z = fairy.position.z
		
		#self.position = fairy.position - fairy.velocity + Vector3(0, 0, height)
		#self.look_at(Vector3(fairy.position.x, fairy.position.y, 0), Vector3(0, 0, 1))
		
		#self.basis = Basis(Quaternion.from_euler(0, atan2(height, fairy.velocity.length())), fairy.velocity.angle())
		
		#self.origin = lerp(self.origin, fairy.global_transform.origin, delta*speed)
		#var current_rotation = Quaternion(self.basis)
		#var next_rotation = self.slerp(Quaternion(fairy.basis), delta*speed)
		#self.basis = Basis(next_rotation)
