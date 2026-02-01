

///GLOBAL
actionNB = 3
acceleration = 1.0

//DONT SET
currentTurn = 0
currentSequenceStep = 0
sequenceTimer = 0
sequenceInited = false
sequenceSubTimer = 0;
characters = array_create(2, Character_Movement);

///NPC
npcGetMoveLength = 2;
npcSequenceAfterTime = 0.25

NPCActionList = []
moveShowedID = 0;
//NPCActionModifier = 1

///PLAYER
playerInputLength = 2.5
playerSequenceAfterTime = 0.25
//playerActionModifier = 1

playerActionList = []
sequenceFinished = false;
currentInputID = 0;

///FIGHT
currentFighterID = 0;
currentActionID = 0;
fightDelay = 0.5;

///UI
UI_NPC_Actions = layer_get_id("UI_NPC_MoveBoxes");
NPC_actionBox_flexPannel = layer_get_flexpanel_node("UI_NPC_MoveBoxes");

UI_Player_Actions = layer_get_id("UI_Character_MoveBoxes");
player_actionBox_flexPannel = layer_get_flexpanel_node("UI_Character_MoveBoxes");

layer_x(UI_NPC_Actions, characters[0].x - 60)
layer_y(UI_NPC_Actions, characters[0].y - 100)

//layer_set_visible(UI_NPC_Actions, false);
layer_set_visible(UI_Player_Actions, false);

alarm[0] = 90;


function SetActionBoxAlpha(_flexRoot, _alpha)
{
	var _childCount = flexpanel_node_get_num_children(_flexRoot);
	for (var i = 0; i < _childCount; i++) {
    var _childNode = flexpanel_node_get_child(_flexRoot, i);
    var _struct = flexpanel_node_get_struct(_childNode);

    
    var _element = _struct.layerElements[0];
	layer_sprite_alpha(_element.elementId, _alpha);
}

function SetActionBoxSprite(_flexRoot, _actionID, actionType)
{

	var sprite = spr_UI_HealthBar_Frame;
	
	var _childNode = flexpanel_node_get_child(_flexRoot, _actionID);
	var _struct = flexpanel_node_get_struct(_childNode);
	var _element = _struct.layerElements[0];


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
	}
	
	layer_sprite_alpha(_element.elementId, 1);
	layer_sprite_change(_element.elementId, sprite);

	}
}