extends Sprite2D

func change_color():
	var image:Image = texture.get_data()
	image.lock()
	
