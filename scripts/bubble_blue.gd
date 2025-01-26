extends StaticBody2D

class_name Bubble_Blue

@onready var player = $"../../Player"
@onready var collision_shape_2d = $CollisionShape2D
@onready var audio_stream_player = $AudioStreamPlayer
@onready var area_2d = $Area2D
@onready var sprite_2d = $Sprite2D
@onready var hit_box = $Area2D/HitBox

@export var speed = 1500
var velocity: Vector2
var direction: Vector2

@export var damage = 1

func _ready():
	direction = player.aim_direction

func _physics_process(delta):
	velocity = direction * speed
	position += velocity * delta
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()	


func _on_area_2d_area_entered(area):
	var areaParent = area.get_parent()
	if areaParent is Enemy1 || areaParent is Enemy2 || areaParent is Enemy3:
		audio_stream_player.play()
		area_2d.monitoring = false
		area_2d.monitorable = false
		sprite_2d.visible = false
		collision_shape_2d.set_deferred("disabled",true)
		hit_box.set_deferred("disabled",true)
		await get_tree().create_timer(0.5).timeout
		queue_free()
