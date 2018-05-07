package
{
	public class Debug
	{
		public static function Log(className:String, classMember:String, textLog:String):void
		{
			trace("[Overlays Framework]["+className+"."+classMember+"]: "+textLog);
		}
	}
}
