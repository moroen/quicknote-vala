using Gtk;

[GtkTemplate (ui = "/ui/settings.ui")]
public class SettingsDialog : Dialog {

    private GLib.Settings settings;

    [GtkChild]
    private Entry entry_local_file;

    [GtkChild]
    private Entry entry_remote_file;

    [GtkChild]
    private Label label_remote;

    [GtkChild]
    private ToggleButton togglebutton_remote;

    [GtkCallback]
    private void on_togglebutton_remote_toggled (ToggleButton toggle) {
        bool toggle_state = toggle.get_active ();
        this.label_remote.set_sensitive (toggle_state);
        this.entry_remote_file.set_sensitive( toggle_state);
    }

    [GtkCallback]
    private void on_button_save_clicked (Button button) {
        this.settings.set_boolean ("useremote", this.togglebutton_remote.active);
        this.settings.set_string ("remotefilename", this.entry_remote_file.text);
        this.settings.set_string ("filename", this.entry_local_file.text);
        this.close ();
    }

    [GtkCallback]
    private void on_button_cancel_clicked (Button button) {
        this.close ();
    }

    [GtkCallback]
    private void on_button_browse_clicked (Button button) {
        var open_dialog = new Gtk.FileChooserDialog ("Pick a file",
		                                             this as Gtk.Window,
		                                             Gtk.FileChooserAction.OPEN,
		                                             Gtk.Stock.CANCEL,
		                                             Gtk.ResponseType.CANCEL,
		                                             Gtk.Stock.OPEN,
		                                             Gtk.ResponseType.ACCEPT);

		open_dialog.local_only = false; //allow for uri
		open_dialog.set_modal (true);
		open_dialog.response.connect (open_response_cb);
		open_dialog.show ();
    }


    void open_response_cb (Gtk.Dialog dialog, int response_id) {
		var open_dialog = dialog as Gtk.FileChooserDialog;

		switch (response_id) {
			case Gtk.ResponseType.ACCEPT: //open the file
                string file = open_dialog.get_filename ();
                this.entry_local_file.text = file;
                break;
			case Gtk.ResponseType.CANCEL:
				print ("cancelled: FileChooserAction.OPEN\n");
				break;
		}
		dialog.destroy ();
	}

    public SettingsDialog () {
        
        // Settings
        this.settings = new GLib.Settings ("com.github.moroen.quicknote");
        this.entry_local_file.text = this.settings.get_string ("filename");
        this.togglebutton_remote.active = this.settings.get_boolean ("useremote");
        this.entry_remote_file.text = this.settings.get_string ("remotefilename");
        this.entry_remote_file.set_sensitive (this.togglebutton_remote.active);
        this.label_remote.set_sensitive (this.togglebutton_remote.active);
    }

}