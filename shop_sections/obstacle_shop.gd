extends Node2D

@onready var item_type:String = "obstacle"
@onready var item_pool:Dictionary = {
		"Speedy": {
			"effect":{"min":0,
				"max":300,
				"expression":"x+1*d",
				"state":"normal",
				"inverse_expression":"0*x*d",
				"targeted_stat":"speed",
				"value":101
			},
			
			"strength":0,
			"fragile":true
		},
		
}
