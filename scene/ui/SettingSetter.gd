extends HSlider

func prepare(_min, _max, _val, _step, pos, size):
	min_value = _min
	max_value = _max
	value = _val
	step = _step
	
	rect_position = pos
	rect_size = size

func set_setting(setting):
	Data.settings[setting] = value
