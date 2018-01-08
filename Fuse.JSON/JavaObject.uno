using Uno;
using Uno.UX;
using Uno.Collections;
using Uno.Threading;
using Uno.IO;
using Uno.Compiler.ExportTargetInterop;
using Fuse;
using Fuse.Platform;
using Fuse.Scripting;
using Fuse.Reactive;

namespace JSON
{		
	public extern(Android) static class JavaObject
	{
		static Matcher<Java.Object> _toJavaObject = new ToJavaObject();

		public static Java.Object FromJSON(Value value)
		{
			return value.Match(_toJavaObject);
		}
	}

	[ForeignInclude(Language.Java,"java.lang.Object","java.util.List","java.util.ArrayList","java.util.Map","java.util.HashMap","android.util.Log")]	
	extern(Android) class ToJavaObject : Matcher<Java.Object>
	{
		[Foreign(Language.Java)]
		public Java.Object Case() @{ return null; @}

		[Foreign(Language.Java)]
		public Java.Object Case(string str) @{ return str; @}

		[Foreign(Language.Java)]
		public Java.Object Case(double num) @{ return (double) num; @}

		[Foreign(Language.Java)]
		public Java.Object Case(bool b) @{ return (boolean) b; @}

		public Java.Object Case(IEnumerable<KeyValuePair<string, Java.Object>> obj)
		{
			var dict = NewHashMap();

			foreach (var keyValue in obj)
			{
				SetMapValue(dict, keyValue.Key, keyValue.Value);
			}

			return dict;
		}

		[Foreign(Language.Java)]
		extern(Android) Java.Object NewHashMap()
		@{
			return new HashMap<String, Object>();
		@}

		[Foreign(Language.Java)]
		extern(Android) void SetMapValue(Java.Object dictHandle, string key, Java.Object value)
		@{
			((Map<String, Object>)dictHandle).put(key, value);
		@}

		extern(Android) public Java.Object Case(IEnumerable<Java.Object> array)
		{
			var result = NewArrayList();

			foreach (var value in array) 
			{
				AddArrayValue(result, value);
			}

			return result;
		}

		[Foreign(Language.Java)]
		extern(Android) Java.Object NewArrayList()
		@{
			return new ArrayList<Object>();
		@}

		[Foreign(Language.Java)]
		extern(Android) void AddArrayValue(Java.Object arrayHandle, Java.Object value)
		@{
			((List<Object>) arrayHandle).add(value);
		@}
	}
}
