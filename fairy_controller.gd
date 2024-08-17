extends Node2D

@export var starting_distance = 70
@export var speed: float
@export var boost_speed: float
@export var tooth_mech: Node2D

var velocity = Vector2()

func _ready() -> void:
	self.position = tooth_mech.position + Vector2(0, -self.starting_distance)
	self.velocity = Vector2(speed, 0)


func _process(delta: float) -> void:
	var input_direction = Vector2(Input.get_axis("ui_left", "ui_right"), Input.get_axis("ui_down", "ui_up"))
	var circling_direction = tooth_mech.position - self.position
	
	velocity += circling_direction
	velocity += input_direction * speed
	
	self.position += self.velocity * delta
	
