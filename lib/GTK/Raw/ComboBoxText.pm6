use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GTK::Raw::Types;

unit package GTK::Raw::ComboBoxText;

sub gtk_combo_box_text_append (
  GtkComboBoxText $combo_box,
  gchar $id,
  gchar $text
)
  is native('gtk-3')
  is export
  { * }

sub gtk_combo_box_text_append_text (GtkComboBoxText $combo_box, gchar $text)
  is native('gtk-3')
  is export
  { * }

sub gtk_combo_box_text_get_active_text (GtkComboBoxText $combo_box)
  returns Str
  is native('gtk-3')
  is export
  { * }

sub gtk_combo_box_text_get_type ()
  returns GType
  is native('gtk-3')
  is export
  { * }

sub gtk_combo_box_text_insert (
  GtkComboBoxText $combo_box,
  gint $position,
  gchar $id,
  gchar $text
)
  is native('gtk-3')
  is export
  { * }

sub gtk_combo_box_text_insert_text (
  GtkComboBoxText $combo_box,
  gint $position,
  gchar $text
)
  is native('gtk-3')
  is export
  { * }

sub gtk_combo_box_text_new ()
  returns GtkWidget
  is native('gtk-3')
  is export
  { * }

sub gtk_combo_box_text_new_with_entry ()
  returns GtkWidget
  is native('gtk-3')
  is export
  { * }

sub gtk_combo_box_text_prepend (
  GtkComboBoxText $combo_box,
  gchar $id,
  gchar $text
)
  is native('gtk-3')
  is export
  { * }

sub gtk_combo_box_text_prepend_text (GtkComboBoxText $combo_box, gchar $text)
  is native('gtk-3')
  is export
  { * }

sub gtk_combo_box_text_remove (GtkComboBoxText $combo_box, gint $position)
  is native('gtk-3')
  is export
  { * }

sub gtk_combo_box_text_remove_all (GtkComboBoxText $combo_box)
  is native('gtk-3')
  is export
  { * }
