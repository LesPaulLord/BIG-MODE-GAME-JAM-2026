

if(currentTimer < length)
{
	currentTimer += delta_time/1000000;
	
	var _ratio = currentTimer/length;
	image_index = _ratio / image_number;
}
else
{
	instance_destroy(self);
}