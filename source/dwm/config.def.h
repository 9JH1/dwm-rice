#include "../join.h"
#include <X11/XF86keysym.h>

// Basic Variables 
static const unsigned int gappx    = 6;        /* gaps between windows */
static const unsigned int snap     = 0;
static const int gappx             = 10;
static const int showbar           = 1;
static const int topbar            = 1;
static const int nmaster           = 1;
static const int resizehints       = 0;
static const float mfact           = 0.5;
static const int lockfullscreen    = 0;
static const unsigned int borderpx = 3;

// Colors
static char normbgcolor[] = "#222222";
static char normbordercolor[] = "#444444";
static char normfgcolor[] = "#bbbbbb";
static char selfgcolor[] = "#eeeeee";
static char selbordercolor[] = "#005577";
static const char *const autostart[] = {
	"st", NULL,
	NULL /* terminate */
};

static char selbgcolor[] = "#005577";

// Arrays
static const char *fonts[]           = { font };
static const char *const autostart[] = {"/home/_3hy/.dwm/src/autostart.sh", NULL, NULL};
static char *colors[][3] = {
    [SchemeNorm] = {normfgcolor, normbgcolor, normbordercolor},
    [SchemeSel] = {selfgcolor, selbgcolor, selbordercolor},
};
static const char *tags[] = {"1", "2", "3", "4", "5", "6", "7", "8", "9"};
static const Rule rules[] = {
    {"iso_term", NULL, NULL, 0, 1, -1},
};

// Spawn vars
static const char *dmenu[]        = { "/home/_3hy/.dwm/script/launcher.sh", NULL};
static const char *terminal[]     = { "/home/_3hy/.dwm/script/terminal.sh", NULL};
static const char *terminal_alt[] = { "/home/_3hy/.dwm/script/terminal.sh", "-isolate", NULL};
static const char *wallpaper[]    = { "/home/_3hy/.dwm/script/background.sh", "--select", NULL};
static const char *screenshot[]   = { "/home/_3hy/.dwm/script/screenshot.sh", NULL};
static const char *zoom[]         = { "boomer", NULL};
static const char *forcequit[]    = { "/home/_3hy/.dwm/script/forcequit.sh", NULL};
static const char *compositor[]  = { "/home/_3hy/.dwm/script/picom.sh", NULL};
static const char *lock[]         = { "/home/_3hy/.dwm/script/lockscreen.sh", "--suspend",  NULL};
static const char *lock_alt[]     = { "/home/_3hy/.dwm/script/lockscreen.sh", "--freeze", NULL};
static const char *autostartcmd[] = {autostart[0], NULL};

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

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY, TAG)                                                      \
  {MODKEY, KEY, view, {.ui = 1 << TAG}},                                       \
  {MODKEY | ControlMask, KEY, tagandview, {.ui = 1 << TAG}},               \
  {MODKEY | ShiftMask, KEY, tag, {.ui = 1 << TAG}}                        \

// Keys!
static const Key keys[] = {
	// Spawn keybinds
    {MODKEY,               XK_r,      spawn, {.v = dmenu}},
    {MODKEY,               XK_Return, spawn, {.v = terminal}},
    {MODKEY | ShiftMask,   XK_Return, spawn, {.v = terminal_alt}},
    {MODKEY,               XK_t,      spawn, {.v = wallpaper}},
    {MODKEY,               XK_x,      spawn, {.v = lock}},
    {MODKEY,               XK_m,      spawn, {.v = lock_alt}},
    {MODKEY | ShiftMask,   XK_s,      spawn, {.v = screenshot}},
    {MODKEY | ShiftMask,   XK_r,      spawn, {.v = autostartcmd}},
	{MODKEY | ShiftMask,   XK_b,      spawn, {.v = compositor}},
    {MODKEY | ShiftMask,   XK_q,      spawn, {.v = forcequit}},
    {MODKEY,               XK_z,      spawn, {.v = zoom}},

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

	// Window Resize
	{MODKEY|ControlMask, key_down,	moveresize, {.v = (int []){ 0, -10, 0, 20 }}}.
	{MODKEY|ControlMask, key_up,	moveresize, {.v = (int []){ 0, 10, 0, -20 }}},
	{MODKEY|ControlMask, key_right, moveresize, {.v = (int []){ -10, 0, 20, 0 }}},
	{MODKEY|ControlMask, key_left,	moveresize, {.v = (int []){ 10, 0, -20, 0 }}},
		
	// Window properties
    {MODKEY,               XK_q,       killclient,     {0}},
    {MODKEY | ShiftMask,   XK_space,   togglefloating, {0}},
    {MODKEY | ControlMask, XK_Return,  zoom,           {0}},

	// Layout
	{MODKEY,             XK_s,     cyclelayout, {.i = -1}},
    {MODKEY,             XK_d,     cyclelayout, {.i = +1}},
    {MODKEY,             XK_f,     setlayout,   {.v = &layouts[1]}},
    {MODKEY | ShiftMask, XK_0,     tag,         {.ui = ~0}},
    {MODKEY,             XK_0,     view,        {.ui = ~0}},
    {MODKEY,             XK_space, setlayout,   {0}},
    {MODKEY,             XK_Tab,   view,        {0}},

    // Misc
	{MODKEY,             XK_F5, xrdb,           {.v = NULL}},
	{MODKEY | ShiftMask, XK_f,  togglefullscr,  {0} },
		
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
