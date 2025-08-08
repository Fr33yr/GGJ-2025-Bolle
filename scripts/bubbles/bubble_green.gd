extends Bubble

class_name Bubble_Green

func _init():
	super()
	speed = 750

func _on_area_2d_area_entered(area):
	var areaParent = area.get_parent()
	if areaParent is Player:
		sfx_pop.play()
		destroy_bubble()
