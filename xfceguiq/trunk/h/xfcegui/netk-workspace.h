/* workspace object */

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

#ifndef NETK_WORKSPACE_H
#define NETK_WORKSPACE_H

#include <glib-object.h>
#include <libxfcegui4/netk-screen.h>

G_BEGIN_DECLS
#define NETK_TYPE_WORKSPACE              (netk_workspace_get_type ())
#define NETK_WORKSPACE(object)           (G_TYPE_CHECK_INSTANCE_CAST ((object), NETK_TYPE_WORKSPACE, NetkWorkspace))
#define NETK_WORKSPACE_CLASS(klass)      (G_TYPE_CHECK_CLASS_CAST ((klass), NETK_TYPE_WORKSPACE, NetkWorkspaceClass))
#define NETK_IS_WORKSPACE(object)        (G_TYPE_CHECK_INSTANCE_TYPE ((object), NETK_TYPE_WORKSPACE))
#define NETK_IS_WORKSPACE_CLASS(klass)   (G_TYPE_CHECK_CLASS_TYPE ((klass), NETK_TYPE_WORKSPACE))
#define NETK_WORKSPACE_GET_CLASS(obj)    (G_TYPE_INSTANCE_GET_CLASS ((obj), NETK_TYPE_WORKSPACE, NetkWorkspaceClass))
typedef struct _NetkWorkspaceClass NetkWorkspaceClass;
typedef struct _NetkWorkspacePrivate NetkWorkspacePrivate;

struct _NetkWorkspace
{
    GObject parent_instance;

    NetkWorkspacePrivate *priv;
};

struct _NetkWorkspaceClass
{
    GObjectClass parent_class;

    void (*name_changed) (NetkWorkspace * space);
};

GType
netk_workspace_get_type (void)
    G_GNUC_CONST;

     int netk_workspace_get_number (NetkWorkspace * space);

     const char *netk_workspace_get_name (NetkWorkspace * space);
     void netk_workspace_change_name (NetkWorkspace * space,
                                      const char *name);

     void netk_workspace_activate (NetkWorkspace * space);
     int netk_workspace_get_width (NetkWorkspace * space);
     int netk_workspace_get_height (NetkWorkspace * space);
     int netk_workspace_get_viewport_x (NetkWorkspace * space);
     int netk_workspace_get_viewport_y (NetkWorkspace * space);
     gboolean netk_workspace_is_virtual (NetkWorkspace * space);
G_END_DECLS
#endif /* NETK_WORKSPACE_H */
