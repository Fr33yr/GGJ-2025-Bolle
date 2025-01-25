extends CharacterBody2D

class_name Player

signal bubble_shot

@onready var sprite_2d = $Sprite2D
@onready var muzzle = $Muzzle
@onready var audio_player = $AudioStreamPlayer2D
@onready var hp_system = $HP_System
@onready var collision_shape_2d = $CollisionShape2D


@export var hp_max: int = 3
@export var move_speed : float = 750
@export var friction : float = 1000
var character_direction : Vector2
var aim_direction = Vector2(-1,0)

var bubble_scene = preload("res://scenes/bubble_blue.tscn")

# Initializes the HPSystem.
func _ready() -> void:
	hp_system.init(hp_max)
	#TODO: HP Bar.
	
	hp_system.died.connect(on_Died)

# Calls to HPSystem to apply damage.
func apply_damage(damage: int):
	hp_system.apply_damage(damage)

# Disables all functions. Called from signal.
func on_Died():
	set_process_input(false)
	set_physics_process(false)
	collision_shape_2d.disabled = true
	#TODO: Should play dying animation first, right?. ALSO SFX
	sprite_2d.visible = false
	
# Checks for contact with other objects. Verifies through class name.
func _on_area_2d_area_entered(area: Area2D) -> void:
	print("Player contacts with: ", area.get_parent().name)
	if area.get_parent() is Enemy:
		var damage = (area.get_parent() as Enemy).damage
		hp_system.apply_damage(damage)
		print("Player recieves ", damage," points of damage!")

func _take_damage(damage: int) -> void:
	#TODO: Update HP Bar.
	pass

func _process(delta) -> void:
	if Input.is_action_just_pressed("fire"):
		shoot()

func _physics_process(delta):
	character_direction.x = Input.get_axis("move_left", "move_right")
	character_direction.y = Input.get_axis("move_up", "move_down")
	character_direction = character_direction.normalized()
		
	if character_direction != Vector2.ZERO:
		velocity = character_direction.normalized() * move_speed
		aim_direction = character_direction	
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta) * Vector2.ZERO
	
	move_and_slide()
	
func shoot():
	bubble_shot.emit(bubble_scene, muzzle.global_position)
	audio_player.play()
