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
attackLanded = false;
blocking = false;

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
	attackLanded = false;
}

function Move(_initial, _goal, _fract)
{
	_newFract = animcurve_channel_evaluate(curveA, _fract);
	show_debug_message("Move to: " + string(_goal));
	var _moved = false;
	
	if(_goal[0] < room_width - Game_Manager.ringPadding + Game_Manager.gridSpace
	 && _goal[0] > 0 - Game_Manager.gridSpace + Game_Manager.ringPadding)
	{
		x = lerp(_initial[0], _goal[0], _newFract)

		_moved = true;
	}
	
	if(_goal[1] > Game_Manager.topPadding)
	{
		y = lerp(_initial[1], _goal[1], _newFract)
		
		if(_initial[1] !=_goal[1])
		{
		_moved = true;
		}
	}	

	show_debug_message("move: " + string(_moved));	
	
	if(!attackLanded)
	{
		if(_moved)
		{
			if(_fract > 0.8)
			{
				if(place_meeting(x,y, Sequence_Manager.characters[1-characterID]))
				{
					if(Sequence_Manager.characters[1-characterID].blocking)
					{
						show_message(object_get_name(Sequence_Manager.characters[1-characterID].object_index) + "blocked attack");
						attackLanded = true;
						audio_play_sound(sfx_Character_Attack, 1, false)
					}
					else					
					{
						show_message(object_get_name(object_index) + " touched " + object_get_name(Sequence_Manager.characters[1-characterID].object_index));
						attackLanded = true;
						audio_play_sound(sfx_Character_Block, 1, false)
					}
				}
			}
		}
	}
}