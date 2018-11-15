use v6.c;

use Cairo;

use GTK::Application;
use GTK::Box;
use GTK::DrawingArea;
use GTK::WidgetPath;

my $da;

sub append_element($p, $s) {
  my %p = (
    active          => GTK_STATE_FLAG_ACTIVE,
    hover           => GTK_STATE_FLAG_PRELIGHT,
    selected        => GTK_STATE_FLAG_SELECTED,
    disabled        => GTK_STATE_FLAG_INSENSITIVE,
    indeterminate   => GTK_STATE_FLAG_INCONSISTEN,
    focus           => GTK_STATE_FLAG_FOCUSED,
    backdrop        => GTK_STATE_FLAG_BACKDROP,
    'dir(ltr)'      => GTK_STATE_FLAG_DIR_LTR,
    'dir(rtl)'      => GTK_STATE_FLAG_DIR_RTL,
    link            => GTK_STATE_FLAG_LINK,
    visited         => GTK_STATE_FLAG_VISITED,
    checked         => GTK_STATE_FLAG_CHECKED,
    'drop(active)'  => GTK_STATE_FLAG_DROP_ACTIVE
  );

  my ($w,  $r)  = $s.split('#');
  my ($c, $pc)  = $r.split(':');
  my ($fc, *@c) = $c.split('.');
  $p.append_type(G_TYPE_NONE);
  $p.iter_set_object_name(-1, $fc);
  $p.iter_add_class(-1, $_) for @c;
  if %p{$pc}:exists {
    $p.iter_set_state(-1, %p{$pc});
  } else {
    warn "Pseudoclass '{ $pc }' does not exist!";
  }
}

sub create_context_for_path ($p, $pp) {
  my $c = GTK::StyleContext.new;

  ($c.path, $c.parent) = ($p, $pp);
  $c.state = $p.iter_get_state(-1);
  $c;
}

sub common_draw($cc, $xx, $yy, $ww, $hh) {
  $*cax = $xx // $*x;
  $*cay = $yy // $*y;

  $cc."get_{ $_ }"( $cc, $cc,state, %b{$_}) for %b.keys;

  my $mw = $cc.get($cc.state,  'min-width');
  my $mh = $cc.get($cc.state, 'min-height');

  $x += %*b<margin>.left;
  $y += %*b<margin>.top;
  $*caw = $ww - %*b<margin>.left + %*b<margin>.right;
  $*cah = $hh - %*b<margin>.top + %*b<margin>.bottom;
  ($w, $h) = ( ($w, $mw).min, ($h, $mh).min )

  GTK::Render.background($cc, $*cr, $*cax, $*cay, $*caw, $*cah);
  GTK::Render.frame($cc, $*cr, $*cax, $*cay, $*caw, $*cah);
  ($x, $y);
}
sub common_adjust($cx is rw, $cy is rw, $cw is rw, $ch is rw)
  $cx += $*cax + %*b<border>.left   + %*b<padding>.left;
  $cy += $*cay + %*b<border>.top    + %*b<padding>.top;
  $cw += $*caw - %*b<border>.left   - %*b<padding>.left -
                 %*b<border>.right  - %*b<padding>.right;
  $ch += $*cah - %*b<border>.top    - %*b<padding>.top -
                 %*b<border>.bottom - %*b<padding>.bottom;
}

