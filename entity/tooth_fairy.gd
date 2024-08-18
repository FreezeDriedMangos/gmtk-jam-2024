class_name ToothFairy extends CharacterBody3D

@export_range(1, 30, 0.5) var TOP_SPEED = 15
@export var ACCEL = 1 * 100
@export_range(1, 2, 0.01) var HANDLING #1 = drifts around, higher = turns better
@export var starting_distance = 70
@export var boost_speed: float = 30
@export var tooth_mech: Node3D

var state: States = States.WALKING
var previous_state: States = States.WALKING
enum States {
	STANDING, WALKING, BOOSTING
}

var boost_dir: Vector2 = Vector2(0, 0)
var speed: Vector2 = Vector2(0, 0)
var move: Vector2 = Vector2(0, 0)

var boost_timer = 99.0
var boost_cooldown = 0.0
const BOOST_CD = 0.8
@export var BOOST_ENDLAG_START = 0.25
@export var BOOST_ENDLAG_END = 0.35

func _ready() -> void:
	pass
	#self.position = tooth_mech.position + Vector3(0, 0, -self.starting_distance)
	#self.velocity = Vector3(speed, 0, 0)

# redo as simple "always move forward, mouse left/right change facing dir, A/D strafe"
func _physics_process(delta: float) -> void:
	var current_top_speed = TOP_SPEED
	boost_cooldown -= delta
	boost_timer += delta

	move.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	move.y = Input.get_action_strength("down") - Input.get_action_strength("up")

	var r = 0
	if move.x != 0 and move.y != 0:
		r = abs(move.x / move.y)
		if r > 1:
			r = 1/r
	move /= pow(sqrt(2), r)

	_change_states(move)

	var boost_factor = 0 # 1 at the start of a boost, 0 at the end, inbetween inbetween
	if (boost_timer < BOOST_ENDLAG_END):
		boost_factor = min(1, remap(boost_timer, BOOST_ENDLAG_START, BOOST_ENDLAG_END, 1, 0))
		current_top_speed *= (10*boost_factor + 1)

	if (move.x == 0):
		speed.x *= (0.3 * boost_factor) + 0.7
	if (move.y == 0):
		speed.y *= (0.3 * boost_factor) + 0.7

	var lerped_dir = speed.normalized().lerp(move, boost_factor == 1 and 0 or 1/HANDLING)
	speed = speed.length() * lerped_dir

	if (boost_factor != 1):
		if sign(move.x) != sign(speed.x):
			speed.x /= HANDLING
		if sign(move.y) != sign(speed.y):
			speed.y /= HANDLING

	speed = boost_factor * (boost_dir * boost_speed) + (1-boost_factor) * speed
	speed += (1 - boost_factor) * move * ACCEL * delta
	speed = speed.limit_length(current_top_speed)
	velocity = Vector3(speed.x, 0, speed.y)
	var colided: bool = move_and_slide()

func _boost():
	boost_timer = 0.0
	boost_cooldown = BOOST_CD
	boost_dir = move

func _change_states(move: Vector2):
	if Input.is_action_just_pressed("dash") and boost_cooldown <= 0 and move.length() > 0:
		_boost()
	match (state):
		States.STANDING:
			if speed.length() > 0.1:
				_set_state(States.WALKING)
		States.WALKING:
			if speed.length() < 0.1:
				_set_state(States.STANDING)

func _enter_state(_new_state):
	pass

func _leave_state(_old_state):
	pass

func _set_state(new_state):
	if new_state == state:
		return #Change unnecessary
	#print(name, " changed state to ", new_state)
	previous_state = state
	state = new_state

	#Calls any special code for the state
	_enter_state(new_state)
	_leave_state(previous_state)
	#Changes animation
	#if(Animations.size() > new_state):
		#if sprite.animation != Animations[new_state]:
			##Swim variant if in the water
			#if watterlogged and sprite.frames.has_animation(Animations[new_state]+"_swim"):
				#sprite.play(Animations[new_state]+"_swim")
			#else:
				#sprite.play(Animations[new_state])
		#else: #Defaults to animation 0
			#print_debug("Defaulting to animation 0")
			#sprite.play(Animations[0])
