/* dia-constraint.h
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

#ifndef __DIA_CONSTRAINT_H__
#define __DIA_CONSTRAINT_H__

#include <diacanvas/dia-variable.h>

G_BEGIN_DECLS

#define DIA_TYPE_CONSTRAINT		(dia_constraint_get_type ())
#define DIA_CONSTRAINT(obj)		(G_TYPE_CHECK_INSTANCE_CAST ((obj), DIA_TYPE_CONSTRAINT, DiaConstraint))
#define DIA_CONSTRAINT_CLASS(klass)	(G_TYPE_CHECK_CLASS_CAST ((klass), DIA_TYPE_CONSTRAINT, DiaConstraintClass))
#define DIA_IS_CONSTRAINT(obj)		(G_TYPE_CHECK_INSTANCE_TYPE ((obj), DIA_TYPE_CONSTRAINT))
#define DIA_IS_CONSTRAINT_CLASS(klass)	(G_TYPE_CHECK_CLASS_TYPE ((klass), DIA_TYPE_CONSTRAINT))
#define DIA_CONSTRAINT_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), DIA_TYPE_CONSTRAINT, DiaConstraintClass))

typedef struct _DiaExpression DiaExpression;

typedef struct _DiaConstraint DiaConstraint;
typedef struct _DiaConstraintClass DiaConstraintClass;

typedef void (* DiaConstraintFunc)	(DiaConstraint	*constraint,
					 DiaVariable	*variable,
					 gdouble	 constant,
					 gpointer	 user_data);

struct _DiaExpression
{
	guint len;

	struct _DiaExpressionElem
	{
		DiaVariable *variable;
		gdouble constant;
	} elem[1];
};

struct _DiaConstraint
{
	GObject parent;

	/*< Private >*/
	guint immutable;

	/*< Private >*/
	DiaExpression *expr;
};


struct _DiaConstraintClass
{
	GObjectClass parent_class;

	void (* need_resolve)	(DiaConstraint *constraint, DiaVariable *var);
};

GType	dia_constraint_get_type		(void);

DiaConstraint* dia_constraint_new	(void);

/* constraint = constraint + @var * @c. */
void	dia_constraint_add		(DiaConstraint *constraint,
					 DiaVariable *var, gdouble c);

void	dia_constraint_add_expression	(DiaConstraint *constraint,
					 DiaExpression *expr);

/* Multiply @constraint by @c. */
void	dia_constraint_times		(DiaConstraint *constraint, gdouble c);

gboolean dia_constraint_has_variables	(DiaConstraint *constraint);

void	dia_constraint_optimize		(DiaConstraint *constraint);

/* Solve a constraint equation for @var, but do not set @var. */
gdouble dia_constraint_solve		(DiaConstraint *constraint,
					 DiaVariable *var);

void	dia_constraint_foreach		(DiaConstraint *constraint,
					 DiaConstraintFunc func,
					 gpointer user_data);


/* The following functions can be used to speed up constraint creation.
 * (Note the ** for expr.) */

/* Use *expr == NULL to create a new expression */
void	dia_expression_add		(DiaExpression **expr,
					 DiaVariable *var, gdouble c);
void	dia_expression_add_expression	(DiaExpression **expr,
					 DiaExpression *expr2);

void	dia_expression_times		(DiaExpression *expr, gdouble c);

void	dia_expression_free		(DiaExpression *expr);


/*< Private >*/
/* Once a constraint is added to a solver it should not be changed. */
void	dia_constraint_freeze		(DiaConstraint *constraint);
void	dia_constraint_thaw		(DiaConstraint *constraint);


G_END_DECLS


#endif /* __DIA_CONSTRAINT_H__ */
