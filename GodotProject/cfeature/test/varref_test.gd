extends Node

class reftest:
	var custom_get = false
	var custom_set = false
	func _set(property: StringName, value: Variant) -> bool:
		if property == "custom_get" or property == "custom_set":
			self[property] = value
			return true
		if self[property] == null:
			self[property] = Ref.new()
			self[property].v = value
		elif custom_set:
			self[property] = value
			return	true
		else:
			var prev = custom_get
			custom_get = true
			self[property].v = value
			custom_get = prev
			return true
		return false
	func _get(property: StringName) -> Variant:	
		if property == "custom_get" or property == "custom_set":
			return
		if not custom_get:
			var prev = custom_get
			custom_get = true
			var v = get_indexed(property+":v")
			custom_get = prev
			return v
		return
	var recursion_stopper = false
	func _get_property_list() -> Array[Dictionary]:
		if recursion_stopper:
			return []
		recursion_stopper = true
		var prop_list = get_property_list()
		recursion_stopper = false
		var prev = custom_get
		custom_get = true
		var list:Array[Dictionary] = []
		for prop in prop_list:
			if self.has_meta(prop["name"]):
				if self[prop["name"]] is Ref:
					list.append({"name":prop["name"],"class_name":prop["class_name"],"type":typeof(self[prop["name"]].v)})
		custom_get = prev
		return list
	var floatref= Ref.new(1.0)
var custom_get = false
var custom_set = false
func _set(property: StringName, value: Variant) -> bool:
	if property == "custom_get" or property == "custom_set":
		self[property] = value
		return true
	if self[property] == null:
		self[property] = Ref.new()
		self[property].v = value
		return	true
	elif custom_set:
		self[property] = value
		return	true
	else:
		var prev = custom_get
		custom_get = true
		self[property].v = value
		custom_get = prev
		return true
	return false
func _get(property: StringName) -> Variant:	
	if property == "custom_get" or property == "custom_set":
		return
	if not custom_get:
		var prev = custom_get
		custom_get = true
		var v = get_indexed(property+":v")
		custom_get = prev
		return v
	return
var recursion_stopper = false
func _get_property_list() -> Array[Dictionary]:
	if recursion_stopper:
		return []
	recursion_stopper = true
	var prop_list = get_property_list()
	recursion_stopper = false
	var prev = custom_get
	custom_get = true
	var list:Array[Dictionary] = []
	for prop in prop_list:
		if self.has_meta(prop["name"]):
			if self[prop["name"]] is Ref:
				list.append({"name":prop["name"],"class_name":prop["class_name"],"type":typeof(self[prop["name"]].v)})
	custom_get = prev
	return list
@onready var floatref= Ref.new(1.0)
var object =reftest.new()
func _ready() -> void:
	object.custom_set =true
	object.floatref = floatref
	object.custom_set = false
	_set("floatref",2.0)
	print(object._get("floatref"))
