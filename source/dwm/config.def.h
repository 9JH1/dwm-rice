#include <X11/XF86keysym.h>

// Basic Variables 
static const unsigned int gappx    = 0;
static const unsigned int snap     = 0;
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayonleft  = 0;   /* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray        = 1;        /* 0 means no systray */
static const int nmaster           = 1;
static const int resizehints       = 0;
static const int extrabar          = 1;        /* 0 means no extra bar */
static const float mfact           = 0.5;
static const int lockfullscreen    = 0;
static const int refreshrate       = 120; 
static const unsigned int borderpx = 3;
static char dmenumon[2]            = "0"; 
static const int barheight         = 30;
static const int showbar           = 1;
static const int topbar            = 1;

static char normbgcolor[]           = "#222222";
static char normbordercolor[]       = "#444444";
static char normfgcolor[]           = "#bbbbbb";
static char selfgcolor[]            = "#eeeeee";
static char selbordercolor[]        = "#005577";
static char selbgcolor[]            = "#005577";

// Arrays
static const char *fonts[]           = { "Terminus:size=16" };
static const char *const autostart[] = {"/home/_3hy/.dwm/script/startup.sh", NULL, NULL};

static char *colors[][3] = {
       /*               fg           bg           border   */
       [SchemeNorm] = { normfgcolor, normbgcolor, normbordercolor },
       [SchemeSel]  = { selfgcolor,  selbgcolor,  selbordercolor  },
};

static const char *tags[] = {"1", "2", "3", "4", "5", "6", "7", "8", "9"};
static const Rule rules[] = {
    {"iso_term", NULL, NULL, 0, 1, -1},
};

// Spawn vars
static const char *dmenucmd[]     = { "/home/_3hy/.dwm/script/launcher.sh", NULL};
static const char *termcmd[]      = { "/home/_3hy/.dwm/script/terminal.sh", NULL};
static const char *termcmdalt[]   = { "/home/_3hy/.dwm/script/terminal.sh", "-isolate", NULL};
static const char *wallpaper[]    = { "/home/_3hy/.dwm/script/background.sh", "--select", NULL};
static const char *screenshot[]   = { "/home/_3hy/.dwm/script/screenshot.sh", NULL};
static const char *zoomcmd[]      = { "/home/_3hy/.dwm/script/zoom.sh", NULL};
static const char *forcequit[]    = { "/home/_3hy/.dwm/script/forcequit.sh", NULL};
static const char *compositor[]   = { "/home/_3hy/.dwm/script/compositor.sh", NULL};
static const char *lock[]         = { "/home/_3hy/.dwm/script/lockscreen.sh", "--suspend",  NULL};
static const char *lock_alt[]     = { "/home/_3hy/.dwm/script/lockscreen.sh", "--image", NULL};
static const char *autostartcmd[] = {autostart[0], NULL};

static const char *media_next[]     = { "/home/_3hy/.dwm/script/media/next.sh", NULL};
static const char *media_prev[]     = { "/home/_3hy/.dwm/script/media/prev.sh", NULL};
static const char *media_status[]   = { "/home/_3hy/.dwm/script/media/status.sh", NULL};
static const char *volume_up[]      = { "/home/_3hy/.dwm/script/media/volume_up.sh", NULL};
static const char *volume_down[]    = { "/home/_3hy/.dwm/script/media/volume_down.sh", NULL};
//static const char *volume_mute[]    = { "/home/_3hy/.dwm/script/media/volume_mute.sh", NULL};



// Misc
static const unsigned int tabModKey = 0x40;
static const unsigned int tabCycleKey = 0x17;
const KeySym key_up    = XK_k;
const KeySym key_down  = XK_j;
const KeySym key_left  = XK_h;
const KeySym key_right = XK_l;

// Layouts 
static const Layout layouts[] = {
    {"[]=", tile},
    {"[M]", monocle},
    {"><>", NULL},
    {NULL, NULL},
};

// Definitions
#define MODKEY Mod4Mask

#define TAGKEYS(KEY, TAG)                                                      \
  {MODKEY, KEY, view, {.ui = 1 << TAG}},                                       \
  {MODKEY | ControlMask, KEY, tagandview, {.ui = 1 << TAG}},               \
  {MODKEY | ShiftMask, KEY, tag, {.ui = 1 << TAG}}                        \

