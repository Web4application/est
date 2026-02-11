package com.example

import java.util.List

class HelloWorld {
    // A standard main method
    def static void main(String[] args) {
        val instance = new HelloWorld
        instance.greet(#['Xtend', 'Java']) // Using a list literal #[]
    }

    // Method with type inference (return type String is inferred)
    def greet(List<String> names) {
        names.forEach[ name | 
            println("Hello " + name)
        ]
    }
}
