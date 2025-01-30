extends CharacterBody2D

class_name Player

signal bubble_shot

@onready var animated_sprite= $AnimatedSprite2D
@onready var muzzle = $Muzzle
@onready var audio_player = $AudioStreamPlayer2D
@onready var hp_system = $HP_System
@onready var collision_shape_2d = $CollisionShape2D

@export var hp_max: int = 3
@export var move_speed : float = 750
@export var friction : float = 1000
var character_direction : Vector2
var aim_direction : Vector2
var bubble_scene = preload("res://scenes/bubbles/bubble_blue.tscn")

var joystick_connected = false

# Initializes the HPSystem.
func _ready() -> void:
	check_connected_joypad()
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
	animated_sprite.visible = false
	await get_tree().create_timer(0.1).timeout 
	get_tree().change_scene_to_file("res://scenes/menus/defeat.tscn")
	
# Checks for contact with other objects. Verifies through class name.
func _on_area_2d_area_entered(area: Area2D) -> void:
	var areaParent = area.get_parent()
	if areaParent is Enemy1 || areaParent is Enemy2 || areaParent is Enemy3 || areaParent is Bubble_Green:
		var damage = (areaParent).damage
		hp_system.apply_damage(damage)

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
	
	if character_direction.y < 0:
		animated_sprite.play("move_up")
	elif character_direction.y > 0:
		animated_sprite.play("move_down")
	
	if character_direction.x > 0:
		animated_sprite.play("move_right")
	elif character_direction.x < 0:
		animated_sprite.play("move_left")
		
	if character_direction != Vector2.ZERO:
		velocity = character_direction.normalized() * move_speed
	else:
		animated_sprite.play("idle")
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta) * Vector2.ZERO
	update_muzzle_direction()
	move_and_slide()

func update_muzzle_direction():
	if joystick_connected: #Use Joypad Input
		var aim_input = Vector2(Input.get_axis("aim_left", "aim_right"),
	 	Input.get_axis("aim_up", "aim_down"))
		aim_direction = aim_input.normalized()
		if aim_input.length() > 0.1: #Dead zone check
			$Muzzle.rotation = aim_input.angle()
			aim_direction = aim_input.normalized()
	else:
		var mouse_position = get_global_mouse_position()
		var muzzle_global_position = muzzle.global_position
		var direction = mouse_position - muzzle_global_position
		$Muzzle.rotation = direction.angle()
		aim_direction = direction.normalized()
		
func shoot():
	if aim_direction == Vector2.ZERO: return
	bubble_shot.emit(bubble_scene, muzzle.global_position)
	audio_player.play()
	
func check_connected_joypad():
	if Input.get_connected_joypads().size() > 0:
		joystick_connected = true
