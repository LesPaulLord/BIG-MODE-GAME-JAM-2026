


if(updateCharactersHealth)
{
	var _player = Sequence_Manager.characters[0]
	var _npc = Sequence_Manager.characters[1]
	
	playerHealth = _player.characterHealth;
	npcHealth = _npc.characterHealth;
	updateCharactersHealth = false;
}

draw_set_alpha(1);
draw_set_color(c_black);
draw_set_font(Font_currentState);
	
draw_text(15, 15, string(playerHealth))
draw_text(window_get_width() - 50, 15, string(npcHealth))


if(gameOver)
{
	var _winner = winnerID == 1 ? "Turkey" : "Stout";	
	var _center = GetMiddleOfScreen();
	
	draw_text(_center[0], _center[1] - 45, _winner + " VICTORY!")
}
