use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GTK::Raw::Switch;
use GTK::Raw::Types;

use GTK::Widget;

use GTK::Roles::Signals::Generic;

class GTK::Switch is GTK::Widget {
  has GtkSwitch $!s;

  also does GTK::Roles::Signals::Generic;

  method bless(*%attrinit) {
    my $o = self.CREATE.BUILDALL(Empty, %attrinit);
    $o.setType('GTK::Switch');
    $o;
  }

  submethod BUILD(:$switch) {
    my $to-parent;
    given $switch {
      when GtkSwitch | GtkWidget {
        $!s = do {
          when GtkWidget {
            $to-parent = $_;
            nativecast(GtkSwitch, $switch);
          }
          when GtkSwitch {
            $to-parent = nativecast(GtkWidget, $_);
            $_;
          }
        };
        self.setWidget($to-parent);
      }
      when GTK::Switch {
      }
      default {
      }
    }
  }

  submethod DESTROY {
    self.disconnect-all($_) for %!signals-generic;
  }

  multi method new {
    my $switch = gtk_switch_new();
    self.bless(:$switch);
  }
  multi method new(GtkWidget $switch) {
    # cw: Check type before-hand?
    self.bless(:$switch);
  }

  # ↓↓↓↓ SIGNALS ↓↓↓↓

  # Is originally:
  # GtkSwitch, gpointer --> void
  method activate {
    self.connect($!s, 'activate');
  }

  # Is originally:
  # GtkSwitch, gboolean, gpointer --> gboolean
  method state-set {
    self.connect-uint-ruint($!s, 'state-set');
  }

  # ↑↑↑↑ SIGNALS ↑↑↑↑

  # ↓↓↓↓ ATTRIBUTES ↓↓↓↓
  method active is rw {
    Proxy.new(
      FETCH => sub ($) {
        Bool( gtk_switch_get_active($!s) );
      },
      STORE => sub ($, Int() $is_active is copy) {
        my gboolean $ia = self.RESOLVE-BOOL($is_active);
        gtk_switch_set_active($!s, $ia);
      }
    );
  }

  method state is rw {
    Proxy.new(
      FETCH => sub ($) {
        so gtk_switch_get_state($!s);
      },
      STORE => sub ($, $state is copy) {
        my gboolean $s = self.RESOLVE-BOOL($state);
        gtk_switch_set_state($!s, $s);
      }
    );
  }
  # ↑↑↑↑ ATTRIBUTES ↑↑↑↑

  # ↓↓↓↓ METHODS ↓↓↓↓
  method get_type {
    gtk_switch_get_type();
  }
  # ↑↑↑↑ METHODS ↑↑↑↑

}
