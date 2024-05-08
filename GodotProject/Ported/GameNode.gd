extends Node
var field = null
var main = null
var root = null
var awaiting = false

var is_event_loaded:bool
func is_event():
	return (is_event_loaded)

##Misc
func close_msg(_msg):
	main.msg_box.close()
	await(main.msg_box.anim_player.animation_finished)
#func try_function_call(func_str,one=null,debug="somethign is wrong",ret = true):
	#if not func_str.is_empty():
		#if Game.has_method(func_str):
			#ret = Game.call(func_str,null)
		#else:
			#print(debug)
	#return ret


func evaluate_expression(expression: String):
	var _exp = Expression.new()
	var err = _exp.parse(expression)
	if err != OK:
		print(_exp.get_error_text())
		return 
	var result = _exp.execute([],self)
	if not _exp.has_execute_failed():
		return (result)
	return result


