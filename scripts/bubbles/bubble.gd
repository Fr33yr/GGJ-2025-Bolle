extends StaticBody2D

class_name Bubble

@onready var collision_shape_2d: CollisionShape2D
@onready var sfx_pop: AudioStreamPlayer
@onready var area_2d: Area2D
@onready var sprite_2d: Sprite2D
@onready var hit_box: CollisionShape2D

var speed = 1500
var velocity: Vector2
var direction: Vector2
var damage = 1

func _init():
	speed = 1500

func _ready():
	collision_shape_2d = $CollisionShape2D
	sfx_pop = $SFX_Pop
	area_2d = $Area2D
	sprite_2d = $Sprite2D
	hit_box = $Area2D/HitBox

func _physics_process(delta):
	velocity = direction * speed
	position += velocity * delta
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	destroy_bubble()

func destroy_bubble():
	area_2d.monitoring = false
	area_2d.monitorable = false
	sprite_2d.visible = false
	collision_shape_2d.set_deferred("disabled",true)
	hit_box.set_deferred("disabled",true)
	await get_tree().create_timer(0.1).timeout
	queue_free()
