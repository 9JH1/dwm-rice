static const int altbar_extra_padding = 10;
static const unsigned int snap = 0;
static const int gappx = 10;
static const int showbar = 1;
static const int topbar = 1;
static const int usealtbar = 1;
static const int nmaster = 1;
static const int resizehints = 0;
static const float mfact = 0.5;
static const int lockfullscreen = 0;
static const unsigned int borderpx = 3;
static const char *altbarclass = "Polybar";
static const char *alttrayname = "snixembed";
static const char *altbarcmd = "$HOME/.dwm/src/polybar.sh no-run";
static const char *fonts[] = {"monospace:size=20"};
static const char *dmenucmd[] = {"/home/_3hy/.dwm/src/launcher.sh", NULL};
static const char *togglebaralt[] = {"/home/_3hy/.dwm/src/polybar.sh",
                                     "--toggle", NULL};
static const char *termcmd[] = {"/home/_3hy/.dwm/src/term.sh", NULL};
static const char *termcmdalt[] = {"/home/_3hy/.dwm/src/term.sh",
                                   "-isolate", NULL};
static const char *wallpaper_safe[] = {"/home/_3hy/.dwm/src/wal.sh",
                                       "--exclude-hidden", NULL};
static const char *screenshot[] = {"/home/_3hy/.dwm/src/screenshot.sh", NULL};
static const char *boomer[] = {"boomer", NULL};
static const char *forcequit[] = {"/home/_3hy/.dwm/src/forcequit.sh", NULL};
static const char *picomtoggle[] = {"/home/_3hy/.dwm/src/picom.sh", NULL};
static const char *lock[] = {"/home/_3hy/.dwm/src/lock.sh", NULL};
static const char *lock_alt[] = {"/home/_3hy/.dwm/src/lock.sh", "--image",
                                 NULL};
static const char *lock_alt_alt[] = {"/home/_3hy/.dwm/src/lock.sh", "--image",
                                     NULL};
static const char *voldown[] = {"pactl", "set-sink-volume", "@DEFAULT_SINK@",
                                "-1%", NULL};
static const char *volup[] = {"pactl", "set-sink-volume", "@DEFAULT_SINK@",
                              "+1%", NULL};
static const char *mute[] = {"pactl", "set-sink-mute", "@DEFAULT_SINK@",
                             "toggle", NULL};
static const char *brightnessup[] = {"brightnessctl", "set", "+1%", NULL};
static const char *brightnessdown[] = {"brightnessctl", "set", "1%-", NULL};
static const char *pause_toggle[] = {"playerctl", "play-pause", NULL};
static const char *forward[] = {"playerctl", "next", NULL};
static const char *backward[] = {"playerctl", "previous", NULL};

static const unsigned int tabModKey = 0x40;
static const unsigned int tabCycleKey = 0x17;

static const char *const autostart[] = {"/home/_3hy/.dwm/src/autostart.sh",
                                        NULL, NULL};

static const char *autostartcmd[] = {autostart[0], NULL};

#include <X11/XF86keysym.h>

// im a basic bitch ok?
static const Layout layouts[] = {
    {"[]=", tile},
    {"[M]", monocle},
    {"><>", NULL},
    {NULL, NULL},
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY, TAG)                                                      \
  {MODKEY, KEY, view, {.ui = 1 << TAG}},                                       \
  {MODKEY | ControlMask, KEY, tagandview, {.ui = 1 << TAG}},               \
  {MODKEY | ShiftMask, KEY, tag, {.ui = 1 << TAG}},                        \

const KeySym key_up    = XK_k;
const KeySym key_down  = XK_j;
const KeySym key_left  = XK_h;
const KeySym key_right = XK_l;

