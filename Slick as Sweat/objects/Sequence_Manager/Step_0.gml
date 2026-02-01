//0 = pause

//1 = Set Random NPC moves

//2 = Input player

//3 = Fight Sequence


switch(currentSequenceStep)
{
	///PAUSE
	case 0:

	break

	//SET RANDOM NPC MOVES
	case 1:
	if (!sequenceInited)	
	{
		InitNPCMovesSequence();
	}
	
	cpu_generate_moves()
	
	break
	
	///PLAYER INPUT
	case 2:	
	if (!sequenceInited)	
	{
		InitPlayerMoveIntputSequence();
		sequenceTimer = 0;
	}
	
	PlayerInputPhase();
	
	break
	
	///FIGHT	
	case 3:
	if (!sequenceInited)	
	{
		InitFight();
		sequenceTimer = 0;
	}
	
	FightSequence();
	
	break;
}

function InitNPCMovesSequence()
{
	show_debug_message("Init NPC Move sequence");
	sequenceTimer = 0;
	sequenceInited = true;
	NPCActionList = []
	array_resize(NPCActionList, actionNB);
	moveShowedID = 0;
	
	for (var i = 0; i < actionNB; i++) 
	{
		randomize();
		// irandom(6) picks a number between 0 and 6
		NPCActionList[i] = GetRandomActionType();
		show_debug_message("random move: " + string(NPCActionList[i]));
	}	

	layer_set_visible(UI_NPC_Actions, true);
	
	//var _count = flexpanel_node_get_num_children(UI_NPC_Actions);
		
	//for(var i =0; i < _count; i++)
	//{		
	//    var child = flexpanel_node_get_child(UI_NPC_Actions, i);
	//    flexpanel_node_style_set_display(child, flexpanel_display.none);
	//}	
}

///NPC////
function cpu_generate_moves()
{
	sequenceTimer += delta_time / 1000000
	sequenceSubTimer += delta_time / 1000000	
	
	if(moveShowedID < actionNB)
	{
		if(sequenceSubTimer > (npcGetMoveLength/actionNB))
		{
			ShowNPCActionFunc(moveShowedID);
			sequenceSubTimer = 0;
			moveShowedID++;
		}
	}
	
	if(sequenceTimer > npcGetMoveLength + npcSequenceAfterTime)
	{
		currentSequenceStep = 2;
		sequenceInited = false;
		
		layer_set_visible(UI_NPC_Actions, false);
	}
}

function ShowNPCActionFunc(_id)
{
	show_debug_message("Show action: " + string(_id))
}



/////PLAYER
function InitPlayerMoveIntputSequence()
{
	show_debug_message("Init Player Input sequence");
	sequenceTimer = 0;
	playerActionList = [];
	sequenceFinished = false;
	currentInputID = 0;
	
	sequenceInited = true;
}

function PlayerInputPhase()
{
	sequenceTimer += delta_time / 1000000

	_keyPressed = false;
	
	if(keyboard_check_pressed(vk_right))
	{
		show_debug_message("press right");
		playerActionList[currentInputID] = ActionType.moveRight;	
		_keyPressed = true;
	}

	if(keyboard_check_pressed(vk_left))
	{
		show_debug_message("press left");
		playerActionList[currentInputID] = ActionType.moveLeft;
		_keyPressed = true;
	}

	if(keyboard_check_pressed(vk_space))
	{
		show_debug_message("press jump");
		playerActionList[currentInputID] = ActionType.jump;	
		_keyPressed = true;
	}
	
	if(keyboard_check_pressed(ord("X")))
	{
		show_debug_message("press attack");
		playerActionList[currentInputID] = ActionType.attack;
		_keyPressed = true;
	}
	
		if(keyboard_check_pressed(ord("C")))
	{
		show_debug_message("press attack");
		playerActionList[currentInputID] = ActionType.block;
		_keyPressed = true;
	}	

	if(_keyPressed)
	{
		currentInputID ++;
		_keyPressed = false;
		
		if(currentInputID > actionNB - 1)
		{
			sequenceFinished = true;
		}
	}
	
	if(sequenceTimer > playerInputLength + playerSequenceAfterTime || sequenceFinished)
	{
		show_debug_message("player input finished");
					
		if(!sequenceFinished)
		{
			show_debug_message("player didin't finish input in time");
			
			for(var i = currentInputID; i < actionNB; i++)
			{
				show_debug_message("add idle on: " + string(i));
				playerActionList[i] = ActionType.idle;
			}
		}
		
		for(var _x = 0; _x < actionNB; _x++)
		{
			show_debug_message("player action: " + string(playerActionList[_x]));
		}
		
		currentSequenceStep = 3;
		sequenceInited = false;
	}
}


////FIGHT
function InitFight()
{
		show_debug_message("Init fight");
		sequenceTimer = 0;
	
		sequenceInited = true;
		characters[0].readyToFight = true;
		characters[1].readyToFight = true;
		currentActionID = 0;
		
		show_debug_message("character: " + string(characters[0]));
		show_debug_message("character: " + string(characters[1]));		
}


function FightSequence()
{	
	if(sequenceTimer < fightDelay)
	{
		sequenceTimer+= delta_time/1000000
		return;
	}
	
	if(ArePlayerReadyToFight())
	{
		if(currentFighterID == 0)
		{
			if(currentActionID < actionNB) ///Mettre specifiquement au character
			{
				show_debug_message("NPC action: " + string(currentActionID));	
				characters[0].PerformAction(NPCActionList[currentActionID], Game_Manager.actionCurrentLength)
				currentFighterID = 1;
				
				JumpCoolDown(0);
			}
		}
		else if (currentFighterID == 1)		
		{
			if(currentActionID < actionNB) ///Mettre specifiquement au character
			{
				show_debug_message("Player action: " + string(currentActionID));	
				characters[1].PerformAction(playerActionList[currentActionID], Game_Manager.actionCurrentLength)
				currentFighterID = 0;
				
				JumpCoolDown(1);
			}
			currentActionID++; // currentACtion change juste quand c player
		}
		
		if(currentActionID >= actionNB)
		{
			show_debug_message("Fight sequence over");	
			currentSequenceStep = 0;
			currentTurn++;
			sequenceInited = false;
			alarm[0] = 60;
		}
	}	
}

function JumpCoolDown(_id)
{
	if(characters[_id].jumpCoolDown > 0)
	{
		characters[_id].jumpCoolDown--;
					
		if(characters[_id].jumpCoolDown==0)
		{
			show_debug_message("character:" + string(_id) + " fall!");
			characters[_id].goalPos[1] = characters[_id].floorY;
		}
	}
}

function GetRandomActionType()
{
	var _rand = irandom(4); 

	switch(_rand)
	{
		case 0: return ActionType.moveLeft;
		case 1: return ActionType.moveRight;
		case 2: return ActionType.jump;
		case 3: return ActionType.attack;
		case 4: return ActionType.block;
	}
}

function ArePlayerReadyToFight()
{
	if(characters[0].readyToFight && characters[1].readyToFight)
	{
		show_debug_message("Ready To Fight!!");
		 return true;	
	}
	else	
	{
		//show_debug_message("Not ready to fight");
	}
}