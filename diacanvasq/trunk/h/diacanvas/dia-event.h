/* dia-event.h
 * Copyright (C) 2001  Arjan Molenaar
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

/* Events to be send to DiaCanvasItem's.
 * This is a small subset of GdkEvent.
 * Note that all events contain world relative coordinates, not item relative!
 */

#ifndef __DIA_EVENT_H__
#define __DIA_EVENT_H__

#include <glib.h>

G_BEGIN_DECLS

typedef enum {
	DIA_EVENT_BUTTON_PRESS,
	DIA_EVENT_2BUTTON_PRESS, /* double click */
	DIA_EVENT_3BUTTON_PRESS, /* triple click */
	DIA_EVENT_BUTTON_RELEASE,
	DIA_EVENT_MOTION,
	DIA_EVENT_KEY_PRESS,
	DIA_EVENT_KEY_RELEASE,
	DIA_EVENT_FOCUS_IN,
	DIA_EVENT_FOCUS_OUT
} DiaEventType;

/* Should have the same makeup as GdkModifierType. */
typedef enum {
	DIA_EVENT_MASK_SHIFT	= 1 << 0,
	DIA_EVENT_MASK_LOCK	= 1 << 1,
	DIA_EVENT_MASK_CTRL	= 1 << 2,
	DIA_EVENT_MASK_MOD1	= 1 << 3,
	DIA_EVENT_MASK_ALT = DIA_EVENT_MASK_MOD1,
	DIA_EVENT_MASK_MOD2	= 1 << 4,
	DIA_EVENT_MASK_MOD3	= 1 << 5,
	DIA_EVENT_MASK_MOD4	= 1 << 6,
	DIA_EVENT_MASK_MOD5	= 1 << 7,
	DIA_EVENT_MASK_BUTTON1	= 1 << 8,
	DIA_EVENT_MASK_BUTTON2	= 1 << 9,
	DIA_EVENT_MASK_BUTTON3	= 1 << 10,
	DIA_EVENT_MASK_BUTTON4	= 1 << 11,
	DIA_EVENT_MASK_BUTTON5	= 1 << 12,
} DiaEventMask;

#define DIA_TYPE_EVENT dia_event_get_type ()
GType dia_event_get_type (void);

typedef union  _DiaEvent	DiaEvent;
typedef struct _DiaEventButton	DiaEventButton;
typedef struct _DiaEventMotion	DiaEventMotion;
typedef struct _DiaEventKey	DiaEventKey;
typedef struct _DiaEventFocus	DiaEventFocus;

struct _DiaEventButton {
	DiaEventType	type;
	gdouble 	x;
	gdouble 	y;
	DiaEventMask	modifier;
	guint		button;
};

struct _DiaEventMotion {
	DiaEventType	type;
	gdouble 	x;
	gdouble 	y;
	DiaEventMask	modifier;
	gdouble 	dx; /* in item relative coordinates */
	gdouble 	dy;
};

struct _DiaEventKey {
	DiaEventType	type;
	guint		keyval;	/* Use values from gdk/gdkkeysyms.h. */
	gint		length;
	gchar*		string;
	DiaEventMask	modifier;
};

struct _DiaEventFocus {
	DiaEventType	type;
};

union _DiaEvent {
	DiaEventType	type;
	DiaEventButton	button;
	DiaEventMotion	motion;
	DiaEventKey	key;
	DiaEventFocus	focus;
};

G_END_DECLS

#endif /* __DIA_EVENT_H__ */