static const Key keys[] = {
		// execs
    {MODKEY, XK_r, spawn, {.v = dmenucmd}},
    {MODKEY, XK_Return, spawn, {.v = termcmd}},
    {MODKEY | ShiftMask, XK_Return, spawn, {.v = termcmdalt}},
    {MODKEY, XK_t, spawn, {.v = wallpaper_safe}},
    {MODKEY, XK_x, spawn, {.v = lock}},
    {MODKEY | ShiftMask, XK_s, spawn, {.v = screenshot}},
    {MODKEY | ShiftMask, XK_r, spawn, {.v = autostartcmd}},
    {MODKEY, XK_m, spawn, {.v = lock_alt}},
		{MODKEY | ShiftMask, XK_b, spawn, {.v = picomtoggle}},
    {MODKEY | ControlMask, XK_x, spawn, {.v = lock_alt_alt}},
    {MODKEY | ShiftMask, XK_q, spawn, {.v = forcequit}},
    {MODKEY, XK_z, spawn, {.v = boomer}},
    {MODKEY, XK_v, spawn, {.v = togglebaralt}},


    {MODKEY | ShiftMask, XK_i, incnmaster, {.i = -1}},

		/*{MODKEY, XK_o, winview, {0}}, */
    {Mod1Mask, XK_Tab, alttab, {0}},
    {MODKEY, XK_q, killclient, {0}},
    {MODKEY | ShiftMask, XK_space, togglefloating, {0}},
    {MODKEY | ShiftMask, XK_0, tag, {.ui = ~0}},
    {MODKEY | ControlMask, XK_Return, zoom, {0}},

    // gaps
    {MODKEY, XK_minus, setgaps, {.i = -1}},
    {MODKEY, XK_equal, setgaps, {.i = +1}},
    {MODKEY | ShiftMask, XK_equal, setgaps, {.i = 0.00}},

    // tiling window and movement
    {MODKEY, XK_i, incnmaster, {.i = +1}},
    {MODKEY, XK_g, incnmaster, {.i = 0}},

		// tiled resize horizontal
    {MODKEY, key_left, setmfact, {.f = -0.05}},
		{MODKEY, key_right, setmfact, {.f = +0.05}},
    
		// tiled resize vertical 
		{MODKEY, key_up, setcfact, {.f = +0.25}},
    {MODKEY, key_down, setcfact, {.f = -0.25}},
    
		// resets
		{MODKEY, XK_o, setmfact, {.f = 0.00}},
    {MODKEY | ShiftMask, XK_o, setcfact, {.f = 0.00}},
   
		// movement
		{MODKEY | ShiftMask, key_down, focusstack, {.i = +1}},
    {MODKEY | ShiftMask, key_up, focusstack, {.i = -1}},

		{ MODKEY|ControlMask,			key_down,	moveresize,		{.v = (int []){ 0, -10, 0, 20 }}},
		{ MODKEY|ControlMask,			key_up,		moveresize,		{.v = (int []){ 0, 10, 0, -20 }}},
		{ MODKEY|ControlMask,			key_right,	moveresize,		{.v = (int []){ -10, 0, 20, 0 }}},
		{ MODKEY|ControlMask,			key_left,	moveresize,		{.v = (int []){ 10, 0, -20, 0 }}},


    // layout + ui
    {MODKEY, XK_0, view, {.ui = ~0}},
    {MODKEY, XK_space, setlayout, {0}},
    {MODKEY, XK_Tab, view, {0}},
    {MODKEY, XK_s, cyclelayout, {.i = -1}},
    {MODKEY, XK_d, cyclelayout, {.i = +1}},
    {MODKEY, XK_f, setlayout, {.v = &layouts[1]}},
    {MODKEY | ShiftMask, XK_f, togglefullscr, {0}},
		
		// move monitor focus  
		{MODKEY, XK_comma, focusmon, {.i = -1}},
    {MODKEY, XK_period, focusmon, {.i = +1}},

		// move window to monitor 
    {MODKEY | ShiftMask, XK_comma, tagmon, {.i = -1}},
    {MODKEY | ShiftMask, XK_period, tagmon, {.i = +1}},

		// move window and focus monitor
		{MODKEY | ControlMask, XK_comma, focustagmon, {.i = -1}},
		{MODKEY | ControlMask, XK_period, focustagmon, {.i = +1}},
    
		{MODKEY, XK_F5, xrdb, {.v = NULL}},

    {0, XF86XK_AudioLowerVolume, spawn, {.v = voldown}},
    {0, XF86XK_AudioRaiseVolume, spawn, {.v = volup}},
    {0, XF86XK_AudioMute, spawn, {.v = mute}},
    {0, XF86XK_AudioPlay, spawn, {.v = pause_toggle}},
    {0, XF86XK_AudioNext, spawn, {.v = forward}},
    {0, XF86XK_AudioPrev, spawn, {.v = backward}},
    {0, XF86XK_MonBrightnessUp, spawn, {.v = brightnessup}},
    {0, XF86XK_MonBrightnessDown, spawn, {.v = brightnessdown}},
    
		TAGKEYS(XK_1, 0) TAGKEYS(XK_2, 1) TAGKEYS(XK_3, 2) TAGKEYS(XK_4, 3)
        TAGKEYS(XK_5, 4) TAGKEYS(XK_6, 5) TAGKEYS(XK_7, 6) TAGKEYS(XK_8, 7)
            TAGKEYS(XK_9, 8)

};

static const Button buttons[] = {
    /* click                event mask      button          function argument */
    {ClkLtSymbol, 0, Button1, setlayout, {0}},
    {ClkLtSymbol, 0, Button3, setlayout, {.v = &layouts[2]}},
    {ClkWinTitle, 0, Button2, zoom, {0}},
    {ClkStatusText, 0, Button2, spawn, {.v = termcmd}},
    {ClkClientWin, MODKEY, Button1, movemouse, {0}},
    {ClkClientWin, MODKEY, Button2, togglefloating, {0}},
    {ClkClientWin, MODKEY, Button3, resizemouse, {0}},
    {ClkTagBar, 0, Button1, view, {0}},
    {ClkTagBar, 0, Button3, toggleview, {0}},
    {ClkTagBar, MODKEY, Button1, tag, {0}},
    {ClkTagBar, MODKEY, Button3, toggletag, {0}},
};

static const char *ipcsockpath = "/tmp/dwm.sock";
static IPCCommand ipccommands[] = {
    IPCCOMMAND(xrdb, 1, {ARG_TYPE_NONE}),
    IPCCOMMAND(togglefloating, 1, {ARG_TYPE_NONE}),
    IPCCOMMAND(quit, 1, {ARG_TYPE_NONE}),
    IPCCOMMAND(togglebar, 1, {ARG_TYPE_NONE}),
		IPCCOMMAND(printcfact, 1, {ARG_TYPE_NONE}),
		IPCCOMMAND(printmfact, 1, {ARG_TYPE_NONE}),
};

static char normbgcolor[] = "#222222";
static char normbordercolor[] = "#444444";
static char normfgcolor[] = "#bbbbbb";
static char selfgcolor[] = "#eeeeee";
static char selbordercolor[] = "#005577";
static char selbgcolor[] = "#005577";
static char *colors[][3] = {
    [SchemeNorm] = {normfgcolor, normbgcolor, normbordercolor},
    [SchemeSel] = {selfgcolor, selbgcolor, selbordercolor},
};

static const char *tags[] = {"1", "2", "3", "4", "5", "6", "7", "8", "9"};

static const Rule rules[] = {
    {"iso_term", NULL, NULL, 0, 1, -1},
};
