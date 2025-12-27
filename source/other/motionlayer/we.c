#include <stdio.h>
#include <stdlib.h>
#include <bsd/string.h>
#include <signal.h>
#include <dirent.h>
#include <sys/time.h>
#include <sys/stat.h>


void help(int fatal){
	printf("wallpaper-engine [OPTIONS] PATH\n");
	printf("OPTIONS:\n");
	printf("--randomize assumes path is a directory and will randomly select a video from it.\n");
	printf("--size-x limit size of video x\n");
	printf("--size-y limit size of video y\n");
	printf("--margin-x set margin of video x\n");
	printf("--margin-y set margin of video y\n");
	printf("--list-mpv-options lists current mpv arguments\n");
	printf("--list-xwinwrap-options list current xwinwrap arguments\n");
	printf("--quiet wont print any output\n");
	printf("--zoom set zoom of video\n");
	printf("--volume set the volume of the video\n");
	printf("--verbose shows more information when running\n");
	printf("--set-mpv-options sets the mpv arguments\n");
	printf("--set-xwinwrap-options sets the xwinwrap arguments\n");
	printf("--append-mpv-options appends to mpv arguments\n");
	printf("--append-xwinwrap-options appends to xwinwrap arguments\n");
	printf("OPTIONS -> METHODS:\n");
	printf("@KILL, @PAUSE, @MUTE, @PAUSE_MUTE,");
	printf("--method-fullscreen\n");
	printf("--method-audio\n");
	printf("--method-locked\n");
	printf("--method-locked-program\n");
	printf("--speed\n");
	if(fatal) exit(0);
}

void quit(){
	printf("\033[25hCtrl+C Pressed, Exiting..");
	exit(0);
}

// weird checks if the number is 
// valid without changing type.
char *eatoi(char *string){
	int out=0;
	out=atoi(string);
	if(out==0 && strcmp(string,"0")!=0){
		printf("Error occured %s is not a number\n",string);
		exit(1);
	}
	return string;
}

int end(char *str, char *end){
	for(int i=strlen(str)-strlen(end);i<strlen(str);i++){
		if(str[i] != end[i - strlen(str)+strlen(end)]) return 1;
	}
	return 0;
}
#define get_index(array,target) getIndex_impl(array,sizeof(array)/sizeof(array[0]),target)
int getIndex_impl(char *array[],size_t size,char *target){
	for(int i=0;i<size;i++){
		if(strcmp(target,array[i])==0){
			return i;
		} else {
			printf("%s != %s\n",target,array[i]);
		}
	}
	return -1;
}

// global vars
int verbose              =  0,
		quiet                =  0;
