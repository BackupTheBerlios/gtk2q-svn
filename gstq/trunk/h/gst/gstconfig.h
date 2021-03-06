/* This header interprets the various GST_* macros that are typically	*
 * provided by the gstreamer-config or gstreamer.pc files.		*/

#ifndef __GST_CONFIG_H__
#define __GST_CONFIG_H__

/***** trick gtk-doc into believing these symbols are defined (yes, it's ugly) */

#if 0
#define GST_DISABLE_LOADSAVE_REGISTRY 1
#define GST_DISABLE_GST_DEBUG 1
#define GST_DISABLE_LOADSAVE 1
#define GST_DISABLE_PARSE 1
#define GST_DISABLE_TRACE 1
#define GST_DISABLE_ALLOC_TRACE 1
#define GST_DISABLE_REGISTRY 1
#define GST_DISABLE_ENUMTYPES 1
#define GST_DISABLE_INDEX 1
#define GST_DISABLE_PLUGIN 1
#define GST_DISABLE_URI 1
#endif


/***** disabling of subsystems *****/

/* wether or not the debugging subsystem is enabled */
/* #undef GST_DISABLE_GST_DEBUG */

/* DOES NOT WORK */
/* #undef GST_DISABLE_LOADSAVE */

/* DOES NOT WORK */
/* #undef GST_DISABLE_PARSE */

/* DOES NOT WORK */
/* #undef GST_DISABLE_TRACE */

/* DOES NOT WORK */
/* #undef GST_DISABLE_ALLOC_TRACE */

/* DOES NOT WORK */
/* #undef GST_DISABLE_REGISTRY */

/* DOES NOT WORK */
/* #undef GST_DISABLE_ENUMTYPES */

/* DOES NOT WORK */
/* #undef GST_DISABLE_INDEX */

/* DOES NOT WORK */
/* #undef GST_DISABLE_PLUGIN */

/* DOES NOT WORK */
/* #undef GST_DISABLE_URI */

/* printf extension format */
/**
 * GST_PTR_FORMAT:
 *
 * printf format type used to debug GStreamer types.
 * This can only be used on types whose size is >= sizeof(gpointer).
 */
#define GST_PTR_FORMAT "P"

/* whether or not the CPU supports unaligned access */
#define GST_HAVE_UNALIGNED_ACCESS 1

/***** Deal with XML stuff, we have to handle both loadsave and registry *****/

#if (! (defined(GST_DISABLE_LOADSAVE) && defined(GST_DISABLE_REGISTRY)) )
# include <libxml/parser.h>
#else
# define GST_DISABLE_LOADSAVE_REGISTRY
#endif

/**
 * GST_EXPORT:
 *
 * Export the given variable from the built shared object.
 *
 * On Windows, this exports the variable from the DLL.
 * On other platforms, this gets defined to "extern".
 */
/**
 * GST_PLUGIN_EXPORT:
 *
 * Export the plugin's definition.
 *
 * On Windows, this exports the plugin definition from the DLL.
 * On other platforms, this gets defined as a no-op.
 */
#ifdef WIN32
#define GST_PLUGIN_EXPORT __declspec(dllexport) extern
#ifdef GST_EXPORTS
#define GST_EXPORT __declspec(dllexport) extern
#else
#define GST_EXPORT __declspec(dllimport) extern
#endif
#else /* not WIN32 */
#define GST_PLUGIN_EXPORT
#define GST_EXPORT extern
#endif

#endif /* __GST_CONFIG_H__ */
