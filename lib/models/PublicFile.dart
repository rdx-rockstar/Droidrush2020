class Publicfile {
  String File_name;
  List<String> tags;
  String LUri;

  Publicfile({ this.File_name, this.LUri, this.tags });

  @override
  String toString() {
    // TODO: implement toString
    return this.File_name + " " + this.LUri;
  }
}