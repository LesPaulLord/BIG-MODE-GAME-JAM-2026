if(coolDown)
{
	if (keyboard_check(vk_anykey)) {
		if(audio_is_playing(sfx_MainMenuTheme)) audio_stop_sound(sfx_MainMenuTheme);
		room_goto(Room_Round1);
	}
}