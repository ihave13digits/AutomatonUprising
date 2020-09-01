extends KinematicBody

var id = ''

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
	'height' : 0.0,
	'weight' : 0.0,
}

var inventory = {
	'axestone' : 1,
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

func _process(delta):
	control(delta)

func control(_delta):
	pass
