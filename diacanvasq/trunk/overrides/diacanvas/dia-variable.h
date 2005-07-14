struct _DiaVariableClass
{
	GObjectClass parent_class;

	/* Notify the outside world the value has changed. */
	void (* changed)	(DiaVariable *var);

	/* used to notify constraints and solvers that the value has changed. */
	void (* changed_internal) (DiaVariable *var);
};
