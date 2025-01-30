extends CharacterBody2D

class_name Enemy2

const bubble_scene = preload("res://scenes/bubbles/bubble_green.tscn")

@onready var audio_stream_randomizer = $AudioStreamRandomizer
@onready var shoot_bubble_sfx = $ShootBubbleSFX
@onready var enemy_laughter_sfx = $EnemyLaughterSFX
@onready var hp_system = $HP_System
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var hp_bar = $HP_Bar
@onready var hitbox = $Area2D/Hitbox
@onready var area_2d = $Area2D

@export var speed = 350.0
@export var chase_speed = 400.0
@export var patrol_path: Array[Marker2D] = []
@export var patrol_wait_time = 0
@export var damage = 1
@export var hp_max: int = 5

var current_patrol_target = 0
var wait_timer = 0.0

var chasing: bool = false
var player: Player

# Initializes the HPSystem.
func _ready() -> void:
	hp_system.init(hp_max)
	hp_bar.max_value = hp_max
	hp_bar.value = hp_max
	
	hp_system.died.connect(on_Died)

# Calls to HPSystem to apply damage.
func apply_damage(damage_recieved: int):
	hp_system.apply_damage(damage_recieved)
	

# Disables all functions. Called from signal.
func on_Died():
	audio_stream_randomizer.play()
	area_2d.monitoring = false
	area_2d.monitorable = false
	animated_sprite_2d.visible = false
	collision_shape_2d.set_deferred("disabled",true)
	hitbox.set_deferred("disabled",true)
	hp_bar.visible = false
	await get_tree().create_timer(0.5).timeout
	queue_free()
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() is Bubble_Blue:
		var damage_recieved = (area.get_parent() as Bubble_Blue).damage
		hp_system.apply_damage(damage_recieved)

func take_damage(damage_recieved: int) -> void:
	animated_sprite_2d.play("dead")
	hp_bar.value -= damage_recieved

func _physics_process(delta: float) -> void:
	if !chasing && patrol_path.size() > 1:
		animated_sprite_2d.play("idle")
		move_along_path(delta)
	elif chasing:
		animated_sprite_2d.play("chasing")
		chase_player(delta)
	

func move_along_path(delta: float):
	var target_position = patrol_path[current_patrol_target].global_position
	var direction = (target_position - position).normalized()
	var distance_to_target = position.distance_to(target_position)
	
	if distance_to_target > speed * delta:
		velocity = direction * speed
		move_and_slide()
	else:
		position = target_position
		wait_timer += delta
		if wait_timer >= patrol_wait_time:
			wait_timer = 0.0
			current_patrol_target = (current_patrol_target + 1) % patrol_path.size()
		

func chase_player(delta: float):
	var player_position = player.global_position
	var direction = (player_position - position).normalized()
	var distance_to_target = position.distance_to(player_position)
	
	if distance_to_target > chase_speed * delta:
		velocity = direction * speed
		move_and_slide()

func _on_player_detector_body_entered(body):
	if body is Player:
		chasing = true
		player = body
		enemy_laughter_sfx.play()


func _on_player_detector_body_exited(body):
	if body is Player:
		chasing = false
		

func _on_timer_timeout():
	if chasing:
		var bubble = bubble_scene.instantiate()
		bubble.direction = player.global_position
		bubble.global_position = global_position
		shoot_bubble_sfx.play()
