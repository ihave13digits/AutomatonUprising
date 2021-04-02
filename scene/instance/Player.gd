extends KinematicBody

signal edit_chunk
signal update_chunks
signal update_cursor
signal update_hud

onready var cursor = $Y/X/Cam/Cursor

var showing_grid = false
var has_control = true
var is_paused = false

var velocity = Vector3()
var update_position = Vector3()

var _yaw = 0.0
var _pitch = 0.0

var id = 'player'

var can = {
	'create' : true,
	'destroy' : true,
	'remove_object' : false,
	'place_object' : false
}

var mesh = {
	'body' : "",
	'hand' : ""
}

var data = {
	# Stats
	'HP' : 0.0,
	'hp' : 0.0,
	'create_rate' : 0.0,
	'destroy_rate' : 0.0,
	'speed' : 500.0,
	'boost' : 1.0,
	# Specified
	'age' : 10.0,
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
	$Y.translation.y = data['height'] - data['height'] * 0.1
	$Y/X/Hand.translation.y -= data['height'] * 0.25
	$Box.shape.height = data['height'] / 2
	$Box.translation.y = data['height'] / 2

func get_pos():
	return Vector3(
		floor(translation.x/Data.physics['tile_size']),
		floor(translation.y/Data.physics['tile_size']),
		floor(translation.z/Data.physics['tile_size']))

func set_held(obj=null):
	if !obj:
		$Y/X/Hand.visible = false
		return
	else:
		$Y/X/Hand.visible = true
		mesh['hand'] = obj
	$Y/X/Hand/Mesh.mesh = load(mesh['hand'])
	$Y/X/Hand/Mesh.material_override = load("res://skin/global_material.tres")

func update_map_position():
	var d = Data.settings['spawn_distance']['value']/2
	
	if int(round(translation.x - (d))) >= int(round(update_position.x)):
		update_position.x = int(round(translation.x))
		emit_signal("update_chunks")
	if int(round(translation.x + (d))) <= int(round(update_position.x)):
		update_position.x = int(round(translation.x))
		emit_signal("update_chunks")

	if int(round(translation.z - (d))) >= int(round(update_position.z)):
		update_position.z = int(round(translation.z))
		emit_signal("update_chunks")
	if int(round(translation.z + (d))) <= int(round(update_position.z)):
		update_position.z = int(round(translation.z))
		emit_signal("update_chunks")

func create():
	if can['create']:
		if cursor.get_collider() != null:
			if cursor.get_collider().id.find('tile') != -1 && can['place_object']:
				emit_signal("edit_chunk", cursor.get_collider().translation, 1)
			else:
				get_parent().hud.display_message(cursor.get_collider().translation)
		can['create'] = false
		$Create.start()

func destroy():
	if can['destroy']:
		if cursor.get_collider() != null:
			if cursor.get_collider().id.find('tile') != -1 && can['remove_object']:
				emit_signal("edit_chunk", cursor.get_collider().translation, -1)
			else:
				get_parent().hud.display_message(cursor.get_collider().id)
				if can['remove_object']:
					cursor.get_collider().queue_free()
		can['destroy'] = false
		$Destroy.start()

func _physics_process(delta):
	if !has_control or is_paused:
		return

	velocity -= Vector3(0, Data.physics['gravity'], 0)
	if velocity.length() > 0.01:
		velocity /= velocity.length()

		var motion = velocity * ((data['speed']*data['boost']) * delta)
		motion = move_and_slide(motion, Vector3.UP, false, 4, 0.78, true)

func _process(_delta):
	if Input.is_action_just_pressed("menu"):
		if Input.get_mouse_mode() != Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			has_control = false
		elif Input.get_mouse_mode() != Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			has_control = true
		emit_signal("update_hud")
	
	if !has_control or is_paused:
		return
	
	if Input.is_action_pressed("jump"):
		if is_on_floor():
			var tween = get_node("Tween")
			tween.interpolate_property(
			self, "translation",
			translation,
			Vector3(translation.x, translation.y+1.5, translation.z),
			0.3,
			Tween.TRANS_SINE
			)
			tween.start()
	
	if Input.is_action_pressed("jog"):
		data['boost'] = 1.5
	if Input.is_action_just_released("jog"):
		data['boost'] = 1.0
	
	if Input.is_action_pressed("run"):
		data['boost'] = 2.0
	if Input.is_action_just_released("run"):
		data['boost'] = 1.0
	
	if Input.is_action_pressed("move_forward"):
		velocity = -$Y.get_transform().basis.z
		update_map_position()
	if Input.is_action_pressed("move_backward"):
		velocity = $Y.get_transform().basis.z
		update_map_position()
	if Input.is_action_pressed("move_left"):
		velocity = -$Y.get_transform().basis.x
		update_map_position()
	if Input.is_action_pressed("move_right"):
		velocity = $Y.get_transform().basis.x
		update_map_position()

	if Input.is_action_pressed("create"):
		create()
	if Input.is_action_pressed("destroy"):
		destroy()

func _input(event):
	if !has_control or is_paused:
		return

	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		_yaw -= event.relative.x * Data.settings['mouse_sensitivity']['value']
		_pitch += event.relative.y * Data.settings['mouse_sensitivity']['value']
		if _pitch > Data.settings['max_pitch']['value']:
			_pitch = Data.settings['max_pitch']['value']
		elif _pitch < -Data.settings['max_pitch']['value']:
			_pitch = -Data.settings['max_pitch']['value']
		$Y.set_rotation(Vector3(0, deg2rad(_yaw), 0))
		$Y.rotate($Y.get_transform().basis.x.normalized(), -deg2rad(_pitch))
		emit_signal("update_cursor")

func _on_Create_timeout(): can['create'] = true
func _on_Destroy_timeout(): can['destroy'] = true
