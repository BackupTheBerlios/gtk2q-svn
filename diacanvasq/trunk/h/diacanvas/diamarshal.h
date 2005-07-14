
#ifndef __dia_marshal_MARSHAL_H__
#define __dia_marshal_MARSHAL_H__

#include	<glib-object.h>

G_BEGIN_DECLS

/* BOOLEAN:INT (diamarshal.list:25) */
extern void dia_marshal_BOOLEAN__INT (GClosure     *closure,
                                      GValue       *return_value,
                                      guint         n_param_values,
                                      const GValue *param_values,
                                      gpointer      invocation_hint,
                                      gpointer      marshal_data);

/* BOOLEAN:POINTER (diamarshal.list:26) */
extern void dia_marshal_BOOLEAN__POINTER (GClosure     *closure,
                                          GValue       *return_value,
                                          guint         n_param_values,
                                          const GValue *param_values,
                                          gpointer      invocation_hint,
                                          gpointer      marshal_data);

/* BOOLEAN:OBJECT,BOXED (diamarshal.list:27) */
extern void dia_marshal_BOOLEAN__OBJECT_BOXED (GClosure     *closure,
                                               GValue       *return_value,
                                               guint         n_param_values,
                                               const GValue *param_values,
                                               gpointer      invocation_hint,
                                               gpointer      marshal_data);

/* BOOLEAN:OBJECT (diamarshal.list:28) */
extern void dia_marshal_BOOLEAN__OBJECT (GClosure     *closure,
                                         GValue       *return_value,
                                         guint         n_param_values,
                                         const GValue *param_values,
                                         gpointer      invocation_hint,
                                         gpointer      marshal_data);

/* VOID:DOUBLE,DOUBLE,BOOLEAN (diamarshal.list:29) */
extern void dia_marshal_VOID__DOUBLE_DOUBLE_BOOLEAN (GClosure     *closure,
                                                     GValue       *return_value,
                                                     guint         n_param_values,
                                                     const GValue *param_values,
                                                     gpointer      invocation_hint,
                                                     gpointer      marshal_data);

/* VOID:INT (diamarshal.list:30) */
#define dia_marshal_VOID__INT	g_cclosure_marshal_VOID__INT

/* VOID:OBJECT (diamarshal.list:31) */
#define dia_marshal_VOID__OBJECT	g_cclosure_marshal_VOID__OBJECT

/* VOID:POINTER (diamarshal.list:32) */
#define dia_marshal_VOID__POINTER	g_cclosure_marshal_VOID__POINTER

/* VOID:POINTER,STRING (diamarshal.list:33) */
extern void dia_marshal_VOID__POINTER_STRING (GClosure     *closure,
                                              GValue       *return_value,
                                              guint         n_param_values,
                                              const GValue *param_values,
                                              gpointer      invocation_hint,
                                              gpointer      marshal_data);

/* VOID:POINTER,STRING,POINTER (diamarshal.list:34) */
extern void dia_marshal_VOID__POINTER_STRING_POINTER (GClosure     *closure,
                                                      GValue       *return_value,
                                                      guint         n_param_values,
                                                      const GValue *param_values,
                                                      gpointer      invocation_hint,
                                                      gpointer      marshal_data);

/* VOID:STRING (diamarshal.list:35) */
#define dia_marshal_VOID__STRING	g_cclosure_marshal_VOID__STRING

/* VOID:VOID (diamarshal.list:36) */
#define dia_marshal_VOID__VOID	g_cclosure_marshal_VOID__VOID

/* VOID:OBJECT,STRING (diamarshal.list:37) */
extern void dia_marshal_VOID__OBJECT_STRING (GClosure     *closure,
                                             GValue       *return_value,
                                             guint         n_param_values,
                                             const GValue *param_values,
                                             gpointer      invocation_hint,
                                             gpointer      marshal_data);

G_END_DECLS

#endif /* __dia_marshal_MARSHAL_H__ */

