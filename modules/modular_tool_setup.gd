@tool
extends EditorScript




#@export_tool_button("Create Groups") var action = add_common_groups_to_project_settings




#func add_common_groups_to_project_settings():
func _run():
	#ProjectSettings.get_setting("group")
	var groups = ProjectSettings.get_setting("global/groups", "default")
	#var groups = ProjectSettings._get_property_list()
	print("Globals groups is - ", groups)
	#for key in ProjectSettings.get_setting(""):
		#if "group" in key:
			#print(key)
