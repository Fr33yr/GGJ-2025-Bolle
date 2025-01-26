extends ScrollContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	vertical_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	scroll_to_bottom()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func on_tween_end():
	await  get_tree().create_timer(1.5).timeout
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func scroll_to_bottom():
	var tween = get_tree().create_tween().set_trans(Tween.TRANS_LINEAR)
	var scrollbar = get_v_scroll_bar()
	tween.connect("finished", on_tween_end)
	
	if scrollbar:
		scrollbar.value = scrollbar.min_value
		tween.tween_property(scrollbar, "value", (scrollbar.max_value_200), 2.0)
		tween.finished 
