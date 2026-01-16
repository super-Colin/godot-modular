extends Control

enum ExampleScenes {ENEMIES1, INTERACTION1}
const scenes = {
	ExampleScenes.ENEMIES1: preload("res://examples/enemies_example_1.tscn"),
}

func _ready() -> void:
	%SceneSelector/Enemies1.pressed.connect(load_scene.bind(ExampleScenes.ENEMIES1))
	%MenuButton.pressed.connect(show_main_menu)


func load_scene(scene:ExampleScenes):
	if not $SceneHolder.get_child_count() == 0:
		$SceneHolder.get_child(0).queue_free()
	var new_scene = scenes[scene].instantiate()
	$SceneHolder.add_child(new_scene)
	hide_main_menu()


func hide_main_menu():
	%SceneSelector.visible = false

func show_main_menu():
	%SceneSelector.visible = true


#
