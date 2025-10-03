class_name BehaviorComponent2D
extends ComponentNode2D


#region Component Contracts
var velocity_influence: Vector2 = Vector2.ZERO # Used by parent entity to add influence

#endregion Component Contracts


#region Exports
## Will it attempt to attack it's targets?
@export var is_hostile: bool = true

## How close something can be before it attacks
@export var attacks_in_range: bool = true
@export var aggroRange: float = 600.0
## Range that the creature will keep track of target through walls
@export_group("Memory")
## Aquired target must get this far to escape targeting
@export var memoryRange: float = 1500.0
### Range that the creature will stop or not care about a target
@export var dontCareRange: float = 2500.0

@export_group("Targets")
## What groups will it target
@export var targetGroups:Array[String] = ["Player", "Creature_Small", "Food_Fruit"]
## Will it actively seek out targets
@export var hunts_for_targets: bool = true

@export_group("Vision")
@export var sighted:bool = true
## Range the creature can confirm a sighting of something
@export var vision_range: float = 800.0
@export var vision_angle: float = 120.0

#endregion Exports



#region Signals
signal s_trigger_attack
signal s_target_moved
#endregion Signals







func _health_area_entered_damage_area(area):
	print("behavior - health area entered: ", area)
	s_trigger_attack.emit()














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
