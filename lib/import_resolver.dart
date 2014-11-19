// Copyright 2014 Zdenko Vrabel. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
library import_resolver;

import 'dart:async';
import 'dart:html';

/**
 * Class load all import links and replace them with the content.
 * 
 * It's solving problem with 'LinkElement.imports'
 * which is not available in all browsers.
 * 
 * Example how to resolve all imports in document:
 * 
 *     ImportResolver.resolve()
 *         .then((_) {
 *            //the imports are replaced now
 *         });
 */
class ImportResolver {
  
  /// validator for HTML creation
  NodeValidatorBuilder validator;
  
  
  /**
   * Constructor
   */
  ImportResolver() {
    validator = new NodeValidatorBuilder();
    validator.allowTextElements();
    validator.allowTemplating();    
    validator.allowHtml5();
    validator.allowElement("link", attributes: ['rel', 'href']);
  }
  

  /**
   * loading all imports and replace them
   */
  static Future<ImportResolver> resolve() => new ImportResolver()._loadImports(document.querySelectorAll("link[rel=import]"));
  
  
  /**
   * load and replace imports recursivelly
   */
  Future<ImportResolver> _loadImports(ElementList<LinkElement> importLinks) {    
    var completer = new Completer();
    List<Future> futures = new List();
    
    //loading imports
    for (LinkElement link in importLinks) {
      var future = 
          HttpRequest
            .getString(link.href)
            .then((content) => _replaceImport(link, content))
            .then((content) => _loadImports(content.querySelectorAll("link[rel=import]")));
      
      futures.add(future);
    }
    
    //waiting when all imports will be resolved
    Future.wait(futures).then((_) => completer.complete(this));    
    return completer.future;
  } 
    
  
  HtmlElement _replaceImport(LinkElement import, String content) {
    // create element and replace old 'link'
    var contentElement = new Element.html( "${content}", validator: validator);
    import.replaceWith(contentElement);    
    return contentElement;
  }
}