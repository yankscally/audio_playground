extends Control

@onready var spectruminstance : AudioEffectSpectrumAnalyzerInstance = AudioServer.get_bus_effect_instance(0, 0, 0)
@onready var captureinstance : AudioEffectCapture = AudioServer.get_bus_effect(0, 1)

var sinehz = 440
var sinephase = 0
var sineamplitude = 0.1
var freqscale = 1.0
func _process(delta):
	var playback : AudioStreamGeneratorPlayback = $AudioStreamPlayer.get_stream_playback()
	var framestep = TAU*sinehz/$AudioStreamPlayer.stream.mix_rate
	for i in range(playback.get_frames_available()):
		var a = sin(sinephase)*sineamplitude
		playback.push_frame(Vector2(a, a))
		sinephase += framestep

	var pts : PackedVector2Array = PackedVector2Array()
	pts.resize(60)
	
	var maxvs = 0.0001
	var boxsize = $VBox/Spectrum.size
	for i in range(60):
		var hz = i*50.0 + 25
		var vs = spectruminstance.get_magnitude_for_frequency_range(hz-25, hz+25, AudioEffectSpectrumAnalyzerInstance.MAGNITUDE_MAX)
		maxvs = max(maxvs, vs.x)
		pts[i] = Vector2(boxsize.x*(i+0.5)/60, (1.0-vs.x/freqscale)*boxsize.y)
	freqscale = maxvs
	$VBox/Spectrum/Line2D.points = pts

func _on_h_slider_freq_value_changed(value):
	$VBox/HBox1/LineEditFreq.text = "%d" % int(value)
	sinehz = value

func _on_h_slider_pitch_value_changed(value):
	$VBox/HBox2/LineEditPitch.text = "%.2f" % value
	$AudioStreamPlayer.pitch_scale = value
