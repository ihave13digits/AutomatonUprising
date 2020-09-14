extends Control

func _on_Continue_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_parent().get_parent().player.has_control = true
	get_parent().get_parent()._update_hud()

func _on_Settings_pressed(): pass

func _on_Controls_pressed(): get_parent().get_parent()._update_hud('controls')

func _on_MainMenu_pressed(): pass

func _on_Exit_pressed(): get_tree().quit()
