extends Control

func get_drag_data(_position):
	var data = {}
	
	var preview = self.duplicate()
	var control = Control.new()
	
	control.add_child(preview)
	preview.rect_position = -rect_size/2
	
	set_drag_preview(control)
	
	return data

func can_drop_data(_position, _data):
	return true

func drop_data(_position, data):
	get_child(0).texture = data["orgin_texture"]
