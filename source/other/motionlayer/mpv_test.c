#include <stdio.h>
#include <mpv/client.h>

int main() {
    // Create mpv context
    mpv_handle *mpv = mpv_create();
    if (!mpv) {
        fprintf(stderr, "Failed to create mpv context\n");
        return -1;
    }

    // Set fullscreen option before initialization
    if (mpv_set_option_string(mpv, "fullscreen", "yes") < 0) {
        fprintf(stderr, "Failed to set fullscreen option\n");
        mpv_terminate_destroy(mpv);
        return -1;
    }

    // Initialize mpv
    if (mpv_initialize(mpv) < 0) {
        fprintf(stderr, "Failed to initialize mpv\n");
        mpv_terminate_destroy(mpv);
        return -1;
    }

    // Load the file "wallpaper_test.mpv"
    const char *cmd[] = {"loadfile", "wallpaper_test.mp4", NULL};
    if (mpv_command(mpv, cmd) < 0) {
        fprintf(stderr, "Failed to load file\n");
        mpv_terminate_destroy(mpv);
        return -1;
    }

    // Wait some time to let mpv play the file (simple approach)
    // In a real app, you'd handle events properly.
    printf("Playing wallpaper_test.mpv in fullscreen. Press Enter to quit.\n");
    getchar();

    // Cleanup
    mpv_terminate_destroy(mpv);
    return 0;
}

