class_name SoundEffectPlayer2D
extends AudioStreamPlayer2D
## An AudioStreamPlayer2D with an added method to play a specific sound effect.


## Play the specified [param stream_to_play]. Stops the currently-playing stream
## if there is one.
func play_stream(stream_to_play: AudioStream) -> void:
	stream = stream_to_play
	play()
