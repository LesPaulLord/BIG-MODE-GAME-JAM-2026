//0 = pause

//1 = Set Random NPC moves

//2 = Input player

//3 = Fight Sequence


switch(currentSequenceStep)
{
	///PAUSE
	case 0:
	HideShakeFX();
	delayDone = false;
	break

	//SET RANDOM NPC MOVES
	case 1:
	if (!sequenceInited)	
	{
		InitNPCMovesSequence();
	}
	
	if(!delayDone) return;	
	
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
	NPCActionList = []
	sequenceInited = true;
	array_resize(NPCActionList, actionNB);
	moveShowedID = 0;
	alarm[2] = initiativeDelay;
	
	instance_destroy(roundObject);
	
	playerAlreadyBlocked = false;
	npcAlreadyBlocked = false;
	
	//Initiative arrow
	var _initiativeArrow =  initiativeID == 0? Initiative_NPC: Initiative_player;
	var _pos = [characters[initiativeID].x, characters[initiativeID].y];
	
	initiativeArrow = instance_create_layer(x, y, "Instances", _initiativeArrow);
	initiativeArrow.depth = -9999;
	
	initiativeArrow.x = _pos[0];
	initiativeArrow.y = _pos[1] - 62;	
	
	///GET RANDOM MOVE
	for (var i = 0; i < actionNB; i++)
	{
		randomize();
		var _action  = GetRandomActionType();
		
		///EXCEPTIONS------------------
		if(_action == ActionType.jump && npcLastInput == ActionType.jump)
		{
			_action = choose(ActionType.moveLeft, ActionType.moveRight, ActionType.block);
		}
		
		npcLastInput = _action;
		
		if(_action == ActionType.block)
		{
			if!(npcAlreadyBlocked)
			{
					npcAlreadyBlocked = true;
			}
			else			
			{
				_action = choose(ActionType.moveLeft, ActionType.moveRight);
			}
		}
		
		if(_action == ActionType.moveRight)
		{
			if(characters[0].x > room_width - Game_Manager.ringPadding + Game_Manager.gridSpace)
			{
				_action =ActionType.moveLeft
			}
		}
		
		if(_action == ActionType.moveLeft)
		{
			if(characters[0].x < Game_Manager.gridSpace + Game_Manager.ringPadding)
			{
				_action =ActionType.moveRight
			}
		}
		////-------------------------
		
		NPCActionList[i] = _action;
		show_debug_message("random move: " + string(NPCActionList[i]));
	}
	
	SetBoxPosition(UI_NPC_Actions, characters[0]);
	layer_set_visible(UI_NPC_Actions, true);
	SetActionBoxAlpha(NPC_actionBox_flexPannel, 0)
	
	HideShakeFX();
}

