use v6.c;

use Method::Also;
use NativeCall;

use GTK::Compat::Types;
use GTK::Raw::ButtonBox;
use GTK::Raw::Types;

use GTK::Box;

my subset Ancestry
  where GtkButtonBox | GtkBox | GtkOrientable | GtkContainer | GtkBuildable |
        GtkWidget;

class GTK::ButtonBox is GTK::Box {
  has GtkButtonBox $!bb;

  method bless(*%attrinit) {
    my $o = self.CREATE.BUILDALL(Empty, %attrinit);
    $o.setType('GTK::ButtonBox');
    $o;
  }

  submethod BUILD(:$buttonbox) {
    my $to-parent;
    given $buttonbox {
      when Ancestry {
        $!bb = do {
          when GtkButtonBox {
            $to-parent = nativecast(GtkBox, $_);
            $_;
          }
          default {
            $to-parent = $_;
            nativecast(GtkButtonBox, $_);
          }
        }
        self.setBox($to-parent);
      }
      when GTK::ButtonBox {
      }
      default {
      }
    }
  }

  multi method new (Ancestry $buttonbox) {
    my $o = self.bless(:$buttonbox);
    $o.upref;
    $o;
  }
  multi method new (Int() $orientation) {
    my guint $o = self.RESOLVE-UINT($orientation.Int);
    my $buttonbox = gtk_button_box_new($o);
    self.bless(:$buttonbox);
  }
  multi method new(:$horizontal, :$vertical) {
    die 'Please specify only $horizontal or $vertical'
      unless $horizontal.defined ^^ $vertical.defined;

    my guint $o = do {
      when $horizontal { GTK_ORIENTATION_HORIZONTAL.Int; }
      when $vertical   { GTK_ORIENTATION_VERTICAL.Int; }
    }
    my $buttonbox = gtk_button_box_new($o);
    self.bless(:$buttonbox);
  }

  method new-hbox is also<new_hbox> {
    GTK::ButtonBox.new(GTK_ORIENTATION_HORIZONTAL);
  }

  method new-vbox is also<new_vbox> {
    GTK::ButtonBox.new(GTK_ORIENTATION_VERTICAL);
  }

  # ↓↓↓↓ SIGNALS ↓↓↓↓
  # ↑↑↑↑ SIGNALS ↑↑↑↑

  # ↓↓↓↓ ATTRIBUTES ↓↓↓↓
  method layout is rw {
    Proxy.new(
      FETCH => sub ($) {
        GtkButtonBoxStyle( gtk_button_box_get_layout($!bb) );
      },
      STORE => sub ($, Int() $layout_style is copy) {
        my uint32 $l = self.RESOLVE-UINT($layout_style);
        gtk_button_box_set_layout($!bb, $l);
      }
    );
  }
  # ↑↑↑↑ ATTRIBUTES ↑↑↑↑

  # ↓↓↓↓ METHODS ↓↓↓↓
  method get_child_non_homogeneous (GtkWidget() $child)
    is also<get-child-non-homogeneous>
  {
    gtk_button_box_get_child_non_homogeneous($!bb, $child);
  }

  method get_child_secondary (GtkWidget() $child)
    is also<get-child-secondary>
  {
    gtk_button_box_get_child_secondary($!bb, $child);
  }

  method get_type is also<get-type> {
    gtk_button_box_get_type();
  }

  multi method set_child_non_homogeneous (
    GtkWidget() $child,
    Int() $non_homogeneous
  )
    is also<set-child-non-homogeneous>
  {
    my gboolean $nh = self.RESOLVE-BOOL($non_homogeneous);
    gtk_button_box_set_child_non_homogeneous($!bb, $child, $nh);
  }

  multi method set_child_secondary (
    GtkWidget $child,
    Int() $is_secondary
  )
    is also<set-child-secondary>
  {
    my gboolean $is = self.RESOLVE-BOOL($is_secondary);
    gtk_button_box_set_child_secondary($!bb, $child, $is);
  }
  # ↑↑↑↑ METHODS ↑↑↑↑

}
