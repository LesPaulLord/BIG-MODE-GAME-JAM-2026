gridSpace = 64;
ringPadding = 70;
topPadding = 64;

fightDelay = 0.5;

updateCharactersHealth = true;

playerHealth = 0;
npcHealth = 0;

winnerID = 0;

playerHearth = [H_P_01, H_P_02, H_P_03, H_P_04, H_P_05]
npcHearth = [H_N_01, H_N_02, H_N_03, H_N_04, H_N_05]

layer_depth("Effect_Shake", -999);

victoryTextInited = false;

gameOver = false;

function GameOver(_winnerID)
{
	winnerID = _winnerID;
	gameOver = true;
}

audio_play_sound_at(sfx_crowd_01, x, y, 0, 100, 300, 1, true, 1, 1);
audio_play_sound_at(sfx_Battle_Song_03, x, y, 0, 100, 300, 1, true, 1, 1);

alarm[0] = 20;

function UpdateHearth()
{
	var _playerHealth = Sequence_Manager.characters[1].characterHealth - 1;
	playerHearth[_playerHealth].sprite_index = spr_UI_Health_02;	
	
	var _npcHealth = Sequence_Manager.characters[0].characterHealth - 1;
	npcHearth[_npcHealth].sprite_index = spr_UI_Health_02;	
}
