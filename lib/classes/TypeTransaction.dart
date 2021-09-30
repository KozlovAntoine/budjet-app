enum TypeTransaction { IMMEDIAT, DIFFERE, PERMANANT }

abstract class TypeTransactionHelper {
  static String typeToString(TypeTransaction type) {
    String txt;
    switch (type) {
      case TypeTransaction.IMMEDIAT:
        txt = "Immédiat";
        break;
      case TypeTransaction.DIFFERE:
        txt = "En différé";
        break;
      case TypeTransaction.PERMANANT:
        txt = "Permanent";
        break;
    }
    return txt;
  }
}
