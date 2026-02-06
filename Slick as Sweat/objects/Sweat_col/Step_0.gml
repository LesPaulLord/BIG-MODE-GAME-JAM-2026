
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