
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
	}
}


if(active)
{
	if(playerID = 1)
	{
		if(place_meeting(x, y, Player))
		{
			show_message("player sweat");
			instance_destroy(self);
		}
	}
	else
	{
		if(place_meeting(x, y, NPC))
		{
			show_message("NPC sweat");
			instance_destroy(self);
		}
	}
}