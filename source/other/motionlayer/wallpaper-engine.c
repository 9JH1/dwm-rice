#include <stdio.h>
#include <string.h> 
#include <stdlib.h>
#include <unistd.h>
#include <dirent.h>
#include <sys/time.h>
void help(){
	printf("wallpaper-engine is a lightweight video wallpaper setter made using xwinwrap and mpv");
	printf("wallpaper-engine [OPTIONS]\n");
	printf("  --path         -p   | path to video\n");
	printf("  --random-path  -rp  | select random video from dir\n");
	printf("  --margin-y     -my  | video top margin with a + or a -\n");
	printf("  --margin-x     -mx  | video left margin with a + or a -\n");
	printf("  --size-y       -sy  | video container size y (px eg 1080)\n");
	printf("  --size-x       -sx  | video container size x (px eg 1920)\n");
	printf("  --zoom         -z   | video zoom\n");
	printf("  --volume       -v   | video volume \n");
	printf("  --placement    -vp  | video placement\n");
	printf("    options are:\n");
	printf("    top-left\n");
	printf("    top-right\n");
	printf("    bottom-left\n");
	printf("    bottom-right\n\n");
	printf("  --mpv-options       | set mpv arguments\n");
	printf("  --xwinwrap-options  | set xwinwrap arguments\n");
	exit(1);
}
char *ratoi(int number){
	char out[sizeof(number)];
	sprintf(out,"%d",number);
	char *out2 = strtok(out,"");
	printf("%s\n",out2);
	return out2;	
}


int endsWith(char *string,char *end){
	int endSize=strlen(end);
	int stringSize=strlen(string);
	for(int i=stringSize-endSize;i<stringSize;i++){
		if(string[i] != end[i-stringSize+endSize]){
			return 1;
  	}
  }
	return 0;
}

int main(int argc, char *argv[]){
	//handle the many arguments 
	// --path -p
	// --margin-y -my
	// --margin-x -mx
	// --start-pos-y -sy
	// --start-pos-x -sx
	// --zoom -z
	// --volume -v 
	// --placement -vp
	// --mpv-help
	// --xwinwrap-help
	char *path="",
			 *placement="",
			 *xwinwrapOptions="-st -sp -s -fdt -ni -b -nf -un -ov",
			 *mpvOptions="-wid WID --vo=gpu --loop --no-sub --no-terminal --no-input-default-bindings --no-config --hwdec=auto --vo=gpu --profile=low-latency --no-audio --no-osc --no-cache --video-sync=display-resample --framedrop=vo", 
			 *randomPath="",
			 *marginX="",
			 *marginY="";

	int sizeY=1080,
			sizeX=1920,
			volume=0;
	double zoom=1.0;

	for(int i=1;i<argc;i++){
		char *argl=argv[i];
		char *argn=argv[i+1];

		if(strcmp(argl,"--path")==0 || strcmp(argl,"-p")==0){
			path=argn;i++;
		} else if (strcmp(argl,"--margin-y")==0 || strcmp(argl,"-my")==0){
			marginY = argn;i++;
		} else if (strcmp(argl,"--margin-x")==0 || strcmp(argl,"-mx")==0){
			marginX = argn;i++;
		} else if (strcmp(argl,"--size-y")==0 || strcmp(argl,"-sy")==0){
			sizeY = atoi(argn);i++;
		} else if (strcmp(argl,"--size-x")==0 || strcmp(argl,"-sx")==0){
			sizeX = atoi(argn);i++;
		} else if (strcmp(argl,"--zoom")==0 || strcmp(argl,"-z")==0){
			zoom = atof(argn);i++;
		} else if (strcmp(argl,"--volume")==0 || strcmp(argl,"-v")==0){
			volume=atoi(argn);i++;
		} else if ( strcmp(argl,"--placement")==0 || strcmp(argl, "-vp")==0){
			placement=argn;i++;
		} else if( strcmp(argl,"--mpv-options")==0) {
			mpvOptions = argn;i++;
		} else if (strcmp(argl,"--xwinwrap-options")==0) {
			xwinwrapOptions = argn;i++;
		} else if (strcmp(argl,"--random-path")==0 || strcmp(argl,"-rp")==0){
			randomPath = argn;i++;
		} else {
			help();
		}

	} 
	if(strlen(randomPath)>0){
		DIR *d;
		struct dirent *dir;
		d = opendir(randomPath);
		int fileCounter=0;
		char allowedExt[3][5] = {
				".avi",
				".mp4",
				".mkv",
		};
		if(d) {
			while((dir = readdir(d)) !=NULL){
				if(strcmp(dir->d_name,".")==0 || strcmp(dir->d_name,"..")==0){}else{
					for(int i=0;i<sizeof(allowedExt)/sizeof(allowedExt[0]);i++){
						if(endsWith(dir->d_name,allowedExt[i])==0){
							fileCounter++;
						}
					}
				}
			}
			struct timeval tv;
			gettimeofday(&tv,NULL);
			unsigned int seed=tv.tv_usec;
			int randFile = rand_r(&seed)%(fileCounter)+1; 
			int localFileCount=0;
			d = opendir(randomPath);	
			while((dir=readdir(d))!=NULL){
				if(localFileCount==randFile){
					path = malloc(strlen(dir->d_name) + strlen(randomPath) +1);
					snprintf(path,strlen(randomPath)+strlen(dir->d_name)+1,"%s%s",randomPath,dir->d_name);	
					break;
				} 
				localFileCount++;
			}	

			closedir(d);
		}					
	}
	if(!(strlen(path)>0)){
		help();
	}
	int resultSize;
	resultSize += strlen("xwinwrap -g x -- mpv  --volume --speed --video-zoom ");
	resultSize +=sizeof(sizeX);
	resultSize +=sizeof(sizeY);
	resultSize +=sizeof(marginX);
	resultSize +=sizeof(marginY);
	resultSize +=strlen(xwinwrapOptions);
	resultSize +=strlen(mpvOptions);
	resultSize += sizeof(volume);
	resultSize += sizeof(zoom);
	resultSize += strlen(path);
	char *result=malloc(resultSize+1);
	if(!result){
		help();
	}

	snprintf(result,resultSize+1,"xwinwrap -g %dx%d%s%s %s -- mpv %s --volume=%d --speed=1 --video-zoom=%.2f \"%s\"",
									sizeX, sizeY, marginX, marginY, xwinwrapOptions, mpvOptions, volume, zoom, path);
	printf("%s\n",result);
	system(result);
	free(result);

