extends Resource
class_name SoundLibrary

@export var soundFx: Array[SoundEffect]


func get_audio_stream(_tag: String):
	var index = -1
	
	if _tag:
		for sound in soundFx:
			index += 1
			if sound.tag == _tag:
				break
		return soundFx[index].stream
	else:
		printerr("can't get sound effect")
	return null
