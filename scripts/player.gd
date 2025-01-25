extends CharacterBody2D

signal bubble_shot

@onready var sprite_2d = $Sprite2D
@onready var bubble = $"../Bubble"
@onready var muzzle = $Muzzle
@onready var audio_player = $AudioStreamPlayer2D

@export var move_speed : float = 500
@export var friction : float = 1000
var character_direction : Vector2
var aim_direction = Vector2(-1,0)

var bubble_scene = preload("res://scenes/bubble.tscn")

func _process(delta):
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
