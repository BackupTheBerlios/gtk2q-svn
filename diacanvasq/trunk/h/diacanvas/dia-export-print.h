/* dia-export-print.h
 * Copyright (C) 2002  Nik Kim <fafhrd@datacom.kz>, Arjan Molenaar
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

#ifndef __DIA_EXPORT_PRINT_H__
#define __DIA_EXPORT_PRINT_H__

#include "dia-canvas.h"
#include "dia-features.h"

#ifdef DIACANVAS2_HAS_GNOME_PRINT
# include <libgnomeprint/gnome-print-job.h>
#endif

G_BEGIN_DECLS

#ifdef DIACANVAS2_HAS_GNOME_PRINT

void dia_export_print (GnomePrintJob *gpm, DiaCanvas *canvas);

#else /* !DIACANVAS2_HAS_GNOME_PRINT */

void dia_export_print (gpointer gpm, DiaCanvas *canvas);

#endif /* !DIACANVAS2_HAS_GNOME_PRINT */

G_END_DECLS

#endif /* __DIA_EXPORT_PRINT_H__ */
