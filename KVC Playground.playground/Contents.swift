
/// KeyValueCodable - Defines a mechanism by which you can access the properties of an object indirectly by name (or key), rather than directly through invocation of an accessor method or as instance variables.
protocol KeyValueCodable {
	
	func valueForKey<T>(key : String) -> T?
	
	func valueForKeyPath<T>(keyPath : String) -> T?
	
	subscript (key : String) -> Any? { get }
}

extension KeyValueCodable {
	
	/// Returns the value for the property identified by a given key.
	func valueForKey<T>(key : String) -> T? {
		
		let mirror = reflect(self)
		
		for index in 0 ..< mirror.count {
			let (childKey, childMirror) = mirror[index]
			if childKey == key {
				return childMirror.value as? T
			}
		}
		return nil
	}
	
	/// Returns the value for the derived property identified by a given key path.
	func valueForKeyPath<T>(keyPath : String) -> T? {
		
		let keys = split(keyPath.characters){$0 == "."}.map{String($0)}
		
		var mirror = reflect(self)
		
		for key in keys {
			for index in 0 ..< mirror.count {
				let (childKey, childMirror) = mirror[index]
				if childKey == key {
					if childKey == keys.last {
						return childMirror.value as? T
					}
					else {
						mirror = childMirror
					}
				}
			}
		}
		return nil
	}
	
	/// Returns the value for the property identified by a given key.
	subscript (key : String) -> Any? {
		get {
			return self.valueForKeyPath(key)
		}
	}
}



/// Test Struct - Conforms to KVC protocol
struct myValue : KeyValueCodable {
	let someString = "Hello World"
	let someNumber = 42
}
let aValue = myValue()


// Access property using KVC valueForKey - provides type safety
let s1 : String? = aValue.valueForKey("someString")

// Access property using KVC subscripting - subscripting only returns an optional of type Any
var s2 : Any? = aValue["someNumber"]



/// Test Struct - Used to demo valueForKeyPath
struct myValueHolder : KeyValueCodable {
	let subValue = myValue()
}
let bValue = myValueHolder()


// Access property chain using valueForKeyPath - provides type safety
let c : String? = bValue.valueForKeyPath("subValue.someString")
let d : Any? = bValue["subValue.someNumber"]

