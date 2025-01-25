extends CharacterBody2D

class_name Enemy

@onready var hp_system = $HP_System
@onready var sprite_2d = $Sprite2D
@onready var hp_bar = $HP_Bar
@onready var hitbox = $Area2D/Hitbox

@export var speed = 300.0
@export var patrol_path: Array[Marker2D] = []
@export var patrol_wait_time = 1.0
@export var damage = 1
@export var hp_max: int = 3

var current_patrol_target = 0
var wait_timer = 0.0

# Initializes the HPSystem.
func _ready() -> void:
	hp_system.init(hp_max)
	hp_bar.max_value = hp_max
	hp_bar.value = hp_max
	
	if patrol_path.size() > 0:
		position = patrol_path [0].position
	
	hp_system.died.connect(on_Died)

# Calls to HPSystem to apply damage.
func apply_damage(damage: int):
	hp_system.apply_damage(damage)
	

# Disables all functions. Called from signal.
func on_Died():
	set_physics_process(false)
	sprite_2d.visible = false
	hitbox.disabled = true

func _physics_process(delta: float) -> void:
	if patrol_path.size() > 1:
		move_along_path(delta)
		
func move_along_path(delta: float):
	var target_position = patrol_path[current_patrol_target].global_position
	var direction = (target_position - position).normalized()
	var distance_to_target = position.distance_to(target_position)
	
	if distance_to_target > speed * delta:
		#TODO: Movement Animation.
		velocity = direction * speed
		move_and_slide()
	else:
		#TODO: Idle Animation.
		position = target_position
		wait_timer += delta
		if wait_timer >= patrol_wait_time:
			wait_timer = 0.0
			current_patrol_target = (current_patrol_target + 1) % patrol_path.size()
		


	
