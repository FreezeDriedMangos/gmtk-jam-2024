class_name CoinProjectile extends Entity

@onready var body:Node3D = $Body

var speed:float = 12.0
var damage:int = 100.0
var spin:Vector3 = Vector3(randf_range(-2.0, 2.0), randf_range(-2.0, 2.0), randf_range(-2.0, 2.0))*10.0
var time_to_live_ms:float = 1000.0
var time_spawned_s:float

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector3.FORWARD*speed
	time_spawned_s = Time.get_unix_time_from_system()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var current_s = Time.get_unix_time_from_system()
	if(current_s - time_spawned_s > time_to_live_ms/1000.0):
		die()

	body.rotation += spin*delta
	position += velocity*delta


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is MinorHorror:
		GamestateManagerGlobal.apply_damage(100, body, self)
