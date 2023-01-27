package;

import flash.system.System;
import flixel.input.touch.FlxTouch;
import openfl.events.UncaughtErrorEvent;
import openfl.utils.AssetType;
import openfl.utils.Assets;
import haxe.CallStack;
import flixel.FlxG;
import openfl.Lib;
#if android
import android.Hardware;
import android.Permissions;
import android.os.Environment;
#end
#if desktop 
import sys.io.File;
import sys.FileSystem;
#end
using StringTools;

class Tools
{
	static var path:String = lime.system.System.applicationStorageDirectory;
	public static var mode:Modes = ROOTDATA;
	private static var path:String = null;
	
	// by Sirox
	public static function returnPath(m:Modes = ROOTDATA):String {
		#if android
		if (m == ROOTDATA && mode != ROOTDATA) { // the most stupid checking i made
			m = mode;
		}
		switch (m) {
			case ROOTDATA:
				path = lime.system.System.applicationStorageDirectory;
			case INTERNAL:
			    path = Environment.getExternalStorageDirectory() + '/' + '.' + Application.current.meta.get('file') + '/';
				if (!FileSystem.exists(path)) {
					FileSystem.createDirectory(path);
				}
			/*case ANDROIDDATA:
			    path = Environment.getDataDirectory() + '/';*/
		}
		if (path != null && path.length > 0) {
			trace(path);
			return path;
		}
		trace('DEATH');
		return null;
		#else
		path = '';
		return path;
		#end
	}
	
        // by Musk
        public static function exists(folder:String, ?type:AssetType = null):Bool
	{
		var format:String = '';

		switch (type)
		{
			case FONT:
				format = '.ttf';
				if (!Assets.exists(folder + format))
					format = '.otf';
			case IMAGE:
				format = '.png';
			case MOVIE_CLIP:
				format = '.swf';
			case MUSIC | SOUND:
				format = '.ogg';
			case TEXT:
				format = '.txt';
				if (!Assets.exists(folder + format))
					format = '.xml';
			case BINARY | TEMPLATE:
				format = '.ay cabron';
				trace('Return: Put the file format in the path.');
		}

		return Assets.exists(folder + format);
	}
  
        public static function isDirectory(library:String):String
	{
		      return Assets.exists(library);
	}
  
        public static function getContent(library:String):String
	{
		      return Assets.getText(library);
	}
	
	public static function getBytes(library:String):String
	{
		      return Assets.getBytes(library);
	}
	
	public static function getBitmapData(library:String):String
	{
		      return Assets.getBitmapData(library);
	}
  
        public static function copyFolder(path:String, copyTo:String)
        {
		#if desktop 
		if (!FileSystem.exists(copyTo)) {
			sys.FileSystem.createDirectory(copyTo);
		}
		var files:Array<String> = FileSystem.readDirectory(path);
		for(file in files) {
			if (FileSystem.exists(path + "/" + file)) {
				copyFolder(path + "/" + file, copyTo + "/" + file);
			} else {
				sys.io.File.copy(path + "/" + file, copyTo + "/" + file);
			}
		}
		#end
	}
  
	public static function getPath(id:String, ?ext:String = "")
	{
		#if android
		var file = Assets.getBytes(id);

		var md5 = Md5.encode(Md5.make(file).toString());

		if (FileSystem.exists(path + md5 + ext))
			return path + md5 + ext;


		File.saveBytes(path + md5 + ext, file);

		return path + md5 + ext;
		#else
		return #if sys Sys.getCwd() + #end id;
		#end
	}
	
        // by Musk
        public static function readDirectory(library:String):Array<String>
	{
		var libraryArray:Array<String> = [];
		var gettt = Assets.list();

		for (folder in gettt.filter(file -> file.contains('$library')))
		{
			/*
			** folder.replace('$library/', '');
			** newFolder = folder; El string se convertía en 'assets' xdxdxdxdxjaskdjasd
			*/
			var newFolder:String = folder.replace('$library/', '');
			if (newFolder.contains('/'))
				newFolder = newFolder.replace(newFolder.substring(newFolder.indexOf('/'), newFolder.length), '');
			if (!libraryArray.contains(newFolder) && !newFolder.startsWith('.'))
				libraryArray.push(newFolder);
		}

		libraryArray.sort(function(a:String, b:String):Int 
		{
			a = a.toUpperCase();
			b = b.toUpperCase();

			if (a < b)
				return -1;
			else if (a > b)
				return 1;
			else
				return 0;
		});

		return libraryArray;
	}
  
}  
