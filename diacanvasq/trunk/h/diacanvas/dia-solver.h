/* dia-solver.h
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

#ifndef __DIA_SOLVER_H__
#define __DIA_SOLVER_H__

#include <diacanvas/dia-constraint.h>

G_BEGIN_DECLS

#define DIA_TYPE_SOLVER		(dia_solver_get_type ())
#define DIA_SOLVER(obj)		(G_TYPE_CHECK_INSTANCE_CAST ((obj), DIA_TYPE_SOLVER, DiaSolver))
#define DIA_SOLVER_CLASS(klass)	(G_TYPE_CHECK_CLASS_CAST ((klass), DIA_TYPE_SOLVER, DiaSolverClass))
#define DIA_IS_SOLVER(obj)		(G_TYPE_CHECK_INSTANCE_TYPE ((obj), DIA_TYPE_SOLVER))
#define DIA_IS_SOLVER_CLASS(klass)	(G_TYPE_CHECK_CLASS_TYPE ((klass), DIA_TYPE_SOLVER))
#define DIA_SOLVER_GET_CLASS(obj)	(G_TYPE_INSTANCE_GET_CLASS ((obj), DIA_TYPE_SOLVER, DiaSolverClass))


typedef struct _DiaSolver DiaSolver;
typedef struct _DiaSolverClass DiaSolverClass;

struct _DiaSolver
{
	GObject parent;
	
	/* Constraints added to the solver. */
	GList *constraints;

	/* Constraints who's values are edited together
	 * with the edited variable. */
	GSList *marked_cons;
	GSList *marked_vars;
	/* In dia_solver_resolve(), this variable holds the constraint
	 * currently solved. */
	DiaConstraint *current_con;
};


struct _DiaSolverClass
{
	GObjectClass parent_class;
};

GType	dia_solver_get_type		(void);

DiaSolver* dia_solver_new		(void);

void	dia_solver_add_constraint	(DiaSolver *solver,
					 DiaConstraint *constraint);

void	dia_solver_remove_constraint	(DiaSolver *solver,
					 DiaConstraint *constraint);

void	dia_solver_resolve		(DiaSolver *solver);


G_END_DECLS

#endif /* __DIA_SOLVER_H__ */
