use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GTK::Raw::Types;

unit package GTK::Raw::ToolShell;

sub gtk_tool_shell_get_ellipsize_mode (GtkToolShell $shell)
  returns uint32 # PangoEllipsizeMode
  is native(gtk)
  is export
  { * }

sub gtk_tool_shell_get_icon_size (GtkToolShell $shell)
  returns uint32 # GtkIconSize
  is native(gtk)
  is export
  { * }

sub gtk_tool_shell_get_orientation (GtkToolShell $shell)
  returns uint32 # GtkOrientation
  is native(gtk)
  is export
  { * }

sub gtk_tool_shell_get_relief_style (GtkToolShell $shell)
  returns uint32 # GtkReliefStyle
  is native(gtk)
  is export
  { * }

sub gtk_tool_shell_get_style (GtkToolShell $shell)
  returns uint32 # GtkToolbarStyle
  is native(gtk)
  is export
  { * }

sub gtk_tool_shell_get_text_alignment (GtkToolShell $shell)
  returns gfloat
  is native(gtk)
  is export
  { * }

sub gtk_tool_shell_get_text_orientation (GtkToolShell $shell)
  returns uint32 # GtkOrientation
  is native(gtk)
  is export
  { * }

sub gtk_tool_shell_get_text_size_group (GtkToolShell $shell)
  returns uint32 # GtkSizeGroup
  is native(gtk)
  is export
  { * }

sub gtk_tool_shell_get_type ()
  returns GType
  is native(gtk)
  is export
  { * }

sub gtk_tool_shell_rebuild_menu (GtkToolShell $shell)
  is native(gtk)
  is export
  { * }
