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
goalPos = [x, y];
actionLength = 0.25;


jumpCoolDown = 0;
floorY = y;

//STATE
attacking = false;
jumping = false;

//visual
curveA = animcurve_get_channel(MovementCurves, "MovementCurveA");

alarm[0] = 5;

if(characterID ==0) image_xscale = -1;

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
	
	if(_goal[0] < room_width + Game_Manager.gridSpace && _goal[0] > 0 - Game_Manager.gridSpace) x = lerp(_initial[0], _goal[0], _newFract)
	if(_goal[1] > 0) y = lerp(_initial[1], _goal[1], _newFract)
}