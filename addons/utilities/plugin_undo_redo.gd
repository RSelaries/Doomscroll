@tool
class_name DoomscrollPluginUndoRedo
extends RefCounted


static var manager: EditorUndoRedoManager
# The object that will hold the history
static var context: Object


static func set_property(target: Resource, property: StringName, value: Variant, action_name: String, merge: bool = false) -> void:
	var previous_value: Variant = target.get(property)
	if previous_value == value:
		return
	
	var mode := UndoRedo.MERGE_DISABLE
	if merge:
		mode = UndoRedo.MERGE_ENDS
		# Get id to not merge different objects
		action_name += " [%d]" % target.get_instance_id()
	
	manager.create_action(action_name, mode, context)
	manager.add_do_property(target, property, value)
	manager.add_undo_property(target, property, previous_value)
	manager.add_do_method(target, "emit_changed")
	manager.add_undo_method(target, "emit_changed")
	manager.commit_action()


static func _get_history() -> UndoRedo:
	return manager.get_history_undo_redo(manager.get_object_history_id(context))


static func undo() -> void:
	_get_history().undo()


static func redo() -> void:
	_get_history().redo()
