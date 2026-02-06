gridSpace = 64;
ringPadding = 70;
topPadding = 64;

fightDelay = 0.5;

updateCharactersHealth = true;

playerHealth = 0;
npcHealth = 0;

winnerID = 0;

gameOverInited = false;

gameOverTimer = 0;

npcHeart = [];
playerHeart = [];

playerHeartPos = 238;
npcHeartPos = 72;
heartSpace = 18;
heartY = 35;

for(var i=0; i<5; i++)
{
	var  _npcHeart = instance_create_layer(playerHeartPos + i * heartSpace, heartY, "Instances", Heart);
	var _playerHeart = instance_create_layer(npcHeartPos + i * heartSpace, heartY, "Instances", Heart);
	
	_playerHeart.depth = -80;
	_npcHeart.depth = -80;
	
	playerHeart[i] = _playerHeart;
	npcHeart[4-i] = _npcHeart;	
}

layer_depth("Effect_Shake", -999);

victoryTextInited = false;

gameOver = false;


audio_play_sound_at(sfx_crowd_01, x, y, 0, 100, 300, 1, true, 1, 1);

alarm[0] = 20;

function GameOver(_winnerID)
{	
	winnerID = _winnerID;
	gameOver = true;
	
	pos = GetMiddleOfScreen();
	pos[1] -= 50;
	var _endText = instance_create_layer(pos[0], pos[1], "instances", EndMatch_text);
	
	if(winnerID == 0)
	{
		_endText.sprite_index = spr_UI_StoutWin_01;
		audio_play_sound_at(sfx_Announcer_StoutWins, x, y, 0, 100, 300, 1, false, 1, 1)
	}
	else	
	{
		_endText.sprite_index = spr_UI_TurkeyWin_01;
		audio_play_sound_at(sfx_Announcer_TurkeyWins, x, y, 0, 100, 300, 1, false, 1, 1)
	}
}

function UpdateHeart()
{
	var _playerHealth = Sequence_Manager.characters[1].characterHealth - 1;
	playerHeart[_playerHealth].sprite_index = spr_UI_Health_02;	
	
	var _npcHealth = Sequence_Manager.characters[0].characterHealth - 1;
	npcHeart[_npcHealth].sprite_index = spr_UI_Health_02;	
}
