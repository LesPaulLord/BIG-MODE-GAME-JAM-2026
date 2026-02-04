
var _otherChar = Sequence_Manager.characters[1-characterID];							
var _fallChanceDir = false;

if(falling)
{
	_fallChanceDir = choose(true, false);
}
							
if(currentActionType == ActionType.moveLeft || falling && _fallChanceDir)
{
	//show_message("from right");
	_otherChar.goalPos[0] = _otherChar.x - Game_Manager.gridSpace;
	_otherChar.goalPos[1] = floorY;
}
else if(currentActionType == ActionType.moveRight  || falling)
{
	//show_message("from left");
	_otherChar.goalPos[0] = _otherChar.x + Game_Manager.gridSpace;
	_otherChar.goalPos[1] = floorY;
}		
					
							
_otherChar.PerformAction(ActionType.knockBack, Sequence_Manager.currentActionLength/2)

alarm[5] = 20;						

instance_create_layer(x, y -30, "Instances", FX_stars);