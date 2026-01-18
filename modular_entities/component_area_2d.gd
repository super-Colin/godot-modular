class_name ComponentArea2D
extends Area2D



var _parent_modular_entity: ModularEntity2D
var _collision_shape: CollisionShape2D
var _collision_starting_position: Vector2
var _player_controlled: bool = false


func _ready() -> void:
	__ready()

func __ready():
	var _parent = get_parent()
	if _parent.has_method("connect_component"):
		_parent_modular_entity = _parent
	_collision_shape = get_node("CollisionShape2D")
	if not _collision_shape:
		printerr("Component Area Base - ", _get_component_id(), " can't find collision shape")
		return
	_collision_starting_position = _collision_shape.position
	_parent_modular_entity.connect_component($'.')

func init_component(player_controlled:bool=false):
	_init_component(player_controlled)
func _init_component(player_controlled:bool=false):
	_player_controlled = player_controlled
	print("Component Area - ", _get_component_id(), " init'd, belongs to: ", _parent_modular_entity)


func tick_process(_delta: float) -> void:
	pass

func tick_physics(_delta: float) -> void:
	pass


func face_left(): # Overwrite in component if extra functionality required
	_face_left()
func _face_left():
	_collision_shape.position.x = abs(_collision_shape.position.x) * -1

func face_right():
	_face_right()
func _face_right():
	_collision_shape.position.x = abs(_collision_shape.position.x)


func get_veloctiy_influence()->Vector2:
	return Vector2.ZERO


func _get_component_id() -> String:
	return name.to_lower()












#
