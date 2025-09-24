extends CharacterBody2D






func _ready() -> void:
	if has_node("Health"):
		setupHealth()



#region Health
func setupHealth():
	$Health.died.connect(_died)

func _died():
	$'.'.queue_free()

#endregion Health




func setupInteractable():
	print("item - setup interactable")
	$Interactable.interactionCallable

func itemIsHeal():
	$Interactable.interactionCallable
	return








#
