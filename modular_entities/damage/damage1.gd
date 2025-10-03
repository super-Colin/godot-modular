extends Area2D
## This area will function as a hurt box for a single attack
## each attack / animation should have it's own Damage area
## 
## It can apply damage to a corresponding Health area


#region Exports
#@export var autoDamage = false
@export var cooldown = 1.0
@export var activeTime = 0.5
@export var damageAmount = 10.0
#endregion Exports


#region Signals
signal s_healthAreaEntered(healthArea)
signal s_startedAttack
signal s_attackCooldownFinished
#endregion Signals

var canAttack = true
var isAttacking = false
@onready var attackId = randi()

func _ready() -> void:
	area_entered.connect(_areaEntered)


func _areaEntered(area):
	#print("damage - area entered: ", area)
	if area.has_method("takeDamageFromSource"):
		s_healthAreaEntered.emit(area)
		#area.takeDamageFromSource($'.')

func attackHealthArea(healthArea):
	if healthArea.has_method("takeDamageFromSource"):
		healthArea.takeDamageFromSource($'.')
		canAttack = false
		var timer = get_tree().create_timer(cooldown).timeout.connect(cooldownDone)

func cooldownDone():
	canAttack = true
	s_attackCooldownFinished.emit()

func player_control(entity:CharacterBody2D, delta:float):
	# run each frame
	#print("damage - ")
	#Input.is_action_just_pressed("Attack")
	return

















#
