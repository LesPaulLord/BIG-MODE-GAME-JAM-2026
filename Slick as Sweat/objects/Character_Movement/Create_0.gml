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

powerMove = 0;

//STATE
attacking = false;
jumping = false;
attackLanded = false;
blocking = false;
knocked = false;
falling = false;
currentActionType = ActionType.idle;
sweating = false;

//HEALTH
characterHealth = 5;
maxHealth = characterHealth;

//visual
curveA = animcurve_get_channel(MovementCurves, "MovementCurveA");
fxSweat = noone;

alarm[0] = 5;

if(characterID == 0) image_xscale = -1;

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
	else	
	{
		///WOBBLE
	}
	
	if(_goal[1] > Game_Manager.topPadding || _ignoreMargins)
	{
		y = lerp(_initial[1], _goal[1], _newFract)
		
		if(_initial[1] !=_goal[1])
		{
			_moved = true;
		}
	}
	else	
	{
		///WOBBLE
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
							var _extraPause = 0;
							
							if(powerMove > 0)
							{
								ResetPowerMove();
								_extraPause+= 20;
							}
							//show_message(object_get_name(Sequence_Manager.characters[1-characterID].object_index) + "blocked attack");
							attackLanded = true;
							var audioFile = choose(sfx_blockC_1, sfx_blockC_2, sfx_blockC_3)
							audio_play_sound(audioFile, 1, false)
							instance_create_layer(x, y -30, "Instances", FX_stars);
							var _fxBlock = instance_create_layer(x, y -30, "Instances", FX_block);
							_fxBlock.depth = -999;							
							
							GoalPosDelayed[0] = _initial[0];
							GoalPosDelayed[1] = floorY;
							
							alarm[6] = 20
							
							//if(falling) = _initial[0] + choose(_initial[0] + Game_Manager.gridSpace, _initial[0] - Game_Manager.gridSpace)
							
							knocked = true;
							alarm[2] = 20 + _extraPause;
						}
						else //// PUNCH		
						{
							var _extraPause = 0;	
							attackLanded = true;
							knocked = true;	

							var audioFile = choose(sfx_punchA_1, sfx_punchA_2, sfx_punchA_3)					
							
							audio_play_sound(audioFile, 1, false)
							
							layer_set_visible("Effect_Shake", 1);
							
							var _otherChar = Sequence_Manager.characters[1-characterID];	
							
							Sequence_Manager.characters[1-characterID].GetHurt(1 + powerMove);
							
							_otherChar.sprite_index = Sequence_Manager.characters[1-characterID].spr_hurt
							
							if(powerMove > 0)
							{
								_bigPunchSFX = choose(sfx_BigPunch_1, sfx_BigPunch_2);
								audio_play_sound(_bigPunchSFX, 1, false, 1, 0 , random_range(0.8,1.2))
								ResetPowerMove();
								_extraPause = 20;
								var _fxPowerPunch = instance_create_layer(x, y -30, "Instances", FX_powerPunch);
								_fxPowerPunch.depth = -9999;
							}	
							
							alarm[3] = random_range(5,20);
							alarm[4] = 20+_extraPause;	
							
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
	for(i =0; i< _value; i++)
	{
		if(characterID == 1)
		{
			if(characterHealth > 0)
			{			
				Game_Manager.playerHeart[characterHealth-1].sprite_index = spr_UI_Health_03;
			}
		}
	
		if(characterID == 0)
		{			
			if(characterHealth > 0)
			{		
				Game_Manager.npcHeart[characterHealth-1].sprite_index = spr_UI_Health_03;
			}
		}
		
		characterHealth--;
		
		if(characterHealth == 2)
		{
			for(i = 0; i<2; i++)
			{
				var _sweat = instance_create_layer(x, y, "Instances", Sweat_col);
				_sweat.reachingDestination = true;
				_sweat.playerID = characterID;
				_sweat.InitSweat();
			}
		}
	}

	
	if(IsDead())
	{
		Game_Manager.GameOver(1 - characterID);
	}
	
	Game_Manager.updateCharactersHealth = true;
}

function ResetPowerMove()
{
	if(instance_exists(fxSweat))
	{
		part_system_position(fxSweat,-500, -500);
	}
	
	sweating = false;
	
	powerMove = 0;	
}

function IsDead()
{
	if(characterHealth <= 0)
	{
		return true;
	}
	
	else return false;
}

function Sweat()
{
	if(!sweating)
	{
		var _emitter = characterID == 0? ps_Sweat_NPC : ps_Sweat;
		fxSweat = part_system_create(_emitter);
		part_system_position(fxSweat, x, y);
	}
	
	powerMove++;
	
	sweating = true;
}

function UpdateDirection()
{		
	if(Sequence_Manager.characters[1-characterID].x - 10 < x)
		{
			image_xscale = -1;
		}
		else		
		{
			image_xscale = 1;
		}	
}

