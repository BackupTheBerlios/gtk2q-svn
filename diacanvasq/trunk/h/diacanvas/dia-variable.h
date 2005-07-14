/* dia-variable.h
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

#ifndef __DIA_VARIABLE_H__
#define __DIA_VARIABLE_H__

#include <glib-object.h>
#include <diacanvas/dia-strength.h>

G_BEGIN_DECLS

#define DIA_TYPE_VARIABLE		(dia_variable_get_type ())
#define DIA_VARIABLE(obj)		(G_TYPE_CHECK_INSTANCE_CAST ((obj), DIA_TYPE_VARIABLE, DiaVariable))
#define DIA_VARIABLE_CLASS(klass)	(G_TYPE_CHECK_CLASS_CAST ((klass), DIA_TYPE_VARIABLE, DiaVariableClass))
#define DIA_IS_VARIABLE(obj)		(G_TYPE_CHECK_INSTANCE_TYPE ((obj), DIA_TYPE_VARIABLE))
#define DIA_IS_VARIABLE_CLASS(klass)	(G_TYPE_CHECK_CLASS_TYPE ((klass), DIA_TYPE_VARIABLE))
#define DIA_VARIABLE_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), DIA_TYPE_VARIABLE, DiaVariableClass))


typedef struct _DiaVariable DiaVariable;
typedef struct _DiaVariableClass DiaVariableClass;

struct _DiaVariable
{
	GObject parent;
	
	gdouble value;
	DiaStrength strength;
};


struct _DiaVariableClass
{
	GObjectClass parent_class;

	/* Notify the outside world the value has changed. */
	void (* changed)	(DiaVariable *var);

	/* used to notify constraints and solvers that the value has changed. */
	void (* changed_internal) (DiaVariable *var);
};

GType	dia_variable_get_type		(void);


DiaVariable* dia_variable_new		(void);

void	dia_variable_set_value		(DiaVariable *var, gdouble value);

gdouble dia_variable_get_value		(DiaVariable *var);

void	dia_variable_set_strength	(DiaVariable *var,
					 DiaStrength strength);

DiaStrength dia_variable_get_strength	(DiaVariable *var);


G_END_DECLS

#endif /* __DIA_VARIABLE_H__ */
