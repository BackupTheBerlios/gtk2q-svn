/* temporary until 2.6 headers are used */

struct _GtkMenuToolButtonClass
{
  GtkToolButtonClass parent_class;

  void (*show_menu) (GtkMenuToolButton *button);

  /* Padding for future expansion */
  void (*_gtk_reserved1) (void);
  void (*_gtk_reserved2) (void);
  void (*_gtk_reserved3) (void);
  void (*_gtk_reserved4) (void);
};
