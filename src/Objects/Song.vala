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

//using Gst;
using Gtk;

public class BeatBox.Song : GLib.Object{
	//core info
	private string _file;
	private string _file_name;
	private string _file_directory;
	private int _file_size;
	private int _rowid;
	
	//tags
	private string _title;
	private string _artist;
	private string _album;
	private string _genre;
	private string _comment;
	private int _year;
	private int _track;
	
	//audioproperties
	private int _bitrate;
	private int _length;
	private int _samplerate;
	private int _bpm;
	
	//extra stuff for beatbox
	private int _rating;
	private int _score;//calculated based on skips, plays, etc.
	private int _play_count;
	private int _skip_count;
	private int _date_added;
	private int _last_played;
	private string _lastfm_url;
	private string _lyrics;
	private string _album_path;
	
	public bool isPreview;
	
	//core stuff
	public Song(string file) {
		this.file = file;
		file_name = "";
		file_directory = "";
		file_size = 0;
		rowid = 0;
		track = 0;
		title = "Unknown Title";
		artist = "Unknown Artist";
		album = "Unknown Album";
		genre = "";
		comment = "";
		year = 0;
		bitrate = 0;
		length = 0;
		samplerate = 0;
		bpm = 0;
		rating = 0;
		score = 0;
		play_count = 0;
		skip_count = 0;
		date_added = 0;
		last_played = 0;
		lyrics = "";
		_album_path = "";
	}
	
	public string file {
		get { return _file; }
		set { _file = value; }
	}
	
	public string file_directory {
		get { return _file_directory; }
		set { _file_directory = value; }
	}
	
	public string file_name {
		get { return _file_name; }
		set { _file_name = value; }
	}
	
	public int file_size {
		get { return _file_size; }
		set { _file_size = value; }
	}
	
	public int rowid {
		get { return _rowid; }
		set { _rowid = value; }
	}
	
	
	//tags
    public string title {
        get { return _title; }
        set { _title = value; }
    }
    
    public string artist {
        get { return _artist; }
        set { _artist = value; }
    }
    
    public string album {
		get { return _album; }
		set { _album = value; }
	}
	
	public string genre {
		get { return _genre; }
		set { _genre = value; } // add smart genre fixer ("rock" -> "Rock")
	}
	
	public string comment {
		get { return _comment; }
		set { _comment = value; }
	}
	
	public int year {
		get { return _year; }
		set { _year = value; }
	}
	
	public int track {
		get { return _track; }
		set { _track = value; }
	}
	
	
	//audioproperties
	public int bitrate {
		get { return _bitrate; }
		set { _bitrate = value; }
	}
	
	public int length {
		get { return _length; }
		set { _length = value; }
	}
	
	public string pretty_length() {
		int minute = 0;
		int seconds = _length;
		
		while(seconds >= 60) {
			++minute;
			seconds -= 60;
		}
		
		return minute.to_string() + ":" + ((seconds < 10 ) ? "0" + seconds.to_string() : seconds.to_string());
	}
	
	public int samplerate {
		get { return _samplerate; }
		set { _samplerate = value; }
	}
	
	public int bpm {
		get { return _bpm; }
		set { _bpm = value; }
	}
	
	public int rating {
		get { return _rating; }
		set { 
			if(value >= 0 && value <= 5)
				_rating = value;
		}
	}
	
	public int score {
		get { return _score; }
		set { _score = value; }
	}
	
	public int calculate_score() {
		
		return 1;
	}
	
	public int play_count {
		get { return _play_count; }
		set { _play_count = value; }
	}
	
	public int skip_count {
		get { return _skip_count; }
		set { _skip_count = value; }
	}
	
	public int last_played {
		get { return _last_played; }
		set { _last_played = value; }
	}
	
	public string pretty_last_played() {
		var t = Time.local(last_played);
		string rv = t.format("%m/%e/%Y %l:%M %p");
		return rv;
	}
	
	public int date_added {
		get { return _date_added; }
		set { _date_added = value; }
	}
	
	public string pretty_date_added() {
		var t = Time.local(date_added);
		string rv = t.format("%m/%e/%Y %l:%M %p");
		return rv;
	}
	
	public string lastfm_url {
		get { return _lastfm_url; }
		set { _lastfm_url = value; }
	}
	
	public string lyrics {
		get { return _lyrics; }
		set { _lyrics = value; }
	}
	
	public Song copy() {
		Song rv = new Song(_file);
		rv.file_name = file_name;
		rv.file_directory = file_directory;
		rv.file_size = file_size;
		rv.rowid = rowid;
		rv.track = track;
		rv.title = title;
		rv.artist = artist;
		rv.album = album;
		rv.genre = genre;
		rv.comment = comment;
		rv.year = year;
		rv.bitrate = bitrate;
		rv.length = length;
		rv.samplerate = samplerate;
		rv.bpm = bpm;
		rv.rating = rating;
		rv.score = score;
		rv.play_count = play_count;
		rv.skip_count = skip_count;
		rv.date_added = date_added;
		rv.last_played = last_played;
		rv.lyrics = lyrics;
		rv.setAlbumArtPath(getAlbumArtPath());
		
		return rv;
	}
	
	public void setAlbumArtPath(string? path) {
		if(path != null)
			_album_path = path;
	}
	
	public string getAlbumArtPath() {
		if(_album_path == "")
			return GLib.Path.build_filename("/", "usr", "share", "icons", "hicolor", "128x128", "mimetypes", "media-audio.png", null);
		else
			return _album_path;
	}
	
	public string getArtistImagePath() {
		return Path.build_path("/", _file.substring(0, _file.substring(0, _file.last_index_of("/", 0)).last_index_of("/", 0)), "Artist.jpg");
	}
}
