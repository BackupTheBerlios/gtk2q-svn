/* application object */

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

#ifndef NETK_APPLICATION_H
#define NETK_APPLICATION_H

#include <glib-object.h>
#include <gdk-pixbuf/gdk-pixbuf.h>
#include <libxfcegui4/netk-screen.h>

G_BEGIN_DECLS

#define NETK_TYPE_APPLICATION              (netk_application_get_type ())
#define NETK_APPLICATION(object)           (G_TYPE_CHECK_INSTANCE_CAST ((object), NETK_TYPE_APPLICATION, NetkApplication))
#define NETK_APPLICATION_CLASS(klass)      (G_TYPE_CHECK_CLASS_CAST ((klass), NETK_TYPE_APPLICATION, NetkApplicationClass))
#define NETK_IS_APPLICATION(object)        (G_TYPE_CHECK_INSTANCE_TYPE ((object), NETK_TYPE_APPLICATION))
#define NETK_IS_APPLICATION_CLASS(klass)   (G_TYPE_CHECK_CLASS_TYPE ((klass), NETK_TYPE_APPLICATION))
#define NETK_APPLICATION_GET_CLASS(obj)    (G_TYPE_INSTANCE_GET_CLASS ((obj), NETK_TYPE_APPLICATION, NetkApplicationClass))
typedef struct _NetkApplicationClass NetkApplicationClass;
typedef struct _NetkApplicationPrivate NetkApplicationPrivate;

struct _NetkApplication
{
    GObject parent_instance;

    NetkApplicationPrivate *priv;
};

struct _NetkApplicationClass
{
    GObjectClass parent_class;

    /* app name or icon name changed */
    void (*name_changed) (NetkApplication * app);

    /* icon changed */
    void (*icon_changed) (NetkApplication * app);
};

GType
netk_application_get_type (void)
    G_GNUC_CONST;

     NetkApplication *netk_application_get (gulong xwindow);

     gulong netk_application_get_xid (NetkApplication * app);

     GList *netk_application_get_windows (NetkApplication * app);
     int netk_application_get_n_windows (NetkApplication * app);

/* application_get_name, application_get_pid, etc.; prefer to read
 * properties straight off the group leader, and failing that, if the
 * prop is the same for all windows in the app, return the values for
 * the window. Failing that, they make stuff up.
 */
     const char *netk_application_get_name (NetkApplication * app);
     const char *netk_application_get_icon_name (NetkApplication * app);
     int netk_application_get_pid (NetkApplication * app);
     GdkPixbuf *netk_application_get_icon (NetkApplication * app);
     GdkPixbuf *netk_application_get_mini_icon (NetkApplication * app);
     gboolean netk_application_get_icon_is_fallback (NetkApplication * app);

G_END_DECLS
#endif /* NETK_APPLICATION_H */
