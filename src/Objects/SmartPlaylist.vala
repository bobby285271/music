/*-
 * Copyright (c) 2011       Scott Ringwelski <sgringwe@mtu.edu>
 *
 * Originaly Written by Scott Ringwelski for BeatBox Music Player
 * BeatBox Music Player: http://www.launchpad.net/beat-box
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 59 Temple Place - Suite 330,
 * Boston, MA 02111-1307, USA.
 */

using Gee;

public class BeatBox.SmartPlaylist : Object {
	private int _rowid;
	public TreeViewSetup tvs;
	private string _name;
	private string _conditional; //any or all
	private Gee.ArrayList<SmartQuery> _queries;
	public int query_count;
	
	private bool _limit;
	private int _limit_amount;
	
	public bool is_up_to_date;
	LinkedList<int> songs;
	
	public SmartPlaylist() {
		_name = "";
		tvs = new TreeViewSetup("#", Gtk.SortType.ASCENDING, MusicTreeView.Hint.SMART_PLAYLIST);
		_conditional = "all";
		query_count = 0;
		_queries = new Gee.ArrayList<SmartQuery>();
		_limit = false;
		_limit_amount = 50;
	}
	
	public int rowid {
		get { return _rowid; }
		set { _rowid = value; }
	}
	
	public string name {
		get { return _name; }
		set { _name = value; }
	}
	
	public string conditional {
		get { return _conditional; }
		set {
			if(value == "all" || value == "any")
				_conditional = value;
			else
				stderr.printf("Invalid conditional for smart playlist. Must be \"all\" or \"any\". Supplied: %s \n", value);
		}
	}
	
	public bool limit {
		get { return _limit; }
		set { _limit = value; }
	}
	
	public int limit_amount {
		get { return _limit_amount; }
		set { _limit_amount = value; }
	}
	
	public void clearQueries() {
		query_count = 0;
		_queries.clear();
	}
	
	public Gee.ArrayList<SmartQuery> queries() {
		return _queries;
	}
	
	public void addQuery(SmartQuery s) {
		query_count++;
		_queries.add(s);
	}
	
	/** temp_playlist should be in format of #,#,#,#,#, **/
	public void queries_from_string(string q) {
		string[] queries_in_string = q.split("<query_seperator>", 0);
		
		int index;
		for(index = 0; index < queries_in_string.length - 1; index++) {
			string[] pieces_of_query = queries_in_string[index].split("<value_seperator>", 0);
			
			SmartQuery sq = new SmartQuery();
			sq.field = pieces_of_query[0];
			sq.comparator = pieces_of_query[1];
			sq.value = pieces_of_query[2];
			
			addQuery(sq);
		}
	}
	
	public string queries_to_string() {
		string rv = "";
		
		foreach(SmartQuery q in queries()) {
			rv += q.field + "<value_seperator>" + q.comparator + "<value_seperator>" + q.value + "<query_seperator>";
		}
		
		return rv;
	}
	
	public LinkedList<int> analyze(LibraryManager lm) {
		if(is_up_to_date) {
			return songs;
		}
		
		LinkedList<int> rv = new LinkedList<int>();
		
		foreach(Song s in lm.songs()) {
			int match_count = 0; //if OR must be greather than 0. if AND must = queries.size.
			
			foreach(SmartQuery q in _queries) {
				if(song_matches_query(q, s))
					match_count++;
			}
			
			if(((conditional == "all" && match_count == _queries.size) || (conditional == "any" && match_count >= 1)) && !s.isTemporary)
				rv.add(s.rowid);
				
			if(_limit && _limit_amount <= rv.size)
				return rv;
		}
		
		is_up_to_date = true;
		songs = rv;
		
		return rv;
	}
	
