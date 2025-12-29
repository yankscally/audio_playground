extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text =\
	"[POS CAM 1] %.3f \n[POS CAM 2] %.3f" % [%Camera1.global_position.z, %Camera2.global_position.z]
