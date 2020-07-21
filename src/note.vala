namespace Notes

{
    enum Column {
        HEADER,
        CONTENTS,
        N_COLUMS
    }

    public class Note: GLib.Object, Json.Serializable {
        public string Id {get; set; default = GLib.Uuid.string_random();}
        public string Header {get; set; default = "New note"; }
        public string Contents {get; set; default = "New note"; }

        public Note.with_data(string Header, string Contents) {
            this.Header = Header;
            this.Contents = Contents;
        }
    }

    public Note[] test_data() {
        return {
            new Note.with_data ("Test 1", "This is test 1"),
            new Note.with_data ("Test 2", "This is test 2")
        };

    }

    public bool save_notes () {
        var notes = test_data ();
        
        //size_t size;

        // var json = Json.gobject_to_data (notes[0], out size);
        
        var array = new Json.Array.sized (notes.length);
        for (int i = 0; i < notes.length; i++) {
            var node = Json.gobject_serialize(notes[i]);
            array.add_element (node);
        }

        var node = new Json.Node (Json.NodeType.ARRAY);
        node.set_array(array);

        Json.Generator generator = new Json.Generator ();
        generator.set_root (node);

        print (generator.to_data (null));      

        return true;
    }

    public Gtk.ListStore get_liststore() {
        Note[] notes = test_data();

        var listmodel = new Gtk.ListStore (1, typeof (Note));
        Gtk.TreeIter iter;

        for (int i = 0; i < notes.length; i++) {
            listmodel.append(out iter);
            listmodel.set(iter, 
                Column.HEADER, notes[i]
            );
        }

        return listmodel;
    }

    public Gtk.TreeIter new_note(Gtk.ListStore liststore) {
        Gtk.TreeIter iter;
        liststore.append(out iter);
        liststore.set(iter, 0, new Note ());
        return iter;
    }
}