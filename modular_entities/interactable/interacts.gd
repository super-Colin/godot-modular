extends Area2D



#region Exports
@export var autoInteract = false
@export var cooldown = 1.0
#endregion Exports


#region Signals
signal s_interactableAreaEntered(interactableArea)
signal s_startedInteraction
signal s_cooldownFinished
#endregion Signals

#region Internal State
var interactable_area
#endregion Internal State

func _ready() -> void:
	area_entered.connect(_areaEntered)


func _areaEntered(area):
	#print("damage - area entered: ", area)
	if area.has_method("_interact_with"):
		s_interactableAreaEntered.emit(area)
		#area.takeDamageFromSource($'.')

func interact_with(interactableArea):
	if interactableArea.has_method("_interact_with"):
		interactableArea.takeDamageFromSource($'.')
		var timer = get_tree().create_timer(cooldown).timeout.connect(cooldownDone)

func cooldownDone():
	s_cooldownFinished.emit()





















#
