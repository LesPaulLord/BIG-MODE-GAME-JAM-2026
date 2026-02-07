
if(reachingDestination)
{
	timer += delta_time / 1000000;
	
	_newFract = animcurve_channel_evaluate(curveA, timer/spawnTime);

	x = lerp(initialPos[0], goal[0], _newFract)
	y = lerp(initialPos[1], goal[1], _newFract)	
	
	if(timer/spawnTime > 1)
	{		
		reachingDestination = false;
		active = true;
		
		if(place_meeting(x,y, Sweat_col))
		{
			reachingDestination = true;
			active = false;
			InitSweat();
		}
	}
}


if(active)
{
	if(playerID = 1)
	{
		if(place_meeting(x, y, Player))
		{
			var _sfx = choose(sfx_sweat_1, sfx_sweat_2);
			instance_destroy(self);
			Sequence_Manager.characters[1].Sweat();
			audio_play_sound(_sfx, 1, false, 1, 0 , random_range(0.8,1.2))
		}
	}
	else
	{
		if(place_meeting(x, y, NPC))
		{
			var _sfx = choose(sfx_sweat_1, sfx_sweat_2);
			instance_destroy(self);
			Sequence_Manager.characters[0].Sweat();
			audio_play_sound(_sfx, 1, false, 1, 0 , random_range(0.8,1.2))
		}
	}
}