class_name Stat extends RefCounted
#custom data type!

var base = 1.0
var multi = 1.0

func init():
	pass


func set_stat(base=1, multi=1):
	self.base = base
	self.multi = multi

func set_base(n):
	base = n

func add_base(n):
	base += n


func set_multi(n):
	multi = n

func add_multi(n):
	multi *= n


func value():
	return base * multi

func _to_string():
	return str(value())
