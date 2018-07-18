use v6.c;

use NativeCall;

use GTK::Raw::Types;

#
# DEFAULT
#
sub g_object_unref(OpaquePointer $p)
  is native('gobject-2.0')
  is export
  { * }

sub g_signal_connect_data(
  OpaquePointer $p,
  Str $signal,
  &handler (OpaquePointer, OpaquePointer),
  OpaquePointer $data
)
  returns uint64
  is native('gobject-2.0')
  is export
  { * }


sub g_signal_connect_wd(
  OpaquePointer $app,
  Str $name,
  &handler (GtkWidget $h_widget, OpaquePointer $h_data),
  OpaquePointer $data,
  uint32 $connect_flags
)
  returns uint32
  is native('gobject-2.0')
  is symbol('g_signal_connect_object')
  is export
  { * }

sub g_signal_handler_disconnect(OpaquePointer $app, uint64 $handler)
  is native('gobject-2.0')
  is export
  { * }


#
# CLASS
#
#sub g_type_check_class_cast (OpaquePointer $tc, int32 $it)
#  returns OpaquePointer
#  is native('glib-2.0')
#  is export(:class)
#  { * }

#
# WINDOW
#
sub gtk_application_window_new (GtkApplication $app)
  returns GtkWindow
  is native('gtk-3')
  is export
  { * }

sub gtk_window_set_title (GtkWindow $win, Str $title)
  is native('gtk-3')
  is export(:window)
  { * }

sub gtk_window_set_default_size (GtkWindow $win, int32 $w, int32 $h)
  is native('gtk-3')
  is export(:window)
  { * }


#
# WIDGET
#
sub gtk_widget_get_type()
  returns int32
  is native('gtk-3')
  is export(:widget)
  { * }

sub gtk_widget_show_all(GtkWidget $w)
  is native('gtk-3')
  is export(:widget)
  { * }


#
# BUTTON
#
sub gtk_button_new()
  returns GtkWidget
  is export(:button)
  is native('gtk-3')
  { * }

#
# APPLICATION
#

sub g_application_run(OpaquePointer, Pointer[uint32], CArray[Str])
  is native('gio-2.0')
  is export
  { * }

# cw:This signature is wrong, so go with something that works and circle back.
#sub gtk_init(uint32 is rw, CArray[Str])
sub gtk_init(CArray[uint32], CArray[CArray[Str]])
  is native('gtk-3')
  is export
  { * }

sub gtk_main()
  is native('gtk-3')
  is export
  { * }

sub gtk_main_quit()
  is native('gtk-3')
  is export
  { * }