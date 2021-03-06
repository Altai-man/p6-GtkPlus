use v6.c;

use Method::Also;
use NativeCall;

use GTK::Compat::Types;

class GTK::Compat::RGBA is repr('CStruct') is export { ... }

our constant GdkRGBA is export := GTK::Compat::RGBA;

class GTK::Compat::RGBA {
  has gdouble $.red;
  has gdouble $.green;
  has gdouble $.blue;
  has gdouble $.alpha;

  method GTK::Compat::Types::GdkRGBA {
    self;
  }

  method copy {
    gdk_rgba_copy(self);
  }

  method equal (GTK::Compat::RGBA $p2) {
    Bool( gdk_rgba_equal(self, $p2) );
  }

  method free {
    gdk_rgba_free(self);
  }

  method get_type is also<get-type> {
    gdk_rgba_get_type();
  }

  method hash {
    gdk_rgba_hash(self);
  }

  method parse (Str() $spec) {
    so gdk_rgba_parse(self, $spec);
  }

  method to_string is also<to-string Str> {
    gdk_rgba_to_string(self);
  }

}

sub infix:<eqv> (GTK::Compat::RGBA $a, GTK::Compat::RGBA $b) {
  $a.equal($b);
}

sub gdk_rgba_copy (GTK::Compat::RGBA $rgba)
  returns GTK::Compat::RGBA
  is native(gtk)
  is export
  { * }

sub gdk_rgba_equal (GTK::Compat::RGBA $p1, GTK::Compat::RGBA $p2)
  returns uint32
  is native(gdk)
  is export
  { * }

sub gdk_rgba_free (GTK::Compat::RGBA $rgba)
  is native(gdk)
  is export
  { * }

sub gdk_rgba_get_type ()
  returns GType
  is native(gdk)
  is export
  { * }

sub gdk_rgba_hash (GTK::Compat::RGBA $p)
  returns guint
  is native(gdk)
  is export
  { * }

sub gdk_rgba_parse (GTK::Compat::RGBA $rgba, gchar $spec)
  returns uint32
  is native(gdk)
  is export
  { * }

sub gdk_rgba_to_string (GTK::Compat::RGBA $rgba)
  returns Str
  is native(gdk)
  is export
  { * }
