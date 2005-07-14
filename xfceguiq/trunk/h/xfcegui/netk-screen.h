/* screen object */

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

#ifndef NETK_SCREEN_H
#define NETK_SCREEN_H

#include <glib-object.h>

G_BEGIN_DECLS
/* forward decls */
typedef struct _NetkApplication NetkApplication;
typedef struct _NetkClassGroup  NetkClassGroup;
typedef struct _NetkWindow NetkWindow;
typedef struct _NetkWorkspace NetkWorkspace;

/* Screen */

#define NETK_TYPE_SCREEN              (netk_screen_get_type ())
#define NETK_SCREEN(object)           (G_TYPE_CHECK_INSTANCE_CAST ((object), NETK_TYPE_SCREEN, NetkScreen))
#define NETK_SCREEN_CLASS(klass)      (G_TYPE_CHECK_CLASS_CAST ((klass), NETK_TYPE_SCREEN, NetkScreenClass))
#define NETK_IS_SCREEN(object)        (G_TYPE_CHECK_INSTANCE_TYPE ((object), NETK_TYPE_SCREEN))
#define NETK_IS_SCREEN_CLASS(klass)   (G_TYPE_CHECK_CLASS_TYPE ((klass), NETK_TYPE_SCREEN))
#define NETK_SCREEN_GET_CLASS(obj)    (G_TYPE_INSTANCE_GET_CLASS ((obj), NETK_TYPE_SCREEN, NetkScreenClass))

typedef struct _NetkScreen NetkScreen;
typedef struct _NetkScreenClass NetkScreenClass;
typedef struct _NetkScreenPrivate NetkScreenPrivate;

struct _NetkScreen
{
    GObject parent_instance;

    NetkScreenPrivate *priv;
};

struct _NetkScreenClass
{
    GObjectClass parent_class;

    /* focused window changed */
    void (*active_window_changed) (NetkScreen * screen);
    /* current workspace changed */
    void (*active_workspace_changed) (NetkScreen * screen);
    /* stacking order changed */
    void (*window_stacking_changed) (NetkScreen * screen);
    /* window added */
    void (*window_opened) (NetkScreen * screen, NetkWindow * window);
    /* window removed */
    void (*window_closed) (NetkScreen * screen, NetkWindow * window);
    /* new workspace */
    void (*workspace_created) (NetkScreen * screen, NetkWorkspace * space);
    /* workspace gone */
    void (*workspace_destroyed) (NetkScreen * screen, NetkWorkspace * space);
    /* new app */
    void (*application_opened) (NetkScreen * screen, NetkApplication * app);
    /* app gone */
    void (*application_closed) (NetkScreen * screen, NetkApplication * app);
    /* new class group */
    void (* class_group_opened) (NetkScreen *screen, NetkClassGroup *class_group);
    /* class group gone */
    void (* class_group_closed) (NetkScreen *screen, NetkClassGroup *class_group);
    
    /* New background */
    void (*background_changed) (NetkScreen * screen);

    /* Toggle showing desktop */
    void (*showing_desktop_changed) (NetkScreen * screen);

    /* Viewport stuff changed */
    void (*viewports_changed) (NetkScreen * screen);

    void (*pad1) (void);
    void (*pad2) (void);
    void (*pad3) (void);
    void (*pad4) (void);
    void (*pad5) (void);
    void (*pad6) (void);
    void (*pad7) (void);
    void (*pad8) (void);
};

GType
netk_screen_get_type (void)
    G_GNUC_CONST;

     NetkScreen *netk_screen_get_default (void);
     NetkScreen *netk_screen_get (int index);
     NetkScreen *netk_screen_get_for_root (gulong root_window_id);

     NetkWorkspace *netk_screen_get_workspace (NetkScreen * screen,
                                               int workspace);
     NetkWorkspace *netk_screen_get_active_workspace (NetkScreen * screen);
     NetkWindow *netk_screen_get_active_window (NetkScreen * screen);
     GList *netk_screen_get_windows (NetkScreen * screen);
     GList *netk_screen_get_windows_stacked (NetkScreen * screen);
     void netk_screen_force_update (NetkScreen * screen);
     int netk_screen_get_workspace_count (NetkScreen * screen);
     void netk_screen_change_workspace_count (NetkScreen * screen, int count);
     gboolean netk_screen_net_wm_supports (NetkScreen * screen,
                                           const char *atom);
     gulong netk_screen_get_background_pixmap (NetkScreen * screen);
     int netk_screen_get_width (NetkScreen * screen);
     int netk_screen_get_height (NetkScreen * screen);

     gboolean netk_screen_get_showing_desktop (NetkScreen * screen);
     void netk_screen_toggle_showing_desktop (NetkScreen * screen,
                                              gboolean show);
     void netk_screen_move_viewport (NetkScreen * screen, int x, int y);
     int netk_screen_try_set_workspace_layout (NetkScreen * screen,
                                               int current_token, int rows,
                                               int columns);
     void netk_screen_release_workspace_layout (NetkScreen * screen,
                                                int current_token);


G_END_DECLS
#endif /* NETK_SCREEN_H */
