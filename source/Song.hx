package;

import moonchart.formats.fnf.legacy.FNFPsych;
import moonchart.backend.FormatDetector;

import Section.SwagSection;
import haxe.Json;
import lime.utils.Assets;

import sys.FileSystem;

using StringTools;

typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var bpm:Float;
	var needsVoices:Bool;
	var speed:Float;

	var player1:String;
	var player2:String;
	var gfVersion:String;
	var noteStyle:String;
	var stage:String;
	var validScore:Bool;
}

class Song
{
	public var song:String;
	public var notes:Array<SwagSection>;
	public var bpm:Float;
	public var needsVoices:Bool = true;
	public var speed:Float = 1;

	public var player1:String = 'bf';
	public var player2:String = 'dad';
	public var gfVersion:String = '';
	public var noteStyle:String = '';
	public var stage:String = '';

	public function new(song, notes, bpm)
	{
		this.song = song;
		this.notes = notes;
		this.bpm = bpm;
	}

	public static function loadFromJson(jsonInput:String, ?folder:String, ?diff:String = "normal"):SwagSong
	{
		var folderLowercase = StringTools.replace(folder, " ", "-").toLowerCase();	
		trace('loading ' + folderLowercase + '/' + jsonInput.toLowerCase());

		if (Paths.exists("data/songs/" + folderLowercase + '/chart.json'))
		{
			final fromFormatName = FormatDetector.findFormat([Paths.rawFile("data/songs/" + folderLowercase + '/chart.json'), Paths.rawFile("data/songs/" + folderLowercase + '/meta.json')]);
			final fromFormat = FormatDetector.createFormatInstance(fromFormatName);
			fromFormat.fromFile(Paths.rawFile("data/songs/" + folderLowercase + '/chart.json'), Paths.exists("data/songs/" + folderLowercase + '/meta.json') ? Paths.rawFile("data/songs/" + folderLowercase + '/meta.json') : null, diff);

			return cast new FNFPsych().fromFormat(fromFormat, diff).data.song;
		} else {
			final fromFormatName = FormatDetector.findFormat(Paths.rawFile("data/songs/" + folderLowercase + '/' + jsonInput.toLowerCase() + ".json"));
			final fromFormat = FormatDetector.createFormatInstance(fromFormatName);

			fromFormat.fromFile(Paths.rawFile("data/songs/" + folderLowercase + '/' + jsonInput.toLowerCase() + ".json"), Paths.exists("data/songs/" + folderLowercase + '/meta.json') ? Paths.rawFile("data/songs/" + folderLowercase + '/meta.json') : null, diff);

			var epicSong:SwagSong = cast new FNFPsych().fromFormat(fromFormat, diff).data.song;
			epicSong.stage = fromFormat.data.song.stage; //why the fuck does this happen what...?
			
			return epicSong;
		}
	}

	public static function parseJSONshit(rawJson:String):SwagSong
	{
		var swagShit:SwagSong = cast Json.parse(rawJson).song;
		swagShit.validScore = true;
		return swagShit;
	}
}
