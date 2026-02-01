

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
npcGetMoveLength = 3;
npcSequenceAfterTime = 0.5

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
UI_NPC_Actions = layer_get_id("UI_NPC_MoveBox");

UI_Player_Actions = layer_get_id("UI_Character_MoveBox");


layer_set_visible(UI_NPC_Actions, false);
layer_set_visible(UI_Player_Actions, false);

alarm[0] = 90;

