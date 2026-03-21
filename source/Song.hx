package;

import moonchart.formats.fnf.legacy.FNFPsych;
import moonchart.backend.FormatDetector;

import Section.SwagSection;
import haxe.Json;

using StringTools;

typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var events:Array<Dynamic>;
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
	public var events:Array<Dynamic>;
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

	public static function loadFromJson(jsonInput:String, ?diff:String = "normal", ?variant:String = null):SwagSong
	{
		var folderLowercase = StringTools.replace(jsonInput, " ", "-").toLowerCase();	
		trace('loading ' + folderLowercase);

		if (Paths.exists("data/songs/" + folderLowercase + '/chart-${variant.toLowerCase()}.json') || Paths.exists("data/songs/" + folderLowercase + '/' + diff.toLowerCase() + '-${variant.toLowerCase()}' + ".json"))
			variant = '-${variant.toLowerCase()}';
		else
			variant = "";

		if (Paths.exists("data/songs/" + folderLowercase + '/chart$variant.json'))
		{
			final fromFormatName = FormatDetector.findFormat([Paths.rawFile("data/songs/" + folderLowercase + '/chart$variant.json'), Paths.rawFile("data/songs/" + folderLowercase + '/meta$variant.json')]);
			final fromFormat = FormatDetector.createFormatInstance(fromFormatName);
			fromFormat.fromFile(Paths.rawFile("data/songs/" + folderLowercase + '/chart$variant.json'), Paths.exists("data/songs/" + folderLowercase + '/meta$variant.json') ? Paths.rawFile("data/songs/" + folderLowercase + '/meta$variant.json') : null, diff);

			return cast new FNFPsych().fromFormat(fromFormat, diff.toLowerCase()).data.song;
		} else {
			final fromFormatName = FormatDetector.findFormat(Paths.rawFile("data/songs/" + folderLowercase + '/' + diff.toLowerCase() + ".json"));
			final fromFormat = FormatDetector.createFormatInstance(fromFormatName);

			fromFormat.fromFile(Paths.rawFile("data/songs/" + folderLowercase + '/' + diff.toLowerCase() + variant + ".json"), Paths.exists("data/songs/" + folderLowercase + '/meta$variant.json') ? Paths.rawFile("data/songs/" + folderLowercase + '/meta$variant.json') : null, diff);

			var epicSong:SwagSong = cast new FNFPsych().fromFormat(fromFormat, diff.toLowerCase()).data.song;
			epicSong.stage = fromFormat.data.song.stage; //why the fuck does this happen what...?
			epicSong.events = fromFormat.data.song.events;
			
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
