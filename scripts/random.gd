extends Node
@onready var rng:RandomNumberGenerator = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
func n(from:int,to:int) -> float:
	return rng.randi_range(from,to)
