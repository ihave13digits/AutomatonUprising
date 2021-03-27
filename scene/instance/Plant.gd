extends StaticBody

var id = ''

var mesh = {
	'body' : "",
}

var data = {
	'growthrate' : 0,
	'lifespan' : 0,
	'weight' : 0,
	'HP' : 0,
	'hp' : 0
}

func _ready():
	$Mesh.mesh = load(mesh['body'])
	$Mesh.material_override = load("res://skin/global_material.tres")
	
	var box = $Mesh.mesh.get_aabb()
	$Box.shape.extents = Vector3(box.size.x/2, box.size.y/2, box.size.z/2)
	$Box.translation = Vector3(0, box.size.y/2, 0)
