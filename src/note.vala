namespace Notes

{
    enum Column {
        HEADER,
        CONTENTS,
        N_COLUMS
    }

    public class Note {
        public string Id;
        public string Header;
        public string Contents;

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
}