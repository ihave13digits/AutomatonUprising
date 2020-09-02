extends KinematicBody

signal update_hud

onready var cursor = $Y/X/Cam/Cursor
var has_control = true

var _yaw = 0.0
var _pitch = 0.0

var id = 'player'

var mesh = {
	'body' : "",
	'hand' : ""
}

var data = {
	# Stats
	'HP' : 0.0,
	'hp' : 0.0,
	# Specified
	'gender' : 0.0,
	'height' : 1.8,
	'weight' : 0.0,
}

var inventory = {
}

var nutrients = {
	# Nutrition
	'calorie' : 0.0,
	'sat_fat' : 0.0,
	'pol_fat' : 0.0,
	'mon_fat' : 0.0,
	'cholesterol' : 0.0,
	'sodium' : 0.0,
	'fiber' : 0.0,
	'sugar' : 0.0,
	'protein' : 0.0,
	'calcium' : 0.0,
	'potassium' : 0.0,
	'iron' : 0.0,
	'vitamin_a' : 0.0,
	'vitamin_c' : 0.0
}

func ready():
	#$Mesh.mesh = load(mesh['body'])
	$Y/X/Hand.translation.y -= data['height'] * 0.25
	$Y.translation.y = data['height']
	$Box.shape.height = data['height'] / 2
	$Box.translation.y = data['height'] / 2

func set_held(obj=null):
	if !obj:
		$Y/X/Hand.visible = false
		return
	else:
		$Y/X/Hand.visible = true
		mesh['hand'] = obj
	$Y/X/Hand/Mesh.mesh = load(mesh['hand'])
	$Y/X/Hand/Mesh.material_override = load("res://skin/global_material.tres")

func _input(event):
	control(event)

func control(event):
	if event is InputEventMouseButton:
		
		if Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			has_control = true
			emit_signal("update_hud")
		
		if cursor.get_collider() != null:
			print(cursor.get_collider().id)
			
	if has_control:
		if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			_yaw -= event.relative.x * Data.settings['mouse_sensitivity']
			_pitch += event.relative.y * Data.settings['mouse_sensitivity']
			
			if _pitch > Data.settings['max_pitch']:
				_pitch = Data.settings['max_pitch']
			elif _pitch < -Data.settings['max_pitch']:
				_pitch = -Data.settings['max_pitch']
				
			$Y.set_rotation(Vector3(0, deg2rad(_yaw), 0))
			$Y.rotate($Y.get_transform().basis.x.normalized(), -deg2rad(_pitch))
		
		if event is InputEventKey:
			var key = OS.get_scancode_string(event.scancode)
			
			if key == Data.controls['move_forward']:
				pass
			elif key == Data.controls['move_backward']:
				pass
	
			if key == Data.controls['move_left']:
				pass
			elif key == Data.controls['move_right']:
				pass
	
			if key == Data.controls['menu']:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
				has_control = false
			emit_signal("update_hud")
