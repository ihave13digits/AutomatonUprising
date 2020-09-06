extends HSlider

func prepare(low, high, val, pos, size):
	min_value = low
	max_value = high
	value = val
	
	rect_position = pos
	rect_size = size

func set_setting(setting):
	Data.settings[setting] = value
