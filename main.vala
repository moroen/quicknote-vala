using Gtk;

[GtkTemplate (ui = "/ui/main.ui")]
public class MainWindow : ApplicationWindow {

    /* 
    [GtkCallback]
    private void on_button1_clicked (Button button) {
        print ("The button was clicked");
    
    }
    */

    private int width = 0;
    private int height = 0;

    private GLib.Settings settings;

    string file_name = "%s/.quicknote".printf (GLib.Environment.get_home_dir ());


    [GtkChild]
    private TextView textView;

    public MainWindow () {
        print ("Init");

        this.settings = new GLib.Settings ("com.github.moroen.quicknote");

        /* Connect default signals */
        this.destroy.connect ( () => {
            print ("Destroy");
            
            try {
                FileUtils.set_contents(this.file_name, this.get_text());
            } catch (FileError e) {
                stderr.printf("%s\n", e.message);
            }

            this.settings.set_int("height", this.height);
            this.settings.set_int("width", this.width);
            
            stdout.printf("Destroy - Width: %d Height: %d\n", this.width, this.height);
        });

        this.size_allocate.connect ( () => {
            this.get_size (out this.width, out this.height);
        });

        stdout.printf("Init - Width: %d Height: %d\n", this.settings.get_int("width"), this.settings.get_int("height"));

        this.set_default_size(this.settings.get_int("width"), this.settings.get_int("height"));

        /* read file */
        this.read_file();
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
        var buffer = this.textView.get_buffer();

        buffer.set_text(text);
    }

    public string get_text () {
        TextIter start;
        TextIter end;

        var buffer = this.textView.get_buffer();
        
        buffer.get_bounds(out start, out end);
        var text = buffer.get_text(start, end, false);

        return text;
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
