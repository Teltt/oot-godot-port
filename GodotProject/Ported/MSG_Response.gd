extends MarginContainer
var text:String = "":
	set(value):
		text = value
		var child = get_child(0)
		child.text = text

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if has_focus():
		get_child(1).color= Color(0.14509804546833, 0.71764707565308, 0.14509804546833)
	else:
		get_child(1).color=Color(0.14509804546833, 0.21960784494877, 0.14509804546833)
	pass