// Keys!
static const Key keys[] = {
	// Spawn keybinds
    {MODKEY,             XK_r,      spawn, {.v = dmenucmd}},
    {MODKEY,             XK_Return, spawn, {.v = termcmd}},
    {MODKEY | ShiftMask, XK_Return, spawn, {.v = termcmdalt}},
    {MODKEY,             XK_t,      spawn, {.v = wallpaper}},
    {MODKEY,             XK_x,      spawn, {.v = lock}},
    {MODKEY,             XK_m,      spawn, {.v = lock_alt}},
    {MODKEY | ShiftMask, XK_s,      spawn, {.v = screenshot}},
    {MODKEY | ShiftMask, XK_r,      spawn, {.v = autostartcmd}},
		{MODKEY | ShiftMask, XK_b,      spawn, {.v = compositor}},
    {MODKEY | ShiftMask, XK_q,      spawn, {.v = forcequit}},
    {MODKEY,             XK_z,      spawn, {.v = zoomcmd}},

    // Gaps
    {MODKEY,             XK_minus, setgaps, {.i = -1}},
    {MODKEY,             XK_equal, setgaps, {.i = +1}},
    {MODKEY | ShiftMask, XK_equal, setgaps, {.i = 0.00}},

    // NMaster 
	{MODKEY | ShiftMask, XK_i, incnmaster, {.i = -1}},
    {MODKEY,             XK_i, incnmaster, {.i = +1}},
    {MODKEY,             XK_g, incnmaster, {.i = 0}},

	// MFacts
    {MODKEY,             key_left,  setmfact, {.f = -0.05}},
	{MODKEY,             key_right, setmfact, {.f = +0.05}},
    {MODKEY | ShiftMask, XK_o,      setcfact, {.f = 0.00}},
    
	// CFact
	{MODKEY, key_up,   setcfact, {.f = +0.25}},
    {MODKEY, key_down, setcfact, {.f = -0.25}},
	{MODKEY, XK_o,     setmfact, {.f = 0.00}},
    
	// Movement
	{MODKEY | ShiftMask, key_down, focusstack, {.i = +1}},
    {MODKEY | ShiftMask, key_up,   focusstack, {.i = -1}},

	// media control
	{MODKEY|ControlMask, key_right, spawn, {.v = media_next}},
	{MODKEY|ControlMask, key_left,	spawn, {.v = media_prev}},
	{MODKEY,             XK_p,      spawn, {.v = media_status}},
	
	{MODKEY|ShiftMask|ControlMask, key_right, spawn, {.v = volume_up}},
	{MODKEY|ShiftMask|ControlMask, key_left,	spawn, {.v = volume_down}},
	
	// Window properties
	{MODKEY | ControlMask, XK_q,      quit,           {0}},
    {MODKEY,               XK_q,      killclient,     {0}},
    {MODKEY | ShiftMask,   XK_space,  togglefloating, {0}},
    {MODKEY | ControlMask, XK_Return, zoom,           {0}},

	// Layout
	{MODKEY,             XK_s,     cyclelayout, {.i = -1}},
    {MODKEY,             XK_d,     cyclelayout, {.i = +1}},
    {MODKEY,             XK_f,     setlayout,   {.v = &layouts[1]}},
    {MODKEY | ShiftMask, XK_0,     tag,         {.ui = ~0}},
    {MODKEY,             XK_0,     view,        {.ui = ~0}},
    {MODKEY,             XK_space, setlayout,   {0}},
    {MODKEY,             XK_Tab,   view,        {0}},

    // Misc
	{MODKEY | ShiftMask, XK_f,  togglefullscr,  {0}},
	{MODKEY | ControlMask | ShiftMask, XK_q, quit, {0}},
	{ MODKEY,                       XK_F5,     xrdb,           {.v = NULL } },
		
	// Monitor 
	{MODKEY,               XK_comma,  focusmon,    {.i = -1}},
    {MODKEY,               XK_period, focusmon,    {.i = +1}},
    {MODKEY | ShiftMask,   XK_comma,  tagmon,      {.i = -1}},
    {MODKEY | ShiftMask,   XK_period, tagmon,      {.i = +1}},
	{MODKEY | ControlMask, XK_comma,  focustagmon, {.i = -1}},
	{MODKEY | ControlMask, XK_period, focustagmon, {.i = +1}},
    
	// Tags
	TAGKEYS(XK_1, 0), 
	TAGKEYS(XK_2, 1),
	TAGKEYS(XK_3, 2),
	TAGKEYS(XK_4, 3),
    TAGKEYS(XK_5, 4),
	TAGKEYS(XK_6, 5),
	TAGKEYS(XK_7, 6),
	TAGKEYS(XK_8, 7),
    TAGKEYS(XK_9, 8)
};

// Buttons
static const Button buttons[] = {
    {ClkLtSymbol,   0,      Button1, setlayout,      {0}},
    {ClkLtSymbol,   0,      Button3, setlayout,      {.v = &layouts[2]}},
    {ClkWinTitle,   0,      Button2, zoom,           {0}},
    {ClkStatusText, 0,      Button2, spawn,          {.v = termcmd}},
    {ClkClientWin,  MODKEY, Button1, movemouse,      {0}},
    {ClkClientWin,  MODKEY, Button2, togglefloating, {0}},
    {ClkClientWin,  MODKEY, Button3, resizemouse,    {0}},
    {ClkTagBar,     0,      Button1, view,           {0}},
    {ClkTagBar,     0,      Button3, toggleview,     {0}},
    {ClkTagBar,     MODKEY, Button1, tag,            {0}},
    {ClkTagBar,     MODKEY, Button3, toggletag,      {0}}
};

static void xrdb_fsignal(const Arg *a){
	xrdb(a);
}


static Signal signals[1] = {
	{1, xrdb_fsignal, {.v= NULL}},
};
