class_name DamageComponent2D
extends ComponentArea2D

## This area will function as a hurt box for a single attack
## each attack / animation should have it's own Damage component
## It can apply damage to a corresponding Health Component

#region Component Contracts
var velocity_influence: Vector2 = Vector2.ZERO # Used by parent entity to add influence
#endregion Component Contracts




#region Exports
@export var active_time = 0.5
@export var damage_amount = 10.0
@export var knockback_amount = 0.0
@export var cooldown = 1.0
#@export var status_effects = []
@export_group("Player Controlled")
@export var input_name = "" # example: "light attack"
#endregion Exports


#region Signals
signal s_health_area_entered(health_area)
signal s_attack_started
signal s_attack_ended
signal s_attackCooldownFinished
#endregion Signals



#region Internal State
var can_attack = true
var is_attacking = false
#var attack_active_time = 0.0
var health_areas_inside: Array[HealthComponent2D] = []
@onready var attackId = randi()
#endregion Internal State


func _ready() -> void:
	__ready()
	area_entered.connect(_area_entered)
	area_exited.connect(_area_exited)




## Called in the parent modular entity's _ready() function
func init_component(player_controlled:bool=false):
	_init_component(player_controlled)


func tick_physics(_delta: float) -> void:
	if _player_controlled:
		if Input.is_action_just_pressed(input_name):
			#print("damage - pressed attack...")
			attack()


func attack():
	if not can_attack or is_attacking:
		return
	print("damage - attacking")
	is_attacking = true
	s_attack_started.emit()
	for health_area in health_areas_inside:
		health_area.take_hit($'.')
	get_tree().create_timer(active_time).timeout.connect(attack_done)
	get_tree().create_timer(cooldown).timeout.connect(cooldownDone)

func attack_done():
	is_attacking = false
	s_attack_ended.emit()
	print("damage - attack done")


func _area_entered(area):
	#if area.has_method("takeDamageFromSource"):
	if area is HealthComponent2D:
		s_health_area_entered.emit(area)
		health_areas_inside.append(area)
		if is_attacking:
			area.take_hit($'.')
		#area.takeDamageFromSource($'.')

func _area_exited(area):
	#if health_areas_inside.has(area):
	health_areas_inside.erase(area)




func attack_health_area(healthArea):
	if healthArea.has_method("takeDamageFromSource"):
		healthArea.takeDamageFromSource($'.')
		can_attack = false

func cooldownDone():
	can_attack = true
	s_attackCooldownFinished.emit()



















#
