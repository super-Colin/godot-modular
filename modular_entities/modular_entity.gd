class_name ModularEntity2D
extends CharacterBody2D
## !!! TODO's to work with this:
## Name your Spite2D "Sprite" in the tree


@onready var debug_string = "Entity: " + entity_type_name + " - "

#region Exports
@export var entity_type_name:String = "Fish"
@export var player_controlled:bool = false
@export var sprite_faces_left:bool = false
@export var entity_base_type:Modular.EntityTypes = Modular.EntityTypes.CREATURE
@export var entity_subtypes:Array[Modular.EntityTypes] = []
#endregion Exports


## This will hold references to the actual nodes
## Component nodes will register themselves in their _ready()
var components: Dictionary = {}




func _ready() -> void:
	__ready() # if _ready is overwritten be sure to call __ready in it


func __ready() -> void:
	for key in components.keys():
		components[key].init_component(player_controlled)
	add_self_to_groups()
	if not player_controlled:
		connect_component_signals()
	if not entity_subtypes.has(entity_base_type):
		entity_subtypes.append(entity_base_type)
	for group in entity_subtypes:
		Modular.set_collision_layer($'.', entity_base_type)
		# TODO, this may need to be replaced. Sum the total and convert to a bit mask???
	print(debug_string, "components: ", components)


func _process(delta: float) -> void:
	for key in components.keys():
		components[key].tick_process(delta)



func _physics_process(delta: float) -> void:
	for key in components.keys():
		if components[key].has_method("tick_physics"):
			components[key].tick_physics(delta)
		add_veloctiy_influence(components[key])
	move_and_slide()




func add_self_to_groups():
	for group in entity_subtypes:
		print("entity ", entity_type_name, ", - group", group)
	$'.'.is_in_modular_group(Modular.EntityTypes.CREATURE)

func is_in_modular_group(group_type:Modular.EntityTypes):
	return $'.'.is_in_group(Modular.Groups[group_type])




#region Component Setup
func connect_component_signals():
	var movement: MovementComponent2D
	var health: Component2DHealth
	var damage: DamageComponent2D
	var behavior: BehaviorComponent2D
	# Sort out components
	for key in components:
		if components[key] is MovementComponent2D:
			movement = components[key]
		elif components[key] is Component2DHealth:
			health = components[key]
		elif components[key] is DamageComponent2D:
			damage = components[key]
		elif components[key] is BehaviorComponent2D:
			behavior = components[key]
	# Connect signals
	if health:
		health.s_died.connect(died)
	#if movement:
		#movement.s_movement_direction_changed.connect(face_direction)
	if behavior:
		if damage:
			damage.s_health_area_entered.connect(behavior._health_area_entered_damage_area)
			behavior.s_trigger_attack.connect(damage.attack)
		if movement:
			behavior.s_target_updated.connect(movement.update_target)
			behavior.s_move_forward.connect(movement._move_forward)
			#behavior.s_turn_around.connect(movement._turn_around)
			behavior.s_turn_around.connect(_turn_around)
			#behavior.s_target_changed.connect(movement.update_target)
			behavior.s_jump_forward.connect(movement._jump_requested)

func get_component(name:String):
	if components.has(name):
		return components[name]
#endregion Component Setup

#region Component Contracts
func connect_component(component):
	components[component._get_component_id()] = component

func add_veloctiy_influence(component):
	if "velocity_influence" in component:
		velocity += component.velocity_influence

#endregion Component Contracts

#region Health Related
func died(destroy:bool=true):
	if destroy:
		$'.'.queue_free()

func _health_area_entered(area):
	if area:
		print("entity ", entity_type_name, ", - health area entered")

#endregion Health Related


#region Movement Related
#var facing_direction:Vector2 = Vector2.RIGHT
var facing_direction:Vector2 = Vector2.LEFT if sprite_faces_left else Vector2.RIGHT

func _turn_around():
	#print("entity ", entity_type_name, ", - turning around")
	face_direction(facing_direction * -1)

func face_direction(direction:Vector2):
	#print("entity ", entity_type_name, ", - facing direction: ", direction)
	facing_direction = direction
	if direction.x >= 0:
		face_right()
	else: 
		face_left()

func face_left():
	#print("entity ", entity_type_name, ", - facing left, frame: ", Engine.get_frames_drawn())
	#print("entity ", entity_type_name, ", - position is: ", position)
	if $'.'.has_node("Sprite"):
		#$Sprite.flip_h = true
		$Sprite.flip_h = false if sprite_faces_left else true
	for key in components.keys():
		# TODO update to face_left in components
		if components[key].has_method("face_left"): 
			components[key].face_left()



func face_right():
	if $'.'.has_node("Sprite"):
		#$Sprite.flip_h = false
		$Sprite.flip_h = true if sprite_faces_left else false
		
	for key in components.keys():
		if components[key].has_method("face_right"): 
			components[key].face_right()

#endregion Movement Related











#
## Base class for modular 2D game entities that can function as creatures or scenery
## Child components are configured through node setup and signals
#

#func make_player_controlled():
	## Set up player input handling
	#Input.set_use_accumulated_input(true)
	## TODO: Implement input mapping system for different control schemes
#
#func make_breakable():
	## Configure entity to be breakable
	## TODO: Set up break effects, particle systems, or destruction logic
	#pass
#
