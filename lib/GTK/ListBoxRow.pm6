use v6.c;

use Method::Also;
use NativeCall;

use GTK::Compat::Types;
use GTK::Raw::ListBox;
use GTK::Raw::Types;

use GTK::Bin;

use GTK::Roles::Actionable;

my subset Ancestry
  where GtkListBoxRow | GtkActionable | GtkBin | GtkBuildable | GtkWidget;

class GTK::ListBoxRow is GTK::Bin {
  also does GTK::Roles::Actionable;

  has GtkListBoxRow $!lbr;

  method bless(*%attrinit) {
    my $o = self.CREATE.BUILDALL(Empty, %attrinit);
    $o.setType('GTK::ListBoxRow');
    $o;
  }

  submethod BUILD(:$row) {
    my $to-parent;
    given $row {
      when Ancestry {
        $!lbr = do {
          when GtkListBoxRow {
            $to-parent = nativecast(GtkBin, $_);
            $_;
          }
          when GtkActionable {
            $!action = $_;                          # GTK::Roles::Actionable
            $to-parent = nativecast(GtkBin, $_);
            nativecast(GtkListBoxRow, $_);
          }
          default {
            $to-parent = $_;
            nativecast(GtkListBoxRow, $_);
          }

        }
        self.setBin($to-parent);
        $!action //= nativecast(GtkActionable, $_); # GTK::Roles::Actionable
      }
      when GTK::ListBoxRow {
      }
      default {
      }
    }
  }

  method GTK::Raw::Types::GtkListBoxRow is also<listboxrow> {
    $!lbr;
  }

  multi method new (Ancestry $row) {
    my $o = self.bless(:$row);
    $o.upref;
    $o;
  }
  multi method new {
    my $row = gtk_list_box_row_new();
    self.bless(:$row);
  }

  # ↓↓↓↓ SIGNALS ↓↓↓↓

  # Is originally:
  # GtkListBoxRow, gpointer --> void
  method activate {
    self.connect($!lbr, 'activate');
  }
  # ↑↑↑↑ SIGNALS ↑↑↑↑

  # ↓↓↓↓ ATTRIBUTES ↓↓↓↓
  method activatable is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_list_box_row_get_activatable($!lbr);
      },
      STORE => sub ($, $activatable is copy) {
        gtk_list_box_row_set_activatable($!lbr, $activatable);
      }
    );
  }

  method header is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_list_box_row_get_header($!lbr);
      },
      STORE => sub ($, $header is copy) {
        gtk_list_box_row_set_header($!lbr, $header);
      }
    );
  }

  method selectable is rw {
    Proxy.new(
      FETCH => sub ($) {
        so gtk_list_box_row_get_selectable($!lbr);
      },
      STORE => sub ($, $selectable is copy) {
        gtk_list_box_row_set_selectable($!lbr, $selectable);
      }
    );
  }
  # ↑↑↑↑ ATTRIBUTES ↑↑↑↑

  # ↓↓↓↓ PROPERTIES ↓↓↓↓
  # ↑↑↑↑ PROPERTIES ↑↑↑↑

  # ↓↓↓↓ METHODS ↓↓↓↓
  method changed {
    gtk_list_box_row_changed($!lbr);
  }

  method get_index is also<get-index> {
    gtk_list_box_row_get_index($!lbr);
  }

  method is_selected is also<is-selected> {
    gtk_list_box_row_is_selected($!lbr);
  }
  # ↑↑↑↑ METHODS ↑↑↑↑

}
