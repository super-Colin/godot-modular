#extends Area2D
class_name InteractsComponent2D
extends ComponentArea2D


#region Exports
@export var autoInteract = false
@export var cooldown = 1.0 # (In seconds) before being able to interact again
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
	if area.has_method("interaction"):
		s_interactableAreaEntered.emit(area)
		area.interaction($'.')

func interact_with(interactableArea):
	if interactableArea.has_method("_interact_with"):
		interactableArea._interact_with($'.')
		var timer = get_tree().create_timer(cooldown).timeout.connect(cooldownDone)

func cooldownDone():
	s_cooldownFinished.emit()


#func tick


















#
