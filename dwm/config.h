/* See LICENSE file for copyright and license details. */
#include "selfrestart.c"

/* appearance */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const int showbar            = 0;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "monospace:size=10" };
static const char dmenufont[]       = "monospace:size=10";
static const char col_gray1[]       = "#222222";
static const char col_gray2[]       = "#444444";
static const char col_gray3[]       = "#bbbbbb";
static const char col_gray4[]       = "#eeeeee";
static const char col_cyan[]        = "#005577";
static const char col_blue[]        = "#0198E1";
static const char *colors[][3]      = {
	/*               fg         bg         border   */
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_cyan,  col_blue },
};

/* tagging */
static const char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
	//{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
	{"vlc",       NULL,      NULL,        ~0,           1,           -1},
};

/* layout(s) */
static const float mfact     = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 1;    /* 1 means respect size hints in tiled resizals */

void getSymbol_tile(char * target, size_t length) {
	snprintf(target, length, "[%d]=", nmaster);
}

void getSymbol_null(char * target, size_t length) {
	snprintf(target, length, "><>");
}

void getSymbol_monocle(char * target, size_t length) {
	snprintf(target, length, "[M]");
}

static const Layout layouts[] = {
	/* { getSymbol function, arrange function } */
	{ getSymbol_tile, tile }, /* first entry is default */
	{ getSymbol_null, NULL }, /* no layout function means floating behavior */
	{ getSymbol_monocle, monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", col_gray1, "-nf", col_gray3, "-sb", col_cyan, "-sf", col_gray4,
	"-i", "-l", "50", "-p", ">", NULL };
static const char *termcmd[]  = { "st", NULL };
static const char *lockcmd[] = { "slock", NULL };
static const char *scrotcmd[] = { "scrot", NULL };
// kudos dk
static const char *spotifyPreviousCmd[] = { "dbus-send", "--type=method_call", "--dest=org.mpris.MediaPlayer2.spotify", "/org/mpris/MediaPlayer2", "org.mpris.MediaPlayer2.Player.Previous", NULL };
static const char *spotifyPlayPauseCmd[] = { "dbus-send", "--type=method_call", "--dest=org.mpris.MediaPlayer2.spotify", "/org/mpris/MediaPlayer2", "org.mpris.MediaPlayer2.Player.PlayPause", NULL };
static const char *spotifyNextCmd[] = { "dbus-send", "--type=method_call", "--dest=org.mpris.MediaPlayer2.spotify", "/org/mpris/MediaPlayer2", "org.mpris.MediaPlayer2.Player.Next", NULL };
static const char *pavuDownCmd[] = { "/usr/bin/pactl", "set-sink-volume", "@DEFAULT_SINK@", "-5%", NULL };
static const char *pavuMuteCmd[] = { "/usr/bin/pactl", "set-sink-mute", "@DEFAULT_SINK@", "toggle", NULL };
static const char *pavuUpCmd[] = { "/usr/bin/pactl", "set-sink-volume", "@DEFAULT_SINK@", "+5%", NULL };
static const char *chromeCmd[] = { "/usr/bin/google-chrome", "--force-device-scale-factor=1.5", NULL };

static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ShiftMask,             XK_q,      quit,           {0} },
	{ MODKEY|ControlMask,           XK_s,      spawn,          {.v = lockcmd } },
	{ MODKEY|ControlMask,           XK_p,      spawn,          {.v = scrotcmd } },
	{ MODKEY,                       XK_F7,     spawn,          {.v = spotifyPreviousCmd} },
	{ MODKEY,                       XK_F8,     spawn,          {.v = spotifyPlayPauseCmd} },
	{ MODKEY,                       XK_F9,     spawn,          {.v = spotifyNextCmd} },
	{ MODKEY|ShiftMask,             XK_F7,     spawn,          {.v = pavuDownCmd} },
	{ MODKEY|ShiftMask,             XK_F8,     spawn,          {.v = pavuMuteCmd} },
	{ MODKEY|ShiftMask,             XK_F9,     spawn,          {.v = pavuUpCmd} },
	{ MODKEY,                       XK_F10,    spawn,          {.v = pavuMuteCmd} },
	{ MODKEY,                       XK_F11,    spawn,          {.v = pavuDownCmd} },
	{ MODKEY,                       XK_F12,    spawn,          {.v = pavuUpCmd} },
	{ 0,                            XK_F13,    spawn,          {.v = spotifyPreviousCmd} },
	{ 0,                            XK_F14,    spawn,          {.v = spotifyPlayPauseCmd} },
	{ 0,                            XK_F15,    spawn,          {.v = spotifyNextCmd} },
	{ MODKEY,                       XK_F13,    spawn,          {.v = pavuDownCmd} },
	{ MODKEY,                       XK_F14,    spawn,          {.v = pavuMuteCmd} },
	{ MODKEY,                       XK_F15,    spawn,          {.v = pavuUpCmd} },
	{ MODKEY,                       XK_o,      spawn,          {.v = chromeCmd} },
	// { MODKEY|ShiftMask,             XK_r,      reload,         {0} },
	{ MODKEY|ShiftMask,             XK_r,      self_restart,   {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

