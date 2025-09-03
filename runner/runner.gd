extends CharacterBody2D


@export var runner_name:String = "e"
@export var appearance_data:Dictionary
@export var acceleration:float = 5
@export var quadratic_acceleration:float = 0
@export var speed:float = 0.1
@export var strength:float = 50
@export var recovery_speed_reduction:float = 2

@export var collision_strength:float = 4
@export var weaknesses:Array = [
]
@export var resistance:Array = [
]
@export var abillities:Dictionary = {
	"ball fetcher":"base"
}
@export var health:int
@onready var variance
@onready var pixel_to_feet:float = 2.5/14
@onready var applied_force:float

@onready var label:String = "character"
var distance_reached:float
var runner_order:int = 0
var reached_the_end:bool = false
enum MovingState {
	NULL,
	FALLING,
	RUNNING
}
@onready var current_s:MovingState = MovingState.NULL

func _ready() -> void:
	start_moving()
func start_moving():
	current_s = MovingState.RUNNING
	$facemovement.play("move")

func start_falling():
	
	current_s = MovingState.FALLING
	$facemovement.play("fall")
	var recovery:SceneTreeTimer = get_tree().create_timer((applied_force/5)-recovery_speed_reduction)
	await recovery.timeout
	start_moving()

func _physics_process(delta: float) -> void:
	if current_s == MovingState.RUNNING:
		var initial_acceleration = acceleration
		
		acceleration += quadratic_acceleration*delta
		speed += acceleration * delta
		velocity.x = speed
		var speed_scale:float = velocity.length()  / (14.0/0.6)
		if speed_scale <0 or speed_scale ==0:
			$facemovement.speed_scale = 0.1
		else:
			$facemovement.speed_scale = speed_scale
	elif current_s == MovingState.FALLING:
		
		if speed<0.001:
			speed = 0
		else:
			speed -= speed/10
		
		velocity.x = speed
		if current_s == MovingState.FALLING:
			velocity.y = speed*2
			
	if (position.x > ref.spawn_obstacles.ending_line or position.x == ref.spawn_obstacles.ending_line) and not reached_the_end:
		reached_the_end = true
		ref.signal_win.emit_signal("reached_end",runner_name)
	
	if not runner_order == 0 and not reached_the_end:
		ref.UI_run[runner_order-1].text = str(round(position.x *pixel_to_feet)) + " " + "Ft."
	move_and_slide()
	
	
