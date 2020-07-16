using Gtk;

[GtkTemplate (ui = "/ui/main.ui")]
public class MainWindow : ApplicationWindow {
    private int width = 0;
    private int height = 0;

    private GLib.Settings settings;

    string file_name = "%s/.quicknote".printf (GLib.Environment.get_home_dir ());

    Gtk.ListStore listmodel;
    
    
    [GtkCallback]
    private void on_button_add_clicked (Button button) {
        print ("The add-button was clicked");

        
       var iter = Notes.new_note(this.listmodel);

        var selection = this.treeview_notes.get_selection ();

        selection.select_iter(iter);

    }
    
    [GtkCallback]
    private void on_button_del_clicked (Button button) {
        print ("The del-button was clicked");
        Gtk.TreeIter iter;
        Gtk.TreeModel model;

        var selection = this.treeview_notes.get_selection ();
        
        if (selection.get_selected(out model, out iter)) {
            this.listmodel.remove(ref iter);
        }
    
    }

    [GtkChild]
    private TextView text_view;

    [GtkChild]
    private TreeView treeview_notes;
  

    public MainWindow () {
        
        this.settings = new GLib.Settings ("com.github.moroen.quicknote");

        try {
            this.icon = IconTheme.get_default ().load_icon ("accessories-text-editor", 48, 0);
        } catch (Error e) {
            stderr.printf (e.message);
        }

        /* Connect default signals */
        this.destroy.connect ( () => {
            
            try {
                FileUtils.set_contents(this.file_name, this.get_text());
            } catch (FileError e) {
                stderr.printf("%s\n", e.message);
            }

            this.settings.set_int("height", this.height);
            this.settings.set_int("width", this.width);
            GLib.Settings.sync ();
        });

        this.size_allocate.connect ( () => {
            this.get_size (out this.width, out this.height);
        });

        /*
        this.button_add.clicked.connect ( () => {
            this.set_text("Clicked");
        });
        */

        this.set_default_size(this.settings.get_int("width"), this.settings.get_int("height"));

        /* read file */
        this.read_file();

        /* init liststore */
        this.listmodel = Notes.get_liststore();

        this.setup_treeview();
    }

    private void read_file () {
        string content;
        try {
            FileUtils.get_contents(this.file_name, out content);
            this.set_text(content);
        } catch (FileError e) {
            stderr.printf("%s\n", e.message);
        }
    }

    public void set_text (string text) {
        var buffer = this.text_view.get_buffer();

        buffer.set_text(text);
    }

    public string get_text () {
        TextIter start;
        TextIter end;

        var buffer = this.text_view.get_buffer();
        
        buffer.get_bounds(out start, out end);
        var text = buffer.get_text(start, end, false);

        return text;
    }

    public void setup_treeview () {
             
        this.treeview_notes.set_model (this.listmodel);
        var cell = new Gtk.CellRendererText ();
        this.treeview_notes.insert_column_with_attributes (-1, "Notes", cell, "text", Notes.Column.HEADER);

        var selection = this.treeview_notes.get_selection ();
        selection.changed.connect ( (selection) => {
            print("Selection changed");
            Gtk.TreeModel model;
            Gtk.TreeIter iter;

            string contents;

            if (selection.get_selected (out model, out iter)) {
                model.get(iter,
                    Notes.Column.CONTENTS, out contents);
                    this.text_view.get_buffer().set_text(contents);
            }

        });
    }
}

void main(string[] args) {
	Gtk.init (ref args);
	var win = new MainWindow();
	win.destroy.connect (Gtk.main_quit);

	// var widget = new MyWidget ("The entry text!");

	// win.add (widget);
    win.show_all();

    

	Gtk.main();
}

/*
public void on_button1_clicked (Button source) {
    source.label = "Thank you!";
}

public void on_button2_clicked (Button source) {
    source.label = "Thanks!";
}

int main (string[] args) {
    Gtk.init (ref args);

    try {
        // If the UI contains custom widgets, their types must've been instantiated once
        // Type type = typeof(Foo.BarEntry);
        // assert(type != 0);
        var builder = new Builder ();
        builder.add_from_file ("sample.ui");
        builder.connect_signals (null);
        var window = builder.get_object ("window") as Window;
        window.show_all ();
        Gtk.main ();
    } catch (Error e) {
        stderr.printf ("Could not load UI: %s\n", e.message);
        return 1;
    }

    return 0;
}

*/
