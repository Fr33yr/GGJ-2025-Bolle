extends StaticBody2D

class_name Bubble_Blue

@onready var player = $"../../Player"
@onready var collision_shape_2d = $CollisionShape2D

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
	if areaParent is Enemy1 || areaParent is Enemy2:
		queue_free()
