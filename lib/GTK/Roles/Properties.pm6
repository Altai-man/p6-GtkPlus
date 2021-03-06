use v6.c;

use Method::Also;
use NativeCall;

use GTK::Compat::Types;
use GTK::Compat::Value;

role GTK::Roles::Properties {
  has GObject $!prop;

  method !checkNames(@names) {
    @names.map({
      if $_ ~~ Str {
        $_;
      } else {
        unless .^can('Str').elems {
          die "$_ value cannot be coerced to string.";
        }
        .Str;
      }
    });
  }

  method !checkValues(@values) {
    @values.map({
      if $_ ~~ GValue {
        $_;
      } else {
        unless .^can('GValue').elems {
          die "$_ value cannot be coerced to GValue";
        }
        .gvalue();
      }
    });
  }

  #proto method set_prop(|) is also<prop_set> { * }

  method prop_set(Str() $name, GValue() $value) {
    self.set_prop($name, $value);
  }
  multi method set_prop(Str() $name, GValue() $value) {
    samewith( [$name], [$value] );
  }
  multi method set_prop(@names, @values) {
    my @n = self!checkNames(@names);
    my @v = self!checkValues(@values);

    die 'Mismatched number of names and values when setting GObject properties.'
      unless +@n == +@v;

    my CArray[Str] $n = CArray[Str].new;
    my $i = 0;
    $n[$i++] = $_ for @n;
    my CArray[GValue] $v = CArray[GValue].new;
    $i = 0;
    $v[$i++] = $_ for @v;

    # $i = 0;
    # for ^$v.elems {
    #   say "V{$i}: { $v[$i++] }";
    # }

    # say "P: {$!prop}";
    # say $n.^name;
    # $i = 0;
    # say "N{$i}: { $n[$i++] }" for $n;

    # -XXX- NOT a general purpose fix, but will work for now.
    g_object_setv($!prop, $n.elems, $n, nativecast(Pointer, @v[0]));
  }

  #proto method get_prop(|) is also<prop_get> { * }

  method prop_get(Str() $name, GValue() $value) {
    self.get_prop($name, $value.g_type);
  }
  multi method get_prop(Str() $name, Int() $type) {
    my @v = ( GTK::Compat::Value.new($type).gvalue );
    samewith( [$name], @v );
    @v[0];
  }
  multi method get_prop(Str() $name, GValue() $value is rw) {
    my @v = ($value);
    samewith( [$name], @v );
    $value = @v[0];
  }
  multi method get_prop(@names, @values) {
    my @n = self!checkNames(@names);
    my @v = self!checkValues(@values);

    die 'Mismatched number of names and values when setting GObject properties.'
      unless +@n == +@v;

    my CArray[Str] $n = CArray[Str].new;
    my $i = 0;
    $n[$i++] = $_ for @n;
    my CArray[GValue] $v = CArray[GValue].new;
    $i++;
    $v[$i++] = $_ for @v;

    # -XXX- NOT a general purpose fix, but will work for now.
    g_object_getv($!prop, $n.elems, $n, nativecast(Pointer, @v[0]));

    # @values = ();
    # @values.push( GTK::Compat::Value.new($v[$_]) ) for (^$v.elems);

    # Be perlish with the return.
    %(do for (^@names.elems) {
      @names[$_] => @values[$_];
    });
  }

}

# sub g_object_setv (
#   GObject $object,
#   guint $n_properties,
#   CArray[Str] $names,
#   CArray[GValue] $values
# )
#   is native(gobject)
#   { * }
#
# sub g_object_getv (
#   GObject $object,
#   guint $n_properties,
#   CArray[Str] $names,
#   CArray[GValue] $values
# )
#   is native(gobject)
#   { * }

sub g_object_setv (
  GObject $object,
  uint32 $n_properties,
  CArray[Str] $names,
  # Note... not an array.
  #CArray[GValue] $values
  Pointer $v
)
  is native(gobject)
  is export
  { * }

sub g_object_getv (
  GObject $object,
  uint32 $n_properties,
  CArray[Str] $names,
  #CArray[GValue] $values
  Pointer $v
)
  is native(gobject)
  is export
  { * }
