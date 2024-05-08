extends Interface

signal im_ready
# Called when the node enters the scene tree for the first time.
func _ready():
	im_ready.emit()