	public bool song_matches_query(SmartQuery q, Song s) {
		if(q.field == "Album") { //strings
			if(q.comparator == "is")
				return q.value.down() == s.album.down();
			else if(q.comparator == "contains")
				return (q.value.down() in s.album.down());
			else if(q.comparator == "does not contain")
				return !(q.value.down() in s.album.down());
		}
		else if(q.field == "Artist") {
			if(q.comparator == "is")
				return q.value.down() == s.artist.down();
			else if(q.comparator == "contains")
				return (q.value.down() in s.artist.down());
			else if(q.comparator == "does not contain")
				return !(q.value.down() in s.artist.down());
		}
		else if(q.field == "Comment") {
			if(q.comparator == "is")
				return q.value.down() == s.comment.down();
			else if(q.comparator == "contains")
				return (q.value.down() in s.comment.down());
			else if(q.comparator == "does not contain")
				return !(q.value.down() in s.comment.down());
		}
		else if(q.field == "Genre") {
			if(q.comparator == "is")
				return q.value.down() == s.genre.down();
			else if(q.comparator == "contains")
				return (q.value.down() in s.genre.down());
			else if(q.comparator == "does not contain")
				return !(q.value.down() in s.genre.down());
		}
		else if(q.field == "Title") {
			if(q.comparator == "is")
				return q.value.down() == s.title.down();
			else if(q.comparator == "contains")
				return (q.value.down() in s.title.down());
			else if(q.comparator == "does not contain")
				return !(q.value.down() in s.title.down());
		}
		else if(q.field == "Bitrate") {//numbers
			if(q.comparator == "is exactly")
				return int.parse(q.value) == s.bitrate;
			else if(q.comparator == "is at most")
				return (s.bitrate <= int.parse(q.value));
			else if(q.comparator == "is at least")
				return (s.bitrate >= int.parse(q.value));
		}
		else if(q.field == "Playcount") {
			if(q.comparator == "is exactly")
				return int.parse(q.value) == s.play_count;
			else if(q.comparator == "is at most")
				return (s.play_count <= int.parse(q.value));
			else if(q.comparator == "is at least")
				return (s.play_count >= int.parse(q.value));
		}
		else if(q.field == "Skipcount") {
			if(q.comparator == "is exactly")
				return int.parse(q.value) == s.skip_count;
			else if(q.comparator == "is at most")
				return (s.skip_count <= int.parse(q.value));
			else if(q.comparator == "is at least")
				return (s.skip_count >= int.parse(q.value));
		}
		else if(q.field == "Year") {
			if(q.comparator == "is exactly")
				return int.parse(q.value) == s.year;
			else if(q.comparator == "is at most")
				return (s.year <= int.parse(q.value));
			else if(q.comparator == "is at least")
				return (s.year >= int.parse(q.value));
		}
		else if(q.field == "Length") {
			if(q.comparator == "is exactly")
				return int.parse(q.value) == s.length;
			else if(q.comparator == "is at most")
				return (s.length <= int.parse(q.value));
			else if(q.comparator == "is at least")
				return (s.length >= int.parse(q.value));
		}
		else if(q.field == "Rating") {
			if(q.comparator == "is exactly")
				return int.parse(q.value) == s.rating;
			else if(q.comparator == "is at most")
				return (s.rating <= int.parse(q.value));
			else if(q.comparator == "is at least")
				return (s.rating >= int.parse(q.value));
		}
		else if(q.field == "Date Added") {//time
			var now = new DateTime.now_local();
			var played = new DateTime.from_unix_local(s.date_added);
			played = played.add_days(int.parse(q.value));
			
			if(q.comparator == "is exactly")
				return (now.get_day_of_year() == played.get_day_of_year() && now.get_year() == played.get_year());
			else if(q.comparator == "is within") {
				return played.compare(now) > 0;
			}
			else if(q.comparator == "is before") {
				return now.compare(played) > 0;
			}
		}
		else if(q.field == "Last Played") {
			if(s.last_played == 0)
				return false;
			
			var now = new DateTime.now_local();
			var played = new DateTime.from_unix_local(s.last_played);
			played = played.add_days(int.parse(q.value));
			
			if(q.comparator == "is exactly")
				return (now.get_day_of_year() == played.get_day_of_year() && now.get_year() == played.get_year());
			else if(q.comparator == "is within") {
				return played.compare(now) > 0;
			}
			else if(q.comparator == "is before") {
				return now.compare(played) > 0;
			}
		}
		
		return false;
	}
}
