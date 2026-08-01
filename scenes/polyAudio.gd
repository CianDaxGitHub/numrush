extends AudioStreamPlayer

@export var sfxLib: SoundLibrary
@export var maxPoly: int = 32


func _ready() -> void:
	stream = AudioStreamPolyphonic.new()
	stream.polyphony = maxPoly

func play_sfx_from_lib(_tag: String, pitch: float = 1, volume: float = 0, delay: float = 0) -> void:
	await get_tree().create_timer(delay).timeout
	if _tag:
		var sfxStream = sfxLib.get_audio_stream(_tag)
		if !playing: self.play()
		
		var polyPlayback = self.get_stream_playback()
		polyPlayback.play_stream(sfxStream, 0, volume, pitch)
	else:
		printerr("can't get sound effect")
