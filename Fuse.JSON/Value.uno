using Uno;
using Uno.Collections;

namespace JSON
{
	public interface Matcher<T>
	{
		T Case(); // Null
		T Case(string str);
		T Case(double num);
		T Case(bool b);
		T Case(IEnumerable<KeyValuePair<string, T>> obj);
		T Case(IEnumerable<T> arr);
	}

	public interface Value
	{
		T Match<T>(Matcher<T> matcher);
	}

	public class Null : Value
	{
		public T Match<T>(Matcher<T> matcher) { return matcher.Case(); }
		private Null() { }
		public static Null TheNull = new Null();
	}

	public class String : Value
	{
		readonly string _value;
		public String(string value)
		{
			if (value == null)
				throw new ArgumentNullException(nameof(value));
			_value = value;
		}
		public T Match<T>(Matcher<T> matcher)
		{
			return matcher.Case(_value);
		}
	}

	public class Number : Value
	{
		readonly double _value;
		public Number(double value) { _value = value; }
		public Number(int value) { _value = (double)value; }
		public T Match<T>(Matcher<T> matcher) { return matcher.Case(_value); }
	}

	public class Bool : Value
	{
		readonly bool _value;
		public Bool(bool value) { _value = value; }
		public T Match<T>(Matcher<T> matcher) { return matcher.Case(_value); }
	}

	public class Object : Value
	{
		readonly Dictionary<string, Value> _dict;

		public Object(Dictionary<string, Value> dict)
		{
			if (dict == null)
				throw new ArgumentNullException(nameof(dict));
			_dict = dict;
		}

		public T Match<T>(Matcher<T> matcher)
		{
			return matcher.Case(
				new ObjectEnumerable<T>(
					_dict,
					matcher));
		}

		class ObjectEnumerable<T> : IEnumerable<KeyValuePair<string, T>>
		{
			Dictionary<string, Value> _dict;
			Matcher<T> _matcher;

			public ObjectEnumerable(Dictionary<string, Value> dict, Matcher<T> matcher)
			{
				_dict = dict;
				_matcher = matcher;
			}

			public IEnumerator<KeyValuePair<string, T>> GetEnumerator()
			{
				return new ObjectEnumerator<T>(_dict.GetEnumerator(), _matcher);
			}
		}

		class ObjectEnumerator<T> : IEnumerator<KeyValuePair<string, T>>
		{
			IEnumerator<KeyValuePair<string, Value>> _enumerator;
			Matcher<T> _matcher;

			public ObjectEnumerator(IEnumerator<KeyValuePair<string, Value>> enumerator, Matcher<T> matcher)
			{
				_enumerator = enumerator;
				_matcher = matcher;
			}

			public bool MoveNext() { return _enumerator.MoveNext(); }
			public void Reset() { _enumerator.Reset(); }

			public KeyValuePair<string, T> Current
			{
				get
				{
					var current = _enumerator.Current;
					return new KeyValuePair<string, T>(current.Key, current.Value.Match(_matcher));
				}
			}

			public void Dispose()
			{
				_enumerator = null;
				_matcher = null;
			}
		}
	}

	public class Array : Value
	{
		readonly Value[] _arr;

		public Array(Value[] arr)
		{
			if (arr == null)
				throw new ArgumentNullException(nameof(arr));
			_arr = arr;
		}

		public T Match<T>(Matcher<T> matcher)
		{
			return matcher.Case(
				new ArrayEnumerable<T>(
					_arr,
					matcher));
		}

		class ArrayEnumerable<T> : IEnumerable<T>
		{
			readonly Value[] _arr;
			readonly Matcher<T> _matcher;

			public ArrayEnumerable(Value[] arr, Matcher<T> matcher)
			{
				_arr = arr;
				_matcher = matcher;
			}

			public IEnumerator<T> GetEnumerator()
			{
				return new ArrayEnumerator<T>(
					_arr,
					_matcher);
			}
		}

		class ArrayEnumerator<T> : IEnumerator<T>
		{
			Value[] _arr;
			int _index;
			Matcher<T> _matcher;

			public ArrayEnumerator(Value[] arr, Matcher<T> matcher)
			{
				_arr = arr;
				_index = -1;
				_matcher = matcher;
			}

			public bool MoveNext()
			{
				++_index;
				return _index < _arr.Length;
			}

			public void Reset() { _index = -1; }

			public T Current { get { return _arr[_index].Match(_matcher); } }

			public void Dispose()
			{
				_arr = null;
				_matcher = null;
			}
		}
	}
}
