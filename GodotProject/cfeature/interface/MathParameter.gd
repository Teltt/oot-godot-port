class_name MathParameter
extends Resource

@export var command:String
@export var params:Array[MathParameter]
var v:
	get:
		return get_param()
func get_param():
	var expression = Expression.new()
	
	var error = expression.parse(command)
	if error != OK:
		print(expression.get_error_text())
		return
	var result = expression.execute([],self)
	if not expression.has_execute_failed():
		return result
