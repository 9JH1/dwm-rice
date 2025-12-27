// comp: gcc -o out check_fullscreen.c -lX11 -lXinerama
#include <X11/Xlib.h>
#include <X11/extensions/Xinerama.h>
#include <X11/Xatom.h>
#include <stdio.h>
#include <stdlib.h>

void list_and_check_fullscreen_windows(Display *display, Window root) {
    // Get Xinerama screens
    int num_screens;
    XineramaScreenInfo *screens = XineramaQueryScreens(display, &num_screens);
    if (!screens) {
        fprintf(stderr, "Xinerama not active or failed to query screens\n");
        return;
    }

    // Get _NET_WM_STATE and _NET_WM_STATE_FULLSCREEN atoms
    Atom net_wm_state = XInternAtom(display, "_NET_WM_STATE", False);
    Atom fullscreen_atom = XInternAtom(display, "_NET_WM_STATE_FULLSCREEN", False);

    // Get all windows
    Window parent, *children;
    unsigned int nchildren;
    if (!XQueryTree(display, root, &root, &parent, &children, &nchildren)) {
        fprintf(stderr, "Failed to query window tree\n");
        XFree(screens);
        return;
    }

    printf("List of all window IDs across all monitors:\n");
    // Iterate through all windows
    for (unsigned int i = 0; i < nchildren; i++) {
        XWindowAttributes attrs;
        if (!XGetWindowAttributes(display, children[i], &attrs) || 
            attrs.map_state != IsViewable) {
            continue; // Skip unmapped or invisible windows
        }

        // Print window ID and name
        char *window_name;
        if (XFetchName(display, children[i], &window_name) && window_name) {
            printf("Window ID: 0x%lx, Name: %s\n", children[i], window_name);
            XFree(window_name);
        } else {
            printf("Window ID: 0x%lx, Name: (Unnamed)\n", children[i]);
        }

        // Check for fullscreen via _NET_WM_STATE
        Atom actual_type;
        int actual_format;
        unsigned long nitems, bytes_after;
        unsigned char *prop = NULL;
        int status = XGetWindowProperty(display, children[i], net_wm_state, 0, 1024,
                                        False, XA_ATOM, &actual_type, &actual_format,
                                        &nitems, &bytes_after, &prop);
        int is_fullscreen = 0;
        if (status == Success && prop && actual_type == XA_ATOM) {
            for (unsigned long j = 0; j < nitems; j++) {
                if (((Atom *)prop)[j] == fullscreen_atom) {
                    is_fullscreen = 1;
                    break;
                }
            }
            XFree(prop);
        }

        // Check geometry against each screen
        if (!is_fullscreen) {
            for (int s = 0; s < num_screens; s++) {
                if (attrs.x == screens[s].x_org && 
                    attrs.y == screens[s].y_org &&
                    attrs.width == screens[s].width &&
                    attrs.height == screens[s].height) {
                    is_fullscreen = 1;
                    break;
                }
            }
        }

        // Report fullscreen status
        if (is_fullscreen) {
            char *window_name;
            if (XFetchName(display, children[i], &window_name) && window_name) {
                printf("  -> Fullscreen on screen %d: %s (ID: 0x%lx)\n", 
                       is_fullscreen ? -1 : 0, window_name, children[i]);
                XFree(window_name);
            } else {
                printf("  -> Fullscreen on screen %d: (Unnamed, ID: 0x%lx)\n", 
                       is_fullscreen ? -1 : 0, children[i]);
            }
        }
    }

    // Free resources
    if (children) {
        XFree(children);
    }
    XFree(screens);
}

int main() {
    // Open connection to X server
    Display *display = XOpenDisplay(NULL);
    if (!display) {
        fprintf(stderr, "Cannot open display\n");
        return 1;
    }

    // Check if Xinerama is active
    int xin_event, xin_error;
    if (!XineramaQueryExtension(display, &xin_event, &xin_error) || 
        !XineramaIsActive(display)) {
        fprintf(stderr, "Xinerama extension not available\n");
        XCloseDisplay(display);
        return 1;
    }

    // Get root window
    Window root = DefaultRootWindow(display);

    // List windows and check for fullscreen
    list_and_check_fullscreen_windows(display, root);

    // Close connection
    XCloseDisplay(display);
    return 0;
}
