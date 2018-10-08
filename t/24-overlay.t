use v6.c;

# Example ported from:
# https://github.com/sweckhoff/GTK-Cairo-Sinusoids/blob/master/gtk_cairo_sinusoid_plot.c

use lib <t .>;

use GTK::Compat::Types;
use GTK::Raw::Types;
use overlay_example;

use GTK::Application;
use GTK::Box;
use GTK::ButtonBox;
use GTK::DrawingArea;
use GTK::Image;
use GTK::Label;
use GTK::Overlay;
use GTK::ToggleButton;
use GTK::Window;

my $packet = {
  width => 400,
  height => 200,
  rad_step => 0.05,
  scale_factor => 75,
  y0 => 100,
  x_step => 1,
  rads => 0.0,
  last_x => 0,
  last_y => 0,
  current_x => 0,
  current_y => 0,
  current_eraser_x => 150,
};

$packet<func> = &sin;
my $a = GTK::Application.new( title => 'org.genex.overlay', pod => $=pod );

sub do_graph($packet) {
  my ($pi_rads, $label);

  $packet<rads> = 0 if $packet<rads> >= 2.0;
  $pi_rads = pi * $packet<rads>;
  $packet<label>.text = "Radians: { $packet<rads>.round(0.1) }pi";
  $packet<rads> += $packet<rad_step>;
  $packet<current_x> = 0 if $packet<current_x> > $packet<width>;
  $packet<last_x last_y> = $packet<current_x current_y>;
  $packet<current_x> += $packet<x_step>;
  $packet<current_y> = $packet<y0> - (
    $packet<scale_factor> * $packet<func>($pi_rads)
  );

  $packet<current_eraser_x> += $packet<x_step>;
  $packet<current_eraser_x> = 0 if $packet<current_eraser_x> > $packet<width>;
  $a.window.queue_draw;
}

sub draw_callback($drawable, $packet) {
  say $drawable;
  # Erase Old
  move_to($packet<eraser>, $packet<current_eraser_x>, 0);
  line_to($packet<eraser>, $packet<current_eraser_x>, $packet<height>);
  cairo_stroke($packet<eraser>);
  # Plot New
  move_to($packet<plot>, $packet<last_x>, $packet<last_y>);
  line_to($packet<plot>, $packet<current_x>, $packet<current_y>);
  cairo_stroke($packet<plot>);

  set_source_surface($drawable, $packet<plot_surface>, 0, 0);
  cairo_paint($drawable);
  False;
}

$a.activate.tap({
  $packet<plot_surface> = image_surface_create(
    CAIRO_FORMAT_ARGB32,
    400,
    200
  );
  die 'Could not create plot surface' unless $packet<plot_surface>;

  $packet<plot> = cairo_create($packet<plot_surface>) or die;
  set_source_rgba($packet<plot>, 1, 0, 0, 0);
  $packet<eraser> = cairo_create($packet<plot_surface>) or die;
  set_source_rgba($packet<eraser>, 0, 0, 0, 0);
  set_operator($packet<eraser>, CAIRO_OPERATOR_CLEAR);
  $a.window.set_size_request(480, 200);
  $packet<window> = $a.window;

  my $overlay = GTK::Overlay.new or die;
  my ($i, $bg) = ('t/plot_background.png', 't/pi_background.png');
  $i = './plot_background.png' unless $i.IO.e;
  $bg = './pi_background.png' unless $bg.IO.e;
  my $image = GTK::Image.new_from_file($i);
  my $background = GTK::Image.new_from_file($bg);
  $packet<label> = GTK::Label.new('Radians: 0.0pi');
  $packet<label>.halign = GTK_ALIGN_START;
  $packet<label>.valign = GTK_ALIGN_END;
  $packet<label>.name = 'radlabel';

  my $drawing_area = GTK::DrawingArea.new;
  $drawing_area.set_size_request(400, 200);
  my $da = $drawing_area.p;
  $drawing_area.draw.tap(-> *@a {
    # Expecting: self, CairoContext, user_data
    #
    # Do these calls do the same thing? (even though the values in $packet change...)
    draw_callback($da, $packet);
    draw_callback(@a[1], $packet);
  });

  $overlay.add($background);
  $overlay.add_overlay($image);
  $overlay.add_overlay($drawing_area);
  $overlay.add_overlay($packet<label>);

  my $hbox = GTK::Box.new-hbox(10);
  my $vbox = GTK::Box.new-vbox(5);
  my @group = GTK::RadioButton.new-group('SIN', 'COS');
  for @group {
    my $b = $_;
    $b.clicked.tap({
      given $b.label {
        when 'SIN' { $packet<func> = &sin if $b.active; }
        when 'COS' { $packet<func> = &cos if $b.active; }
      }
    });
    $vbox.pack_start($b, True, False);
  }

  @group[0].active = True;
  $hbox.pack_start($overlay, False, False);
  $hbox.pack_start($vbox, False, False);
  $a.window.add($hbox);
  $a.window.show_all;

  # set_timeout equivalent.
  $*SCHEDULER.cue({ do_graph($packet) }, :every(0.1));
});

$a.run;

=begin css
#radlabel { color: #ffffff; }
=end css
