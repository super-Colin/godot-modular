class_name ComponentNode2D
extends Node2D

#var debug_string = "ComponentNode2D Base - "

## The parent Modular Entity that will use this component
var _parent_modular_entity: ModularEntity2D
var _player_controlled:bool = false
@export var _component_type:Modular.ComponentTypes = Modular.ComponentTypes.BEHAVIOR


func _ready() -> void:
	__ready()

func __ready():
	var _parent = get_parent()
	if _parent.has_method("connect_component"):
		_parent_modular_entity = _parent
		_parent_modular_entity.connect_component($'.')
	else:
		printerr("Component Node Base - ", "parent isn't modular entity")


func init_component(player_controlled:bool=false):
	_init_component(player_controlled)
func _init_component(player_controlled:bool=false):
	_player_controlled = player_controlled
	print("ComponentNode2D Base - ", _get_component_id(), " init'd, belongs to: ", _parent_modular_entity)



func tick_process(_delta: float) -> void:
	pass

func tick_physics(_delta: float) -> void:
	pass

func face_left():
	pass

func face_right():
	pass


func get_veloctiy_influence()->Vector2:
	return Vector2.ZERO


func _get_component_id() -> String:
	return name.to_lower()












#
