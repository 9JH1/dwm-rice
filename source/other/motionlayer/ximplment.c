#include <X11/Xlib.h>
#include <X11/Xatom.h>

#include <X11/extensions/shape.h>

#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/stat.h>
#include <sys/types.h>

#define ATOM(a) XInternAtom(display, #a, False)

Display *display = NULL;
int display_width;
int display_height;
int screen;

static pid_t pid = 0;


static Window find_subwindow(Window win, int w, int h) {
  unsigned int i, j;
  Window troot, parent, *children;
  unsigned int n;

  /* search subwindows with same size as display or work area */

  for (i = 0; i < 10; i++) {
    XQueryTree(display, win, &troot, &parent, &children, &n);

    for (j = 0; j < n; j++) {
      XWindowAttributes attrs;

      if (XGetWindowAttributes(display, children[j], &attrs)) {
        /* Window must be mapped and same size as display or
         * work space */
        if (attrs.map_state != 0 &&
            ((attrs.width == display_width && attrs.height == display_height) ||
             (attrs.width == w && attrs.height == h))) {
          win = children[j];
          break;
        }
      }
    }

    XFree(children);
    if (j == n) {
      break;
    }
  }

  return win;
}

static Window find_desktop_window(Window *p_root, Window *p_desktop) {
  Atom type;
  int format, i;
  unsigned long nitems, bytes;
  unsigned int n;
  Window root = RootWindow(display, screen);
  Window win = root;
  Window troot, parent, *children;
  unsigned char *buf = NULL;

  if (!p_root || !p_desktop) {
    return 0;
  }

  /* some window managers set __SWM_VROOT to some child of root window */

  XQueryTree(display, root, &troot, &parent, &children, &n);
  for (i = 0; i < (int)n; i++) {
    if (XGetWindowProperty(display, children[i], ATOM(__SWM_VROOT), 0, 1, False,
                           XA_WINDOW, &type, &format, &nitems, &bytes,
                           &buf) == Success &&
        type == XA_WINDOW) {
      win = *(Window *)buf;
      XFree(buf);
      XFree(children);
      fflush(stderr);
      *p_root = win;
      *p_desktop = win;
      return win;
    }

    if (buf) {
      XFree(buf);
      buf = 0;
    }
  }
  XFree(children);

  /* get subwindows from root */
  win = find_subwindow(root, -1, -1);

  display_width = DisplayWidth(display, screen);
  display_height = DisplayHeight(display, screen);

  win = find_subwindow(win, display_width, display_height);

  if (buf) {
    XFree(buf);
    buf = 0;
  }

  fflush(stderr);

  *p_root = root;
  *p_desktop = win;

  return win;
}


struct window {
  Window root, window, desktop;
  Drawable drawable;
  Visual *visual;
  Colormap colourmap;

  unsigned int width;
  unsigned int height;
  int x;
  int y;
} window;


int set_xwin(int array_size, char *array[], char *geometry) {
  char *endArg = NULL;
  char widArg[256]; // Buffer for window ID
  int status = 0;
  char *arguments[array_size + 3]; // array_size + "-wid" + widArg + NULL

  window.width = 100;
  window.height = 100;

  XParseGeometry(geometry, &window.x, &window.y, &window.width, &window.height);

  // Copy input arguments
  for (int i = 0; i < array_size; i++) {
    arguments[i] = array[i];
  }
	
	display = XOpenDisplay(NULL);
  screen = DefaultScreen(display);
  display_width = DisplayWidth(display, screen);
  display_height = DisplayHeight(display, screen);
  if (!display)
    return 1;

  int depth = 0, flags = CWOverrideRedirect | CWBackingStore;
  Visual *visual = NULL;

  if (!find_desktop_window(&window.root, &window.desktop)) {
    printf("Error: couldn't find desktop window\n");
    return 1;
  }

  window.visual = DefaultVisual(display, screen);
  window.colourmap = DefaultColormap(display, screen);

  // set_bypass_compositor(display, window.desktop);
  depth = CopyFromParent;
  visual = CopyFromParent;

  /* An override_redirect True window.
   * No WM hints or button processing needed. */
  XSetWindowAttributes attrs = {
      ParentRelative, 0L, 0, 0L, 0, 0, Always, 0L, 0L, False,
      StructureNotifyMask | ExposureMask, 0L, True, 0, 0};

  flags |= CWBackPixel;

  window.window = XCreateWindow(display, window.desktop, window.x, window.y,
                                window.width, window.height, 0, depth,
                                InputOutput, visual, flags, &attrs);
  XLowerWindow(display, window.window);

  Region region = XCreateRegion();
  if (region) {
    XShapeCombineRegion(display, window.window, ShapeInput, 0, 0, region, ShapeSet);
    XDestroyRegion(region);
  }

  XMapWindow(display, window.window);
  XSync(display, window.window);

  // Populate arguments array
  arguments[array_size] = "-wid"; // Add -wid flag
  sprintf(widArg, "0x%x", (int)window.window); // Format window ID
  arguments[array_size + 1] = widArg; // Add window ID
  arguments[array_size + 2] = endArg; // NULL terminator
	printf("starting program\n"); 
  pid = fork();

  switch (pid) {
  case -1:
    perror("fork");
    return 1;
  case 0:
    execvp(arguments[0], arguments);
    perror(arguments[0]);
    exit(2);
    break;
  default:
    break;
  }

  for (;;) {
    if (waitpid(pid, &status, 0) != -1) {
      if (WIFEXITED(status))
        fprintf(stderr, "%s died, exit status %d\n", arguments[0],
                WEXITSTATUS(status));
      break;
    }
  }

  XDestroyWindow(display, window.window);
  XCloseDisplay(display);

  return 0;
}
