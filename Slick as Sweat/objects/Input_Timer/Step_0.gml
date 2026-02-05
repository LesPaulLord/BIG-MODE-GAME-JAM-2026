

if(currentTimer < length)
{
	currentTimer += delta_time/1000000;
	
	var _ratio = currentTimer/length;
	image_index = (image_number - 1) * (1 - _ratio);
}
else
{
	image_index = 0;
	instance_destroy(self);
}