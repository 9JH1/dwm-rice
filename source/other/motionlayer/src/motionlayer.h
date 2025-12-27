#ifndef MOTIONLAYER_H
	/* Executed if someone trys to include 
	 * PLIB in the same file twice */

#define MOTIONLAYER_H
	int get_first_frame(char *video_path, char *output_path);
	int set_xwin(const int array_size, char **array, const char *geometry);
	int randompath(char *path);
#endif // PLIB_H
