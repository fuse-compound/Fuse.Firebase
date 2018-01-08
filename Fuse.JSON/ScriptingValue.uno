using Fuse.Scripting;
using Uno;
using Uno.Collections;

namespace JSON
{
	public static class ScriptingValue
	{
		public static object FromJSON(Context context, Value value)
		{
			return value.Match(new ToScriptingValue(context));
		}

		public static Value ToJSON(object value)
		{
			if (value == null) return Null.TheNull;
			if (value is string) return new String((string)value);
			if (value is double) return new Number((double)value);
			if (value is int) return new Number((int)value);
			if (value is bool) return new Bool((bool)value);
			if (value is Fuse.Scripting.Array)
			{
				var sarr = (Fuse.Scripting.Array)value;
				var len = sarr.Length;
				var arr = new Value[len];
				for (int i = 0; i < len; ++i)
				{
					arr[i] = ToJSON(sarr[i]);
				}
				return new Array(arr);
			}
			if (value is Fuse.Scripting.Object)
			{
				var sobj = (Fuse.Scripting.Object)value;
				var dict = new Dictionary<string, Value>();
				foreach (var key in sobj.Keys)
				{
					dict[key] = ToJSON(sobj[key]);
				}
				return new Object(dict);
			}
			throw new ArgumentException("Not JSON-convertible", nameof(value));
		}
	}

	class ToScriptingValue : Matcher<object>
	{
		readonly Context _context;

		public ToScriptingValue(Context context)
		{
			if (context == null)
				throw new ArgumentNullException(nameof(context));
			_context = context;
		}

		public object Case() { return null; }
		public object Case(string str) { return str; }
		public object Case(double num) { return num; }
		public object Case(bool b) { return b; }
		public object Case(IEnumerable<KeyValuePair<string, object>> obj)
		{
			var result = _context.NewObject();
			foreach (var keyValue in obj)
			{
				result[keyValue.Key] = keyValue.Value;
			}
			return result;
		}
		public object Case(IEnumerable<object> arr)
		{
			var result = _context.NewArray();
			int i = 0;
			foreach (var val in arr)
			{
				result[i] = val;
				++i;
			}
			return result;
		}
	}
}
