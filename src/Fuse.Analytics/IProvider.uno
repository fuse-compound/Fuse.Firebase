using Uno;
using Uno.Collections;
using Fuse;
namespace Fuse.Analytics
{
	public interface IProvider
	{
		void LogEvent(string name, string[] keys, string[] vals, int len, bool timed);
		void EndTimedEvent(string name, string[] keys, string[] vals, int len);
		void LogPage(string page, string path);
	}
}
