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
	if areaParent is Player || areaParent is Bubble_Blue:
		sfx_pops.play()
		explode()
		destroy_potion()

func explode():
	await get_tree().create_timer(0.11).timeout
	var bubble1 = Preloads.BUBBLE_GREEN.instantiate()
	var bubble2 = Preloads.BUBBLE_GREEN.instantiate()
	var bubble3 = Preloads.BUBBLE_GREEN.instantiate()
	var bubble4 = Preloads.BUBBLE_GREEN.instantiate()
	
	bubble1.global_position = potion_green.global_position
	bubble2.global_position = potion_green.global_position
	bubble3.global_position = potion_green.global_position
	bubble4.global_position = potion_green.global_position
	
	bubble1.direction = Vector2(1,1)
	bubble2.direction = Vector2(1,-1)
	bubble3.direction = Vector2(-1,-1)
	bubble4.direction = Vector2(-1,1)
	
	var container: Node = potion_green.get_parent()
	
	container.add_child(bubble1,false,Node.INTERNAL_MODE_DISABLED)
	container.add_child(bubble2,false,Node.INTERNAL_MODE_DISABLED)
	container.add_child(bubble3,false,Node.INTERNAL_MODE_DISABLED)
	container.add_child(bubble4,false,Node.INTERNAL_MODE_DISABLED)

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
