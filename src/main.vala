using Gtk;



void main(string[] args) {
	Gtk.init (ref args);
	var win = new MainWindow();
	// var win = new SettingsWindow();
	win.destroy.connect (Gtk.main_quit);

    win.show_all();
	Gtk.main();
}

