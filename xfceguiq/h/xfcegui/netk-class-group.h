/* class group object */

/*
 * Copyright (C) 2003 Ximian, Inc.
 * Authors: Federico Mena-Quintero <federico@ximian.com>
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

#ifndef NETK_CLASS_GROUP_H
#define NETK_CLASS_GROUP_H

#include <glib-object.h>
#include <gdk-pixbuf/gdk-pixbuf.h>
#include <libxfcegui4/netk-screen.h>

G_BEGIN_DECLS
#define NETK_TYPE_CLASS_GROUP              (netk_class_group_get_type ())
#define NETK_CLASS_GROUP(object)           (G_TYPE_CHECK_INSTANCE_CAST ((object), NETK_TYPE_CLASS_GROUP, NetkClassGroup))
#define NETK_CLASS_GROUP_CLASS(klass)      (G_TYPE_CHECK_CLASS_CAST ((klass), NETK_TYPE_CLASS_GROUP, NetkClassGroupClass))
#define NETK_IS_CLASS_GROUP(object)        (G_TYPE_CHECK_INSTANCE_TYPE ((object), NETK_TYPE_CLASS_GROUP))
#define NETK_IS_CLASS_GROUP_CLASS(klass)   (G_TYPE_CHECK_CLASS_TYPE ((klass), NETK_TYPE_CLASS_GROUP))
#define NETK_CLASS_GROUP_GET_CLASS(obj)    (G_TYPE_INSTANCE_GET_CLASS ((obj), NETK_TYPE_CLASS_GROUP, NetkClassGroupClass))
typedef struct _NetkClassGroupClass NetkClassGroupClass;
typedef struct _NetkClassGroupPrivate NetkClassGroupPrivate;

struct _NetkClassGroup
{
    GObject parent_instance;

    NetkClassGroupPrivate *priv;
};

struct _NetkClassGroupClass
{
    GObjectClass parent_class;

    void (*name_changed) (NetkApplication * app);
    void (*icon_changed) (NetkApplication * app);
};

GType netk_class_group_get_type (void) G_GNUC_CONST;

NetkClassGroup *netk_class_group_get (const char *res_class);

GList *netk_class_group_get_windows (NetkClassGroup * class_group);
const char *netk_class_group_get_res_class (NetkClassGroup * class_group);

const char *netk_class_group_get_name (NetkClassGroup * class_group);

GdkPixbuf *netk_class_group_get_icon (NetkClassGroup * class_group);
GdkPixbuf *netk_class_group_get_mini_icon (NetkClassGroup * class_group);

NetkClassGroup *p_netk_class_group_create (const char *res_class);
void p_netk_class_group_destroy (NetkClassGroup * class_group);
void p_netk_class_group_add_window (NetkClassGroup * class_group, NetkWindow * window);
void p_netk_class_group_remove_window (NetkClassGroup * class_group, NetkWindow * window);

G_END_DECLS
#endif
