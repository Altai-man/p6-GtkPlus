use v6.c;

use Method::Also;
use NativeCall;

use GTK::Compat::Types;
use GTK::Raw::SeparatorToolItem;
use GTK::Raw::Types;

use GTK::ToolItem;

my subset Ancestry
  where GtkSeparatorToolItem | GtkToolItem | GtkBin | GtkContainer |
        GtkBuilder           | GtkWidget;

class GTK::SeparatorToolItem is GTK::ToolItem {
  has GtkSeparatorToolItem $!sti;

  method bless(*%attrinit) {
    my $o = self.CREATE.BUILDALL(Empty, %attrinit);
    $o.setType('GTK::SeparatorToolItem');
    $o;
  }

  submethod BUILD(:$separator) {
    my $to-parent;
    given $separator {
      when Ancestry {
        $!sti = do {
          when GtkSeparatorToolItem {
            $to-parent = nativecast(GtkToolItem, $_);
            $_;
          }
          default {
            $to-parent = $_;
            nativecast(GtkSeparatorToolItem, $_);
          }
        };
        self.setToolItem($to-parent);
      }
      when GTK::SeparatorToolItem {
      }
      default {
      }
    }
  }

  multi method new (Ancestry $separator) {
    self.bless(:$separator);
  }
  multi method new {
    my $separator = gtk_separator_tool_item_new();
    self.bless(:$separator);
  }

  # ↓↓↓↓ SIGNALS ↓↓↓↓
  # ↑↑↑↑ SIGNALS ↑↑↑↑

  # ↓↓↓↓ ATTRIBUTES ↓↓↓↓
  method draw is rw {
    Proxy.new(
      FETCH => sub ($) {
        Bool( gtk_separator_tool_item_get_draw($!sti) );
      },
      STORE => sub ($, Int() $draw is copy) {
        my gboolean $d = $draw == 0 ?? 0 !! 1;
        gtk_separator_tool_item_set_draw($!sti, $d);
      }
    );
  }
  # ↑↑↑↑ ATTRIBUTES ↑↑↑↑

  # ↓↓↓↓ METHODS ↓↓↓↓
  method get_type is also<get-type> {
    gtk_separator_tool_item_get_type();
  }
  # ↑↑↑↑ METHODS ↑↑↑↑

}
