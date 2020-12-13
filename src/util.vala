using Gtk;

string expand_file_name(string file_name) {

    int index = file_name.index_of_char('/');
    if (index == -1) {
        index = file_name.index_of_char('\\');
    }

    if (index == -1) {
        return "%s/%s".printf(GLib.Environment.get_home_dir (), file_name);
    } else {
        return file_name;
    }   
}

public string get_text_from_buffer (Gtk.TextBuffer buffer) {
    TextIter start;
    TextIter end;
    
    buffer.get_bounds(out start, out end);
    var text = buffer.get_text(start, end, false);
    return text;
}