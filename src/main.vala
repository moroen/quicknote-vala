using Gtk;



void main(string[] args) {
	Gtk.init (ref args);
	var win = new MainWindow();
	win.destroy.connect (Gtk.main_quit);

    win.show_all();
	Gtk.main();
}

