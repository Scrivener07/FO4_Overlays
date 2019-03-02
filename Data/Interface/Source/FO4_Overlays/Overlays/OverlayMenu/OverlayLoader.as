package
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import Shared.AS3.Debug;
	import Shared.AS3.Path;
	import Shared.AS3.Utility;
	import Shared.F4SE.ICodeObject;

	public dynamic class OverlayLoader extends MovieClip implements Shared.F4SE.ICodeObject
	{
		private var f4se:*;

		// Files
		private var Uri:String;
		private var LastFile:String;
		private static const ImageMountID:String = "OverlayMenu_ImageMount";

		private static const DDS:String = "dds";
		private static const SWF:String = "swf";

		// Stage
		private function get Resolution():Number { return stage.height; }
		private static const DefaultHeight:Number = 720;

		// Loader
		private var ContentLoader:Loader;
		private function get Info() : LoaderInfo { return ContentLoader.contentLoaderInfo; }
		private function get Url() : String { return ContentLoader.contentLoaderInfo.url; }
		private function get Content() : DisplayObject { return ContentLoader.contentLoaderInfo.content; }


		// Initialize
		//---------------------------------------------

		public function OverlayLoader()
		{
			super();
			this.visible = false;
			ContentLoader = new Loader();
			Info.addEventListener(Event.COMPLETE, this.OnLoadComplete);
			Info.addEventListener(IOErrorEvent.IO_ERROR, this.OnLoadError);
			Debug.WriteLine("[OverlayLoader]", "(ctor)", "Constructor Code");
		}


		// Events
		//---------------------------------------------

		public function onF4SEObjCreated(codeObject:*):void
		{ // @F4SE
			if(codeObject != null)
			{
				f4se = codeObject;
				Debug.WriteLine("[OverlayLoader]", "(onF4SEObjCreated)", "Received F4SE code object.");
			}
			else
			{
				Debug.WriteLine("[OverlayLoader]", "(onF4SEObjCreated)", "The f4se object is null.");
			}
		}


		private function OnLoadComplete(e:Event):void
		{
			// Note: Scale to default height of 720 works for dds files. The stage height works for swf files.
			this.addChild(Content);
			Utility.ScaleToHeight(Content, DefaultHeight);
			this.visible = true;
			Debug.TraceDisplayList(MovieClip(stage.getChildAt(0)));
			Debug.WriteLine("[OverlayLoader]", "(OnLoadComplete)", e.toString()+", "+toString());
		}


		private function OnLoadError(e:IOErrorEvent):void
		{
			Clear();
			var extension:String = Path.GetFileExtension(e.text)
			if(extension == SWF)
			{
				Debug.WriteLine("[OverlayLoader]", "(OnLoadError)", e.toString()+"\nNo SWF file was found, trying DDS files. "+toString());
				Load(LastFile, DDS);
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
			return Load(filepath, SWF);
		}


		private function Load(filepath:String, extension:String):Boolean
		{
			Clear();
			var value = Path.ConvertFileExtension(filepath, extension);
			Debug.WriteLine("[OverlayLoader]", "(ConvertFileExtension)", "Converting file path '"+filepath+"' to '"+extension+"' extension as '"+value+"'.");
			filepath = value;
			var urlRequest:URLRequest;




			if (extension == SWF)
			{
				urlRequest = new URLRequest(filepath);
				Debug.WriteLine("[OverlayLoader]", "(Load)", "SWF: "+urlRequest.url);
			}
			else if (extension == DDS)
			{
				if(GetTextureExists(filepath))
				{
					Shared.F4SE.Extensions.MountImage(f4se, OverlayMenu.Name, filepath, ImageMountID);
					urlRequest = new URLRequest("img://"+ImageMountID);
					Debug.WriteLine("[OverlayLoader]", "(Load)", "DDS: '"+urlRequest.url+"' as '"+filepath+"' to "+OverlayMenu.Name+" with resource ID "+ImageMountID);
				}
				else
				{
					Debug.WriteLine("[OverlayLoader]", "(Load)", "DDS: '"+filepath+"' does not exist.");
					return false;
				}
			}
			else
			{
				Debug.WriteLine("[OverlayLoader]", "(Load)", "Unhandled: '"+filepath+"' with extension '"+extension+"'");
				return false;
			}




			LastFile = filepath;
			ContentLoader.load(urlRequest);
			return true;
		}


		private function GetTextureExists(filepath:String):Boolean
		{
			var folder:String = Path.GetDirectory("Data\\Textures\\"+filepath);
			return Shared.F4SE.Extensions.GetDirectoryListing(f4se, folder, "*.dds", true).length > 0;
		}


		private function Clear():Boolean
		{
			this.visible = false;


			Unmount(LastFile);


			Unload();


			return true;
		}


		private function Unmount(filepath:String):Boolean
		{
			if (filepath != null)
			{
				if(Path.GetFileExtension(filepath) == DDS)
				{
					Shared.F4SE.Extensions.UnmountImage(f4se, OverlayMenu.Name, filepath);
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


		private function Unload():Boolean
		{
			if (Content)
			{
				this.visible = false;
				removeChild(Content);
				ContentLoader.unload();
				Debug.WriteLine("[OverlayLoader]", "(Unload)", "Unloaded content from loader.");
				return true;
			}
			else
			{
				Debug.WriteLine("[OverlayLoader]", "(Unload)", "No existing content to unload.");
				return false;
			}
		}


		public override function toString():String
		{
			var sResolution = "Resolution: "+stage.width+"x"+stage.height;
			var sPosition = " Position: "+this.x+"x"+this.y;
			var sURI = "Uri: '"+Uri+"'";
			var sLastFile = "LastFile: '"+LastFile+"'";
			var sUrl = "Url: '"+Url+"'";
			return sResolution+", "+sPosition+", "+sURI+", "+sLastFile+", "+sUrl;
		}


	}
}
