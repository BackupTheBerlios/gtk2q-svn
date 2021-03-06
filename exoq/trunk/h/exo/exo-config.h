/* $Id: exo-config.h.in 18442 2005-10-27 18:12:00Z benny $ */
/*-
 * Copyright (c) 2004-2005 os-cillation e.K.
 *
 * Written by Benedikt Meurer <benny@xfce.org>.
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

#if !defined (EXO_INSIDE_EXO_H) && !defined (EXO_COMPILATION)
#error "Only <exo/exo.h> can be included directly, this file may disappear or change contents."
#endif

#ifndef __EXO_CONFIG_H__
#define __EXO_CONFIG_H__

#include <glib.h>

G_BEGIN_DECLS;

#define EXO_MAJOR_VERSION 0
#define EXO_MINOR_VERSION 3
#define EXO_MICRO_VERSION 1

#define EXO_CHECK_VERSION(major,minor,micro) \
  (EXO_MAJOR_VERSION > (major) \
   || (EXO_MAJOR_VERSION == (major) \
       && EXO_MINOR_VERSION > (minor)) \
   || (EXO_MAJOR_VERSION == (major) \
       && EXO_MINOR_VERSION == (minor) \
       && EXO_MICRO_VERSION >= (micro)))

extern const guint exo_major_version;
extern const guint exo_minor_version;
extern const guint exo_micro_version;

const gchar *exo_check_version (guint required_major,
                                guint required_minor,
                                guint required_micro);

/* with newer GObject versions it's possible to avoid the unnecessary
 * copying of the name, nick and blurb settings for GParamSpec's.
 */
#if defined(G_PARAM_STATIC_NAME) && defined(G_PARAM_STATIC_NICK) && defined(G_PARAM_STATIC_BLURB)
#define EXO_PARAM_READABLE  (G_PARAM_READABLE \
                           | G_PARAM_STATIC_NAME \
                           | G_PARAM_STATIC_NICK \
                           | G_PARAM_STATIC_BLURB)
#define EXO_PARAM_WRITABLE  (G_PARAM_WRITABLE \
                           | G_PARAM_STATIC_NAME \
                           | G_PARAM_STATIC_NICK \
                           | G_PARAM_STATIC_BLURB)
#define EXO_PARAM_READWRITE (G_PARAM_READWRITE \
                           | G_PARAM_STATIC_NAME \
                           | G_PARAM_STATIC_NICK \
                           | G_PARAM_STATIC_BLURB)
#else
#define EXO_PARAM_READABLE  (G_PARAM_READABLE)
#define EXO_PARAM_WRITABLE  (G_PARAM_WRITABLE)
#define EXO_PARAM_READWRITE (G_PARAM_READWRITE)
#endif

G_END_DECLS;

#endif /* !__EXO_CONFIG_H__ */

