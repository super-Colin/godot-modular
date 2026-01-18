extends Area2D

@export var interaction_function:Interactions.Types
@export var interaction_strengh:float = 1.0



var interactionCallable:Callable
#var interactionCallable



func interaction(interactingBody):
	print("interactable - interactingBody: ", interactingBody)
	if interactionCallable:
		interactionCallable.call()
		$'.'.queue_free()



















#
