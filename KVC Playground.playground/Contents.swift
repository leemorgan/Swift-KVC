
/// KVC Protocol - Defines a mechanism by which you can access the properties of an object indirectly by name (or key), rather than directly through invocation of an accessor method or as instance variables.
protocol KVC {
	func valueForKey(key : String) -> Any?
}

extension KVC {
	
	/// Returns the value for the property identified by a given key.
	func valueForKey(key : String) -> Any? {
		
		let mirror = reflect(self)
		
		for index in 0 ..< mirror.count {
			let (childKey, childMirror) = mirror[index]
			if childKey == key {
				return childMirror.value
			}
		}
		return nil
	}
	
	/// Returns the value for the property identified by a given key.
	subscript (key : String) -> Any? {
		return self.valueForKey(key)
	}
}



/// Test Struct - Conforms to KVC protocol
struct myValue : KVC {
	let someString = "Hello"
	let someNumber = 42
}
let aValue = myValue()


// Access property using KVC valueForKey
aValue.valueForKey("someString")

// Access property using KVC subscripting
aValue["someString"]