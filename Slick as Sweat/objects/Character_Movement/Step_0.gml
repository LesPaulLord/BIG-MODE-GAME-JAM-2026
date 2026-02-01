if(!performAction)
{
	if(isControllable)
	{
		if(keyboard_check(vk_right))
		{
			show_debug_message("perform move right");
			PerformAction(ActionType.moveRight, actionCurrentLength);	
		}

		if(keyboard_check(vk_left))
		{
			show_debug_message("perform move left");
			PerformAction(ActionType.moveLeft, actionCurrentLength);	
		}

		if(keyboard_check(vk_up))
		{
			show_debug_message("perform jump");
			PerformAction(ActionType.jump, actionCurrentLength);	
		}
	
		if(keyboard_check(ord("Y")))
		{
			show_debug_message("perform attack");
			PerformAction(ActionType.attack, actionCurrentLength);
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
		
		blocking = false;
		
		show_debug_message("perform action inited! initial: " + string(initialPos[0]) + ", " + string(initialPos[1]));
		
		switch(actionType)
		{
			case ActionType.idle:

				break;
		
			case ActionType.moveRight:			
				goalPos[0] = x + Game_Manager.gridSpace;
				goalPos[1] = goalPos[1];
				image_xscale = 1;
				sprite_index = spr_idle;
				audio_play_sound(sfx_Character_Move, 1, false)
				break;
		
			case ActionType.moveLeft:
				goalPos[0] = x - Game_Manager.gridSpace;
				goalPos[1] = goalPos[1];
				image_xscale = -1;
				sprite_index = spr_idle;
				audio_play_sound(sfx_Character_Move, 1, false)
				break;
		
			case ActionType.jump:
				goalPos[0] = goalPos[0];
				goalPos[1] = y - Game_Manager.gridSpace;
				jumping = true;
				jumpCoolDown = 1;
				sprite_index = spr_jump;
				audio_play_sound(sfx_Character_Move, 1, false)
				break;
		
			case ActionType.attack:
				attacking = true;
				sprite_index = spr_attack;
				break;
		
			case ActionType.block:
				sprite_index = spr_block;
				audio_play_sound(sfx_Character_Block, 1, false)
				blocking = true;
				break;
		
			case ActionType.knockBack:
		
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
			Move(initialPos, goalPos, _fract);
			break;
		
		case ActionType.moveLeft:
			Move(initialPos, goalPos, _fract);
			break;
		
		case ActionType.jump:
			Move(initialPos, goalPos, _fract);

			break;
		
		case ActionType.attack:

			break;
		
		case ActionType.block:
			Move(initialPos, goalPos, _fract);
			break;
		
		case ActionType.knockBack:
		
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
			jumping = false;
			break;
		
		case ActionType.attack:
			attacking = false;
			break;
		
		case ActionType.block:
		
			break;
		
		case ActionType.knockBack:
		
			break;
	}
	
	if(_fract >= 1)
	{
		show_debug_message("action end current pos = " + string(x) + " , " + string(y));
		performAction = false;
		readyToFight = true;
	}
}