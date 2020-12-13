using Gtk;

[GtkTemplate (ui = "/ui/settings.ui")]
public class SettingsDialog : Dialog {

    private GLib.Settings settings;

    [GtkChild]
    private Entry entry_local_file;

    [GtkChild]
    private Entry entry_remote_file;


    [GtkCallback]
    private void on_button_cancel_clicked (Button button) {
        this.close ();
    }

    public SettingsDialog () {
        stdout.printf("%s\n", "Init dialog");

        this.settings = new GLib.Settings ("com.github.moroen.quicknote");
        
        this.entry_local_file.text = this.settings.get_string ("filename");
    }

}