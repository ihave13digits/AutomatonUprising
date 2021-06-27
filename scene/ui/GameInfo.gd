extends Control

onready var labels = {
	0 : $L0,
	1 : $L1,
	2 : $L2,
	3 : $L3,
	4 : $L4,
	5 : $L5,
	6 : $L6,
	7 : $L7,
	8 : $L8,
	9 : $L9,
}

func _ready():
	set_text(0, ".")
	set_text(1, ".")
	set_text(2, ".")
	set_text(3, ".")
	set_text(4, ".")
	set_text(5, ".")
	set_text(6, ".")
	set_text(7, ".")
	set_text(8, ".")
	set_text(9, ".")

func set_text(l, txt):
	labels[l].text = txt
