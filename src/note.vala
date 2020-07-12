namespace Note

{
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
}