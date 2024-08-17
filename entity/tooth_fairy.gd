class_name ToothFairy extends Entity

@export var starting_distance = 70
@export var speed: float = 200
@export var boost_speed: float
@export var tooth_mech: Node3D

@export var velocity = Vector3()

func _ready() -> void:
	self.position = tooth_mech.position + Vector3(0, -self.starting_distance, 0)
	self.velocity = Vector2(speed, 0)


func _process(delta: float) -> void:
	var input_direction = Vector2(Input.get_axis("ui_left", "ui_right"), -Input.get_axis("ui_down", "ui_up"))
	var circling_direction = tooth_mech.position - self.position
	
	velocity += circling_direction
	
	self.position += self.velocity * delta
	self.position += input_direction * speed * delta
