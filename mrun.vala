using Gtk;

public class MRun : Gtk.Dialog {

	private Gtk.Entry entry;
	private Gtk.Widget button;
	private Gtk.ListStore list_store;

	public MRun () {
		this.title = "Mini Run Progrum";
		this.window_position = WindowPosition.CENTER;
		this.destroy.connect (Gtk.main_quit);
		this.set_default_size (400, 10);

		var content = this.get_content_area () as Box;

		this.entry = new Entry ();
		content.add (entry);

		Gtk.EntryCompletion completion = new Gtk.EntryCompletion ();
		completion.set_inline_completion(true);
		entry.set_completion (completion);

		this.list_store = new Gtk.ListStore (1, typeof (string));
		completion.set_model (list_store);
		completion.set_text_column (0);

		var cell = new Gtk.CellRendererText ();
		completion.pack_start(cell, false);
		completion.add_attribute(cell, "text", 1);

		foreach (string path in GLib.Environment.get_variable("PATH").split(":")) {
			this.add_files_from(path);
		}

		this.add_button ("gtk-cancel", ResponseType.CANCEL);
		this.button = this.add_button ("gtk-ok", ResponseType.OK);
		this.button.sensitive = false;

		this.entry.changed.connect (() => {
			this.button.sensitive = (this.entry.text != "");
		});
		this.entry.activate.connect (run_event);
		this.response.connect (on_response);
	}

	private void add_files_from (string url) {
		var directory = File.new_for_path (url);
		try {
			var enumerator = directory.enumerate_children (FileAttribute.STANDARD_NAME, 0);
			FileInfo file_info;
			Gtk.TreeIter iter;
			while ((file_info = enumerator.next_file ()) != null) {
				this.list_store.append (out iter);
				this.list_store.set (iter, 0, file_info.get_name ());
			}
		} catch (Error e) {
			error ("%s", e.message);
		}
	}

	private void on_response (Dialog source, int response_id) {
		switch (response_id) {
		case ResponseType.CANCEL:
			destroy ();
			break;
		case ResponseType.OK:
			this.run_event();
			break;
		}
	}

	private void run_event () {
		try {
			GLib.Process.spawn_command_line_async(this.entry.text);
			destroy ();
		} catch (Error e) {
			error ("%s", e.message);
		}
	}

	public static int main (string[] args) {
		Gtk.init (ref args);

		MRun minirun = new MRun ();
		minirun.show_all();

		Gtk.main ();
		return 0;
	}
}
