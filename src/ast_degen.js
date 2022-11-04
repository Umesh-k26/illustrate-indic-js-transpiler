export function degen(ast) {
  let res = "";
  if (ast) {
    ast.forEach((stmt) => {
      res += stmt_degen(stmt);
      res += "\n";
    });
  }
  return res;
}

function stmt_degen(stmt) {
  let res = "";
  switch (stmt[0]) {
    case "blockStmt":
      res += "{";
      res += degen(stmt[1]);
      res += "}";
      break;

    case "constStmt":
      res += "const ";
      res += vardec_degen(stmt[1]);
      break;

    case "functionStmt":
      break;
    case "emptyStmt":
      // do nothing
      break;

    case "exprStmt":
      res += expr_degen(stmt[1]);
      break;

    case "ifStmt":
      res += if_degen(stmt[1]);
      break;

    case "iterStmt":
      res += iter_degen(stmt[1]);
      break;

    case "continueStmt":
      res += "continue;";
      break;

    case "breakStmt":
      res += "break;";
      break;

    case "returnStmt":
      res += "return ";
      if (stmt[1]) res += expr_degen(stmt[1]);
      break;

    default:
      break;
  }
  return res;
}

function vardec_degen(arr) {
  let res = "";
  arr.forEach((element) => {
    res += element.identifier;

    if (element.value) {
      res = res + "=" + element.value;
    }
  });
  return res;
}

function expr_degen(expr) {}

function if_degen(node) {
  let res = "if";
  res += "(";
  res += expr_degen(node.exp);
  res += ")";
  res += stmt_degen(node.stmt1);

  if (node.stmt2) {
    res += "else ";
    res += stmt_degen(node.stmt2);
  }
  return res;
}

function iter_degen(node) {
  let res = "";
  switch (node.type) {
    case "do_while":
      res =
        "do" +
        stmt_degen(node.body) +
        "while" +
        "(" +
        expr_degen(node.test) +
        ")";
      break;

    case "while":
      res = "while" + "(" + expr_degen(node.test) + ")" + stmt_degen(node.body);

      break;

    case "for":
      res =
        "for" +
        "(" +
        expr_degen(node.init) +
        "; " +
        expr_degen(node.test) +
        "; " +
        expr_degen(node.update) +
        ")" +
        stmt_degen(node.body);
      break;

    case "rangeloop":
      break;

    default:
      break;
  }
}
