extends KinematicBody

var id = 'drone'

var mesh = {
	'body' : "",
}

var data = {
	'weight' : 0,
	'HP' : 0,
	'hp' : 0,
}

func _ready():
	$Mesh.mesh = load(mesh['body'])
	$Mesh.material_override = load("res://skin/global_material.tres")
