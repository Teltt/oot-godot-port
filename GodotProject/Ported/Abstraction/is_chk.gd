extends RefCounted
class_name ISCHK
var is_v = false
var chk_func
signal tell
func _init(_chk_func,connections = []):
	chk_func = _chk_func
	for c in connections:
		tell.connect(c)
func chk():
	is_v = chk_func.call()
	tell.emit(is_v)
func _is():
	return is_v
