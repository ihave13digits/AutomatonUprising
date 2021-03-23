extends StaticBody

var id = ''

var mesh = {
	'surface' : "",
	'body' : "",
}

var data = {
	'growthrate' : 0,
	'lifespan' : 0,
	'density' : 0,
	'HP' : 0,
	'hp' : 0
}

func _ready():
	$Mesh.multimesh.mesh = load(mesh['body'])
	$Mesh.material_override = load("res://skin/global_material.tres")
	$Mesh.multimesh.instance_count = data['density']
	
	var half = int($Mesh.multimesh.instance_count/2)
	
	for i in range(half):
		var position
		var X = ((randi() % 50)*0.01)-.25
		var Z = ((randi() % 50)*0.01)-.25
		position = Transform(Basis(), Vector3(X, 0, Z))
		$Mesh.multimesh.set_instance_transform(i, position)
	for i in range(half, $Mesh.multimesh.instance_count):
		var position
		var X = (randi() % 100)*0.01-.5
		var Z = (randi() % 100)*0.01-.5
		position = Transform(Basis(), Vector3(X, 0, Z))
		$Mesh.multimesh.set_instance_transform(i, position)
