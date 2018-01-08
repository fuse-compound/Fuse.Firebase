using Fuse.Scripting;
using Uno.Collections;
using Uno.Compiler.ExportTargetInterop;

public class Test : Uno.Application
{
	public Test()
	{
		if defined(iOS)
		{
			var d = new Dictionary<string, JSON.Value>();
			d["hej"] = new JSON.String("hopp");
			d["happ"] = new JSON.String("hupp");
			d["arr"] = new JSON.Array(new JSON.Value[] { new JSON.String("arrayValue") });
			var jsonObject = new JSON.Object(d);
			var test = JSON.ObjCObject.FromJSON(jsonObject);
			NSLog(test);
		}
	}

	[Foreign(Language.ObjC)]
	extern(iOS) static void NSLog(ObjC.Object o)
	@{
		::NSLog(@"%@", o);
	@}
}
