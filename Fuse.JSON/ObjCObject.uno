using Uno.Collections;
using Uno.Compiler.ExportTargetInterop;

namespace JSON
{
	public extern(iOS) static class ObjCObject
	{
		static Matcher<ObjC.Object> _toObjCObject = new ToObjCObject();

		public static ObjC.Object FromJSON(Value value)
		{
			return value.Match(_toObjCObject);
		}
	}

	extern(iOS) class ToObjCObject : Matcher<ObjC.Object>
	{
		[Foreign(Language.ObjC)]
		public ObjC.Object Case() @{ return [NSNull null]; @}

		[Foreign(Language.ObjC)]
		public ObjC.Object Case(string str) @{ return str; @}

		[Foreign(Language.ObjC)]
		public ObjC.Object Case(double num) @{ return [NSNumber numberWithDouble:num]; @}

		[Foreign(Language.ObjC)]
		public ObjC.Object Case(bool b) @{ return [NSNumber numberWithBool:(b ? YES : NO)]; @}

		public ObjC.Object Case(IEnumerable<KeyValuePair<string, ObjC.Object>> obj)
		{
			var dict = NewNSMutableDictionary();
			foreach (var keyValue in obj)
				SetDictValue(dict, keyValue.Key, keyValue.Value);
			return CopyToImmutableDict(dict);
		}

		[Foreign(Language.ObjC)]
		ObjC.Object NewNSMutableDictionary()
		@{
			return [NSMutableDictionary dictionary];
		@}

		[Foreign(Language.ObjC)]
		void SetDictValue(ObjC.Object dictHandle, string key, ObjC.Object value)
		@{
			((NSMutableDictionary*)dictHandle)[key] = value;
		@}

		[Foreign(Language.ObjC)]
		ObjC.Object CopyToImmutableDict(ObjC.Object dictHandle)
		@{
			return [((NSMutableDictionary*)dictHandle) copy];
		@}

		public ObjC.Object Case(IEnumerable<ObjC.Object> arr)
		{
			var result = NewNSMutableArray();
			foreach (var value in arr)
				AddArrayValue(result, value);
			return CopyToImmutableArray(result);
		}

		[Foreign(Language.ObjC)]
		ObjC.Object NewNSMutableArray()
		@{
			return [NSMutableArray array];
		@}

		[Foreign(Language.ObjC)]
		void AddArrayValue(ObjC.Object arrayHandle, ObjC.Object value)
		@{
			[((NSMutableArray*)arrayHandle) addObject:value];
		@}

		[Foreign(Language.ObjC)]
		ObjC.Object CopyToImmutableArray(ObjC.Object arrayHandle)
		@{
			return [((NSMutableArray*)arrayHandle) copy];
		@}
	}
}
