
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
		sequenceTimer = 0;
	}
	
	break
	
	///FIGHT
	
	case 3:
	if (!sequenceInited)	
	{
		sequenceTimer = 0;
	}
	
	break;
}

function InitNPCMovesSequence()
{
	show_debug_message("Init NPC Move sequence");
	sequenceTimer = 0;
		
}

function cpu_generate_moves()
{
	sequenceTimer += delta_time / 1000000	
	
	if(sequenceTimer > npcGetMoveLength)
	{
		currentSequenceStep = 2;
		sequenceInited = false;
	}
	
	
}

function InitPlayerMoveIntputSequence()
{
	show_debug_message("Init Player Input sequence");
	sequenceTimer = 0;		
}

function PlayerInputSequence()
{
	sequenceTimer += delta_time / 1000000	
	
	if(sequenceTimer > npcGetMoveLength)
	{
		currentSequenceStep = 2;
		sequenceInited = false;
	}
}