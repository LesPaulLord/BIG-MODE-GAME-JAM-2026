if(gameOver)
{
	if(!gameOverInited)
	{
		audio_stop_sound(sfx_Battle_Song_03);
		gameOverInited = true;
	}
	
	//CLEAR REMAINING SWEAT
	for(var i =0; i<2; i++)
	{
		if(Sequence_Manager.characters[i].fxSweat != noone)
		{
			part_system_position(Sequence_Manager.characters[i].fxSweat,-500, -500);	
		}
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