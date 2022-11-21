class_name AdvancedSpinBox
extends SpinBox

# this signal is on;y emitted when triggered by not a quie
signal value_changed_no_silence(value)

var is_silenced: bool = false

func _input(event: InputEvent):
	if event is InputEventKey and event.is_pressed() and \
			(event.scancode == KEY_UP or event.scancode == KEY_DOWN):
		if get_focus_owner() == get_line_edit():
			if get_line_edit().editable:
				if event.scancode == KEY_UP:
					value += 1
				else:
					value -= 1
			get_tree().set_input_as_handled()


func set_value_quietly(new_value: float):
	is_silenced = true
	value = new_value
	is_silenced = false


func _on_AdvancedSpinBox_value_changed(value):
#	print(self, " is silenced ", is_silenced)
	if not is_silenced:
		emit_signal("value_changed_no_silence", value)


func remove(_param1 = null, _param2 = null):
	queue_free()

#
#func _on_AdvancedSpinBox_focus_entered():
#	print("focused")
#
#
#func set_small_font():
#	var fnt: DynamicFont = load("res://assets/styles/subscribe_font.tres")
##	fnt.size = 20
#	add_font_override("font", fnt)
#	add_color_override("font_color", Color.red)
#
