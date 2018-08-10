use v6.c;

use lib 't';

use Test;

use NativeCall;

# Could be abstracted away at the module level.
use GTK::Compat::Types;
use GTK::Raw::Types;
use GTK::Raw::Widget;

use GTK::Application;
use GTK::Button;
use GTK::Box;

use GTK::Raw::Container;

#use GTK::Raw::Subs :app, :window, :widget, :button;

my $a = GTK::Application.new(
  title  => 'org.genex.test.widget',
  width  => 400,
  height => 400
);

#$a.activate.tap({
#  my $win = gtk_application_window_new($a.app);
#  gtk_window_set_title($win, $a.title);
#  gtk_window_set_default_size($win, $a.width, $a.height);
#  gtk_application_add_window($a.app, $win);
#  gtk_widget_show_all($win);
#});

# Try this all without application and just a window.

$a.activate.tap({
  my $box = GTK::Box.new-box(GTK_ORIENTATION_VERTICAL, 6);

  #$a.window.add($box);
  gtk_container_add($a.window.window, $box.widget);

  my ($b1, $b2, $b3) = (
    GTK::Button.new_with_label('Click Me'),
    GTK::Button.new_with_mnemonic('_Open'),
    GTK::Button.new_with_mnemonic('_Close')
  );
  $b1.clicked.tap({ say 'Click me button was clicked'; });
  $b2.clicked.tap({ say 'Open button was clicked'; });
  $b3.clicked.tap({ say 'Closing application.'; $a.exit; });
  $box.pack_start($b1, True, True, 0);
  $box.pack_start($b2, True, True, 0);
  $box.pack_start($b3, True, True, 0);

  say "B: " ~ $box;
  say "BW: " ~ $box.widget;

  my $childs = gtk_container_get_children($box.widget);
  my $c = 1;
  while $childs {
    my $button = GTK::Button.new( :button($childs.data) );

    say "B{ $c++ }: { $button.label }";
    $childs = $childs.next;
  }

  #say $childs.first;

  $a.show_all;
});

$a.run;
