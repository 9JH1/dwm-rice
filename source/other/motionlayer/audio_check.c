// comp: gcc -o out audio_check.c -lpulse

#include <pulse/pulseaudio.h>
#include <stdio.h>
#include <stdlib.h>

// Callback for sink input info
void sink_input_info_cb(pa_context *c, const pa_sink_input_info *i, int eol, void *userdata) {
    if (eol > 0) return; // End of list
    if (i) {
        // Check if the sink input is running
        if (i->corked == 0) { // Not paused
            printf("Audio playing from client: %s (Sink Input ID: %u)\n",
                   i->name ? i->name : "Unknown",
                   i->index);
        }
    }
}

// Callback for context state changes
void context_state_cb(pa_context *c, void *userdata) {
    pa_mainloop *mainloop = (pa_mainloop *)userdata;
    switch (pa_context_get_state(c)) {
        case PA_CONTEXT_READY:
            // Query sink inputs when context is ready
            pa_context_get_sink_input_info_list(c, sink_input_info_cb, NULL);
            break;
        case PA_CONTEXT_FAILED:
        case PA_CONTEXT_TERMINATED:
            fprintf(stderr, "PulseAudio connection failed or terminated\n");
            pa_mainloop_quit(mainloop, 1);
            break;
        default:
            break;
    }
}

int main() {
    // Initialize mainloop and context
    pa_mainloop *mainloop = pa_mainloop_new();
    if (!mainloop) {
        fprintf(stderr, "Failed to create PulseAudio mainloop\n");
        return 1;
    }

    pa_mainloop_api *mainloop_api = pa_mainloop_get_api(mainloop);
    pa_context *context = pa_context_new(mainloop_api, "AudioCheck");
    if (!context) {
        fprintf(stderr, "Failed to create PulseAudio context\n");
        pa_mainloop_free(mainloop);
        return 1;
    }

    // Connect to PulseAudio server
    if (pa_context_connect(context, NULL, 0, NULL) < 0) {
        fprintf(stderr, "Failed to connect to PulseAudio: %s\n",
                pa_strerror(pa_context_errno(context)));
        pa_context_unref(context);
        pa_mainloop_free(mainloop);
        return 1;
    }

    // Set state callback
    pa_context_set_state_callback(context, context_state_cb, mainloop);

    // Run the mainloop
    int ret;
    if (pa_mainloop_run(mainloop, &ret) < 0) {
        fprintf(stderr, "Failed to run PulseAudio mainloop\n");
    }

    // Cleanup
    pa_context_disconnect(context);
    pa_context_unref(context);
    pa_mainloop_free(mainloop);
    return ret;
}
