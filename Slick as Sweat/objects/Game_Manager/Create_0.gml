gridSpace = 64;
ringPadding = 66;
topPadding = 64;

actionInitialLength = 0.15;
fightDelay = 0.5;

actionCurrentLength = actionInitialLength;
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