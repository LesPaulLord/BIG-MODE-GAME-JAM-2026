enum ActionType {
	idle,
	moveRight,
	moveLeft,
	jump,
	attack,
	block,
	knockBack	
}

readyToFight = false;
actionType = ActionType.idle;
performAction = false;
performActionInited = false;

actionTimer = 0;
initialPos = [0,0];
goalPos = [0, 0];
actionLength = 0.25;


//STATE
attacking = false;
jumping = false;

//visual
curveA = animcurve_get_channel(MovementCurves, "MovementCurveA");

function PerformAction(_actionType, _length)
{
	actionType = _actionType;
	actionLength = _length
	performAction = true;
	performActionInited = false;
}

function Move(_initial, _goal, _fract)
{
	_newFract = animcurve_channel_evaluate(curveA, _fract);
	show_debug_message("Move to: " + string(_goal));
    x = lerp(_initial[0], _goal[0], _newFract)
	y = lerp(_initial[1], _goal[1], _newFract)
}
