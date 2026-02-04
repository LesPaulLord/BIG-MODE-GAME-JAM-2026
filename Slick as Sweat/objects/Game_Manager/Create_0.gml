gridSpace = 64;
ringPadding = 70;
topPadding = 64;

fightDelay = 0.5;

updateCharactersHealth = true;

playerHealth = 0;
npcHealth = 0;

winnerID = 0;

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