multi sub draw_style_common-ro ($cc, $ww, $hh) {
  my ($*cax, $*cay, $*caw, $*cah);
  my %*b = (
    margin => GtkBorder.new, border => GtkBorder.new, padding => GtkBorder.new
  );
  common_draw($cc, $xx, $yy, $ww, $hh);
}
multi sub draw_style_common ($cc, $ww, $hh) {
  samewith($cc, Nil, Nil, $ww, $hh);
}
multi sub draw_style_common ($cc, $xx, $yy, $ww, $hh) {
  my %*b = (
    margin => GtkBorder.new, border => GtkBorder.new, padding => GtkBorder.new
  );
  my ($*cax, $*cay, $*caw, $*cah) = (;
  common_draw($cc, $xx, $yy, $ww, $hh);
  common_adjust($*cw, $*cy, $*cw, $*ch);
}
multi sub draw_style_common (
  $cc, $xx, $yy, $ww, $hh
  $cxx is rw, $cyy is rw, $cww is rw, $chh is rw
) {
  my %*b = (
    margin => GtkBorder.new, border => GtkBorder.new, padding => GtkBorder.new
  );
  my ($*cax, $*cay, $*caw, $*cah);
  common_draw($cc, $xx, $yy, $ww, $hh);
  common_adjust($cxx, $cyy, $cww, $chh);
}

multi sub query_size($cc, $w is rw, $h is rw) {
  my %*b = (
    margin => GtkBorder.new, border => GtkBorder.new, padding => GtkBorder.new
  );
  $cc."get_{ $_ }"( $cc, $cc,state, %b{$_}) for %b.keys;

  my $mw = $cc.get($cc.state,  'min-width');
  my $mh = $cc.get($cc.state, 'min-height');

  for ($mw, $mh) -> $min is rw {
    for <left right> X <margin border padding> -> ($m, $t) {
      $min += %b{$t}."$m"();
    }
  }

  $w = ($mw, $w).max with $w;
  $h = ($mh, $h).max with $h;
}

sub get_style($pp, $s) {
  my $p = $pp.defined ??
    GTK::WidgetPath.copy($pp.path) !! GTK::WidgetPath.new;

  append_element($p, $s);
  create_context_for_path($p, $pp);
}

sub get_style_with_siblings ($pp, $s, @sibs, $p) {
  my $p = $pp.defined ??
    GTK::WidgetPath.copy($pp.path) !! GTK::WidgetPath.new;

  my $sp = GTK::WidgetPath.new;
  append_element($sp, $_) for @sibs;
  $p.append_with_siblings($p, $sp, $p);
  $sp.downref;
  create_context_for_path($p, $pp);
}

sub draw_progress($p) {
  my ($bc, $tc, $pc);

  $bc = get_style( Nil, 'progressbar.horizontal');
  $tc = get_style( $cc, 'trough');
  $pc = get_style( $tc, 'progress.left');

  $*h = 0;
  query_size($_, $, $h) for $bc, $tc, $pc;
  draw_style_common-ro($_, $, $, $, $_ =:= $pc ?? $p !! $, $) 
    for $bc, $tc, $pc;
  .downref for $bc, $tc, $pc;
}

sub draw_scale($p) {
  my ($sc, $cc, $tc, $slc, $hc, $*cx, $*cy, $*cw, $*ch. $th, $sh);

  $sc  = get_style( Nil, 'scale.horizontal');
  $cc  = get_style( $sc, 'contents');
  $tc  = get_style( $cc, 'trough');
  $slc = get_style( $tc, 'slider');
  $hc  = get_style($slc, 'highlight.top');

  $*h = 0;
  query_size($_) for $sc, $cc, $tc, $slc, $hc;

  draw_style_common($sc, Nil,  Nil,  Nil,   $w,  $*h);
  draw_style_common($cc, Nil, $*cx, $*cy, $*cw, $*ch);

  $th = 0;
  query_size($tc, Nil, $th);
  $sh = 0;
  query_size($_, Nil, $sh) for $slc, $hc;
  $th += $sh;
  draw_style_common( $tc, Nil,      $*cx, $*cy,     $*cw,  $th);
  draw_style_common( $hc, Nil,      $*cw, $*cy, $*cw / 2, $*ch);
  draw_style_common($slc, Nil, $*cx + $p, $*cy,     $*ch, $*ch);

  .downref for $sc, $cc, $tc, $slc,  $hc
}

sub draw_combobox($he) {
  my ($ec, $btc, $bbc, $ac, $bw, $*cx, $*cy, $*cw, $*ch);
  my $cc = get_style(Nil, 'combobox:focus');
  my $bc = get_style($cc, 'box.horizontal.linked');

  my @s = <button.combo>;
  if $he {
    @s.unshift: 'entry.combo:focus';
    $ec  = get_style_with_siblings($bc, @s[0], @s, 0);
    $btc = get_style_with_siblings($bc, @s[1], @s, 1);
  } else {
    $btc = get_style_with_siblings($bc, @s[0], @s, 0);
  }
  $bbc = get_style($btc, 'box.horizontal');
  $ac  = get_style($bbc, 'arrow');

  $*h = 0;
  my @c = ($cc, $bc, $btc, $bbc, $ac);
  @c.splice(2, 0, $ec) if $he;
  query_size($_) for @c;

  my $aw = $ac.style_context_get($ac.get_state, 'min-width');
  my $ah = $ac.style_context_get($ac.get_state, 'min-height');
  my $as = ($aw, $ah).min;
  draw_style_common($_) for $cc, $bc;

  if $he {
    $bw = $*h;
    draw_style_common($ec, Nil, Nil, Nil, $*w - $bw, $*h);
    draw_style_common($bc, Nil, $*x + $*w - $bw, Nil, $bw);
  } else {
    $bw = $*w;
    draw_style_common($bc, Nil, $*x + $*w - $bw, Nil, $bw);
  }

  draw_style_common($bbc, Nil, $cx, $cy, $cw, $ch);
  draw_style_common( $ac, Nil, $cx, $cy, $cw, $ch);
  $ac.render_arrow($*cr, π/2, $cx + $cw - $as, $cy + ($ch - $as) / 2, $as);

  @c = $he ?? ($ac, $ec, $bc, $cc) !! ($ac, $bc, $cc);
  .downref for @c;
}

sub draw_spinbutton($h) {
  my ($sc, $ec, $uc, $dc, $it, $ii, $p)
  my ($iw, $ih, $is, $bw, $*cx, $*cy, $*cw, $*ch);

  $sc = get_style(Nil, 'spinbutton.horizontal:focus');
  $ec = get_style($sc, 'entry:focus');
  $uc = get_style($uc, 'button.up:focus:active');
  $dc = get_style($uc, 'button.down:focus');

  $*h = 0;
  query_size($_) for $sc, $ec, $uc, $dc;
  $bw = $h;

  draw_style_common($_) for $sc, $ec;

  for <add remove> {
    $it = GTK::IconTheme.get_for_screen($da.screen);
    $iw = $uc.style_context_get($uc.state, 'min-width');
    $ih = $uc.style_context_get($uc.state, 'min-height');
    $is = ($iw, $ih).min;
    $ii = $it.lookup_icon("list-{$_}-symnbolic", $is, 0);
    $p  = $ii.load_symbolic_for_context($uc);
    {
      my $x = $*x + $width - ($_ eq 'add' ?? 1 !! 2) * $bw;
      draw_style_common($uc, $x, Nil, $bw, Nil);
      GTK::Render.icon($uc, $cr, $p, $*cw, $*cy + ($ch - $is) / 2);
    }
  }

  .downref for $p, $dc, $uc, $ec, $sc;
}

sub do_draw($da, $cairo_t) {
  my ($*pw, $*w, $*h, $*x, $*y);
  my $*cr = cast(Cairo::Context, $cairo_t);

  ($w, $h) = ($da.get_allocated_width, $da.get_allocated_height);
  $*pw = $*w/2;
  $*cr.rectangle(0, 0, $*w, $*h);
  $*cr.set_source_rgb(0.9, 0.9, 0.9);
  $*cr.fill;

  $*x = $*y = 10;
  for (
    GTK_STATE_FLAG_NORMAL,
    GTK_STATE_FLAG_PRELIGHT
    GTK_STATE_FLAG_ACTIVE +| GTK_STATE_FLAG_PRELIGHT
  ) -> {
    draw_horizontal_scrollbar($pw - 20, 30 + $++ * 10 , $_, $h);
    $*y += $*h + 8;
  }

  $*y += $h + 8;
  for (GTK_STATE_FLAG_NORMAL, GTK_STATE_FLAG_SELECTED) {
    my $l = GTK_STATE_FLAG_NORMAL ?? 'Not selected' || 'Selected';
    draw_text($pw - 20, 20, $l, $_);
    $*y += 20 + 10 if $_ == GTK_STATE_FLAG_NORMAL;
  }

  $*x = 10;
  $*y += 20 + 10;
  for (&draw_checked, &draw_radio) -> $func {
    for <NORMAL CHECKED> {
      $func( ::("GTK_STATE_FLAG_$_") );
      $*x += $*w + 10;
    }
  }
  $*x = 10;

  $*y += $*h + 10;
  draw_progress($pw - 20, 50);

  $*y += $*h + 10;
  draw_scale($pw - 20, 75);

  $*y += $*h + 20;
  draw_notebook($pw - 20, 160);

  # Second column
  $*x += $pw;
  $*y = 10;
  draw_menu($pw - 20);

  $*y += $*h + 10;
  draw_menubar($pw - 20);

  $*y += $*h + 20;
  draw_spinbutton($pw - 30);

  $*y += $*h + 30;
  draw_combobox(     Nil, Nil, $pw - 20, False);
  $*y += $*h + 10;
  draw_combobox(10 + $pw, Nil, $pw - 20,  True);

  0;
}

my $a = GTK::Application.new( title => 'org.genex.widgetpath' );
$a.activate.tap({
  $a.window.title = 'Foreign Drawing';

  my $b  = GTK::Box.new-hbox(10);
  $da = GTK::DrawingArea.new;
  $da.set_size_request(400, 400);
  $da.hexpand = $da.vexpand = $da.app_paintable = True;
  $b.add($da);

  $da.draw.tap(-> *@a { @a[*-1].r = do_draw($da, @a[1]) });

  $a.window.show_all;
});

$a.run;