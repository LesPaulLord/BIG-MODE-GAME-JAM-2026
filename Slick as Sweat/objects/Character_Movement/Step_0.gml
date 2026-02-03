if(!performAction)
{
	if(isControllable)
	{
		if(keyboard_check(vk_right))
		{
			show_debug_message("perform move right");
			PerformAction(ActionType.moveRight, Sequence_Manager.currentActionLength);
		}

		if(keyboard_check(vk_left))
		{
			show_debug_message("perform move left");
			PerformAction(ActionType.moveLeft, Sequence_Manager.currentActionLength);
		}

		if(keyboard_check(vk_up))
		{
			show_debug_message("perform jump");
			PerformAction(ActionType.jump, Sequence_Manager.currentActionLength);
		}
	
		if(keyboard_check(ord("Y")))
		{
			show_debug_message("perform attack");
			PerformAction(ActionType.attack, Sequence_Manager.currentActionLength);
		}
	
		if(keyboard_check(vk_enter))
		{
			 show_debug_message("current pos: " + string(x) + " " + string(y))
		}
	}
}

if(performAction)
{	
	//Init PERFORM ACTION
	if(!performActionInited)
	{
		actionTimer = 0;
		readyToFight = false;
		initialPos[0] = x;
		initialPos[1] = y;
		image_speed = 0.5;
		depth = -50;
		currentActionType = actionType;
		
		blocking = false;
		
		show_debug_message("perform action inited! initial: " + string(initialPos[0]) + ", " + string(initialPos[1]));
		var dashAudio = choose(sfx_dash_1, sfx_dash_2)
		
		switch(actionType)
		{
			case ActionType.idle:

				break;
		
			case ActionType.moveRight:
				goalPos[0] = x + Game_Manager.gridSpace;
				goalPos[1] = goalPos[1];
				
				if(!falling) sprite_index = spr_idle;
				else sprite_index = spr_downKick;

				audio_play_sound(dashAudio, 1, false, 1, 0 , random_range(0.8,1.2))
				break;
		
			case ActionType.moveLeft:
				goalPos[0] = x - Game_Manager.gridSpace;
				goalPos[1] = goalPos[1];
				if(!falling) sprite_index = spr_idle;
				else sprite_index = spr_downKick;
				
				audio_play_sound(dashAudio, 1, false, 1, 0 , random_range(0.8,1.2))
				break;
		
			case ActionType.jump:
				goalPos[0] = goalPos[0];
				goalPos[1] = y - Game_Manager.gridSpace;
				audio_play_sound(dashAudio, 1, false)
				
				if(!jumping) instance_create_layer(x, y, "Instances", FX_jump);
				
				jumping = true;
				jumpCoolDown = 1;
				sprite_index = spr_jump;
				break;
		
			case ActionType.attack:
				attacking = true;
				sprite_index = spr_attack;
				break;
		
			case ActionType.block:
				sprite_index = spr_block;
				var blockAudio = choose(sfx_dash_1, sfx_dash_2)
				audio_play_sound(blockAudio, 1, false, 1, 0 , random_range(0.8,1.2))
				blocking = true;
				break;
		
			case ActionType.knockBack:
				knocked = true;
				break;
				
			case ActionType.move:
				
				break;
				
		}
		
		performActionInited = true;
	}	
	
	actionTimer += delta_time/1000000;	
	var _fract = actionTimer / actionLength;
	
	///UPDATE PERFORM ACTION
	switch(actionType)
	{
		case ActionType.idle:

			break;
		
		case ActionType.moveRight:
			Move(initialPos, goalPos, _fract, true);
			break;
		
		case ActionType.moveLeft:
			Move(initialPos, goalPos, _fract, true);
			break;
		
		case ActionType.jump:
			Move(initialPos, goalPos, _fract, true);

			break;
		
		case ActionType.attack:

			break;
		
		case ActionType.block:
			if(falling)
			{
				Move(initialPos, goalPos, _fract, true);
			}
			else			
			{				
				Move(initialPos, goalPos, _fract, false);
			}
			break;
		
		case ActionType.knockBack:
			Move(initialPos, goalPos, _fract, false, true);
			break;
			
		case ActionType.move:
			Move(initialPos, goalPos, _fract, false);
			break;
	}
	
	///END PERFORM ACTION
	switch(actionType)
	{
		case ActionType.idle:

			break;
		
		case ActionType.moveRight:
			break;
		
		case ActionType.moveLeft:
		
			break;
		
		case ActionType.jump:

			break;
		
		case ActionType.attack:
			attacking = false;
			break;
		
		case ActionType.block:
			break;
		
		case ActionType.knockBack:
			knocked = false;
			break;
			
		case ActionType.move:
		
			break;
	}
	
	if(_fract >= 1)
	{
		show_debug_message("action end current pos = " + string(x) + " , " + string(y));
		performAction = false;
		readyToFight = true;		
		falling = false;
		if(Sequence_Manager.characters[1-characterID].x- 10 < x)
		{
				image_xscale = -1;
		}
		else		
		{
				image_xscale = 1;
		}		
	}
}