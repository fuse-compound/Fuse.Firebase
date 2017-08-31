using Uno;
using Uno.UX;
using Uno.Threading;
using Uno.Text;
using Uno.Platform;
using Uno.Compiler.ExportTargetInterop;
using Uno.Collections;
using Fuse;
using Fuse.Scripting;
using Fuse.Reactive;
using Firebase.Database;

namespace Firebase.Database.JS
{
	/**
	*/
	[UXGlobalModule]
	public sealed class DatabaseModule : NativeEventEmitterModule
	{
		static readonly DatabaseModule _instance;

		public DatabaseModule() : base(false,"data")
		{
			if(_instance != null) return;
			Uno.UX.Resource.SetGlobalKey(_instance = this, "Firebase/Database");

            DatabaseService.Init();
			var onData = new NativeEvent("onData");
			On("data", onData);

			AddMember(onData);
			AddMember(new NativeFunction("listen", (NativeCallback)Listen));
            AddMember(new NativePromise<string, string>("read", Read, null));
            AddMember(new NativeFunction("push", (NativeCallback)Push));
            AddMember(new NativeFunction("save", (NativeCallback)Save));
            AddMember(new NativeFunction("delete", (NativeCallback)Delete));
		}

        static Future<string> Read(object[] args)
        {
            var path = args[0].ToString();
            return new Read(path);
        }

        static void DoSave(string path, object arg) {
            if (arg is Fuse.Scripting.Object) {
                var p = (Fuse.Scripting.Object)arg;
                var keys = p.Keys;
                string[] objs = new string[keys.Length];
                for (int i=0; i < keys.Length; i++) {
                    if (p[keys[i]] == null) {
                        objs[i] = null;
                    }
                    else {
                        objs[i] = p[keys[i]].ToString();
                    }
                }
                DatabaseService.Save(path, keys, objs, keys.Length);
                return;
            }
            else if (arg is Fuse.Scripting.Array) {
                var arr = (Fuse.Scripting.Array)arg;
                string[] narr = new string[arr.Length];
                for (int i=0; i < arr.Length; i++) {
                    narr[i] = arr[i].ToString();
                }
                DatabaseService.Save(path, narr);
            }
            else if (arg is string) {
                DatabaseService.Save(path, arg as string);
                return;
            }
            else if (arg is double || arg is int) {
                DatabaseService.Save(path, Marshal.ToDouble(arg));
                return;
            }
            else if (arg == null) {
                DatabaseService.SaveNull(path);
                return;
            }
            else {
                debug_log("Save: Unimplemented Javascript type");
                debug_log arg;
                debug_log arg.GetType();
                throw new Exception("Save: Unimplemented Javascript type");
            }
        }

        static object Push(Fuse.Scripting.Context context, object[] args)
        {
            var path = args[0].ToString();
            var push_path = DatabaseService.NewChildId(path);
            if defined(iOS) {
                DatabaseService.Save(
                    path + "/" + push_path,
                    JSON.ObjCObject.FromJSON(JSON.ScriptingValue.ToJSON(args[1]))
                );
            }
            else if defined(Android) {
                DatabaseService.Save(
                    path + "/" + push_path,
                    JSON.JavaObject.FromJSON(JSON.ScriptingValue.ToJSON(args[1]))
                );
            }
            else {
                DoSave(
                    path + "/" + push_path,
                    args[1]
                );
            }
            return push_path;
        }

        static object Save(Fuse.Scripting.Context context, object[] args)
        {
            if defined(iOS) {
                DatabaseService.Save(
                    args[0].ToString(),
                    JSON.ObjCObject.FromJSON(JSON.ScriptingValue.ToJSON(args[1]))
                );
            }
            else if defined(Android) {
                DatabaseService.Save(
                    args[0].ToString(),
                    JSON.JavaObject.FromJSON(JSON.ScriptingValue.ToJSON(args[1]))
                );
            }
            else {
                DoSave(
                    args[0].ToString(),
                    args[1]
                );
            }
            return null;
        }

        static object Delete(Fuse.Scripting.Context context, object[] args)
        {
            DatabaseService.SaveNull(args[0].ToString());
            return null;
        }

        void ListenCallback (string path, string msg)
        {
        	Emit("data", path, msg);
        }

		object Listen(Fuse.Scripting.Context context, object[] args)
		{
			debug_log "listen";
            var path = args[0].ToString();
			DatabaseService.Listen(path, ListenCallback);
			return null;
		}
	}
}