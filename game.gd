extends Control

enum ExampleScenes {PLAYER1, ENEMIES1, INTERACTION1}
const scenes = {
	ExampleScenes.ENEMIES1: preload("res://examples/enemies_example_1.tscn"),
	#ExampleScenes.PLAYER1: preload("res://examples/enemies_example_1.tscn"),
	ExampleScenes.INTERACTION1: preload("res://examples/interaction_example_1.tscn"),
}

func _ready() -> void:
	%SceneSelector/Enemies1.pressed.connect(load_scene.bind(ExampleScenes.ENEMIES1))
	%SceneSelector/Interaction1.pressed.connect(load_scene.bind(ExampleScenes.INTERACTION1))
	%MenuButton.pressed.connect(show_main_menu)


func load_scene(scene:ExampleScenes):
	if not $SceneHolder.get_child_count() == 0:
		$SceneHolder.get_child(0).queue_free()
	var new_scene = scenes[scene].instantiate()
	$SceneHolder.add_child(new_scene)
	hide_main_menu()


func hide_main_menu():
	%SceneSelector.visible = false
	$SceneHolder.visible = true
	%MenuButton.visible = true
	

func show_main_menu():
	%SceneSelector.visible = true
	$SceneHolder.visible = false
	%MenuButton.visible = false


#
