use v6.c;

use Method::Also;
use NativeCall;

use GTK::Compat::Types;
use GTK::Raw::IconView;
use GTK::Raw::Types;

use GTK::CellArea;
use GTK::Container;

use GTK::Roles::CellLayout;
use GTK::Roles::Scrollable;
use GTK::Roles::Signals::IconView;

my subset Ancestry where GtkIconView | GtkCellLayout | GtkScrollable |
                         GtkBuilder  | GtkWidget;

class GTK::IconView is GTK::Container {
  also does GTK::Roles::CellLayout;
  also does GTK::Roles::Scrollable;
  also does GTK::Roles::Signals::IconView;

  has GtkIconView $!iv;

  method bless(*%attrinit) {
    my $o = self.CREATE.BUILDALL(Empty, %attrinit);
    $o.setType('GTK::IconView');
    $o;
  }

  submethod DESTROY {
    self.disconnect-all($_) for %!signals-iv;
  }

  submethod BUILD(:$iconview) {
    my $to-parent;
    given $iconview {
      when Ancestry {
        $!iv = do {
          when GtkIconView  {
            $to-parent = nativecast(GtkContainer, $_);
            $_;
          }
          when GtkCellLayout {
            $!cl = $_;                      # GTK::Roles::CellLayout
            $to-parent = nativecast(GtkContainer, $_);
            nativecast(GtkIconView, $_);
          }
          when GtkScrollable {
            $!s = $_;                       # GTK::Roles::CellLayout
            $to-parent = nativecast(GtkContainer, $_);
            nativecast(GtkIconView, $_);
          }
          when GtkWidget {
            $to-parent = $_;
            nativecast(GtkIconView, $_);
          }
        }
        self.setContainer($to-parent);
      }
      when GTK::IconView {
      }
      default {
      }
    }
    $!cl = nativecast(GtkCellLayout, $!iv); # GTK::Roles::CellLayout
    $!s = nativecast(GtkScrollable, $!iv);  # GTK::Roles::Scrollable
  }

  multi method new (Ancestry $iconview) {
    self.bless(:$iconview);
  }
  multi method new {
    my $iconview = gtk_icon_view_new();
    self.bless(:$iconview);
  }

  method new_with_area (GtkCellArea() $area) is also<new-with-area> {
    my $iconview = gtk_icon_view_new_with_area($area);
    self.bless(:$iconview);
  }

  method new_with_model (GtkTreeModel() $model) is also<new-with-model> {
    my $iconview = gtk_icon_view_new_with_model($model);
    self.bless(:$iconview);
  }

  # ↓↓↓↓ SIGNALS ↓↓↓↓

  # Is originally:
  # GtkIconView, gpointer --> gboolean
  method activate-cursor-item is also<activate_cursor_item> {
    self.connect-activate-cursor-item($!iv);
  }

  # Is originally:
  # GtkIconView, GtkTreePath, gpointer --> void
  method item-activated is also<item_activated> {
    self.connect-item-activated($!iv);
  }

  # Is originally:
  # GtkIconView, GtkMovementStep, gint, gpointer --> gboolean
  method move-cursor is also<move_cursor> {
    self.connect-move-cursor1($!iv);
  }

  # Is originally:
  # GtkIconView, gpointer --> void
  method select-all is also<select_all> {
    self.connect($!iv, 'select-all');
  }

  # Is originally:
  # GtkIconView, gpointer --> void
  method select-cursor-item is also<select_cursor_item> {
    self.connect($!iv, 'select-cursor-item');
  }

  # Is originally:
  # GtkIconView, gpointer --> void
  method selection-changed is also<selection_changed> {
    self.connect($!iv, 'selection-changed');
  }

  # Is originally:
  # GtkIconView, gpointer --> void
  method toggle-cursor-item is also<toggle_cursor_item> {
    self.connect($!iv, 'toggle-cursor-item');
  }

  # Is originally:
  # GtkIconView, gpointer --> void
  method unselect-all is also<unselect_all> {
    self.connect($!iv, 'unselect-all');
  }

  # ↑↑↑↑ SIGNALS ↑↑↑↑

  # ↓↓↓↓ ATTRIBUTES ↓↓↓↓
  method activate_on_single_click is rw is also<activate-on-single-click> {
    Proxy.new(
      FETCH => sub ($) {
        so gtk_icon_view_get_activate_on_single_click($!iv);
      },
      STORE => sub ($, Int() $single is copy) {
        my gboolean $s = self.RESOLVE-BOOL($single);
        gtk_icon_view_set_activate_on_single_click($!iv, $s);
      }
    );
  }

