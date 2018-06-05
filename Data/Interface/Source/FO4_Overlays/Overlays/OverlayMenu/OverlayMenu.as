﻿package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import AS3.*;
	import Overlays.*;

	public class OverlayMenu extends MovieClip
	{
		public var Overlay:OverlayLoader;
		public static const Name:String = "OverlayMenu";

		public function get Visible():Boolean { return this.visible; }
		public function set Visible(value:Boolean):void { this.visible = value; }

		public function get Alpha():Number { return this.alpha; }
		public function set Alpha(value:Number):void { this.alpha = value; }


		// Initialize
		//---------------------------------------------

		public function OverlayMenu()
		{
			Debug.WriteLine("OverlayMenu", "ctor", "Constructor Code", this.loaderInfo.url);
			Overlay.Info.addEventListener(Event.COMPLETE, this.OnLoadComplete);
			Overlay.Info.addEventListener(IOErrorEvent.IO_ERROR, this.OnLoadError);
		}


		private function OnLoadComplete(e:Event):void
		{
			Debug.TraceDisplayList(this);
		}


		private function OnLoadError(e:IOErrorEvent):void
		{
			Debug.TraceDisplayList(this);
		}


		// Methods
		//---------------------------------------------

		public function SetURI(uri:String):void
		{
			Debug.WriteLine("OverlayMenu", "Request", "Setting the uri to '"+uri+"'");
			Overlay.TryLoad(uri);
		}


	}
}