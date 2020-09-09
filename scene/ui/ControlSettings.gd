extends Control

func _change_key(action_string, new_key):
	if !InputMap.get_action_list(action_string).empty():
		InputMap.action_erase_event(action_string, InputMap.get_action_list(action_string)[0])
	for i in Data.controls:
		if InputMap.action_has_event(i, new_key):
			InputMap.action_erase_event(i, new_key)
	InputMap.action_add_event(action_string, new_key)


func _on_Menu_pressed():
	pass

func _on_Jog_pressed():
	pass

func _on_Run_pressed():
	pass

func _on_Jump_pressed():
	pass

func _on_MoveForward_pressed():
	pass

func _on_MoveBackward_pressed():
	pass

func _on_MoveLeft_pressed():
	pass

func _on_MoveRight_pressed():
	pass


func _on_Done_pressed():
	queue_free()
