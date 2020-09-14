extends Control

func _ready():
	$MouseSensitivity.value = Data.settings['mouse_sensitivity']['value']
	$WheelSensitivity.value = Data.settings['wheel_sensitivity']['value']
	$SpawnDistance.value = Data.settings['spawn_distance']['value']
	$HUDOpacity.value = Data.settings['hud_opacity']['value']
	$EffectsVolume.value = Data.settings['effects_volume']['value']
	$MusicVolume.value = Data.settings['music_volume']['value']

func _on_MouseSensitivity_value_changed(value):
	Data.settings['mouse_sensitivity']['value'] = value

func _on_WheelSensitivity_value_changed(value):
	Data.settings['wheel_sensitivity']['value'] = value

func _on_SpawnDistance_value_changed(value):
	Data.settings['spawn_distance']['value'] = value

func _on_HUDOpacity_value_changed(value):
	Data.settings['hud_opacity']['value'] = value
	get_parent().center_img.modulate = Color(1.0, 1.0, 1.0, Data.settings['hud_opacity']['value'])

func _on_EffectsVolume_value_changed(value):
	Data.settings['effects_volume']['value'] = value

func _on_MusicVolume_value_changed(value):
	Data.settings['music_volume']['value'] = value

func _on_Done_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_parent().get_parent().player.has_control = true
	get_parent().get_parent()._update_hud()
	queue_free()
