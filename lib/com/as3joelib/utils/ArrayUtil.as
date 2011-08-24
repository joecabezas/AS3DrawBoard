package utils
{
	public class ArrayUtil
	{
		public static function arrayConcatUnique(... args):Array
		{
			var retArr:Array = new Array();
			for each (var arg:* in args)
			{
				if (arg is Array)
				{
					for each (var value:* in arg)
					{
						if (retArr.indexOf(value) == -1)
							retArr.push(value);
					}
				}
			}
			return retArr;
		}
		
		public static function mergeObjects(... args) : Object 
		{
			var final:Object = new Object();
			
			for each (var arg:* in args)
			{
				if (arg is Object)
				{
					for(var key:String in arg)
					{
						//trace(key);
						final[key] = arg[key];
					}
				}
			}
			
			return final;
		}
	}
}