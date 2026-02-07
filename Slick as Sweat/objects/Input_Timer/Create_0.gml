length = 1;
currentTimer = 0;

image_index = image_number-1;

sfxTimer = audio_play_sound(sfx_tiktak, 1, true);
sfxTone = audio_play_sound(sfx_tone, 1, true);


function RemoveTimer()
{
	if(audio_is_playing(sfx_tone)) audio_stop_sound(sfx_tone);
	if(audio_is_playing(sfx_tiktak)) audio_stop_sound(sfx_tiktak);
	instance_destroy(self);
}