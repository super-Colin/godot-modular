class_name ModularEntity2D
extends CharacterBody2D



#region Exports
@export var player_controlled:bool = false
@export var groups:Array[Modular.Types] = []
#endregion Exports



var components: Dictionary = {}



func add_self_to_groups():
	for group in groups:
		print("group - ", group)
	$'.'.is_in_modular_group(Modular.Types.CREATURE)

func is_in_modular_group(group_type:Modular.Types):
	return $'.'.is_in_group(Modular.Groups[group_type])


func _ready() -> void:
	__ready() # if _ready is overwritten be sure to call __ready in it

func __ready() -> void:
	for key in components.keys():
		components[key].init_component(player_controlled)
	add_self_to_groups()
	connect_component_signals()
	print("entity - componets: ", components)


func _process(delta: float) -> void:
	for key in components.keys():
		#print("entity - _process key: ", key, ", node: ", components[key])
		components[key].tick_process(delta)


func _physics_process(delta: float) -> void:
	for key in components.keys():
		components[key].tick_physics(delta)
	for key in components.keys():
		add_veloctiy_influence(components[key])
	move_and_slide()



#region Component Setup
func connect_component_signals():
	var movement: MovementComponent2D
	var health: HealthComponent2D
	var damage: DamageComponent2D
	var behavior: BehaviorComponent2D
	# Sort out components
	for key in components:
		if components[key] is MovementComponent2D:
			movement = components[key]
		elif components[key] is HealthComponent2D:
			health = components[key]
		elif components[key] is DamageComponent2D:
			damage = components[key]
		elif components[key] is BehaviorComponent2D:
			behavior = components[key]
	# Connect signals
	if health:
		health.s_died.connect(died)
	if movement:
		movement.s_movement_direction_changed.connect(face_direction)
	if behavior:
		if damage:
			damage.s_health_area_entered.connect(behavior._health_area_entered_damage_area)
			behavior.s_trigger_attack.connect(damage.attack)
		if movement:
			behavior.s_target_moved.connect(movement.update_target)
			#behavior.s_target_changed.connect(movement.update_target)
			
#endregion Component Setup


#region Component
func add_veloctiy_influence(component):
	if "velocity_influence" in component:
		velocity += component.velocity_influence

#endregion Component


#region Component Contracts
func connect_component(component):
	components[component._get_component_id()] = component

#endregion Component Contracts


#region Health Related
func died(destroy:bool=true):
	if destroy:
		$'.'.queue_free()

func _health_area_entered(area):
	if area:
		print("health area entered")

#endregion Health Related


#region Movement Related
func face_direction(direction:Vector2):
	if direction.x >= 0:
		face_right()
	else: 
		face_left()

func face_left():
	for key in components.keys():
		if components[key].has_method("face_left"): components[key].face_left()
	if $'.'.has_node("Sprite"):
		$Sprite.flip_h = true


func face_right():
	for key in components.keys():
		if components[key].has_method("face_right"): components[key].face_right()
	if $'.'.has_node("Sprite"):
		$Sprite.flip_h = false

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
#func _physics_process(delta):
	## Main physics update loop
	#if can_move:
		#handle_movement(delta)
	#
	## Update AI if not player controlled
	#if not is_player_controlled and ai_component:
		#ai_component.update_ai(delta)
#
#func handle_movement(delta):
	## Apply gravity
	#velocity.y += gravity * delta
	#
	## Handle horizontal movement
	#if is_player_controlled:
		#handle_player_input()
	#else:
		## Use component-based movement if available
		#if movement_component:
			#movement_component.apply_movement(velocity, delta)
	#
	## Move the entity
	#move_and_slide()
#
#func handle_player_input():
	## Handle player input for movement
	#var direction = Input.get_axis("move_left", "move_right")
	#velocity.x = direction * move_speed
	#
	## Handle jumping
	#if Input.is_action_just_pressed("jump") and is_on_floor():
		#jump()
#
#func jump():
	## Make entity jump if on ground
	#if is_on_floor():
		#velocity.y = jump_speed
#
#func _on_damage_taken(damage_amount):
	## Handle damage received
	## TODO: Add visual feedback or hit effects
	#pass
#
#func _on_health_depleted():
	## Handle death/destruction
	#if is_breakable:
		#break_entity()
	#else:
		#queue_free()
#
#func break_entity():
	## Break the entity into pieces or remove it
	## TODO: Implement destruction effects, particle systems, or drop items
	#queue_free()
