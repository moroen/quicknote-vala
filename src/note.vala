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

    public bool save_liststore (Gtk.TreeModel model, string file_name) {
       
        var array = new Json.Array();

        model.foreach ( (model, path, iter) => {
            Note note;
     
            model.get(iter, 0, out note);
            var node = Json.gobject_serialize(note);
            array.add_element(node);
            return false;
        });    

        var node = new Json.Node (Json.NodeType.ARRAY);
        node.set_array(array);

        var jobj = new Json.Object ();
        jobj.set_array_member ("notes", array);

        var root_node = new Json.Node (Json.NodeType.OBJECT);
        root_node.set_object (jobj);
        
        Json.Generator generator = new Json.Generator ();
        generator.set_root (root_node);

        try {
            FileUtils.set_contents(file_name, generator.to_data (null));
        } catch (FileError e) {
            stderr.printf("%s\n", e.message);
        }
        
        // print (generator.to_data (null));      

        return true;
    }

    public Gtk.ListStore get_liststore(string file_name) {
        var listmodel = new Gtk.ListStore (1, typeof (Note));
        Gtk.TreeIter iter;

        try {
            var parser = new Json.Parser();
            parser.load_from_file (file_name);

            var root = parser.get_root ().get_object ();
            var notes_array = root.get_array_member("notes");

            foreach (var node_element in notes_array.get_elements ()) {
                Note note = Json.gobject_deserialize (typeof(Note), node_element) as Note;
                listmodel.append(out iter);
                listmodel.set(iter, Column.HEADER, note);
            }
        } catch (FileError e) {
            stderr.printf("%s\n", e.message);

            listmodel.append(out iter);
            listmodel.set(iter, Column.HEADER, new Note.with_data("New note", "New note"));
         
        } catch (Error e) {
            stderr.printf("%s\n", e.message);
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