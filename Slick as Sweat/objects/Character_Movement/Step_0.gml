if(!performAction)
{
	if(isControllable)
	{
		if(keyboard_check(vk_right))
		{
			show_debug_message("perform move right");
			PerformAction(ActionType.moveRight, actionLength);	
		}

		if(keyboard_check(vk_left))
		{
			show_debug_message("perform move left");
			PerformAction(ActionType.moveLeft, actionLength);	
		}

		if(keyboard_check(vk_up))
		{
			show_debug_message("perform jump");
			PerformAction(ActionType.jump, actionLength);	
		}
	
		if(keyboard_check(ord("Y")))
		{
			show_debug_message("perform attack");
			PerformAction(ActionType.attack, actionLength);
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
		
		show_debug_message("perform action inited! initial: " + string(initialPos[0]) + ", " + string(initialPos[1]));
		
		switch(actionType)
		{
			case ActionType.idle:

				break;
		
			case ActionType.moveRight:			
				goalPos[0] = x + Game_Manager.gridSpace;
				goalPos[1] = y;
				image_xscale = 1;
				sprite_index = spr_Idle_Turkey_01;
				break;
		
			case ActionType.moveLeft:
				goalPos[0] = x - Game_Manager.gridSpace;
				goalPos[1] = y;
				image_xscale = -1;
				sprite_index = spr_Idle_Turkey_01;
				break;
		
			case ActionType.jump:
				goalPos[0] = x;
				goalPos[1] = y - Game_Manager.gridSpace;
				jumping = true;
				sprite_index = spr_Jump_Turkey_01;
				break;
		
			case ActionType.attack:
				attacking = true;
				sprite_index = spr_Punch_Turkey_01;
				break;
		
			case ActionType.block:
				sprite_index = spr_Block_Turkey_01;
				break;
		
			case ActionType.knockBack:
		
				break;
		}
		
		performActionInited = true;
	}	
	
	actionTimer += delta_time/1000000;	
	var _fract = actionTimer / actionLength;	
	show_debug_message("actionTimer: " + string(actionTimer) +" fract " + string(_fract));
	
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