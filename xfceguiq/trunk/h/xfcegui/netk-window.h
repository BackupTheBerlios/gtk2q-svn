/* window object */

/*
 * Copyright (C) 2001 Havoc Pennington
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

#ifndef NETK_WINDOW_H
#define NETK_WINDOW_H

#include <glib-object.h>
#include <libxfcegui4/netk-screen.h>
#include <gdk-pixbuf/gdk-pixbuf.h>

G_BEGIN_DECLS 

typedef enum
{
    NETK_WINDOW_STATE_MINIMIZED = 1 << 0,
    NETK_WINDOW_STATE_MAXIMIZED_HORIZONTALLY = 1 << 1,
    NETK_WINDOW_STATE_MAXIMIZED_VERTICALLY = 1 << 2,
    NETK_WINDOW_STATE_SHADED = 1 << 3,
    NETK_WINDOW_STATE_SKIP_PAGER = 1 << 4,
    NETK_WINDOW_STATE_SKIP_TASKLIST = 1 << 5,
    NETK_WINDOW_STATE_STICKY = 1 << 6,
    NETK_WINDOW_STATE_HIDDEN = 1 << 7,
    NETK_WINDOW_STATE_FULLSCREEN = 1 << 8,
    NETK_WINDOW_STATE_URGENT = 1 << 9
}
NetkWindowState;

typedef enum
{
    NETK_WINDOW_ACTION_MOVE = 1 << 0,
    NETK_WINDOW_ACTION_RESIZE = 1 << 1,
    NETK_WINDOW_ACTION_SHADE = 1 << 2,
    NETK_WINDOW_ACTION_STICK = 1 << 3,
    NETK_WINDOW_ACTION_MAXIMIZE_HORIZONTALLY = 1 << 4,
    NETK_WINDOW_ACTION_MAXIMIZE_VERTICALLY = 1 << 5,
    NETK_WINDOW_ACTION_CHANGE_WORKSPACE = 1 << 6,       /* includes pin/unpin */
    NETK_WINDOW_ACTION_CLOSE = 1 << 7,
    NETK_WINDOW_ACTION_UNMAXIMIZE_HORIZONTALLY = 1 << 8,
    NETK_WINDOW_ACTION_UNMAXIMIZE_VERTICALLY = 1 << 9,
    NETK_WINDOW_ACTION_UNSHADE = 1 << 10,
    NETK_WINDOW_ACTION_UNSTICK = 1 << 11,
    NETK_WINDOW_ACTION_MINIMIZE = 1 << 12,
    NETK_WINDOW_ACTION_UNMINIMIZE = 1 << 13,
    NETK_WINDOW_ACTION_MAXIMIZE = 1 << 14,
    NETK_WINDOW_ACTION_UNMAXIMIZE = 1 << 15
}
NetkWindowActions;

typedef enum
{
    NETK_WINDOW_NORMAL,         /* document/app window */
    NETK_WINDOW_DESKTOP,        /* desktop background */
    NETK_WINDOW_DOCK,           /* panel */
    NETK_WINDOW_DIALOG,         /* dialog */
    NETK_WINDOW_MODAL_DIALOG,   /* modal dialog */
    NETK_WINDOW_TOOLBAR,        /* tearoff toolbar */
    NETK_WINDOW_MENU,           /* tearoff menu */
    NETK_WINDOW_UTILITY,        /* palette/toolbox window */
    NETK_WINDOW_SPLASHSCREEN    /* splash screen */
}
NetkWindowType;

#define NETK_TYPE_WINDOW              (netk_window_get_type ())
#define NETK_WINDOW(object)           (G_TYPE_CHECK_INSTANCE_CAST ((object), NETK_TYPE_WINDOW, NetkWindow))
#define NETK_WINDOW_CLASS(klass)      (G_TYPE_CHECK_CLASS_CAST ((klass), NETK_TYPE_WINDOW, NetkWindowClass))
#define NETK_IS_WINDOW(object)        (G_TYPE_CHECK_INSTANCE_TYPE ((object), NETK_TYPE_WINDOW))
#define NETK_IS_WINDOW_CLASS(klass)   (G_TYPE_CHECK_CLASS_TYPE ((klass), NETK_TYPE_WINDOW))
#define NETK_WINDOW_GET_CLASS(obj)    (G_TYPE_INSTANCE_GET_CLASS ((obj), NETK_TYPE_WINDOW, NetkWindowClass))

typedef struct _NetkWindowClass NetkWindowClass;
typedef struct _NetkWindowPrivate NetkWindowPrivate;

struct _NetkWindow
{
    GObject parent_instance;

    NetkWindowPrivate *priv;
};

struct _NetkWindowClass
{
    GObjectClass parent_class;

