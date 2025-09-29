@tool
extends Node2D

@export_tool_button("Get Error") 
var err_action = getErrCode

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return

func hello():
	print("Hello world!")

func getErrCode():
	var script = EditorInterface.get_script_editor().get_current_script()
	var err_code = script.reload()
	print("--------------")
	print("script is: ", script, " - ", script.get_global_name())
	print("script get_rpc_config: ", script.get_rpc_config())
	print("script get_script_signal_list: ", script.get_script_signal_list())
	print("script can_instantiate: ", script.can_instantiate())
	print("error code is: ", err_code)
