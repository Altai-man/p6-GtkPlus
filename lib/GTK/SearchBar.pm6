use v6.c;

use Method::Also;
use NativeCall;

use GTK::Compat::Types;
use GTK::Raw::SearchBar;
use GTK::Raw::Types;

use GTK::Bin;

my subset Ancestry
  where GtkSearchBar | GtkBin | GtkContainer | GtkBuildable | GtkWidget;

class GTK::SearchBar is GTK::Bin {
  has GtkSearchBar $!sb;

  method bless(*%attrinit) {
    my $o = self.CREATE.BUILDALL(Empty, %attrinit);
    $o.setType('GTK::SearchBar');
    $o;
  }

  submethod BUILD(:$searchbar) {
    my $to-parent;
    given $searchbar {
      when Ancestry {
        $!sb = do {
          when GtkSearchBar {
            $to-parent = nativecast(GtkBin, $_);
            $_;
          }
          default {
            $to-parent = $_;
            nativecast(GtkSearchBar, $_);
          }
        }
        self.setBin($to-parent);
      }
      when GTK::SearchBar {
      }
      default {
      }
    }
  }

  multi method new (Ancestry $searchbar) {
    my $o = self.bless(:$searchbar);
    $o.upref;
    $o;
  }
  multi method new {
    my $searchbar = gtk_search_bar_new();
    self.bless(:$searchbar);
  }

  # ↓↓↓↓ SIGNALS ↓↓↓↓
  # ↑↑↑↑ SIGNALS ↑↑↑↑

  # ↓↓↓↓ ATTRIBUTES ↓↓↓↓
  method search_mode is rw is also<search-mode> {
    Proxy.new(
      FETCH => sub ($) {
        so gtk_search_bar_get_search_mode($!sb);
      },
      STORE => sub ($, Int() $search_mode is copy) {
        my gboolean $sm = self.RESOLVE-BOOL($search_mode);
        gtk_search_bar_set_search_mode($!sb, $sm);
      }
    );
  }

  method show_close_button is rw is also<show-close-button> {
    Proxy.new(
      FETCH => sub ($) {
        so gtk_search_bar_get_show_close_button($!sb);
      },
      STORE => sub ($, Int() $visible is copy) {
        my gboolean $v = self.RESOLVE-BOOL($visible);
        gtk_search_bar_set_show_close_button($!sb, $v);
      }
    );
  }
  # ↑↑↑↑ ATTRIBUTES ↑↑↑↑

  # ↓↓↓↓ METHODS ↓↓↓↓
  method connect_entry (GtkEntry() $entry) is also<connect-entry> {
    gtk_search_bar_connect_entry($!sb, $entry);
  }

  method get_type is also<get-type> {
    gtk_search_bar_get_type();
  }

  method handle_event (GdkEvent $event) is also<handle-event> {
    gtk_search_bar_handle_event($!sb, $event);
  }
  # ↑↑↑↑ METHODS ↑↑↑↑

}
