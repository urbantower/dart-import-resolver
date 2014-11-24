# Import Resolver

A small library for Dart that helps you resolve import links in your HTML document. I wrote it when Dart's LinkElement.import wasn't supported in all browsers 
or was experimental. This is temporary solution and  will not be needed in the future, when the LinkElement.import will be stable.  

## Installation

Add import_resolver to your project's pubspec.yaml file.

	dependencies:
  		import_resolver: '>=1.0.1<1.1.0'  		   
  		
## How to use

In your main method, just call `ImportResolver.resolve()`. This operation might take some time. For that reason, the method is returning Future and you
can prevent FOUC.

	void main() {
		ImportResolver.resolve().then((_) {
			//here are all links resolved 
		});
	}

	