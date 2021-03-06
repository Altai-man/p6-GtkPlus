use v6.c;

use Method::Also;
use NativeCall;

use GTK::Compat::GSList;
use GTK::Compat::Types;
use GTK::Raw::TextIter;
use GTK::Raw::Types;

class GTK::TextIter {
  also does GTK::Roles::Types;

  has GtkTextIter $!ti;

  method bless(*%attrinit) {
    use nqp;
    my $o = nqp::create(self).BUILDALL(Empty, %attrinit);
    # Non-widget descendent does not have setType.
    #$o.setType('GTK::TextIter');
    $o;
  }

  submethod BUILD(:$textiter) {
   $!ti = $textiter
  }

  multi method new {
    my $textiter = GtkTextIter.new;
    self.bless(:$textiter);
  }
  multi method new(GtkTextIter $textiter) {
    self.bless(:$textiter);
  }

  method GTK::Raw::Types::GtkTextIter {
    $!ti;
  }

  # ↓↓↓↓ SIGNALS ↓↓↓↓
  # ↑↑↑↑ SIGNALS ↑↑↑↑

  # ↓↓↓↓ ATTRIBUTES ↓↓↓↓
  method line is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_text_iter_get_line($!ti);
      },
      STORE => sub ($, Int() $line_number is copy) {
        my gint $ln = self.RESOLVE-INT($line_number);
        gtk_text_iter_set_line($!ti, $ln);
      }
    );
  }

  method line_index is rw is also<line-index> {
    Proxy.new(
      FETCH => sub ($) {
        gtk_text_iter_get_line_index($!ti);
      },
      STORE => sub ($, Int() $byte_on_line is copy) {
        my gint $b = self.RESOLVE-INT($byte_on_line);
        gtk_text_iter_set_line_index($!ti, $b);
      }
    );
  }

  method line_offset is rw is also<line-offset> {
    Proxy.new(
      FETCH => sub ($) {
        gtk_text_iter_get_line_offset($!ti);
      },
      STORE => sub ($, int() $char_on_line is copy) {
        my gint $c = self.RESOLVE-INT($char_on_line);
        gtk_text_iter_set_line_offset($!ti, $c);
      }
    );
  }

  method offset is rw {
    Proxy.new(
      FETCH => sub ($) {
        gtk_text_iter_get_offset($!ti);
      },
      STORE => sub ($, Int() $char_offset is copy) {
        my gint $c = self.RESOLVE-INT($char_offset);
        gtk_text_iter_set_offset($!ti, $c);
      }
    );
  }

  method visible_line_index is rw is also<visible-line-index> {
    Proxy.new(
      FETCH => sub ($) {
        gtk_text_iter_get_visible_line_index($!ti);
      },
      STORE => sub ($, Int() $byte_on_line is copy) {
        my gint $b = self.RESOLVE-INT($byte_on_line);
        gtk_text_iter_set_visible_line_index($!ti, $b);
      }
    );
  }

  method visible_line_offset is rw is also<visible-line-offset> {
    Proxy.new(
      FETCH => sub ($) {
        gtk_text_iter_get_visible_line_offset($!ti);
      },
      STORE => sub ($, Int() $char_on_line is copy) {
        my gint $c = self.RESOLVE-INT($char_on_line);
        gtk_text_iter_set_visible_line_offset($!ti, $c);
      }
    );
  }
  # ↑↑↑↑ ATTRIBUTES ↑↑↑↑

  # ↓↓↓↓ METHODS ↓↓↓↓
  method assign (GtkTextIter() $other) {
    gtk_text_iter_assign($!ti, $other);
  }

  method backward_char is also<backward-char> {
    so gtk_text_iter_backward_char($!ti);
  }

  method backward_chars (gint $count) is also<backward-chars> {
    so gtk_text_iter_backward_chars($!ti, $count);
  }

  method backward_cursor_position is also<backward-cursor-position> {
    so gtk_text_iter_backward_cursor_position($!ti);
  }

  method backward_cursor_positions (gint $count) is also<backward-cursor-positions> {
    so gtk_text_iter_backward_cursor_positions($!ti, $count);
  }

  method backward_find_char (
    GtkTextCharPredicate $pred,
    gpointer $user_data,
    GtkTextIter() $limit
  ) is also<backward-find-char> {
    so gtk_text_iter_backward_find_char(
      $!ti,
      $pred,
      $user_data,
      $limit
    );
  }

  method backward_line is also<backward-line> {
    so gtk_text_iter_backward_line($!ti);
  }

  method backward_lines (gint $count) is also<backward-lines> {
    so gtk_text_iter_backward_lines($!ti, $count);
  }

  method backward_search (
    gchar $str,
    GtkTextSearchFlags $flags,
    GtkTextIter() $match_start,
    GtkTextIter() $match_end,
    GtkTextIter() $limit
  ) is also<backward-search> {
    so gtk_text_iter_backward_search(
      $!ti,
      $str,
      $flags,
      $match_start,
      $match_end,
      $limit
    );
  }

  method backward_sentence_start is also<backward-sentence-start> {
    so gtk_text_iter_backward_sentence_start($!ti);
  }

  method backward_sentence_starts (gint $count) is also<backward-sentence-starts> {
    so gtk_text_iter_backward_sentence_starts($!ti, $count);
  }

  method backward_to_tag_toggle (GtkTextTag() $tag) is also<backward-to-tag-toggle> {
    so gtk_text_iter_backward_to_tag_toggle($!ti, $tag);
  }

  method backward_visible_cursor_position () is also<backward-visible-cursor-position> {
    so gtk_text_iter_backward_visible_cursor_position($!ti);
  }

  method backward_visible_cursor_positions (gint $count) is also<backward-visible-cursor-positions> {
    so gtk_text_iter_backward_visible_cursor_positions($!ti, $count);
  }

  method backward_visible_line is also<backward-visible-line> {
    so gtk_text_iter_backward_visible_line($!ti);
  }

  method backward_visible_lines (gint $count) is also<backward-visible-lines> {
    so gtk_text_iter_backward_visible_lines($!ti, $count);
  }

  method backward_visible_word_start is also<backward-visible-word-start> {
    so gtk_text_iter_backward_visible_word_start($!ti);
  }

  method backward_visible_word_starts (gint $count) is also<backward-visible-word-starts> {
    so gtk_text_iter_backward_visible_word_starts($!ti, $count);
  }

  method backward_word_start is also<backward-word-start> {
    so gtk_text_iter_backward_word_start($!ti);
  }

  method backward_word_starts (gint $count) is also<backward-word-starts> {
    so gtk_text_iter_backward_word_starts($!ti, $count);
  }

  method begins_tag (GtkTextTag() $tag) is also<begins-tag> {
    so gtk_text_iter_begins_tag($!ti, $tag);
  }

  method can_insert (gboolean $default_editability) is also<can-insert> {
    so gtk_text_iter_can_insert($!ti, $default_editability);
  }

  method compare (GtkTextIter() $rhs) {
    gtk_text_iter_compare($!ti, $rhs);
  }

  method copy {
    GTK::TextIter.new( gtk_text_iter_copy($!ti) );
  }

  method editable (gboolean $default_setting) {
    so gtk_text_iter_editable($!ti, $default_setting);
  }

  method ends_line is also<ends-line> {
    so gtk_text_iter_ends_line($!ti);
  }

  method ends_sentence is also<ends-sentence> {
    so gtk_text_iter_ends_sentence($!ti);
  }

  method ends_tag (GtkTextTag() $tag) is also<ends-tag> {
    so gtk_text_iter_ends_tag($!ti, $tag);
  }

  method ends_word is also<ends-word> {
    so gtk_text_iter_ends_word($!ti);
  }

  method equal (GtkTextIter() $rhs) {
    so gtk_text_iter_equal($!ti, $rhs);
  }

  method forward_char is also<forward-char> {
    so gtk_text_iter_forward_char($!ti);
  }

  method forward_chars (gint $count) is also<forward-chars> {
    so gtk_text_iter_forward_chars($!ti, $count);
  }

  method forward_cursor_position is also<forward-cursor-position> {
    so gtk_text_iter_forward_cursor_position($!ti);
  }

  method forward_cursor_positions (gint $count) is also<forward-cursor-positions> {
    so gtk_text_iter_forward_cursor_positions($!ti, $count);
  }

  method forward_find_char (
    GtkTextCharPredicate $pred,
    gpointer $user_data,
    GtkTextIter() $limit
  ) is also<forward-find-char> {
    so gtk_text_iter_forward_find_char($!ti, $pred, $user_data, $limit);
  }

  method forward_line is also<forward-line> {
    so gtk_text_iter_forward_line($!ti);
  }

  method forward_lines (gint $count) is also<forward-lines> {
    so gtk_text_iter_forward_lines($!ti, $count);
  }

  method forward_search (
    gchar $str,
    GtkTextSearchFlags $flags,
    GtkTextIter() $match_start,
    GtkTextIter() $match_end,
    GtkTextIter() $limit
  ) is also<forward-search> {
    so gtk_text_iter_forward_search(
      $!ti,
      $str,
      $flags,
      $match_start,
      $match_end,
      $limit
    );
  }

  method forward_sentence_end is also<forward-sentence-end> {
    so gtk_text_iter_forward_sentence_end($!ti);
  }

  method forward_sentence_ends (gint $count) is also<forward-sentence-ends> {
    so gtk_text_iter_forward_sentence_ends($!ti, $count);
  }

  method forward_to_end () is also<forward-to-end> {
    so gtk_text_iter_forward_to_end($!ti);
  }

  method forward_to_line_end is also<forward-to-line-end> {
    so gtk_text_iter_forward_to_line_end($!ti);
  }

  method forward_to_tag_toggle (GtkTextTag() $tag) is also<forward-to-tag-toggle> {
    so gtk_text_iter_forward_to_tag_toggle($!ti, $tag);
  }

  method forward_visible_cursor_position is also<forward-visible-cursor-position> {
    so gtk_text_iter_forward_visible_cursor_position($!ti);
  }

  method forward_visible_cursor_positions (gint $count) is also<forward-visible-cursor-positions> {
    so gtk_text_iter_forward_visible_cursor_positions($!ti, $count);
  }

  method forward_visible_line is also<forward-visible-line> {
    so gtk_text_iter_forward_visible_line($!ti);
  }

  method forward_visible_lines (gint $count) is also<forward-visible-lines> {
    so gtk_text_iter_forward_visible_lines($!ti, $count);
  }

  method forward_visible_word_end is also<forward-visible-word-end> {
    so gtk_text_iter_forward_visible_word_end($!ti);
  }

  method forward_visible_word_ends (gint $count) is also<forward-visible-word-ends> {
    so gtk_text_iter_forward_visible_word_ends($!ti, $count);
  }

  method forward_word_end is also<forward-word-end> {
    so gtk_text_iter_forward_word_end($!ti);
  }

  method forward_word_ends (gint $count) is also<forward-word-ends> {
    so gtk_text_iter_forward_word_ends($!ti, $count);
  }

  method free {
    gtk_text_iter_free($!ti);
  }

  method get_attributes (GtkTextAttributes $values) is also<get-attributes> {
    so gtk_text_iter_get_attributes($!ti, $values);
  }

  method get_buffer is also<get-buffer> {
    # Late binding to prevent circular dependency.
    ::('GTK::TextBuffer').new( gtk_text_iter_get_buffer($!ti) );
  }

  method get_bytes_in_line () is also<get-bytes-in-line> {
    gtk_text_iter_get_bytes_in_line($!ti);
  }

  method get_char is also<get-char> {
    gtk_text_iter_get_char($!ti);
  }

  method get_chars_in_line is also<get-chars-in-line> {
    gtk_text_iter_get_chars_in_line($!ti);
  }

  method get_child_anchor is also<get-child-anchor> {
    gtk_text_iter_get_child_anchor($!ti);
  }

  method get_language is also<get-language> {
    gtk_text_iter_get_language($!ti);
  }

  method get_marks is also<get-marks> {
    gtk_text_iter_get_marks($!ti);
  }

  method get_pixbuf is also<get-pixbuf> {
    gtk_text_iter_get_pixbuf($!ti);
  }

  method get_slice (GtkTextIter() $end) is also<get-slice> {
    gtk_text_iter_get_slice($!ti, $end);
  }

  method get_tags is also<get-tags> {
    GTK::Compat::GSList.new( gtk_text_iter_get_tags($!ti) );
  }

  method get_text (GtkTextIter() $end) is also<get-text> {
    gtk_text_iter_get_text($!ti, $end);
  }

  method get_toggled_tags (gboolean $toggled_on) is also<get-toggled-tags> {
    gtk_text_iter_get_toggled_tags($!ti, $toggled_on);
  }

  method get_type is also<get-type> {
    gtk_text_iter_get_type();
  }

  method get_visible_slice (GtkTextIter() $end) is also<get-visible-slice> {
    gtk_text_iter_get_visible_slice($!ti, $end);
  }

  method get_visible_text (GtkTextIter() $end) is also<get-visible-text> {
    gtk_text_iter_get_visible_text($!ti, $end);
  }

  method has_tag (GtkTextTag() $tag) is also<has-tag> {
    so gtk_text_iter_has_tag($!ti, $tag);
  }

  method in_range (GtkTextIter() $start, GtkTextIter() $end) is also<in-range> {
    so gtk_text_iter_in_range($!ti, $start, $end);
  }

  method inside_sentence is also<inside-sentence> {
    so gtk_text_iter_inside_sentence($!ti);
  }

  method inside_word is also<inside-word> {
    so gtk_text_iter_inside_word($!ti);
  }

  method is_cursor_position is also<is-cursor-position> {
    so gtk_text_iter_is_cursor_position($!ti);
  }

  method is_end is also<is-end> {
    so gtk_text_iter_is_end($!ti);
  }

  method is_start is also<is-start> {
    so gtk_text_iter_is_start($!ti);
  }

  method order (GtkTextIter $second) {
    gtk_text_iter_order($!ti, $second);
  }

  method starts_line is also<starts-line> {
    so gtk_text_iter_starts_line($!ti);
  }

  method starts_sentence is also<starts-sentence> {
    so gtk_text_iter_starts_sentence($!ti);
  }

  method starts_tag (GtkTextTag() $tag) is also<starts-tag> {
    so gtk_text_iter_starts_tag($!ti, $tag);
  }

  method starts_word is also<starts-word> {
    so gtk_text_iter_starts_word($!ti);
  }

  method toggles_tag (GtkTextTag() $tag) is also<toggles-tag> {
    so gtk_text_iter_toggles_tag($!ti, $tag);
  }
  # ↑↑↑↑ METHODS ↑↑↑↑

}

