#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void help(){
	printf("OPTIONS: \n--geometry : set geometry <width>x<height>+<margintop>+<marginleft>, \n--output-path : set the output frame path, \n--randomize if --path is a directory then randomize items, \n--path : set the path to directory / file, \n--loop : loop the video selected ( this can be a dir ), \n--video-zoom 1.0-0.0, \n--video-volume 0-100\n");
}

int main(const int argc, const char *argv[]){
	if(argc <= 1) help();
	else {	
		char *video_path = "";
		char *video_geometry = "1920x1080+0+0";
		char *frame_output_path = "./frame.jpg";
		char *video_zoom = "1.0";
		char *video_volume = "0";
		int loop = 0;
		int randomize = 0;

		for(int i=1;i<argc;i++){
			char* argl = (char *)argv[i];
			char* argn = (char *)argv[i+1];

			if(strcmp(argl,"--path")==0){
				video_path = argn;
			} else if (strcmp(argl, "--geometry")==0){
				video_geometry = argn;
			} else if (strcmp(argl, "--output-path")==0){
				frame_output_path = argn;
			} else if (strcmp(argl, "--video-zoom")){
				video_zoom = argn; 
			} else if (strcmp(argl,"--video-volume")==0){
				video_volume = argn;
			} else if (strcmp(argl,"--loop")==0){
				loop = 1;
			} else if (strcmp(argl,"--randomize")){
				randomize = 1;
			}
		}

		if(strlen(video_path)<= 0){
			printf("path \"%s\" is invalid\n",video_path);
			exit(1);
		} else if (validate_path(video_path)!=0) exit(1);


		if(randomize) if(randompath(video_path)!=0) exit(1);

		char* video_loop_char = loop ? "--loop=yes" : "--loop=no";
		video_zoom = combine("--video-zoom=",video_zoom);	
		video_geometry = combine("--geometry=",video_geometry);	
		
		if(strcmp(video_volume,"0")==0) video_volume = "--mute";
		else video_volume = combine("--volume=",video_volume);
		
		/* add quotes on video path 
		int video_path_size = snprintf(NULL,0,"\"%s\"",video_path);
		char *video_path_char = malloc(video_path_size+1);
		snprintf(video_path_char,video_path_size+1,"\"%s\"",video_path);
		*/
		
		
		for(int i=0;i<21;i++){
			printf("set mpv option: %s\n",mpv_options[i]);
		}

		get_first_frame(video_path, frame_output_path);
		set_xwin(21, mpv_options, video_geometry);

		free(video_zoom);
		free(video_geometry);
		free(video_path);
		//free(video_path_char);

		if(strcmp(video_volume,"0") != 0) free(video_volume);
		
		return 0;
	}
	return 1;
}
