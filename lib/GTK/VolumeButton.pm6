use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GTK::Raw::Types;
use GTK::Raw::VolumeButton;

use GTK::ScaleButton;

class GTK::VolumeButton is GTK::ScaleButton {
  has GtkVolumeButton $!vb;

  method bless(*%attrinit) {
    use nqp;
    my $o = nqp::create(self).BUILDALL(Empty, %attrinit);
    $o.setType('GTK::VolumeButton');
    $o;
  }

  submethod BUILD(:$button) {
    given $button {
      my $to-parent;
      when GtkVolumeButton | GtkWidget {
        $!vb = do {
          when GtkWidget       {
            $to-parent = $_;
            nativecast(GtkVolumeButton, $_);
          }
          when GtkVolumeButton {
            $to-parent = nativecast(GtkScaleButton, $_);
            $_;
          }
        }
        self.setScaleButton($to-parent);
      }
      when GTK::VolumeButton {
      }
      default {
      }
    }
  }

  method new {
    $button = gtk_volume_button_new();
    self.bless(:$button);
  }
  method new (GtkWidget $button) {
    self.bless(:$button);
  }

  # ↓↓↓↓ SIGNALS ↓↓↓↓
  # ↑↑↑↑ SIGNALS ↑↑↑↑

  # ↓↓↓↓ ATTRIBUTES ↓↓↓↓
  # ↑↑↑↑ ATTRIBUTES ↑↑↑↑

  # ↓↓↓↓ METHODS ↓↓↓↓
  method get_type {
    gtk_volume_button_get_type();
  }
  # ↑↑↑↑ METHODS ↑↑↑↑

}
