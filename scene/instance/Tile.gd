extends StaticBody

var id = ''

var active = false

var mesh = {
	'body' : "",
}

func _ready():
	$Mesh.mesh = load(mesh['body'])
	set_collision()

func set_material(mtrl):
	$Mesh.material_override = load(Data.material[mtrl])

func set_collision():
	var mdt = MeshDataTool.new()
	mdt.create_from_surface($Mesh.mesh, 0)

	var point_array = []
	for v in range(mdt.get_vertex_count()):
		var vtx = mdt.get_vertex(v)
		point_array.append(vtx)
	
	$Box.shape = ConvexPolygonShape.new()
	$Box.shape.set_points(point_array)
