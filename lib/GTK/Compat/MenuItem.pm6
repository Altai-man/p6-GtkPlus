use v6.c;

use NativeCall;

use GTK::Compat::Types;
use GTK::Compat::Raw::Menu;

class GTK::MenuItem {
  has GMenuItem $!mitem;

  submethod BUILD(:$item) {
    $!mitem = $item
  }

  multi method new (GMenuItem $item) {
    self.bless(:$item);
  }
  multi method new (Str() $label, Str() $detailed_action) {
    my $item = g_menu_item_new($label, $detailed_action);
    self.bless(:$item);
  }

  method new_from_model (GMenuModel() $model, Int() $item_index) {
    my gint $ii = self.RESOLVE-INT($item_index);
    my $item = g_menu_item_new_from_model($model, $ii);
    self.bless(:$item);
  }

  # ↓↓↓↓ SIGNALS ↓↓↓↓
  # ↑↑↑↑ SIGNALS ↑↑↑↑

  # ↓↓↓↓ ATTRIBUTES ↓↓↓↓
  # ↑↑↑↑ ATTRIBUTES ↑↑↑↑

  # ↓↓↓↓ PROPERTIES ↓↓↓↓
  # ↑↑↑↑ PROPERTIES ↑↑↑↑

  method new_section (Str() $label, GMenuModel() $section) {
    g_menu_item_new_section($label, $section);
  }

  method new_submenu (Str() $label, GMenuModel() $submenu) {
    g_menu_item_new_submenu($label, $submenu);
  }

  # ↓↓↓↓ METHODS ↓↓↓↓
  method get_attribute_value (
    Str() $attribute,
    GVariantType $expected_type
  ) {
    g_menu_item_get_attribute_value($!mitem, $attribute, $expected_type);
  }

  method get_link (Str() $link) {
    g_menu_item_get_link($!mitem, $link);
  }

  method get_type {
    g_menu_item_get_type();
  }

  method set_action_and_target_value (
    Str() $action,
    GVariant $target_value
  ) {
    g_menu_item_set_action_and_target_value($!mitem, $action, $target_value);
  }

  method set_attribute_value (Str() $attribute, GVariant $value) {
    g_menu_item_set_attribute_value($!mitem, $attribute, $value);
  }

  method set_detailed_action (Str() $detailed_action) {
    g_menu_item_set_detailed_action($!mitem, $detailed_action);
  }

  method set_icon (GIcon() $icon) {
    g_menu_item_set_icon($!mitem, $icon);
  }

  method set_label (Str() $label) {
    g_menu_item_set_label($!mitem, $label);
  }

  method set_link (Str() $link, GMenuModel() $model) {
    g_menu_item_set_link($!mitem, $link, $model);
  }

  method set_section (GMenuModel() $section) {
    g_menu_item_set_section($!mitem, $section);
  }

  method set_submenu (GMenuModel() $submenu) {
    g_menu_item_set_submenu($!mitem, $submenu);
  }
  # ↑↑↑↑ METHODS ↑↑↑↑

}