    /* window name or icon name changed */
    void (*name_changed) (NetkWindow * window);

    /* minimized, maximized, sticky, skip pager, skip task, shaded
     * may have changed
     */
    void (*state_changed) (NetkWindow * window, NetkWindowState changed_mask,
                           NetkWindowState new_state);

    /* Changed workspace or pinned/unpinned state */
    void (*workspace_changed) (NetkWindow * window);

    /* Changed icon */
    void (*icon_changed) (NetkWindow * window);

    /* Changed actions */
    void (*actions_changed) (NetkWindow * window,
                             NetkWindowActions changed_mask,
                             NetkWindowActions new_actions);

    /* Changed size/position */
    void (*geometry_changed) (NetkWindow * window);
};

GType netk_window_get_type (void) G_GNUC_CONST;

NetkWindow *netk_window_get (gulong xwindow);

NetkScreen *netk_window_get_screen (NetkWindow * window);

const char *netk_window_get_name (NetkWindow * window);
const char *netk_window_get_icon_name (NetkWindow * window);

NetkApplication *netk_window_get_application (NetkWindow * window);
gulong netk_window_get_group_leader (NetkWindow * window);
gulong netk_window_get_xid (NetkWindow * window);

NetkClassGroup *netk_window_get_class_group (NetkWindow *window);
const char *netk_window_get_session_id (NetkWindow * window);
const char *netk_window_get_session_id_utf8 (NetkWindow * window);
int netk_window_get_pid (NetkWindow * window);

NetkWindowType netk_window_get_window_type (NetkWindow * window);
const char* netk_window_get_resource_class (NetkWindow *window);

gboolean netk_window_is_minimized (NetkWindow * window);
gboolean netk_window_is_maximized_horizontally (NetkWindow * window);
gboolean netk_window_is_maximized_vertically (NetkWindow * window);
gboolean netk_window_is_maximized (NetkWindow * window);
gboolean netk_window_is_shaded (NetkWindow * window);
gboolean netk_window_is_skip_pager (NetkWindow * window);
gboolean netk_window_is_skip_tasklist (NetkWindow * window);
gboolean netk_window_is_sticky (NetkWindow * window);

void netk_window_set_skip_pager (NetkWindow * window, gboolean skip);
void netk_window_set_skip_tasklist (NetkWindow * window, gboolean skip);

void netk_window_close (NetkWindow * window);
void netk_window_minimize (NetkWindow * window);
void netk_window_unminimize (NetkWindow * window);
void netk_window_maximize (NetkWindow * window);
void netk_window_unmaximize (NetkWindow * window);
void netk_window_maximize_horizontally (NetkWindow * window);
void netk_window_unmaximize_horizontally (NetkWindow * window);
void netk_window_maximize_vertically (NetkWindow * window);
void netk_window_unmaximize_vertically (NetkWindow * window);
void netk_window_shade (NetkWindow * window);
void netk_window_unshade (NetkWindow * window);
void netk_window_stick (NetkWindow * window);
void netk_window_unstick (NetkWindow * window);
void netk_window_keyboard_move (NetkWindow * window);
void netk_window_keyboard_size (NetkWindow * window);

NetkWorkspace *netk_window_get_workspace (NetkWindow * window);
void netk_window_move_to_workspace (NetkWindow * window,
                                    NetkWorkspace * space);

/* pinned = on all workspaces */
gboolean netk_window_is_pinned (NetkWindow * window);
void netk_window_pin (NetkWindow * window);
void netk_window_unpin (NetkWindow * window);

void netk_window_activate (NetkWindow * window);
gboolean netk_window_is_active (NetkWindow * window);
void netk_window_activate_transient (NetkWindow * window);

GdkPixbuf *netk_window_get_icon (NetkWindow * window);
GdkPixbuf *netk_window_get_mini_icon (NetkWindow * window);

gboolean netk_window_get_icon_is_fallback (NetkWindow * window);

void netk_window_set_icon_geometry (NetkWindow * window, int x, int y,
                                    int width, int height);

NetkWindowActions netk_window_get_actions (NetkWindow * window);
NetkWindowState netk_window_get_state (NetkWindow * window);

void netk_window_get_geometry (NetkWindow * window, int *xp, int *yp,
                               int *widthp, int *heightp);

gboolean netk_window_is_visible_on_workspace (NetkWindow * window,
                                              NetkWorkspace * workspace);
gboolean netk_window_is_on_workspace (NetkWindow * window,
                                      NetkWorkspace * workspace);
gboolean netk_window_is_in_viewport (NetkWindow * window,
                                     NetkWorkspace * workspace);

G_END_DECLS
#endif /* NETK_WINDOW_H */
