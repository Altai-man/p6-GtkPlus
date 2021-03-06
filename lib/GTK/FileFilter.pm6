use v6.c;

use Method::Also;
use NativeCall;

use GTK::Compat::Types;
use GTK::Raw::FileFilter;
use GTK::Raw::Types;

use GTK::Roles::Buildable;
use GTK::Roles::Types;

class GTK::FileFilter does GTK::Roles::Types {
  also does GTK::Roles::Buildable;
  
  has GtkFileFilter $!ff;

  submethod BUILD(:$filter) {
    $!ff = $filter;
    $!b = nativecast(GtkBuildable, $!ff);   # GTK::Roles::Buildable
  }

  method new () {
    my $filter = gtk_file_filter_new();
    self.bless(:$filter);
  }

  method new_from_gvariant (
    Pointer $v                  # GVariant $v
  ) is also<new-from-gvariant> {
    my $filter = gtk_file_filter_new_from_gvariant($v);
    self.bless(:$filter);
  }

  # ↓↓↓↓ SIGNALS ↓↓↓↓
  # ↑↑↑↑ SIGNALS ↑↑↑↑

  # ↓↓↓↓ ATTRIBUTES ↓↓↓↓
  method name is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_file_filter_get_name($!ff);
      },
      STORE => sub ($, $name is copy) {
        gtk_file_filter_set_name($!ff, $name);
      }
    );
  }
  # ↑↑↑↑ ATTRIBUTES ↑↑↑↑

  # ↓↓↓↓ METHODS ↓↓↓↓
  multi method add_custom (
    Int() $needed,              # GtkFileFilterFlags $needed,
    GtkFileFilterFunc $func,
    gpointer $data,
    GDestroyNotify $notify
  ) is also<add-custom> {
    my guint $n = self.RESOLVE-UINT($needed);
    gtk_file_filter_add_custom($!ff, $n, $func, $data, $notify);
  }

  method add_mime_type (Str() $mime_type) is also<add-mime-type> {
    gtk_file_filter_add_mime_type($!ff, $mime_type);
  }

  method add_pattern (Str() $pattern) is also<add-pattern> {
    gtk_file_filter_add_pattern($!ff, $pattern);
  }

  method add_pixbuf_formats (GtkFileFilter() $f) is also<add-pixbuf-formats> {
    gtk_file_filter_add_pixbuf_formats($f);
  }

  method filter (GtkFileFilterInfo $filter_info) {
    gtk_file_filter_filter($!ff, $filter_info);
  }

  method get_needed is also<get-needed> {
    so gtk_file_filter_get_needed($!ff);
  }

  method get_type is also<get-type> {
    gtk_file_filter_get_type();
  }

  method to_gvariant is also<to-gvariant> {
    gtk_file_filter_to_gvariant($!ff);
  }

  # ↑↑↑↑ METHODS ↑↑↑↑

}

