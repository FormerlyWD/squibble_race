extends Resource
class_name effect_format



@export_category("effect stats")
@export var is_effect_enabled:bool = true
@export var targeted_stat:String
@export_group("effect growth")
@export var is_growth_enabled:bool
@export var growth_initial:float
@export var growth_final:float
@export var growth_transition_type:Tween.TransitionType
@export var growth_duration:float

@export_group("effect decay")
@export var is_decay_reciprocated:bool
@export var is_decay_enabled:bool
@export var decay_initial:float
@export var decay_final:float
@export var decay_transition_type:Tween.TransitionType

@export var decay_duration:float
