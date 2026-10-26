class_name Player
extends CharacterBody3D

@export_group("Movement")
@export var mouse_sensitivity: float = 0.003
@export var walk_speed: float = 5.0
@export var sprint_speed: float = 9.5
@export var bob_frequency: float = 2.0
@export var bob_amplitude: float = 0.01
@export var jump_velocity: float = 4.5

@onready var head: Node3D = $Head

var input_dir : Vector2
var move_dir: Vector3
var current_speed: float
var gravity : float = ProjectSettings.get_setting("physics/3d/default_gravity")
var bob_time: float = 0.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		#Yaw (left/right)
		rotate_y(-event.relative.x * mouse_sensitivity)
		#Pitch (up/down)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	#Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	#Jump
	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y = jump_velocity
	
	current_speed = walk_speed
	if Input.is_action_pressed("sprint") && is_on_floor():
		current_speed = sprint_speed
	
	#Direction
	input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	move_dir = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	#Movement
	if move_dir:
		velocity.x = move_dir.x * current_speed
		velocity.z = move_dir.z * current_speed
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
	
	move_and_slide()
	
	if is_on_floor() && velocity.length() > 0.1:
		bob_time += delta * (velocity.length())
		head.transform.origin.y = head.position.y + sin(bob_time * bob_frequency) * bob_amplitude
