extends KinematicBody

var id = ""

var velocity = Vector3()

var data = {
	'damage' : 0.0,
	'weight' : 0.0,
	'speed' : 0.0
}

func _process(delta):
	var motion = velocity * data['speed'] * delta
	velocity = move_and_collide(motion)
