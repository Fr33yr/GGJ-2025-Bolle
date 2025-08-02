extends Bubble

class_name Bubble_Green

func _on_area_2d_area_entered(area):
	var areaParent = area.get_parent()
	if areaParent is Player || areaParent is Bubble_Blue:
		sfx_pop.play()
		destroy_bubble()
