use v6.c;

use Method::Also;
use NativeCall;

use GTK::Compat::Types;
use GTK::Raw::LinkButton;
use GTK::Raw::Types;

use GTK::Button;

my subset Ancestry where GtkLinkButton | GtkButton    | GtkActionable |
                         GtkBin        | GtkContainer | GtkBuildable  |
                         GtkWidget;

class GTK::LinkButton is GTK::Button {
  has GtkLinkButton $!lb;

  method bless(*%attrinit) {
    my $o = self.CREATE.BUILDALL(Empty, %attrinit);
    $o.setType('GTK::LinkButton');
    $o;
  }

  submethod BUILD(:$button) {
    my $to-parent;
    given $button {
      when Ancestry {
        $!lb = do {
          when GtkLinkButton {
            $to-parent = nativecast(GtkButton, $_);
            $_;
          }
          default {
            $to-parent = $_;
            nativecast(GtkLinkButton, $_);
          }
        };
        self.setButton($to-parent);
      }
      when GTK::LinkButton {
      }
      default {
      }
    }
  }

  multi method new (Ancestry $button) {
    my $o = self.bless(:$button);
    $o.upref;
    $o;
  }
  multi method new ($uri) {
    my $button = gtk_link_button_new($uri);
    self.bless(:$button);
  }

  method new_with_label (Str() $uri, Str() $label)
    is also<new-with-label>
  {
    my $button = gtk_link_button_new_with_label($uri, $label);
    self.bless(:$button);
  }

  # ↓↓↓↓ SIGNALS ↓↓↓↓
  method activate-link is also<activate_link> {
    self.connect($!lb, 'activate-link');
  }
  # ↑↑↑↑ SIGNALS ↑↑↑↑

  # ↓↓↓↓ ATTRIBUTES ↓↓↓↓
  method uri is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_link_button_get_uri($!lb);
      },
      STORE => sub ($, Str() $uri is copy) {
        gtk_link_button_set_uri($!lb, $uri);
      }
    );
  }

  method visited is rw {
    Proxy.new(
      FETCH => sub ($) {
        so gtk_link_button_get_visited($!lb);
      },
      STORE => sub ($, $visited is copy) {
        my gboolean $v = self.RESOLVE-BOOL($visited);
        gtk_link_button_set_visited($!lb, $v);
      }
    );
  }
  # ↑↑↑↑ ATTRIBUTES ↑↑↑↑

  # ↓↓↓↓ METHODS ↓↓↓↓
  method get_type is also<get-type> {
    gtk_link_button_get_type();
  }
  # ↑↑↑↑ METHODS ↑↑↑↑

}
