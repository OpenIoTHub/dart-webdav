import 'package:xml/xml.dart' as xml;

class FileInfo {
  String path;
  String displayName;
  String contentType;

  FileInfo(this.path, this.displayName, this.contentType);

  bool get isDirectory => this.path.endsWith("/");

  @override
  String toString() {
    return 'FileInfo{displayName: $displayName, isDirectory: $isDirectory ,path: $path, contentType: $contentType}';
  }
}

List<FileInfo> treeFromWevDavXml(String xmlStr) {
  var path;
  var prop;
  var displayName;
  var contentType;
  // Initialize a list to store the FileInfo Objects
  var tree = new List<FileInfo>();

  // parse the xml using the xml.parse method
  var xmlDocument = xml.parse(xmlStr);

  // Iterate over the response to find all folders / files and parse the information
  xmlDocument.findAllElements("D:response").forEach((response) {
    path = response
        .findElements("D:href")
        .single
        .text;
    try{
      prop = response
          .findElements("D:propstat")
          .single
          .findElements("D:prop");
      try{
        displayName = prop.single
            .findElements("D:displayname")
            .single
            .text;
      }catch(e){
        prop = null;
      }
      try{
        contentType = prop.single
            .findElements("D:getcontenttype")
            .single
            .text;
      }catch(e){
        contentType = null;
      }
    }catch(e){
      path = null;
      displayName = null;
      contentType = null;
    }
    // Add the just found file to the tree
    tree.add(new FileInfo(path, displayName, contentType));
  });
  // Return the tree
  return tree;
}
