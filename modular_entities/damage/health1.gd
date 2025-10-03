extends Area2D # Health (and Hitbox)

#region Exports
@export var max_health: int = 100
@export var destroy_on_death: bool = false
@export var invulnerable: bool = false
#endregion Exports

#region Signals
signal health_changed(current, max)
signal damaged(amount)
signal died
#endregion Signals

#region Internal-Variables
var current_health: int
var dead: bool = false
#endregion Internal-Variables


func _ready() -> void:
	current_health = max_health


func take_damage(amount: int) -> void:
	if invulnerable:
		return
	current_health -= amount
	damaged.emit(amount)
	health_changed.emit(current_health, max_health)
	if current_health <= 0:
		die()

func heal(amount: int) -> void:
	current_health = clamp(current_health + amount, 0, max_health)
	health_changed.emit(current_health, max_health)

func die() -> void:
	died.emit()
	if destroy_on_death:
		queue_free()





##func takeDamage(amount: int) -> void:
#func takeDamageFromSource(source:Node) -> void:
	#takeDamage(source.damageAmount)
	##source.damageFeedback($'.')


#func takeDamage(amount: int, source: Node = null) -> void:
	#if isDead():
		#return
	#var finalDamage = max(amount - defense, 0)
	#currentHealth = max(currentHealth - finalDamage, 0)
	#emit_signal("tookDamage", finalDamage, source)
	#emit_signal("healthChanged", currentHealth, maxHealth)
	#if currentHealth <= 0:
		#emit_signal("died")

#func heal(amount: int) -> void:
	#if isDead():
		#return
	#currentHealth = min(currentHealth + amount, maxHealth)
	#emit_signal("healthChanged", currentHealth, maxHealth)

#func isDead() -> bool:
	#return currentHealth <= 0






#