  method column_spacing is rw is also<column-spacing> {
    Proxy.new(
      FETCH => sub ($) {
        GTK::CellArea.new( gtk_icon_view_get_column_spacing($!iv) );
      },
      STORE => sub ($, GtkCellArea() $column_spacing is copy) {
        gtk_icon_view_set_column_spacing($!iv, $column_spacing);
      }
    );
  }

  method columns is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_icon_view_get_columns($!iv);
      },
      STORE => sub ($, Int() $columns is copy) {
        my gint $c = self.RESOLVE-INT($columns);
        gtk_icon_view_set_columns($!iv, $c);
      }
    );
  }

  method item_orientation is rw is also<item-orientation> {
    Proxy.new(
      FETCH => sub ($) {
        GtkOrientation( gtk_icon_view_get_item_orientation($!iv) );
      },
      STORE => sub ($, $orientation is copy) {
        my guint $o = self.RESOLVE-UINT($orientation);
        gtk_icon_view_set_item_orientation($!iv, $o);
      }
    );
  }

  method item_padding is rw is also<item-padding> {
    Proxy.new(
      FETCH => sub ($) {
        gtk_icon_view_get_item_padding($!iv);
      },
      STORE => sub ($, Int() $item_padding is copy) {
        my gint $i = self.RESOLVE-INT($item_padding);
        gtk_icon_view_set_item_padding($!iv, $i);
      }
    );
  }

  method item_width is rw is also<item-width> {
    Proxy.new(
      FETCH => sub ($) {
        gtk_icon_view_get_item_width($!iv);
      },
      STORE => sub ($, Int() $item_width is copy) {
        my gint $i = self.RESOLVE-INT($item_width);
        gtk_icon_view_set_item_width($!iv, $i);
      }
    );
  }

  method margin is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_icon_view_get_margin($!iv);
      },
      STORE => sub ($, Int() $margin is copy) {
        my gint $m = self.RESOLVE-INT($margin);
        gtk_icon_view_set_margin($!iv, $m);
      }
    );
  }

  method markup_column is rw is also<markup-column> {
    Proxy.new(
      FETCH => sub ($) {
        gtk_icon_view_get_markup_column($!iv);
      },
      STORE => sub ($, Int() $column is copy) {
        my gint $c = self.RESOLVE-INT($column);
        gtk_icon_view_set_markup_column($!iv, $c);
      }
    );
  }

  method model is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_icon_view_get_model($!iv);
      },
      STORE => sub ($, GtkTreeModel() $model is copy) {
        gtk_icon_view_set_model($!iv, $model);
      }
    );
  }

  method pixbuf_column is rw is also<pixbuf-column> {
    Proxy.new(
      FETCH => sub ($) {
        gtk_icon_view_get_pixbuf_column($!iv);
      },
      STORE => sub ($, Int() $column is copy) {
        my gint $c = self.RESOLVE-INT($column);
        gtk_icon_view_set_pixbuf_column($!iv, $c);
      }
    );
  }

  method reorderable is rw {
    Proxy.new(
      FETCH => sub ($) {
        so gtk_icon_view_get_reorderable($!iv);
      },
      STORE => sub ($, $reorderable is copy) {
        my gint $r = self.RESOLVE-INT($reorderable);
        gtk_icon_view_set_reorderable($!iv, $r);
      }
    );
  }

  method row_spacing is rw is also<row-spacing> {
    Proxy.new(
      FETCH => sub ($) {
        gtk_icon_view_get_row_spacing($!iv);
      },
      STORE => sub ($, Int() $row_spacing is copy) {
        my gint $r = self.RESOLVE-INT($row_spacing);
        gtk_icon_view_set_row_spacing($!iv, $r);
      }
    );
  }

  method selection_mode is rw is also<selection-mode> {
    Proxy.new(
      FETCH => sub ($) {
        GtkSelectionMode( gtk_icon_view_get_selection_mode($!iv) );
      },
      STORE => sub ($, Int() $mode is copy) {
        my gint $m = self.RESOLVE-INT($mode);
        gtk_icon_view_set_selection_mode($!iv, $m);
      }
    );
  }

  method spacing is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_icon_view_get_spacing($!iv);
      },
      STORE => sub ($, $spacing is copy) {
        my gboolean $s = self.RESOLVE-BOOL($spacing);
        gtk_icon_view_set_spacing($!iv, $spacing);
      }
    );
  }

  method text_column is rw is also<text-column> {
    Proxy.new(
      FETCH => sub ($) {
        gtk_icon_view_get_text_column($!iv);
      },
      STORE => sub ($, Int() $column is copy) {
        my gint $c = self.RESOLVE-INT($column);
        gtk_icon_view_set_text_column($!iv, $c);
      }
    );
  }

  method tooltip_column is rw is also<tooltip-column> {
    Proxy.new(
      FETCH => sub ($) {
        gtk_icon_view_get_tooltip_column($!iv);
      },
      STORE => sub ($, Int() $column is copy) {
        my gint $c = self.RESOLVE-INT($column);
        gtk_icon_view_set_tooltip_column($!iv, $c);
      }
    );
  }

  # ↑↑↑↑ ATTRIBUTES ↑↑↑↑

  # ↓↓↓↓ PROPERTIES ↓↓↓↓
  # ↑↑↑↑ PROPERTIES ↑↑↑↑

  # ↓↓↓↓ METHODS ↓↓↓↓

  method convert_widget_to_bin_window_coords (
    Int() $wx,
    Int() $wy,
    Int() $bx,
    Int() $by
  )
    is also<convert-widget-to-bin-window-coords>
  {
    my @i = ($wx, $wy, $bx, $by);
    my ($wxx, $wyy, $bxx, $byy) = self.RESOLVE-INT(@i);
    gtk_icon_view_convert_widget_to_bin_window_coords(
      $!iv,
      $wxx,
      $wyy,
      $bxx,
      $byy
    );
  }

  method create_drag_icon (GtkTreePath() $path) is also<create-drag-icon> {
    gtk_icon_view_create_drag_icon($!iv, $path);
  }

  method enable_model_drag_dest (
    GtkTargetEntry() $targets,
    Int() $n_targets,
    Int() $actions             # GdkDragAction $actions
  )
    is also<enable-model-drag-dest>
  {
    my gint $nt = self.RESOLVE-INT($n_targets);
    my uint32 $a = self.RESOLVE-UINT($actions);
    gtk_icon_view_enable_model_drag_dest($!iv, $targets, $nt, $a);
  }

  method enable_model_drag_source (
    Int() $start_button_mask,  # GdkModifierType $start_button_mask,
    GtkTargetEntry() $targets,
    Int() $n_targets,
    Int() $actions             # GdkDragAction $actions
  )
    is also<enable-model-drag-source>
  {
    my @u = ($start_button_mask, $actions);
    my guint ($s, $a) = self.RESOLVE-UINT(@u);
    my gint $nt = self.RESOLVE-INT($n_targets);
    gtk_icon_view_enable_model_drag_source($!iv, $s, $targets, $nt, $a);
  }

  method get_cell_rect (
    GtkTreePath() $path,
    GtkCellRenderer() $cell,
    GdkRectangle() $rect
  )
    is also<get-cell-rect>
  {
    gtk_icon_view_get_cell_rect($!iv, $path, $cell, $rect);
  }

  method get_cursor (GtkTreePath() $path, GtkCellRenderer() $cell)
    is also<get-cursor>
  {
    gtk_icon_view_get_cursor($!iv, $path, $cell);
  }

  method get_dest_item_at_pos (
    Int() $drag_x,
    Int() $drag_y,
    GtkTreePath() $path,
    uint32 $pos                 # GtkIconViewDropPosition $pos
  )
    is also<get-dest-item-at-pos>
  {
    my @i = ($drag_x, $drag_y);
    my gint ($dx, $dy) = self.RESOLVE-INT(@i);
    my uint32 $p = self.RESOLVE-UINT($pos);
    gtk_icon_view_get_dest_item_at_pos($!iv, $dx, $dy, $path, $p);
  }

  method get_drag_dest_item (
    GtkTreePath() $path,
    uint32 $pos                 # GtkIconViewDropPosition $pos
  )
    is also<get-drag-dest-item>
  {
    my uint32 $p = self.RESOLVE-UINT($pos);
    gtk_icon_view_get_drag_dest_item($!iv, $path, $p);
  }

  method get_item_at_pos (
    Int() $x,
    Int() $y,
    GtkTreePath() $path,
    GtkCellRenderer() $cell
  )
    is also<get-item-at-pos>
  {
    my @i = ($x, $y);
    my gint ($xx, $yy) = self.RESOLVE-INT(@i);
    gtk_icon_view_get_item_at_pos($!iv, $xx, $yy, $path, $cell);
  }

  method get_item_column (GtkTreePath() $path)
    is also<get-item-column>
  {
    gtk_icon_view_get_item_column($!iv, $path);
  }

  method get_item_row (GtkTreePath() $path)
    is also<get-item-row>
  {
    gtk_icon_view_get_item_row($!iv, $path);
  }

  method get_path_at_pos (Int() $x, Int() $y)
    is also<get-path-at-pos>
  {
    my @i = ($x, $y);
    my gint ($xx, $yy) = self.RESOLVE-INT(@i);
    gtk_icon_view_get_path_at_pos($!iv, $xx, $yy);
  }

  method get_selected_items is also<get-selected-items> {
    gtk_icon_view_get_selected_items($!iv);
  }

  method get_tooltip_context (
    Int() $x,
    Int() $y,
    Int() $keyboard_tip,
    GtkTreeModel() $model,
    GtkTreePath() $path,
    GtkTreeIter() $iter
  )
    is also<get-tooltip-context>
  {
    my @i = ($x, $y);
    my gint ($xx, $yy) = self.RESOLVE-INT(@i);
    my gboolean $kt = self.RESOLVE-BOOL($keyboard_tip);
    gtk_icon_view_get_tooltip_context(
      $!iv,
      $x,
      $y,
      $keyboard_tip,
      $model,
      $path,
      $iter
    );
  }

  method get_type is also<get-type> {
    gtk_icon_view_get_type();
  }

  method get_visible_range (
    GtkTreePath() $start_path,
    GtkTreePath() $end_path
  )
    is also<get-visible-range>
  {
    gtk_icon_view_get_visible_range($!iv, $start_path, $end_path);
  }

  method emit_item_activated (GtkTreePath() $path)
    is also<emit-item-activated>
  {
    gtk_icon_view_item_activated($!iv, $path);
  }

  method path_is_selected (GtkTreePath() $path) is also<path-is-selected> {
    gtk_icon_view_path_is_selected($!iv, $path);
  }

  method scroll_to_path (
    GtkTreePath() $path,
    Int() $use_align,
    Num() $row_align,
    Num() $col_align
  )
    is also<scroll-to-path>
  {
    my guint $ua = self.RESOLVE-BOOL($use_align);
    my num32 ($ra, $ca) = ($row_align, $col_align);
    gtk_icon_view_scroll_to_path($!iv, $path, $ua, $ra, $ca);
  }

  method select_all_icons is also<select-all-icons> {
    gtk_icon_view_select_all($!iv);
  }

  method select_path (GtkTreePath() $path) is also<select-path> {
    gtk_icon_view_select_path($!iv, $path);
  }

  method selected_foreach (
    GtkIconViewForeachFunc $func,
    gpointer $data
  )
    is also<selected-foreach>
  {
    gtk_icon_view_selected_foreach($!iv, $func, $data);
  }

  method set_cursor (
    GtkTreePath() $path,
    GtkCellRenderer() $cell,
    Int() $start_editing
  )
    is also<set-cursor>
  {
    my gboolean $se = self.RESOLVE-BOOL($start_editing);
    gtk_icon_view_set_cursor($!iv, $path, $cell, $se);
  }

  method set_drag_dest_item (
    GtkTreePath() $path,
    uint32 $pos                 # GtkIconViewDropPosition $pos
  )
    is also<set-drag-dest-item>
  {
    my uint32 $p = self.RESOLVE-UINT($pos);
    gtk_icon_view_set_drag_dest_item($!iv, $path, $p);
  }

  method set_tooltip_cell (
    GtkTooltip() $tooltip,
    GtkTreePath() $path,
    GtkCellRenderer() $cell
  )
    is also<set-tooltip-cell>
  {
    gtk_icon_view_set_tooltip_cell($!iv, $tooltip, $path, $cell);
  }

  method set_tooltip_item (GtkTooltip() $tooltip, GtkTreePath() $path)
    is also<set-tooltip-item>
  {
    gtk_icon_view_set_tooltip_item($!iv, $tooltip, $path);
  }

  method unselect_all_icons is also<unselect-all-icons> {
    gtk_icon_view_unselect_all($!iv);
  }

  method unselect_path (GtkTreePath() $path) is also<unselect-path> {
    gtk_icon_view_unselect_path($!iv, $path);
  }

  method unset_model_drag_dest is also<unset-model-drag-dest> {
    gtk_icon_view_unset_model_drag_dest($!iv);
  }

  method unset_model_drag_source is also<unset-model-drag-source> {
    gtk_icon_view_unset_model_drag_source($!iv);
  }

  # ↑↑↑↑ METHODS ↑↑↑↑

}
