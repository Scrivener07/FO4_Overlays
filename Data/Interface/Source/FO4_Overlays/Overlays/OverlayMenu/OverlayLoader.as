package
{
	import Components.LoaderType;
	import F4SE.Extensions;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import System.Diagnostics.Debug;
	import System.Diagnostics.Utility;
	import System.Display;
	import System.IO.File;
	import System.IO.FileSystem;
	import System.IO.Path;

	public dynamic class OverlayLoader extends LoaderType
	{
		// Files
		private var Uri:String;
		private var LastFile:String;
		private static const ImageMountID:String = "OverlayMenu_ImageMount";

		private static const DDS:String = "dds";
		private static const SWF:String = "swf";


		// Initialize
		//---------------------------------------------

		public function OverlayLoader()
		{
			super();
			Debug.WriteLine("[OverlayLoader]", "(ctor)", "Constructor Code");
		}


		// Events
		//---------------------------------------------

		override protected function OnLoadComplete(e:Event):void
		{
			// Note: Scale to default height of 720 works for dds files. The stage height works for swf files.
			Display.ScaleToHeight(Content, DefaultHeight);
			super.OnLoadComplete(e);
			Utility.TraceDisplayList(MovieClip(stage.getChildAt(0)));
			Debug.WriteLine("[OverlayLoader]", "(OnLoadComplete)", e.toString()+", "+toString());
		}


		override protected function OnLoadError(e:IOErrorEvent):void
		{
			Unload();
			var extension:String = Path.GetFileExtension(e.text)
			if(extension == SWF)
			{
				Debug.WriteLine("[OverlayLoader]", "(OnLoadError)", e.toString()+"\nNo SWF file was found, trying DDS files. "+toString());
				LoadWithExtension(LastFile, DDS);
			}
			else if (extension == DDS)
			{
				Debug.WriteLine("[OverlayLoader]", "(OnLoadError)", e.toString()+", No DDS file was found. "+toString());
			}
			else
			{
				Debug.WriteLine("[OverlayLoader]", "(OnLoadError)", e.toString()+", The error was unhandled. "+toString());
			}
		}


		// Functions
		//---------------------------------------------

		public function TryLoad(filepath:String):Boolean
		{
			Uri = filepath;
			return LoadWithExtension(filepath, SWF);
		}


		// override
		public function LoadWithExtension(filepath:String, extension:String):Boolean
		{
			Unload();
			var value = Path.ConvertFileExtension(filepath, extension);
			Debug.WriteLine("[OverlayLoader]", "(ConvertFileExtension)", "Converting file path '"+filepath+"' to '"+extension+"' extension as '"+value+"'.");
			filepath = value;
			var urlRequest:URLRequest;

			if (extension == SWF)
			{
				urlRequest = new URLRequest(filepath);
				Debug.WriteLine("[OverlayLoader]", "(LoadWithExtension)", "SWF: "+urlRequest.url);
			}
			else if (extension == DDS)
			{
				// if(File.GetTextureExists(XSE, filepath))
				if(File.Exists(XSE, FileSystem.Textures, filepath))
				{
					F4SE.Extensions.MountImage(XSE, OverlayMenu.Name, filepath, ImageMountID);
					urlRequest = new URLRequest("img://"+ImageMountID);
					Debug.WriteLine("[OverlayLoader]", "(LoadWithExtension)", "DDS: '"+urlRequest.url+"' as '"+filepath+"' to "+OverlayMenu.Name+" with resource ID "+ImageMountID);
				}
				else
				{
					Debug.WriteLine("[OverlayLoader]", "(LoadWithExtension)", "DDS: '"+filepath+"' does not exist.");
					return false;
				}
			}
			else
			{
				Debug.WriteLine("[OverlayLoader]", "(LoadWithExtension)", "Unhandled: '"+filepath+"' with extension '"+extension+"'");
				return false;
			}

			LastFile = filepath;
			Load(urlRequest);
			return true;
		}


		override public function Unload() : Boolean
		{
			if (super.Unload())
			{
				return Unmount(LastFile);
			}
			else
			{
				return false;
			}
		}


		private function Unmount(filepath:String):Boolean
		{
			if (filepath != null)
			{
				if(Path.GetFileExtension(filepath) == DDS)
				{
					F4SE.Extensions.UnmountImage(XSE, OverlayMenu.Name, filepath);
					Debug.WriteLine("[OverlayLoader]", "(Unmount)", "Unmounted the image '"+filepath+"' from "+OverlayMenu.Name+" with resource ID "+ImageMountID);
					return true;
				}
				else
				{
					Debug.WriteLine("[OverlayLoader]", "(Unmount)", "Only DDS file may be unmounted. '"+filepath+"'");
					return false;
				}
			}
			else
			{
				Debug.WriteLine("[OverlayLoader]", "(Unmount)", "Cannot unmount file null filepath.");
				return false;
			}
		}


		// override public function toString():String
		// {
		// 	var sResolution = "Resolution: "+stage.width+"x"+stage.height;
		// 	var sPosition = " Position: "+this.x+"x"+this.y;
		// 	var sURI = "Uri: '"+Uri+"'";
		// 	var sLastFile = "LastFile: '"+LastFile+"'";
		// 	var sUrl = "Url: '"+Url+"'";
		// 	return sResolution+", "+sPosition+", "+sURI+", "+sLastFile+", "+sUrl;
		// }


	}
}
