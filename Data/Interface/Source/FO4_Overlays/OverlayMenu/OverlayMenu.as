package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;

	public class OverlayMenu extends MovieClip
	{
		public var Overlay:OverlayLoader;

		public function get Visible():Boolean { return this.visible; }
		public function set Visible(argument:Boolean):void { this.visible = argument; }


		public function OverlayMenu()
		{
			Debug.Log("OverlayMenu", "ctor", "Constructor Code");
		}


		// Functions
		//---------------------------------------------

		public function SetOverlay(filepath:String) : *
		{
			filepath = ConvertFileExtension(filepath, "swf");

			Overlay.Info.addEventListener(Event.COMPLETE, this.OnLoadComplete);
			Overlay.Info.addEventListener(IOErrorEvent.IO_ERROR, this.OnLoadError);
			Overlay.Load(filepath);
			Debug.Log("OverlayMenu", "SetOverlay", "Setting the overlay file path to '"+filepath+"'.");
		}


		private function ConvertFileExtension(filepath:String, toExtension:String) : String
		{
			var converted = Path.ConvertFileExtension(filepath, toExtension);
			Debug.Log("OverlayMenu", "ConvertFileExtension", "Converting file path '"+filepath+"' to '"+toExtension+"' extension as '"+converted+"'.");
			return converted;
		}


		// Events
		//---------------------------------------------

		private function OnLoadComplete(e:Event) : void
		{
			Overlay.Info.removeEventListener(Event.COMPLETE, this.OnLoadComplete);
			Overlay.Info.removeEventListener(IOErrorEvent.IO_ERROR, this.OnLoadError);
			Debug.Log("OverlayMenu", "OnLoadComplete", "Override found at '"+Overlay.FilePath+"' with instance of '"+Overlay.Instance+"'.");
		}


		private function OnLoadError(e:IOErrorEvent) : void
		{
			Overlay.Info.removeEventListener(Event.COMPLETE, this.OnLoadComplete);
			Overlay.Info.removeEventListener(IOErrorEvent.IO_ERROR, this.OnLoadError);
			Debug.Log("OverlayMenu", "OnLoadError", "No override found at '"+Overlay.FilePath+"'.");
		}


	}
}
