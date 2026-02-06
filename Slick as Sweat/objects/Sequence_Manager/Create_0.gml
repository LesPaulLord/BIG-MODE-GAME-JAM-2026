

///GLOBAL
acceleration = 1.0
initiativeDelay = 1;

//DONT SET
currentTurn = 0
currentSequenceStep = 0
sequenceTimer = 0
sequenceInited = false
delayDone = false;
sequenceSubTimer = 0;
characters = array_create(2, Character_Movement);

///NPC
npcSequenceAfterTime = 0.65;

NPCActionList = []
moveShowedID = 0;
//NPCActionModifier = 1

///PLAYER
playerInputLength = 2.5
playerSequenceAfterTime = 0.5
playerIconID = 0;
playerSequenceFinishInit = false;
inputTimer = noone;

///
playerActionList = []
sequenceFinished = false;

playerLastInput = ActionType.idle;
npcLastInput = ActionType.idle;

playerAlreadyBlocked = false;
npcAlreadyBlocked = false;

///FIGHT
currentFighterID = 0;
currentActionID = 0;
currentActionMadePerTurn = 0;
currentActionLength = actionLength;

///UI
UI_NPC_Actions = layer_get_id("UI_NPC_MoveBoxes");
NPC_actionBox_flexPannel = layer_get_flexpanel_node("UI_NPC_MoveBoxes");

UI_Player_Actions = layer_get_id("UI_Character_MoveBoxes");
player_actionBox_flexPannel = layer_get_flexpanel_node("UI_Character_MoveBoxes");

SetBoxPosition(UI_NPC_Actions, characters[0])

layer_set_visible(UI_NPC_Actions, false);
layer_set_visible(UI_Player_Actions, false);

currentElementAnimated = noone;

initiativeArrow = noone;

initiativeID = 0;

fightText = noone;

var spr_round = [spr_UI_Round_01, spr_UI_Round_02, spr_UI_Round_03]
var sfx_round_announcer = [sfx_Announcer_Round1, sfx_Announcer_Round2, sfx_Announcer_Round3, sfx_Announcer_Round4, sfx_Announcer_Round5]

roundObject = instance_create_layer(GetMiddleOfScreen()[0], GetMiddleOfScreen()[1]-50, "Instances", Round_text);
roundObject.sprite_index = spr_round[roundID-1];
audio_play_sound_at(sfx_round_announcer[roundID -1], x, y, 0, 100, 300, 1, false, 1, 1, 0, random_range(0.9, 1.1));
alarm[0] = 70;

Game_Manager.updateCharactersHealth = true;

_musicPitch = 1;

switch(roundID){
	case 2: _musicPitch = 1.2; break;
	case 3: _musicPitch = 1.5; break;
}

audio_play_sound_at(sfx_Battle_Song_03, x, y, 0, 100, 300, 1, true, 1, 1, 0, _musicPitch);


function SetActionBoxAlpha(_flexRoot, _alpha)
{
	var _childCount = flexpanel_node_get_num_children(_flexRoot);
	for (var i = 0; i < _childCount; i++) {
    var _childNode = flexpanel_node_get_child(_flexRoot, i);
    var _struct = flexpanel_node_get_struct(_childNode);
    
    var _element = _struct.layerElements[0];
	layer_sprite_alpha(_element.elementId, _alpha);
}

function SetActionBoxSprite(_flexRoot, _actionID, actionType, setAnim = true)
{
	var sprite = spr_UI_HealthBar_Frame;
	
	var _childNode = flexpanel_node_get_child(_flexRoot, _actionID);
	var _struct = flexpanel_node_get_struct(_childNode);
	var _element = _struct.layerElements[0];
	
	if(currentElementAnimated != noone)
	{
		layer_sprite_speed(currentElementAnimated, 0);
		layer_sprite_index(currentElementAnimated, 9);	
	}
	currentElementAnimated = _element.elementId;
	
	layer_sprite_index(currentElementAnimated, 0);
	
	if(!setAnim)
	{
			layer_sprite_speed(_element.elementId, 0);
			layer_sprite_index(currentElementAnimated, 9);
	}
	else	
	{
			layer_sprite_speed(_element.elementId, 1);
	}

	switch(actionType)
	{
		case ActionType.attack:
			sprite = spr_UI_MoveBox_Attack;
			break;
		
		case ActionType.block:
			sprite = spr_UI_MoveBox_Block;
			break;
		
		case ActionType.moveLeft:
			sprite = spr_UI_MoveBox_ArrowLeft;
			break;
		
		case ActionType.moveRight:
			sprite = spr_UI_MoveBox_ArrowRight;
			break;
		
		case ActionType.jump:
			sprite = spr_UI_MoveBox_ArrowUp;
			break;
			
		case ActionType.idle:
			sprite = spr_UI_MoveBox_Frame;
			break;
	}
	
	layer_sprite_alpha(_element.elementId, 1);
	layer_sprite_change(_element.elementId, sprite);
	
	if(setAnim)	alarm[3] = 15;
	}
}

function SetBoxPosition(_box, _character)
{
	layer_x(_box, _character.x - 60)
	layer_y(_box, _character.y - 100)
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
			characters[_id].jumping = false;
			characters[_id].falling = true;
		}
	}
}

function GetRandomActionType()
{	
	var _rand = irandom(3);

	switch(_rand)
	{
		case 0: return ActionType.moveLeft;
		case 1: return ActionType.moveRight;
		case 2: return ActionType.jump;
		case 3: return ActionType.block;
	}
}

function ArePlayerReadyToFight()
{
	if(characters[0].readyToFight && characters[1].readyToFight && !characters[0].knocked  && !characters[1].knocked && !Game_Manager.gameOver)
	{
		show_debug_message("Ready To Fight!!");
		 return true;
	}
	else	
	{
		//show_debug_message("Not ready to fight");
	}
}

function HideShakeFX()
{
	if(layer_get_visible("Effect_Shake") == true)
	{
		layer_set_visible("Effect_Shake", 0);
	}
}