int main(int argc, char *argv[]){

	// base config ints
	char *volume = "0",
			*size_x = "1920",
			*size_y= "1080",
			*margin_x = "+0",
			*margin_y = "+0",
			*speed = "1",
			*zoom = "0";
	int	randomize = 0,
			method_fullscreen = -1,
			method_audio = -1,
			method_locked = -1,
			show_mpv_options = 0,
			show_xwinwrap_options = 0;

	// base config chars
	char mpv_options[256*2] = "--vo=gpu --loop --no-sub --no-terminal --no-input-default-bindings --no-config --hwdec=auto --profile=low-latency --no-osc --no-cache --video-sync=display-resample --framedrop=vo ",
			 xwinwrap_options[256] = "-st -sp -s -fdt -ni -b -nf -un -ov ",
			 method_locked_program[256]="",
			 file_target[256]="";

	// method array for later
	char *method_list[]={
		"KILL",
		"PAUSE",
		"MUTE",
		"PAUSE_MUTE"
	};	
	signal(SIGINT,quit);

	// start argument loop
	if(argc>1){
		for(int i=1;i<argc;i++){
			char *argl = argv[i];
			char *argn = "";

			if(argv[i+1]){ 
				argn = argv[i+1];
			}
				if(strcmp(argl,"--size-x")==0) size_x = eatoi(argn);
				else if(strcmp(argl,"--list-mpv-options")==0) show_mpv_options=1;
				else if(strcmp(argl,"--list-xwinwrap-options")==0) show_xwinwrap_options=1;
				else if(strcmp(argl,"--randomize")==0) randomize=1;
				else if(strcmp(argl,"--quiet")==0) quiet=1;
				else if(strcmp(argl,"--verbose")==0) verbose=1;
				else if(strcmp(argl, "--help")==0) help(1);
				else if(strcmp(argl, "--size-y")==0) size_y = eatoi(argn);
				else if(strcmp(argl, "--margin-x")==0) margin_x = eatoi(argn);
				else if(strcmp(argl, "--margin-y")==0) margin_y = eatoi(argn);
				else if(strcmp(argl, "--zoom")==0) zoom = eatoi(argn);
				else if(strcmp(argl,"--volume")==0) volume = eatoi(argn);
				else if(strcmp(argl,"--set-mpv-options")==0) strlcpy(mpv_options,argn,sizeof(mpv_options));
				else if(strcmp(argl,"--set-xwinwrap-options")==0) strlcpy(xwinwrap_options,argn,sizeof(xwinwrap_options));
				else if(strcmp(argl,"--append-mpv-options")==0) strlcat(mpv_options,argn,sizeof(mpv_options));
				else if(strcmp(argl,"--append-xwinwrap-options")==0) strlcat(xwinwrap_options,argn,sizeof(xwinwrap_options));
				else if(strcmp(argl,"--speed")==0) speed = eatoi(argn);
				else if(strcmp(argl,"--method-locked-program")==0) strlcpy(method_locked_program,argn,sizeof(method_locked_program));
				else if(strcmp(argl,"--path")==0) strlcpy(file_target,argn,sizeof(file_target));
				else if(strcmp(argl,"--method-fullscreen")==0){
					method_fullscreen = get_index(method_list,argn);
					if(method_fullscreen==-1){
						printf("Error occured \"%s\" is not a known method_audio\n",argn);
						exit(1);
					}
				} else if(strcmp(argl,"--method-locked")==0){
					method_locked = get_index(method_list,argn);
					if(method_locked == -1){
						printf("Error occured \"%s\" is not a known method_locked\n",argn);
						exit(1);
					}
				}
		}
	} else help(1);

	if(show_mpv_options){

		// list mpv_options
		printf("MPV options:\n");
		for(int ii=0;ii<strlen(mpv_options);ii++){
			if(mpv_options[ii] == ' ') printf("\n");
			else printf("%c",mpv_options[ii]);
		}
		printf("\n");
	} 
	if(show_xwinwrap_options){

		// list xwinwrap_options
		printf("Base xwinwrap options:\n");
		for(int ii=0;ii<strlen(xwinwrap_options);ii++){
			if(xwinwrap_options[ii] == ' ') printf("\n");
			else printf("%c",xwinwrap_options[ii]);
		}
		printf("\n");
	}
	// * * * * END OF ARGUMENT PROCCESSING * * * *
	if(strlen(file_target)==0) {
		printf("Error occured --path is undefined\n");
		exit(1);
	}
	
	// randomizer
	int file_count=0;
	if(randomize){
		DIR *d=NULL;
		struct dirent *dir;
		d = opendir(file_target);
		char allowed[4][5] = {
			".avi",
			".mp4",
			".mkv",
			".gif",
		};
		if(d) {
			while((dir = readdir(d)) != NULL){
				if(strcmp(dir->d_name,".")!=0 && strcmp(dir->d_name,"..")!=0){
					for(int i=0;i<sizeof(allowed)/sizeof(allowed[0]);i++){
						if(end(dir->d_name,allowed[i])==0){
							file_count++;
						}
					} 
				}
			}
			int random_file_target=0; 

			if(file_count > 0){
				struct timeval tv;
				gettimeofday(&tv,NULL);
				unsigned int seed=tv.tv_usec;
				random_file_target = rand_r(&seed)%file_count+1;
			}
			int local_file_count=0;
			d = opendir(file_target);
			while((dir = readdir(d)) != NULL){
				if(strcmp(dir->d_name,".")!=0 && strcmp(dir->d_name,"..")!=0){
					if(local_file_count == random_file_target){
						strlcat(file_target,"/",sizeof(file_target));
						strlcat(file_target,dir->d_name,sizeof(file_target));
						break;
					} else {
						local_file_count++;
					}
				}
			}
		} else {
			printf("something went wrong\n");
		}
	}
	struct stat buffer;
	if(stat(file_target,&buffer)!=0){
		printf("Error occured file %s dosent exist\n",file_target);
		exit(1);
	} else if (S_ISDIR(buffer.st_mode) && randomize==0){
		printf("Error occured file %s is a folder\n",file_target);
		exit(1);
	}

	// * * * * ERROR CHECKING AND RANDOMIZATION COMPLETE * * * *
	int xwinwrap_final_size=0;
	xwinwrap_final_size+=strlen(xwinwrap_options);
	xwinwrap_final_size+=strlen(size_x);
	xwinwrap_final_size+=strlen(size_y);
	xwinwrap_final_size+=strlen(margin_x);
	xwinwrap_final_size+=strlen(margin_y);
	xwinwrap_final_size+=strlen("xwinwrap -g x  -- ");
	char xwinwrap_final_command[xwinwrap_final_size+1];
	snprintf(xwinwrap_final_command,xwinwrap_final_size+1,"xwinwrap -g %sx%s%s%s %s -- ",size_x,size_y,margin_x,margin_y,xwinwrap_options);

	int mpv_final_size=0;
	mpv_final_size+=strlen(mpv_options);
	mpv_final_size+=strlen(zoom);
	mpv_final_size+=strlen(volume);
	mpv_final_size+=strlen(speed);
	mpv_final_size+=strlen("mpv --volume= --speed= --video-zoom");
	char mpv_final_command[mpv_final_size+1];
	snprintf(mpv_final_command,mpv_final_size+1,"mpv --volume=%s --speed=%s --video-zoom=%s %s ",volume,speed,zoom,mpv_options);
	
	int final_size=0;
	final_size+=strlen(xwinwrap_final_command);
	final_size+=strlen(mpv_final_command);
	final_size+=strlen(file_target);
	char final_command[final_size+1];
	snprintf(final_command,final_size+1,"%s%s \"%s\"",xwinwrap_final_command,mpv_final_command,file_target);

	printf("%s\n",final_command);
	return 0;
}
