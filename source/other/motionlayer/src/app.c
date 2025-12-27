#include "motionlayer.h"
#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/stat.h>
#include <sys/time.h>
#include <unistd.h>

void help(const char *reason) {
  printf("motionlayer [OPTIONS]\n");
  printf("OPTIONS:\n");
  printf("--path      | <char>\n");
  printf("--zoom      | <float>\n");
  printf("--frame-out | <char>\n");
  printf("--randomize |\n");
  printf("--geometry  | <char>");
  printf("            | ^ EG 1920x1080+0+0\n");
  printf("            | |- or <width>x<height>+<margin-left>+<margin-top>\n");

  printf("Example: motionlayer --path \"/backgrounds/video.mp4\" --geometry "
         "\"3840x1080+1920+0\"\n");
  printf("\n%s\n", reason);
}

int valid(const char *path) {
  if (access(path, F_OK) == 0)
    return 0;
  return 1;
}

char *combine(const char *a, const char *b) {
  int size = snprintf(NULL, 0, "%s%s", a, b);
  char *result = (char *)malloc(size + 1);
  snprintf(result, size + 1, "%s%s", a, b);
  return result;
}

int main(const int argc, const char *argv[]) {
  // check for arguments
  if (argc <= 1) {
    help("Path is a requried argument");
    return 1;
  }

  int randomize = 0;
  char *path = NULL;
  double zoom = 1.0;
  char *geometry = NULL;
  char *zoom_char = NULL;
  char *output_path = NULL;

  // process arguments;
  for (int i = 1; i < argc; i++) {
    const char *argl = argv[i];
    const char *argn = argv[i + 1];

    if (strcmp(argl, "--path") == 0) {
      path = (char *)argn;

      i++;
    } else if (strcmp(argl, "--zoom") == 0) {

      zoom = atof(argn);
      if (zoom == 0.00) {
        int size = snprintf(
            NULL, 0,
            "%s is not a valid float\nvalue must be a float greater than 0",
            argn);
        if (size > 0) {
          char *string = (char *)malloc(size + 1);
          snprintf(
              string, size + 1,
              "%s is not a valid float\nvalue must be a float greater than 0",
              argn);
          help(string);
          free(string);
        }
      } else
        zoom_char = (char *)argn;
      i++;
    } else if (strcmp(argl, "--geometry") == 0) {
      geometry = (char *)argn;
      i++;
    } else if (strcmp(argl, "--frame-out") == 0) {
      output_path = (char *)argn;
      i++;
    } else if (strcmp(argl, "--randomize") == 0)
      randomize = 1;
    else {
      // default behavoir
      char *string = combine("Unknown command: ", argl);
      help(string);
      free(string);
      return 1;
    }
  }

  // Validate path
  if (!path) {
    help("Path is a required argument");
    return 1;
  } else {

    // check path exists
    if (valid(path) != 0) {
      int size = snprintf(NULL, 0, "Path: \"%s\" is not a valid path", path);
      if (size > 0) {
        char *string = (char *)malloc(size + 1);
        snprintf(string, size + 1, "Path: \"%s\" is not a valid path", path);
        help(string);
        free(string);
        return 1;
      } else
        return 2;
    } else {

      // check if path is a directory
      struct stat st;
      const int DIRECTORY = (stat(path, &st) == 0) && S_ISDIR(st.st_mode);
      if (DIRECTORY && !randomize) {

        // path is a directory but randomize is not on so we raise help
        int size = snprintf(NULL, 0,
                            "Path: \"%s\" is a directory, use the --randomize "
                            "flag to use a directory",
                            path);
        if (size > 0) {
          char *string = (char *)malloc(size + 1);
          snprintf(string, size + 1,
                   "Path: \"%s\" is a directory, use the --randomize flag to "
                   "use a directory",
                   path);
          help(string);
          free(string);
          return 1;
        } else
          return 2;
      } else if (DIRECTORY) {
        printf("Directory \"%s\" validated\n", path);
      } else {
        printf("File \"%s\" validated\n", path);
      }
    }
  }

  // Validate output dir
  if (output_path == NULL)
    output_path = "./frame.jpg";
  else {
    if (valid(output_path) != 0) {
      int size = snprintf(NULL, 0, "Output path: \"%s\" is not a valid path",
                          output_path);
      if (size > 0) {
        char *string = (char *)malloc(size + 1);
        snprintf(string, size + 1, "Output path: \"%s\" is not a valid path",
                 output_path);
        help(string);
        free(string);
        return 1;
      } else
        return 2;
    }
    /*
      TODO: make the other path validaation block ( above ) into
      an actual function so it can be called for both the path and
      output path
    */
  }

  // handle the randomize flag ( not --shuffle lol )
  if (randomize) {
    DIR *d;
    struct dirent *dir;
    d = opendir(path);
    int count = 0;

    // count the items
    if (d) {
      while ((dir = readdir(d)) != NULL)
        count++;
      if (count == 0) {
        int size = snprintf(NULL, 0, "Directory \"%s\" is empty", path);
        if (size > 0) {
          char *string = (char *)malloc(size + 1);
          snprintf(string, size + 1, "Directory \"%s\" is empty", path);
          help(string);
          free(string);
          return 1;
        } else
          return 2;
      }

      // pick random
      int index = 0;
      struct timeval tv;
      gettimeofday(&tv, NULL);
      unsigned int seed = tv.tv_usec;
      int random = rand_r(&seed) % (count);
      // TODO: fix the issue with rand_r not being detected by ALE

      // rewind dir
      rewinddir(d);

      while ((dir = readdir(d)) != NULL) {
        if (index == random) {
          path = combine(path, (char *)dir->d_name);
        }
        index++;
      }
      closedir(d);
    }
  }

  // make zoom flag
  char *video_zoom = NULL;
  if (zoom_char != NULL)
    video_zoom = combine("--video-zoom=", zoom_char);

  // make geometry flag
  char *video_geometry = NULL;
  if (geometry != NULL)
    video_geometry = combine("--geometry=", geometry);

  // set mpv options
  char *mpv_options[] = {"mpv",
                         "--no-osc",
                         "--no-input-default-bindings",
                         "--no-sub",
                         "--hwdec=vaapi",
                         "--vo=gpu",
                         "--profile=low-latency",
                         "--no-cache",
                         "--video-sync=display-resample",
                         "--cache-secs=30",
                         "--demuxer-thread=yes",
                         "--gpu-api=vulkan",
                         "--framedrop=vo",
                         "--no-config",
                         "--really-quiet=yes",
                         "--fullscreen",
                         "--no-terminal",
                         "--loop=yes",
												 "--mute",
                         (geometry != NULL) ? (char *)video_geometry : "",
                         (zoom_char != NULL) ? (char *)video_zoom : "",
                         path};

  // print info
  const int mpv_options_size = sizeof(mpv_options) / sizeof(mpv_options[0]);
  printf("Setting mpv options:\n");
  for (int i = 0; i < mpv_options_size; i++) {
    printf("%s ", mpv_options[i]);
  }
  printf("\nset %d options\n", mpv_options_size);

  // create the output frame
  get_first_frame(path, output_path);

  // render the video
  set_xwin(mpv_options_size, mpv_options,
           geometry ? geometry : "1920x1080+0+0");

  // clean up
  if (geometry)
    free(video_geometry);
  if (zoom_char)
    free(video_zoom);
  if (randomize)
    free(path);
  return 0;
}
