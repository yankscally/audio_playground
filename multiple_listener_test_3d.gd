extends Node3D

@onready var spectrumanalyser : AudioEffectSpectrumAnalyzerInstance = AudioServer.get_bus_effect_instance(0, 0)

var tone = false

func _ready():
	if tone:
		print(spectrumanalyser)
		$AudioStreamPlayer3D.stream = AudioStreamGenerator.new()
		$AudioStreamPlayer3D.play()

var generator_timestamp = 0.0
var generator_freq = 200
func _process_tone_generator() -> void:
	var gplayback: AudioStreamGeneratorPlayback = $AudioStreamPlayer3D.get_stream_playback()
	var gdt: float = 1.0 / $AudioStreamPlayer3D.stream.mix_rate
	for i in range(gplayback.get_frames_available()):
		var a: float = 0.5 * sin(generator_timestamp * generator_freq * TAU)
		gplayback.push_frame(Vector2(a, a))
		generator_timestamp += gdt

func _process(_delta):
	var g = spectrumanalyser.get_magnitude_for_frequency_range(20, 200)
	$AudioStreamPlayer3D/meshleft.scale.y = clampf(g.x*30, 0.2, 7.0)
	$AudioStreamPlayer3D/meshright.scale.y = clampf(g.y*30, 0.2, 7.0)
	if tone:
		_process_tone_generator()

func _input(event):
	if event is InputEventKey and event.keycode == KEY_G and event.pressed:
		tone = true
		$AudioStreamPlayer3D.stream = AudioStreamGenerator.new()
		$AudioStreamPlayer3D.play()
