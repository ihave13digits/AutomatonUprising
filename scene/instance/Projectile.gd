extends KinematicBody

var id = ""

var velocity = Vector3()

var mesh = {
	'body' : "",
}

var data = {
	'damage' : 0.0,
	'weight' : 0.0,
	'speed' : 0.0
}

func _ready():
	$Mesh.mesh = load(mesh['body'])
	$Mesh.material_override = load("res://skin/global_material.tres")

func _process(delta):
	var motion = velocity * data['speed'] * delta
	velocity = move_and_collide(motion)
