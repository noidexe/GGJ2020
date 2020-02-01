tool
extends ProgressBar

export(StyleBoxFlat) var fg_working
export(StyleBoxFlat) var fg_broken
export(StyleBoxFlat) var bg_working
export(StyleBoxFlat) var bg_broken

export(bool) var is_working = true setget _set_working, _get_working

func setup(time_to_trigger):
	value = 0
	max_value = time_to_trigger
	pass
	

func _set_working(enabled: bool):
	if enabled:
		add_stylebox_override("fg", fg_working)
		add_stylebox_override("bg", bg_working)
		is_working = true
	else: 
		add_stylebox_override("fg", fg_broken)
		add_stylebox_override("bg", bg_broken)
		is_working = false
		
func _get_working() -> bool:
	return is_working
