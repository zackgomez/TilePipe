# the class to hold the data from a generated tile
extends Resource

class_name GeneratedTile

var mask: int
var position_in_template: Vector2
var image: Image = null
var is_rendering := false


func _init(new_mask: int, new_position_in_template: Vector2):
	._init()
	mask = new_mask
	position_in_template = new_position_in_template
	
