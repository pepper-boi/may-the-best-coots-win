extends TextureRect

export var type = ""
var changed = false
export var on_side = true

func get_drag_data(_position):
	g.picked()
	
	var data = {}
	
	data["orgin_texture"] = texture
	data["orgin_color"] = modulate
	data["orgin_type"] = type
	data["orgin_object"] = self
	
	var preview = self.duplicate()
	var control = Control.new()
	
	control.add_child(preview)
	preview.rect_position = -rect_size/2
	
	set_drag_preview(control)
	
	return data

func can_drop_data(_position, _data):
	if not on_side:
		return on_side
	else:
		return on_side and not $"../../../..".ready

func drop_data(_position, data):
#	var og_obj:TextureRect = data["orgin_object"]
#	og_obj.texture = texture
#	og_obj.modulate = modulate
#	og_obj.type = type
	g.dropped()
	var p = $"../../../.."
	if on_side:
		if not changed:
			p.changed += 1
			changed = true
			if p.changed == clamp(p.turn+1,0,5):
				p.get_node("Join").disabled = false
	texture = data["orgin_texture"]
	modulate = data["orgin_color"]
	type = data["orgin_type"]
