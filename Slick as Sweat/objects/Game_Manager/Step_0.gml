if(gameOver)
{
	if(!gameOverInited)
	{
		audio_stop_sound(sfx_Battle_Song_03);
		gameOverInited = true;
	}

	gameOverTimer += delta_time/100000
	
	if(gameOverTimer > 1.5)	
	{
		if (keyboard_key != vk_nokey) 
		{
			if(winnerID == 0)
			{
				audio_stop_all();
				room_goto(Room_Lose);
			}
			else		
			{
				audio_stop_all();
				room_goto_next();	
			}
		}
	}	
}