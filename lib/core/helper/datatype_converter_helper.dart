class DatatypeConverterHelper {
  static String convert({required String datatype}) {
    switch (datatype.toLowerCase()) {
      case "array":
        {
          return "arrayValue";
        }
      case "bool":
        {
          return "booleanValue";
        }
      case "float":
        {
          return "doubleValue";
        }
      case "null":
        {
          return "nullValue";
        }
      case "map":
        {
          return "mapValue";
        }
      case "number":
        {
          return "integerValue";
        }
      case "string":
        {
          return "stringValue";
        }
      case "timestamp":
        {
          return "timestampValue";
        }
      default:
        {
          return "";
        }
    }
  }
}
