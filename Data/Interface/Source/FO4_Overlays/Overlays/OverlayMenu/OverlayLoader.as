package
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import AS3.*;
	import F4SE.*;
	import Overlays.*;

	public dynamic class OverlayLoader extends MovieClip implements F4SE.IExtensions
	{
		// TODO: I am not unmounting the images properly.
		// TODO: Its attempting to mount swf files in its current state.
		/*
			# F4SE
			- added Scaleform functions to load dds images
				- MountImage(menuName, pathToMount, mountName)
				- UnmountImage(menuName, pathToUnmount)
				- Image is loaded through URLRequest("img://mountName")
			- added Scaleform receiving function
				- function onF4SEObjCreated(codeObject:Object):void
				- This function is called on the menu root document as well as first-level children

			# Scaling (Expired)
			that looks like it's going to be file texture the size of your screen
			which you will probably need multiple resolution versions so it doesnt look like ass at certain resolutions
			you should be able to determine the real resolution in scaleform though
			then you could pick which texture to mount based on that
			yeah, stageWidth and stageHeight properties will be the actual resolution values
			not the scaled to 720p value
		*/

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


		// Events
		//---------------------------------------------

		public function OverlayLoader()
		{
			super();
			trace("\n");
			trace("\n");
			trace("\n");
			trace("\n");
			trace("\n");
			trace("\n");
			trace("\n");
			trace("\n");
			trace("\n");
			trace("\n");
			trace("\n");
			trace("\n");
			trace("\n");
			trace("\n");
			this.visible = false;
			ContentLoader = new Loader();
			Info.addEventListener(Event.COMPLETE, this.OnLoadComplete);
			Info.addEventListener(IOErrorEvent.IO_ERROR, this.OnLoadError);
			Debug.WriteLine("OverlayLoader", "(ctor)", "Constructor Code");
		}


		public function onF4SEObjCreated(codeObject:*):void
		{ // @F4SE
			if(codeObject != null)
			{
				f4se = codeObject;
				Debug.WriteLine("[OverlayLoader]", "(onF4SEObjCreated)", "Received F4SE code object.");
				Debug.TraceObject(f4se);
			}
			else
			{
				Debug.WriteLine("[OverlayLoader]", "(onF4SEObjCreated)", "The f4se object is null.");
			}
		}


		// Methods
		//---------------------------------------------

		public function TryLoad(filepath:String):void
		{
			Uri = filepath;
			Load(filepath, SWF);
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
					F4SE.Extensions.MountImage(f4se, OverlayMenu.Name, filepath, ImageMountID);
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
			return F4SE.Extensions.GetDirectoryListing(f4se, folder, "*.dds", true).length > 0;
		}


		private function OnLoadComplete(e:Event):void
		{
			addChild(Content);
			Utility.ScaleToHeight(Content, DefaultHeight); // Note: The default height of 720 works for dds files.
			// Utility.ScaleToHeight(this, Resolution); // Note: The stage height works for swf files.

			this.visible = true;
			Debug.WriteLine("[OverlayLoader]", "(OnLoadComplete)", e.toString()+"\n"+toString());
		}


		private function OnLoadError(e:IOErrorEvent):void
		{
			Clear();
			var extension:String = Path.GetFileExtension(e.text)
			if(extension == SWF)
			{
				Debug.WriteLine("[OverlayLoader]", "(OnLoadError)", e.toString()+" No SWF file was found, trying DDS files.\n"+toString());
				Load(LastFile, DDS);
			}
			else if (extension == DDS)
			{
				Debug.WriteLine("[OverlayLoader]", "(OnLoadError)", e.toString()+" No suitable files were found.\n"+toString());
			}
			else
			{
				Debug.WriteLine("[OverlayLoader]", "(OnLoadError)", e.toString()+" The error was unhandled.\n"+toString());
			}
		}


		// Methods
		//---------------------------------------------

		private function Clear():void
		{
			this.visible = false;
			Unmount(LastFile);
			Unload();
		}


		private function Unmount(filepath:String):Boolean
		{
			if (filepath != null)
			{
				if(Path.GetFileExtension(filepath) == DDS)
				{
					F4SE.Extensions.UnmountImage(f4se, OverlayMenu.Name, filepath);
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
				Content.loaderInfo.loader.unload();
				Debug.WriteLine("[OverlayLoader]", "(Unload)", "Unloaded content from loader.");
				return true;
			}
			else
			{
				Debug.WriteLine("[OverlayLoader]", "(Unload)", "No existing content to unload.");
				return false;
			}
		}


		// Functions
		//---------------------------------------------

		public override function toString():String
		{
			var sResolution = "Resolution: "+stage.width+"x"+stage.height+" ("+this.x+"x"+this.y+")";
			var sURI = "Uri: '"+Uri+"'";
			var sLastFile = "LastFile: '"+LastFile+"'";
			var sUrl = "Url: '"+Url+"'";
			return sResolution+"\n"+sURI+"\n"+sLastFile+"\n"+sUrl;
		}


	}
}
