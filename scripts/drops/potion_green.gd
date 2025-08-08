extends StaticBody2D

class_name Potion_Green

@onready var potion_green: StaticBody2D
@onready var sprite_2d: Sprite2D
@onready var collision_shape_2d: CollisionShape2D
@onready var area_2d: Area2D
@onready var hit_box: CollisionShape2D
@onready var timer: Timer
@onready var sfx_pops: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	potion_green = $"."
	sprite_2d = $Sprite2D
	collision_shape_2d = $CollisionShape2D
	area_2d = $Area2D
	hit_box = $Area2D/HitBox
	timer = $Timer
	sfx_pops = $SFX_Pops


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_area_2d_area_entered(area):
	var areaParent = area.get_parent()
	if areaParent is Player || areaParent is Bubble_Blue|| areaParent is Bubble_Red:
		sfx_pops.play()
		explode()
		destroy_potion()

func explode():
	await get_tree().create_timer(0.1).timeout
	var bubble1 = preload("res://scenes/bubbles/bubble_green.tscn").instantiate()
	var bubble2 = preload("res://scenes/bubbles/bubble_green.tscn").instantiate()
	var bubble3 = preload("res://scenes/bubbles/bubble_green.tscn").instantiate()
	var bubble4 = preload("res://scenes/bubbles/bubble_green.tscn").instantiate()
	var bubble5 = preload("res://scenes/bubbles/bubble_green.tscn").instantiate()
	var bubble6 = preload("res://scenes/bubbles/bubble_green.tscn").instantiate()
	var bubble7 = preload("res://scenes/bubbles/bubble_green.tscn").instantiate()
	var bubble8 = preload("res://scenes/bubbles/bubble_green.tscn").instantiate()
	
	bubble1.global_position = potion_green.global_position + Vector2(25,25)
	bubble2.global_position = potion_green.global_position + Vector2(25,-25)
	bubble3.global_position = potion_green.global_position + Vector2(-25,-25)
	bubble4.global_position = potion_green.global_position + Vector2(-25,25)
	bubble5.global_position = potion_green.global_position + Vector2(25,0)
	bubble6.global_position = potion_green.global_position + Vector2(0,25)
	bubble7.global_position = potion_green.global_position + Vector2(-25,0)
	bubble8.global_position = potion_green.global_position + Vector2(0,-25)
	
	bubble1.direction = Vector2(1,1)
	bubble2.direction = Vector2(1,-1)
	bubble3.direction = Vector2(-1,-1)
	bubble4.direction = Vector2(-1,1)
	bubble5.direction = Vector2(1,0)
	bubble6.direction = Vector2(0,1)
	bubble7.direction = Vector2(-1,0)
	bubble8.direction = Vector2(0,-1)
	
	bubble5.speed = 1000
	bubble6.speed = 1000
	bubble7.speed = 1000
	bubble8.speed = 1000
	
	var container: Node = potion_green.get_parent()
	
	container.add_child(bubble1,false,Node.INTERNAL_MODE_DISABLED)
	container.add_child(bubble2,false,Node.INTERNAL_MODE_DISABLED)
	container.add_child(bubble3,false,Node.INTERNAL_MODE_DISABLED)
	container.add_child(bubble4,false,Node.INTERNAL_MODE_DISABLED)
	container.add_child(bubble5,false,Node.INTERNAL_MODE_DISABLED)
	container.add_child(bubble6,false,Node.INTERNAL_MODE_DISABLED)
	container.add_child(bubble7,false,Node.INTERNAL_MODE_DISABLED)
	container.add_child(bubble8,false,Node.INTERNAL_MODE_DISABLED)

func destroy_potion():
	area_2d.monitoring = false
	area_2d.monitorable = false
	sprite_2d.visible = false
	collision_shape_2d.set_deferred("disabled",true)
	hit_box.set_deferred("disabled",true)
	await get_tree().create_timer(0.4).timeout
	queue_free()

func _on_timer_timeout():
	queue_free()
