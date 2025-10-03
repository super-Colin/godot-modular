extends Node2D # Behavior

enum State { IDLE, PATROL, CHASE }

@export var patrol_points: Array[Vector2] = []
@export var patrol_wait_time: float = 1.0
@export var detection_range: float = 120.0
@export var target_group: String = "Player"

var current_state: State = State.IDLE
var current_patrol_index: int = 0
var wait_timer: float = 0.0
var target: Node2D = null
var body: CharacterBody2D

func _ready() -> void:
	body = get_parent() as CharacterBody2D
	if not body:
		push_warning("BehaviorModule must be a child of a CharacterBody2D")
	enter_state(State.IDLE)

func _physics_process(delta: float) -> void:
	update_state(delta)

#region FSM Logic
func enter_state(new_state: State) -> void:
	exit_state(current_state)
	current_state = new_state
	match current_state:
		State.IDLE:
			wait_timer = patrol_wait_time
		State.PATROL:
			move_to_next_patrol_point()
		State.CHASE:
			pass  # Let chase logic update in update_state()

func exit_state(old_state: State) -> void:
	match old_state:
		State.IDLE:
			pass
		State.PATROL:
			stop_movement()
		State.CHASE:
			stop_movement()

func update_state(delta: float) -> void:
	match current_state:
		State.IDLE:
			update_idle(delta)
		State.PATROL:
			update_patrol(delta)
		State.CHASE:
			update_chase(delta)
#endregion FSM Logic

#region State Updates
func update_idle(delta: float) -> void:
	wait_timer -= delta
	if wait_timer <= 0:
		if patrol_points.size() > 0:
			enter_state(State.PATROL)
		else:
			wait_timer = patrol_wait_time  # Loop idle if no patrol

func update_patrol(delta: float) -> void:
	if patrol_points.size() == 0:
		enter_state(State.IDLE)
		return
	var dist = body.global_position.distance_to(patrol_points[current_patrol_index])
	if dist < 4.0:
		current_patrol_index = (current_patrol_index + 1) % patrol_points.size()
		enter_state(State.IDLE)
	check_for_target()

func update_chase(delta: float) -> void:
	if not is_instance_valid(target):
		enter_state(State.IDLE)
		return
	var dist = body.global_position.distance_to(target.global_position)
	if dist > detection_range * 1.5:
		enter_state(State.IDLE)
		return
	move_to_point(target.global_position)
#endregion State Updates

#region Transitions
func check_for_target() -> void:
	for node in get_tree().get_nodes_in_group(target_group):
		if node is Node2D and body.global_position.distance_to(node.global_position) <= detection_range:
			target = node
			enter_state(State.CHASE)
			break
#endregion

#region Movement Helpers
func move_to_point(pos: Vector2) -> void:
	$"../Movement".move_towards(pos)

func stop_movement() -> void:
	$"../Movement".stop()

func move_to_next_patrol_point() -> void:
	if patrol_points.size() == 0:
		return
	move_to_point(patrol_points[current_patrol_index])
#endregion















#
##region Enums
#
#enum Behaviors {
	#BASIC,
	#SWEEP,
	#WANDER, 
#}
#
##enum Intentions {
	###PATROL, 
	##SEEK, 
	##CHASE, 
	##MOVE_FOWARD, 
	###SAY_HELLO, 
	###SPEAK, 
	###SWEEP
##}
#
##endregion Enums
#
#
#@export var defaultBehavior: Behaviors = Behaviors.BASIC
## Will it attempt to attack it's target?
@export var isHostile: bool = true
## What groups are it's targets?
@export var targetGroups:Array[String] = ["Player", "Food"]
## Range the creature can confirm a sighting of something
@export var visionRange: float = 800.0
@export var visionAngle: float = 120.0
## How close something can be before it attacks
@export var aggroRange: float = 600.0
## Range that the creature will keep track of target through walls
@export var memoryRange: float = 1000.0
### Range that the creature will stop or not care about a target
@export var dontCareRange: float = 1500.0
#
#
##var currentIntention = Intentions.MOVE_FOWARD
#var currentTargetNode:Node2D
#var currentPointOfInterest:Vector2
#var targetSighted:bool=false
#
#
#func forgetTarget():
	#currentTargetNode = null
#
#func getPOI(entity: CharacterBody2D)->Vector2:
	##if not currentTargetNode or not isValidTargetNode(currentTargetNode):
	#if not currentTargetNode:
		#findNewTargetNode(entity)
	## check is still valid
	#else:
		## update position
		#currentPointOfInterest = currentTargetNode.global_position - entity.global_position
		#if tooFarToCare(currentPointOfInterest.length()):
			#currentPointOfInterest = Vector2.ZERO
	#return currentPointOfInterest
#
#
#func findNewTargetNode(entity: CharacterBody2D, index = 0): 
	## index in case one isn't possible for some reason
	#var targets = getTargetNodes()
	#if targets.size() > index:
		#currentTargetNode = targets[index]
		#currentPointOfInterest = currentTargetNode.global_position - entity.global_position
		#print("behavior - found new target node: ", currentTargetNode, ", as POI: ", currentPointOfInterest)
	#else:
		#currentPointOfInterest = Vector2.ZERO
#
#
#
#
#func getTargetGroups():
	#return targetGroups
#
#func getCurrentTarget():
	#return currentTargetNode
#
#
#func getTargetNodes()->Array:
	#var targets = []
	#for group in targetGroups:
		#targets.append_array(get_tree().get_nodes_in_group(group))
	#return targets
#
#
#
#
#func findNewPOI(entity: CharacterBody2D):
	#var targets = getTargetNodes()
	#if targets.size() > 0:
		#currentPointOfInterest = targets[0].global_position - entity.global_position
	#else:
		#currentPointOfInterest = Vector2(50,0) * entity.getFacingDirection()
	#return currentPointOfInterest
#
#
#func getBehavior():
	#return defaultBehavior
#
#
#
#
##region Environment Awareness
#
#func tooFarToCare(distance):
	#return distance > dontCareRange
#
#func canSeeNode(entity: CharacterBody2D, node:Node) -> bool:
	#if not node:
		#return false
	#var toNodeVector = node.global_position - global_position
	#var distance = toNodeVector.length()
	#if distance > visionRange:
		#return false
	## Check angle between enemy's "facing direction" and the vector to the player
	#var angle = rad_to_deg(entity.getFacingDirection().angle_to(toNodeVector.normalized()))
	#if abs(angle) > visionAngle / 2.0:
		#return false
	## check it's not too far to see
	## then check nothing is block LOS
	## Line-of-sight check using RayCast2D
	#if has_node("LineOfSightRay"):
		#var ray = $LineOfSightRay
		#ray.target_position = toNodeVector
		#ray.force_raycast_update()
		#if ray.is_colliding():
			#print("behavior - ray is colliding: ", ray.get_collider())
			##var collider = ray.get_collider()
			#if ray.get_collider() == node:
				#return true
		#else:
			#return true
	#return false
#
#
#
##endregion Environment Awareness
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
#
##
