extends Node


#region Exports

## Applies gravity to parents velocity without parent needing to invoke it. Useful for things that don't need anykind of behavior
@export var autoGravity:bool = false
@export var gravityScale:float = 1.0
@export var maxFallSpeed:float = 200.0

#endregion Exports



func _ready() -> void:
	return

func _physics_process(delta: float) -> void:
	#return
	if autoGravity:
		var theThing = get_parent()
		#var theThing:CharacterBody2D = get_parent()
		applyGravity(theThing, delta)
		theThing.move_and_slide()


func applyGravity(entity: CharacterBody2D, delta: float) -> void:
	if entity.is_on_floor():
		return
	var gravVector: Vector2 = entity.get_gravity()
	entity.velocity += gravVector * gravityScale * delta
	# Clamp velocity in gravity direction
	#var gravSpeed = entity.velocity.dot(gravVector.normalized())
	#if gravSpeed > maxFallSpeed:
		#entity.velocity -= gravVector.normalized() * (gravSpeed + maxFallSpeed)









#
