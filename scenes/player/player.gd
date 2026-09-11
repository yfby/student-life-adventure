class_name Player
extends CharacterBody2D

# Player movement
@export_group("Movement")
@export var move_speed: float = 125.0
@export var acceleration: float = 300.0
@export var friction: float = 250.0
@export var external_velocity_decay: float = 4.0

var move_velocity: Vector2 = Vector2.ZERO
var external_velocity: Vector2 = Vector2.ZERO

@onready var charge_bar: ProgressBar = %ChargeBar
@onready var camera: PlayerCamera = $Camera2D

func _ready() -> void:
	add_to_group("player") # This makes it easier to find the player, and make references
	
		

func _physics_process(delta: float) -> void:
	movement(delta)
	move_and_slide()


func movement(delta: float):
	var input_dir := Input.get_vector("left", "right", "up", "down")
	
	if input_dir != Vector2.ZERO:
		move_velocity = move_velocity.move_toward(input_dir * move_speed, acceleration * delta)
	else:
		move_velocity = move_velocity.move_toward(Vector2.ZERO, friction * delta)
	
	external_velocity = external_velocity.lerp(Vector2.ZERO, 1.0 - exp(-external_velocity_decay * delta))
	
	velocity = move_velocity + external_velocity

# Used by other/external scripts to apply forces to the body
func apply_force(force: Vector2):
	external_velocity += force