function cpu_generate_moves()
{
	sequenceTimer += delta_time / 1000000
	sequenceSubTimer += delta_time / 1000000	
	
	if(moveShowedID < actionNB)
	{
		if(sequenceSubTimer > (npcGetMoveLength/actionNB))
		{
			ShowNPCActionFunc(moveShowedID, moveShowedID);
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

function ShowNPCActionFunc(_id, _moveId)
{
	show_debug_message("Show action: " + string(_moveId))
	
	SetActionBoxSprite(NPC_actionBox_flexPannel, _id, NPCActionList[_id]);
	
	var audioFile = choose(sfx_input_1, sfx_input_2, sfx_input_3)
	audio_play_sound(audioFile, 1, false)
}

/////PLAYER
function InitPlayerMoveIntputSequence()
{
	show_debug_message("Init Player Input sequence");
	sequenceTimer = 0;
	playerActionList = [];
	sequenceFinished = false;
	currentInputID = 0;
	
	layer_set_visible(UI_Player_Actions, true);
	SetActionBoxAlpha(player_actionBox_flexPannel, 0);
	SetBoxPosition(UI_Player_Actions, characters[1])
	
	for(var i =0; i < actionNB; i++)
	{
		SetActionBoxSprite(player_actionBox_flexPannel, i, ActionType.idle);
	}
	
	sequenceInited = true;
	playerSequenceFinishInit = false;
}

function PlayerInputPhase()
{
	sequenceTimer += delta_time / 1000000

	_keyPressed = false;
	
	if(!sequenceFinished)
	{
	if(keyboard_check_pressed(vk_right))
	{		
		if(characters[1].x > room_width - Game_Manager.ringPadding + Game_Manager.gridSpace)
		{
			audio_play_sound(sfx_cantInput, 1, false)
		}
		else
		{
			show_debug_message("press right");
			playerActionList[currentInputID] = ActionType.moveRight;	
			_keyPressed = true;
		}
	}

	if(keyboard_check_pressed(vk_left))
	{
		if(characters[0].x < Game_Manager.gridSpace + Game_Manager.ringPadding)
		{
			audio_play_sound(sfx_cantInput, 1, false)
		}
		else		
		{
			show_debug_message("press left");
			playerActionList[currentInputID] = ActionType.moveLeft;
			_keyPressed = true;
		}		
	}

	if(keyboard_check_pressed(vk_up))
	{
		if(playerLastInput != ActionType.jump)
		{
		show_debug_message("press jump");
		playerActionList[currentInputID] = ActionType.jump;	
		_keyPressed = true;
		}
		else // AIR KICK IF WE PUT IT
		{
			audio_play_sound(sfx_cantInput, 1, false)
		}
	}
	
	if(keyboard_check_pressed(vk_down))
	{
		if(!playerAlreadyBlocked)
		{
			show_debug_message("press block");
			playerActionList[currentInputID] = ActionType.block;
			_keyPressed = true;
			playerAlreadyBlocked = true;
		}
		else		
		{
			audio_play_sound(sfx_cantInput, 1, false)
		}
	}	
	}


	if(_keyPressed)
	{
		SetActionBoxSprite(player_actionBox_flexPannel, currentInputID, playerActionList[currentInputID]);
		
		var audioFile = choose(sfx_input_1, sfx_input_2, sfx_input_3)
		audio_play_sound(audioFile, 1, false)
		
		playerLastInput = playerActionList[currentInputID];
		
		currentInputID ++;
		_keyPressed = false;
		
		if(currentInputID > actionNB - 1)
		{
			sequenceFinished = true;
		}
	}
	
	if(sequenceTimer > playerInputLength + playerSequenceAfterTime)
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
	else if(sequenceFinished && !playerSequenceFinishInit)
	{
		sequenceTimer = playerInputLength;
		playerSequenceFinishInit = true;
	}
}


////FIGHT
function InitFight()
{
	show_debug_message("Init fight");
	sequenceTimer = 0;
	
	instance_destroy(initiativeArrow);
	
	sequenceInited = true;
	characters[0].readyToFight = true;
	characters[1].readyToFight = true;
	currentActionID = 0;
		
	var _center = GetMiddleOfScreen();
	_center[1] -= 60;
	fightText = instance_create_layer(_center[0], _center[1], "Instances", Fight_Text);
	audio_play_sound_at(choose(sfx_Announcer_Fight, sfx_Announcer_Fight_02, sfx_Announcer_Fight_03), x, y, 0, 100, 300, 1, false, 1, 1, 0, random_range(0.9, 1.1));
	
	layer_set_visible(UI_Player_Actions, false);
	
	currentFighterID = initiativeID;
	currentActionMadePerTurn = 0;
}


function FightSequence()
{	
	sequenceTimer+= delta_time/1000000
			
	if(sequenceTimer < Game_Manager.fightDelay)
	{
		return;
	}
	
	if(sequenceTimer > Game_Manager.fightDelay * 1.5)
	{
		if(fightText != noone)
		{
			instance_destroy(fightText);
			fightText = noone;
		}
	}
	
	if(ArePlayerReadyToFight())
	{
		HideShakeFX();
		
		if(currentFighterID == 0)
		{
			if(currentActionID < actionNB) ///Mettre specifiquement au character
			{
				show_debug_message("NPC action: " + string(currentActionID));	
				characters[0].PerformAction(NPCActionList[currentActionID], currentActionLength)
				currentFighterID = 1;
				
				JumpCoolDown(0);
				currentActionMadePerTurn++;
			}
		}
		else if (currentFighterID == 1)		
		{
			if(currentActionID < actionNB) ///Mettre specifiquement au character
			{
				show_debug_message("Player action: " + string(currentActionID));	
				characters[1].PerformAction(playerActionList[currentActionID], currentActionLength)
				currentFighterID = 0;
				
				JumpCoolDown(1);
				currentActionMadePerTurn++;
			}
		}
		
		if(currentActionMadePerTurn >= 2)
		{
			currentActionID++;
			currentActionMadePerTurn = 0;
		}
		
		if(currentActionID >= actionNB)
		{
			show_debug_message("Fight sequence over");	
			currentSequenceStep = 0;
			currentTurn++;
			initiativeID = initiativeID == 0? 1 : 0;
			sequenceInited = false;
			alarm[0] = 60;
			
			HideShakeFX();
		}
	}	
}