class_name HealthComponent2D
extends ComponentArea2D




#region Component Contracts
var velocity_influence: Vector2 = Vector2.ZERO # Used by parent entity to add influence
#endregion Component Contracts


#region Exports
@export var max_health: int = 100
@export var destroy_on_death: bool = false
@export_group("Invulnerability")
@export var invulnerable_always: bool = false
@export var invulnerable_on_hit: bool = true
@export var invulnerable_on_hit_length: float = 0.5
#endregion Exports

#region Signals
signal s_health_changed(previous:float, new:float)
signal s_damaged(amount:float)
signal s_died(destroy:bool)
#endregion Signals

#region Internal State
@onready var current_health: float = max_health
var dead: bool = false
var invulnerable: bool = false
#endregion Internal State


#func _ready() -> void:
	#__ready()
	#area_entered.connect(_area_entered)
	#area_exited.connect(_area_exited)

## Called in the parent modular entity's _ready() function
func init_component(player_controlled:bool=false):
	_init_component(player_controlled)
	collision_layer






#func tick_physics(delta: float) -> void:
	#_tick_physics(delta)
	#pass





func take_hit(damage_source:DamageComponent2D): # Component Contract
	print("Health - taking hit: ", damage_source)
	if invulnerable:
		return
	#velocity_influence from knockback?
	var new_health = current_health - damage_source.damage_amount
	s_damaged.emit(damage_source.damage_amount)
	s_health_changed.emit(current_health, new_health)
	current_health = new_health
	if current_health <= 0.0:
		s_died.emit(destroy_on_death)
	if invulnerable_on_hit:
		invulnerable = true
		get_tree().create_timer(invulnerable_on_hit_length).timeout.connect(func():invulnerable = false)









#
##region Core Properties
#@export var max_health: int = 100
#@export var destroy_on_death: bool = false
#@export var invulnerable: bool = false
##endregion Core Properties
#
##region Signals
#signal health_changed(current, max)
#signal damaged(amount)
#signal died
##endregion Signals
#
##region Internal State
#var current_health: int
#var dead: bool = false
##endregion Internal State
#
#
#

#
#
##region Healing Functions
#func heal(amount:int)->bool:
	## Check if the object is already dead. If so, healing won't do anything.
	#if dead:
		#print("Cannot heal a dead object.")
		#return false
	## Increase the current health.  This is the core healing action.
	#current_health = min(current_health + amount, max_health) # Cap at max_health
	## Emit a signal to notify that the health has changed.  This is useful for UI updates etc.
	#emit_signal("health_changed", current_health, max_health)
	## Optionally, you could add visual or audio feedback here.
	## For example, play a healing animation or sound effect.
	#return true # Indicate that the healing was successful.
##endregion Healing Functions











#func heal(amount:int)->bool:
	#return true








#extends Area2D # Health (and Hitbox)
#
#@export var max_health: int = 100
#@export var destroy_on_death: bool = false
#@export var invulnerable: bool = false
#
#signal health_changed(current, max)
#signal damaged(amount)
#signal died
#
#var current_health: int
#var dead: bool = false


#Group things like exports, related variables, and signals together and add "#region {group_name}" above each group and "#endregion {group_name}" below each group:











#
##region Exports
#@export var max_health: int = 100
#@export var destroy_on_death: bool = false
#@export var invulnerable: bool = false
##endregion Exports

##region Signals
#signal health_changed(current, max)
#signal damaged(amount)
#signal died
##endregion Signals
#
##region Internal-Variables
#var current_health: int
#var dead: bool = false
##endregion Internal-Variables
#
#
#func _ready() -> void:
	#current_health = max_health
#
#
#func take_damage(amount: int) -> void:
	#if invulnerable:
		#return
	#current_health -= amount
	#damaged.emit(amount)
	#health_changed.emit(current_health, max_health)
	#if current_health <= 0:
		#die()
#
#func heal(amount: int) -> void:
	#current_health = clamp(current_health + amount, 0, max_health)
	#health_changed.emit(current_health, max_health)
#
#func die() -> void:
	#died.emit()
	#if destroy_on_death:
		#queue_free()
#





#
