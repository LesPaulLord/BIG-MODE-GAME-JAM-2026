active = false;
initialPos = [0, 0]
goal = [0, 0]
playerID = 0;
reachingDestination = false;
spawnTime = 0.75;
timer = 0;

curveA = animcurve_get_channel(MovementCurves, "MovementCurveA");

function InitSweat()
{
	goal = GetRandomGoal();
	reachingDestination = true;

	initialPos[0] = x;
	initialPos[1] = y;

	if(playerID == 0)
	{
		sprite_index = spr_fx_sweat_stout;
	}

	if(playerID == 1)
	{
		sprite_index = spr_fx_sweat_turkey;
	}

	function GetRandomGoal()
	{
		randomize();
		var _x = choose(64, 128, 192, 256, 320);
		var _y = choose(80, 144, 80);
	
		while(_x == initialPos[0] && _y == initialPos[1])
		{
			_x = choose(64, 128, 192, 256, 320);
			_y = choose(80, 144, 80);
		}

		return [_x, _y];
	}
}


