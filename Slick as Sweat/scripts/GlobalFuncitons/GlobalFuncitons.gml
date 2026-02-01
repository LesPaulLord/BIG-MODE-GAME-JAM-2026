function GetMiddleOfScreen()
{
	var _center = [0,0];
	_center[0] = camera_get_view_width(view_camera[0]) / 2;
	_center[1] = camera_get_view_height(view_camera[0]) / 2;
	
	return _center;
}