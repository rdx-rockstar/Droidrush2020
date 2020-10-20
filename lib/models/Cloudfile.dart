class Cloudfile {
  String File_name;
  String LUri;

  Cloudfile({ this.File_name, this.LUri});

  @override
  String toString() {
    // TODO: implement toString
    return this.File_name + " " + this.LUri;
  }
}