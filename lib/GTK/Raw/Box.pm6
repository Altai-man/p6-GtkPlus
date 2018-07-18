use v6.c;

use NativeCall;

use GTK::Raw::Types;

unit package GTK::Raw::Box;

sub gtk_box_get_type ()
  returns GType
  is native('gtk-3')
  is export
  { * }

# GtkOrientation $orientation
sub gtk_box_new (uint32 $orientation, gint $spacing)
  returns GtkWidget
  is native('gtk-3')
  is export
  { * }

sub gtk_box_pack_end (GtkBox $box, GtkWidget $child, gboolean $expand, gboolean $fill, guint $padding)
  is native('gtk-3')
  is export
  { * }

sub gtk_box_pack_start (GtkBox $box, GtkWidget $child, gboolean $expand, gboolean $fill, guint $padding)
  is native('gtk-3')
  is export
  { * }

# GtkPackType $pack_type
sub gtk_box_query_child_packing (GtkBox $box, GtkWidget $child, gboolean $expand, gboolean $fill, guint $padding, uint32 $pack_type)
  is native('gtk-3')
  is export
  { * }

sub gtk_box_reorder_child (GtkBox $box, GtkWidget $child, gint $position)
  is native('gtk-3')
  is export
  { * }

# GtkPackType $pack_type
sub gtk_box_set_child_packing (GtkBox $box, GtkWidget $child, gboolean $expand, gboolean $fill, guint $padding, uint32 $pack_type)
  is native('gtk-3')
  is export
  { * }

sub gtk_box_get_center_widget (GtkBox $box)
  returns GtkWidget
  is native('gtk-3')
  is export
  { * }

# -->GtkBaselinePosition
sub gtk_box_get_baseline_position (GtkBox $box)
  returns uint32
  is native('gtk-3')
  is export
  { * }

sub gtk_box_get_spacing (GtkBox $box)
  returns gint
  is native('gtk-3')
  is export
  { * }

sub gtk_box_get_homogeneous (GtkBox $box)
  returns uint32
  is native('gtk-3')
  is export
  { * }

sub gtk_box_set_center_widget (GtkBox $box, GtkWidget $widget)
  is native('gtk-3')
  is export
  { * }

# GtkBaselinePosition $position
sub gtk_box_set_baseline_position (GtkBox $box, uint32 $position)
  is native('gtk-3')
  is export
  { * }

sub gtk_box_set_spacing (GtkBox $box, gint $spacing)
  is native('gtk-3')
  is export
  { * }

sub gtk_box_set_homogeneous (GtkBox $box, gboolean $homogeneous)
  is native('gtk-3')
  is export
  { * }