enum ActionType {
	idle,
	moveRight,
	moveLeft,
	jump,
	attack,
	block,
	knockBack,
	move
}

readyToFight = false;
actionType = ActionType.idle;
performAction = false;
performActionInited = false;

actionTimer = 0;
initialPos = [0,0];
goalPos = [x, y];
GoalPosDelayed = [x, y];
actionLength = 0.25;

jumpCoolDown = 0;
floorY = y;

//STATE
attacking = false;
jumping = false;
attackLanded = false;
blocking = false;
knocked = false;
falling = false;
currentActionType = ActionType.idle;

//HEALTH
characterHealth = 5;
maxHealth = characterHealth;

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

function Move(_initial, _goal, _fract, _attack, _ignoreMargins = false){
	_newFract = animcurve_channel_evaluate(curveA, _fract);
	show_debug_message("Move to: " + string(_goal));
	var _moved = false;
	var _cancelReady = false;
	
	if(_goal[0] < room_width - Game_Manager.ringPadding + Game_Manager.gridSpace
	 && _goal[0] > 0 - Game_Manager.gridSpace + Game_Manager.ringPadding || _ignoreMargins)
	{
		x = lerp(_initial[0], _goal[0], _newFract)

		_moved = true;
	}
	
	if(_goal[1] > Game_Manager.topPadding || _ignoreMargins)
	{
		y = lerp(_initial[1], _goal[1], _newFract)
		
		if(_initial[1] !=_goal[1])
		{
			_moved = true;
		}
	}

	show_debug_message("move: " + string(_moved));	
	
	if(!attackLanded && _attack)
	{
		if(_moved)
		{
			if(_fract > 0.8)
			{
				if(place_meeting(x,y, Sequence_Manager.characters[1-characterID]))
				{
					depth = -100;

					if(!blocking || falling)
					{
						if(!falling)sprite_index = spr_attack;
						else sprite_index = spr_downKick;
						
						///BLOCK
						if(Sequence_Manager.characters[1-characterID].blocking)
						{
							//show_message(object_get_name(Sequence_Manager.characters[1-characterID].object_index) + "blocked attack");
							attackLanded = true;
							var audioFile = choose(sfx_blockC_1, sfx_blockC_2, sfx_blockC_3)
							audio_play_sound(audioFile, 1, false)
							instance_create_layer(x, y -30, "Instances", FX_stars);
							var _fxBlock = instance_create_layer(x, y -30, "Instances", FX_block);
							_fxBlock.depth = -999;
							
							goalPos[0] = _initial[0];
							goalPos[1] = floorY;
							
							if(falling) = _initial[0] + choose(_initial[0] + Game_Manager.gridSpace, _initial[0] - Game_Manager.gridSpace)
							
							knocked = true;
							alarm[2] = 20;
						}
						else //// PUNCH		
						{
							//show_message(object_get_name(object_index) + " touched " + object_get_name(Sequence_Manager.characters[1-characterID].object_index));
							attackLanded = true;
						
							var audioFile = choose(sfx_punchA_1, sfx_punchA_2, sfx_punchA_3)
							audio_play_sound(audioFile, 1, false)
						
						    var _otherChar = Sequence_Manager.characters[1-characterID];							
							var _fallChanceDir = false;
							
							if(falling)
							{
								_fallChanceDir = choose(true, false);
							}
							
							if(currentActionType == ActionType.moveLeft || falling && _fallChanceDir)
							{
								//show_message("from right");
								_otherChar.goalPos[0] = _otherChar.x - Game_Manager.gridSpace;
								_otherChar.goalPos[1] = floorY;
							}
							else if(currentActionType == ActionType.moveRight  || falling)
							{
								//show_message("from left");
								_otherChar.goalPos[0] = _otherChar.x + Game_Manager.gridSpace;
								_otherChar.goalPos[1] = floorY;
							}
							
							alarm[3] = random_range(5,20);							
							
							_otherChar.PerformAction(ActionType.knockBack, Sequence_Manager.currentActionLength*0.75)
						
							_otherChar.sprite_index = Sequence_Manager.characters[1-characterID].spr_hurt
							instance_create_layer(x, y -30, "Instances", FX_stars);
						
							layer_set_visible("Effect_Shake", 1);
							
							Sequence_Manager.characters[1-characterID].GetHurt(1);
						
							Game_Manager.updateCharactersHealth = true;
						}
					}
				}
			}
		}
	}
}

function GetHurt(_value)
{
	characterHealth-= _value;
	
	if(IsDead())
	{
		Game_Manager.GameOver(1 - characterID);
	}
	
	Game_Manager.updateCharactersHealth = true;
}

function IsDead()
{
	if(characterHealth <= 0)
	{
		return true;
	}
	
	else return false;
}

