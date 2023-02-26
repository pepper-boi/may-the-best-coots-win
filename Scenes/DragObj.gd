extends TextureRect
class_name Draggable

var id: int
var label: String
# set this to true once we've been dropped on our target
var dropped_on_target: bool = false


func _ready() -> void:
	add_to_group("DRAGGABLE")


func get_drag_data(_position: Vector2):
	print("[Draggable] get_drag_data has run")
	modulate.a = 0.5
	dropped_on_target = false
	if not dropped_on_target:
		set_drag_preview(_get_preview_control())
		return self


func _on_item_dropped_on_target(draggable):
	print("[Draggable] Signal item_dropped_on_target received")
	modulate.a = 0.5
	if draggable.get("id") != id:
		return
	print("[Draggable] Iven been dropped, removing myself from source container")
	queue_free()


func _get_preview_control() -> Control:
	"""
	The preview control must not be in the scene tree. You should not free the control, and
	you should not keep a reference to the control beyond the duration of the drag.
	It will be deleted automatically after the drag has ended.
	"""
	var preview = self.duplicate()
	preview.modulate.a = 1
	
	return preview
