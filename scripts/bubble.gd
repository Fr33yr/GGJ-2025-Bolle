extends Area2D

@onready var player = $"../../Player"
@onready var area_2d = $Area2D
@onready var collision_shape_2d = $Area2D/CollisionShape2D

@export var speed = 1250
var velocity: Vector2
var direction: Vector2

var damage = 1

func _ready():
	direction = player.aim_direction

func _physics_process(delta):
	velocity = direction * speed
	position += velocity * delta
	
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
