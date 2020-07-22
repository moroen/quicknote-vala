using Gtk;

[GtkTemplate (ui = "/ui/main.ui")]
public class MainWindow : ApplicationWindow {
    private int width = 0;
    private int height = 0;

    private GLib.Settings settings;

    Gtk.ListStore listmodel;

    [GtkChild]
    private TextView text_view;

    [GtkChild]
    private TreeView treeview_notes;

    [GtkChild]
    private Button button_del;
    
    [GtkCallback]
    private void on_button_add_clicked (Button button) {
        var iter = Notes.new_note(this.listmodel);
        var selection = this.treeview_notes.get_selection ();

        selection.select_iter (iter);
    }
    
    [GtkCallback]
    private void on_button_del_clicked (Button button) {
        Gtk.TreeIter iter;
        Gtk.TreeModel model;

        var selection = this.treeview_notes.get_selection ();
        
        if (selection.get_selected(out model, out iter)) {
            this.listmodel.remove(ref iter);
        } 
    }

    [GtkCallback]
    private void on_button_test_clicked (Button button) {
        Notes.save_notes (this.treeview_notes.get_model (), this.settings.get_string ("filename"));
    }

    
  

    public MainWindow () {
        
        this.settings = new GLib.Settings ("com.github.moroen.quicknote");

        try {
            this.icon = IconTheme.get_default ().load_icon ("accessories-text-editor", 48, 0);
        } catch (Error e) {
            stderr.printf (e.message);
        }

        /* Connect default signals */
        this.destroy.connect ( () => {
            
            /*
            try {
                FileUtils.set_contents(this.file_name, this.get_text_from_buffer(this.text_view.get_buffer()));
            } catch (FileError e) {
                stderr.printf("%s\n", e.message);
            }
            */
            this.settings.set_int("height", this.height);
            this.settings.set_int("width", this.width);
            GLib.Settings.sync ();
        });

        this.size_allocate.connect ( () => {
            this.get_size (out this.width, out this.height);
        });


        this.set_default_size(this.settings.get_int("width"), this.settings.get_int("height"));

        /* read file */
        // this.read_file();

        this.text_view.get_buffer().changed.connect ( (buffer) => {
            // print(get_text_from_buffer(buffer));
        });

        /* init liststore */
        this.listmodel = Notes.get_liststore();

        this.setup_treeview();
    }

    /*
    private void read_file () {
        string content;
        try {
            FileUtils.get_contents(this.file_name, out content);
            this.set_text(content);
        } catch (FileError e) {
            stderr.printf("%s\n", e.message);
        }
    }
    */

    public void set_text (string text) {
        var buffer = this.text_view.get_buffer();

        buffer.set_text(text);
    }

    public string get_text_from_buffer (Gtk.TextBuffer buffer) {
        TextIter start;
        TextIter end;
        
        buffer.get_bounds(out start, out end);
        var text = buffer.get_text(start, end, false);
        return text;
    }

    public void setup_treeview () {
             
        this.treeview_notes.set_model (this.listmodel);
        var cell = new Gtk.CellRendererText ();

        // this.treeview_notes.insert_column_with_attributes (-1, "Notes", cell, "text", Notes.Column.HEADER);

        this.treeview_notes.insert_column_with_data_func (-1, "Notes", cell, (column, cell, model, iter) => {
            Notes.Note note;

            model.@get (iter, 0, out note);

            unowned Gtk.CellRendererText renderer = (cell as Gtk.CellRendererText);
            renderer.text = note.Header;
        });
        

        var selection = this.treeview_notes.get_selection ();
        selection.changed.connect ( (selection) => {
            Gtk.TreeModel model;
            Gtk.TreeIter iter;
            Notes.Note note;

            if (selection.get_selected (out model, out iter)) {
                model.get(iter, 0, out note);
                this.text_view.get_buffer().set_text(note.Contents);
                this.button_del.set_sensitive(true);
            } else {
                this.text_view.get_buffer().set_text("");
                this.button_del.set_sensitive(false); 
            }

        });
    }
}

void main(string[] args) {
	Gtk.init (ref args);
	var win = new MainWindow();
	win.destroy.connect (Gtk.main_quit);

    win.show_all();
	Gtk.main();
}

