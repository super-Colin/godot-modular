class_name ComponentNode2D
extends Node2D



var _entity: CharacterBody2D
var _player_controlled:bool = false


func _ready() -> void:
	__ready()

func __ready():
	_entity = get_parent()
	_entity.connect_component($'.')


func _init_component(player_controlled:bool=false):
	_player_controlled = player_controlled
	print("component - ", _get_component_id(), " init'd, belongs to: ", _entity)



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
