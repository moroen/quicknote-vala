namespace Notes

{
    enum Column {
        HEADER,
        CONTENTS,
        N_COLUMS
    }

    public class Note: GLib.Object, Json.Serializable {
        public string Id {get; set;}
        public string Header {get; set;}
        public string Contents {get; set;}

        public Note(string Header, string Contents) {
            this.Id = GLib.Uuid.string_random();
            this.Header = Header;
            this.Contents = Contents;
        }
    }

    public Note[] test_data() {
        return {
            new Note ("Test 1", "This is test 1"),
            new Note ("Test 2", "This is test 2")
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

        var listmodel = new Gtk.ListStore (Column.N_COLUMS, typeof (string), typeof (string));
        Gtk.TreeIter iter;

        for (int i = 0; i < notes.length; i++) {
            listmodel.append(out iter);
            listmodel.set(iter, 
                Column.HEADER, notes[i].Header,
                Column.CONTENTS, notes[i].Contents
            );
        }

        return listmodel;
    }

    public Gtk.TreeIter new_note(Gtk.ListStore liststore) {
        Gtk.TreeIter iter;
        /*
        var model = this.treeview_notes.get_model ();

        model.get_iter_from_string (out iter, "0");  
        this.listmodel.set(iter, Notes.Column.HEADER, "Tjoho");
        */

        liststore.append(out iter);
        liststore.set(iter, 
            Column.HEADER, "New note",
            Column.CONTENTS, ""
        );

        return iter;
    }
}