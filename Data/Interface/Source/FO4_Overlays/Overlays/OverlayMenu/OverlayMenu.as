package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import AS3.*;
	import Overlays.*;

	public class OverlayMenu extends MovieClip
	{
		/*
			now, while it does load, it will inherit the color palette and end up tinting your image
			now this is where you could change your flags around and then manually capture the colorization event in Scaleform
			https://github.com/expired6978/F4SEPlugins/blob/master/AS3/LooksMenu/LooksMenu.as#L462
		*/

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
			AS3.Debug.WriteLine("OverlayMenu", "ctor", "Constructor Code", this.loaderInfo.url);
			Overlay.Info.addEventListener(Event.COMPLETE, this.OnLoadComplete);
			Overlay.Info.addEventListener(IOErrorEvent.IO_ERROR, this.OnLoadError);
		}


		private function OnLoadComplete(e:Event):void
		{
			AS3.Debug.TraceDisplayList(this);
		}


		private function OnLoadError(e:IOErrorEvent):void
		{
			AS3.Debug.TraceDisplayList(this);
		}


		// Methods
		//---------------------------------------------

		public function SetURI(uri:String):void
		{
			AS3.Debug.WriteLine("OverlayMenu", "Request", "Setting the uri to '"+uri+"'");
			Overlay.TryLoad(uri);
		}


	}
}
