@tool
class_name BehaviorComponent2D
extends ComponentNode2D


#region Component Contracts
var velocity_influence: Vector2 = Vector2.ZERO # Used by parent entity to add influence

#endregion Component Contracts


#region Exports
## Will it attempt to attack any of it's targets?
@export var is_hostile: bool = true

## Will try to chase after any targets it becomes aware of
@export var auto_aggro:  bool = true
## Always try to attack when an attackable target is in range
@export var auto_attack: bool = true
## Range that the creature will keep track of target through walls
@export_group("Awareness")
## Any entity in this range will be detected immediately
@export var alert_range: float = 150.0
## Aquired target must get this far to escape targeting
@export var forget_range: float = 500.0

@export_group("Targets")
## What groups will it target
@export var target_groups:Array[Modular.Types] = []
@export var primary_target_group:Modular.Types
## Will it actively seek out targets
@export var hunts_for_targets: bool = true



@export_group("Vision")
@export var sighted:bool = true
## Range the creature can confirm a sighting of something
@export var vision_range: float = 300.0
@export var vision_angle: float = 120.0

#endregion Exports

#region Signals
signal s_trigger_attack
signal s_target_moved
signal s_target_changed
#endregion Signals

#region Internal State
var has_target:bool = false
var target_entity:Node2D
#endregion Internal State



#region Editor Updates
@export_group("Editor Updates")
## Update in editor to reflect export settings
@export_tool_button("Editor Updates") var update_editor = _update_with_editor_settings

func _update_with_editor_settings():
	$Alert/CollisionShape2D.shape.radius = alert_range
	$Forget/CollisionShape2D.shape.radius = forget_range
	$LineOfSightRay.target_position.x = vision_range
	$TargetMarker.position.x = vision_range
	update_sight_cone()

func update_sight_cone():
	var half_angle := deg_to_rad(vision_angle) / 2.0
	var height := tan(half_angle) * vision_range
	$Sight/CollisionPolygon2D.polygon[1] = Vector2(vision_range, -height)
	$Sight/CollisionPolygon2D.polygon[2] = Vector2(vision_range, height)
#endregion Editor Updates




func _ready() -> void:
	if Engine.is_editor_hint():
		return
	_update_with_editor_settings()
	__ready()


func tick_process(delta):
	if not has_target:
		find_new_target()





func find_new_target():
	var targets = []
	for type in target_groups:
		targets.append_array(get_tree().get_nodes_in_group(Modular.Groups[type]))
	if not targets.size() > 0:
		return
	#print("behavior - targets: ", targets)
	if is_entity_in_sight(targets[0]):
		change_target(targets[0])
		print("behavior - found target: ", target_entity)


func is_entity_in_sight(entity:Node2D): # Double check collision layers if not working
	#print("behavior - $Sight.overlaps_body(entity): ", entity, ", ", $Sight.overlaps_body(entity))
	if $Sight.overlaps_body(entity):
	#if $Sight.overlaps_area(entity):
		return true
	return false



func _health_area_entered_damage_area(area):
	print("behavior - health area entered: ", area)
	s_trigger_attack.emit()



func change_target(entity:Node2D):
	target_entity = entity
	has_target = true
	s_target_changed.emit(target_entity)




#@export var debug_behavior:bool = false # Useful for debugging
#
### Array to store available behaviors with weights.
### Each entry is a Dictionary {name: String, weight: float}
#var behaviors: Array[Dictionary] = [] 
#var current_behavior: String = ""




#
##region Utility AI Helper Functions
#func calculate_total_weight() -> float:
	#var total_weight = 0.0
	#for behavior in behaviors:
		#total_weight += behavior.weight
	#return total_weight
#
#func choose_behavior() -> String:
	#var total_weight = calculate_total_weight()
	#var random_value = randf_range(0.0, total_weight)
	#var cumulative_weight = 0.0
#
	#for behavior in behaviors:
		#cumulative_weight += behavior.weight
		#if random_value <= cumulative_value:
			#return behavior.name
	#return "" # Should never happen, but return something to avoid errors.
##endregion Utility AI Helper Functions
#
##region Public Functions
#func add_behavior(name: String, weight: float) -> void:
	#behaviors.append({"name": name, "weight": weight})
	#if debug_behavior:
		#print("Added behavior: " + name + " with weight: " + str(weight))
	#
#func remove_behavior(name: String) -> void:
	#var index_to_remove = -1
	#for i in range(behaviors.size()):
		#if behaviors[i].name == name:
			#index_to_remove = i
			#break
	#
	#if index_to_remove != -1:
		#behaviors.remove_at(index_to_remove)
		#if debug_behavior:
			#print("Removed behavior: " + name)
	#else:
		#print("Behavior not found: " + name)
#
#func get_next_behavior() -> String:
	#if behaviors.is_empty():
		#return ""
	#return choose_behavior()
#
#func clear_behaviors() -> void:
	#behaviors.clear()
##endregion Public Functions
