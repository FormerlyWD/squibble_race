extends CharacterBody2D

@export var strength:float = 3
@onready var applied_force:float = 0
@onready var force_modifier:float = 5
@onready var obstacle_type:String
@onready var label:String = "obstacle"

enum State {
	THROWN,
	STATIC
}
@onready var current_s:State = State.STATIC

func _ready() -> void:
	pass
	
func throw():
	current_s = State.THROWN


func reset_properties():
	current_s = State.STATIC
	applied_force = 0
	force_modifier = 5
	pass
func _physics_process(delta: float) -> void:
	if current_s == State.STATIC:
		pass
	elif current_s == State.THROWN:
		
		if applied_force == 0:
			reset_properties()
			return
		
		velocity = applied_force*Vector2(1,2)*force_modifier
		if applied_force<0.0001:
			applied_force = 0
		else:
			applied_force -= applied_force/10
	move_and_slide()
		
