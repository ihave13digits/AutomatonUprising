extends Control

enum ACTIONS {menu, jog, run, jump, move_forward, move_backward, move_left, move_right}
var action_string = ''

func _ready():
	update_labels()

func _input(event):
	if event is InputEventKey:
		var key = OS.get_scancode_string(event.scancode)
		if event.pressed:
			if key and action_string in Data.controls:
				Data.controls[action_string] = key
				_change_key(event)
				update_labels()
	if event is InputEventMouseButton:
		var button
		if event.is_action_pressed("button_1") or event.is_action_released("button_1"):
			button = 'button_1'
		if event.is_action_pressed("button_2") or event.is_action_released("button_2"):
			button = 'button_2'
		if button and action_string in Data.controls:
			Data.controls[action_string] = button
			_change_key(event)
			update_labels()

func _change_key(new_key):
	if !InputMap.get_action_list(action_string).empty():
		InputMap.action_erase_event(action_string, InputMap.get_action_list(action_string)[0])
	InputMap.action_add_event(action_string, new_key)

func update_labels():
	$LabelMenu.text = Data.controls['menu']
	$LabelJog.text = Data.controls['jog']
	$LabelRun.text = Data.controls['run']
	$LabelJump.text = Data.controls['jump']
	$LabelMoveForward.text = Data.controls['move_forward']
	$LabelMoveBackward.text = Data.controls['move_backward']
	$LabelMoveLeft.text = Data.controls['move_left']
	$LabelMoveRight.text = Data.controls['move_right']

func _on_Menu_pressed(): action_string = 'menu'
func _on_Jog_pressed(): action_string = 'jog'
func _on_Run_pressed(): action_string = 'run'
func _on_Jump_pressed(): action_string = 'jump'
func _on_MoveForward_pressed(): action_string = 'move_forward'
func _on_MoveBackward_pressed(): action_string = 'move_backward'
func _on_MoveLeft_pressed(): action_string = 'move_left'
func _on_MoveRight_pressed(): action_string = 'move_right'

func _on_Done_pressed():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_parent().get_parent().player.has_control = true
	get_parent().get_parent()._update_hud()
	queue_free()
