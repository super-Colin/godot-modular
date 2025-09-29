class_name ComponentArea2D
extends Area2D



var _entity: CharacterBody2D
var _collision_shape: CollisionShape2D
var _collision_starting_position: Vector2
var _player_controlled: bool = false


func _ready() -> void:
	__ready()

func __ready():
	_entity = get_parent()
	_collision_shape = get_node("CollisionShape2D")
	if not _collision_shape:
		push_error("Component Area - ", _get_component_id(), " can't find collision shape")
		return
	_collision_starting_position = _collision_shape.position
	_entity.connect_component($'.')


func _init_component(player_controlled:bool=false):
	_player_controlled = player_controlled
	print("Component Area - ", _get_component_id(), " init'd, belongs to: ", _entity)


func tick_process(_delta: float) -> void:
	pass


func tick_physics(_delta: float) -> void:
	pass


func face_left():
	_collision_shape.position.x = abs(_collision_shape.position.x) * -1

func face_right():
	_collision_shape.position.x = abs(_collision_shape.position.x)


func get_veloctiy_influence()->Vector2:
	return Vector2.ZERO


func _get_component_id() -> String:
	return name.to_lower()












#
