
/// KeyValueCodable - Defines a mechanism by which you can access the properties of an object indirectly by name (or key), rather than directly through invocation of an accessor method or as instance variables.
protocol KeyValueCodable {
    
    func value<T>(for key : String) -> T?
    
    func value<T>(forKeyPath keyPath: String) -> T?
    
    subscript (key : String) -> Any? { get }
}

extension KeyValueCodable {
    
    /// Returns the value for the property identified by a given key.
    func value<T>(for key : String) -> T? {
        
        let mirror = Mirror(reflecting: self)
        
        for child in mirror.children {
            guard let childKey = child.label else { continue }
            
            guard childKey == key else { continue }
            
            return child.value as? T
        }
        
        return nil
    }
    
    /// Returns the value for the derived property identified by a given key path.
    func value<T>(forKeyPath keyPath: String) -> T? {
        
        let keys = keyPath.characters.split(separator: ".").map { String($0) }
        
        var mirror = Mirror(reflecting: self)
        
        for key in keys {
            for child in mirror.children {
                
                guard let childKey = child.label else { continue }
                
                guard childKey == key else { continue }
                
                if let last = keys.last, childKey == last {
                    return child.value as? T
                } else {
                    mirror = Mirror(reflecting: child.value)
                }
            }
        }
        return nil
    }
    
    /// Returns the value for the property identified by a given key.
    subscript (key : String) -> Any? {
        get {
            return self.value(forKeyPath: key)
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
let s1 : String? = aValue.value(for: "someString")

// Access property using KVC subscripting - subscripting only returns an optional of type Any
var s2 : Any? = aValue["someNumber"]



/// Test Struct - Used to demo valueForKeyPath
struct myValueHolder : KeyValueCodable {
	let subValue = myValue()
}
let bValue = myValueHolder()


// Access property chain using valueForKeyPath - provides type safety
let c : String? = bValue.value(forKeyPath: "subValue.someString")
let d : Any? = bValue["subValue.someNumber"]

