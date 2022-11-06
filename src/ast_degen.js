function degen(ast) {
  let res = "";
  if (ast) {
    ast.forEach((stmt) => {
      res += stmt_degen(stmt);
      res += "\n";
    });
  }
  return res;
}
module.exports = degen;

function stmt_degen(stmt) {
  let res = "";
  switch (stmt[0]) {
    case "blockStmt":
      res += "{\n" + degen(stmt[1]) + "\n}";
      break;

    case "varStmt":
      res = "var " + vardec_degen(stmt[1]) + ";";
      break;

    case "constStmt":
      res = "const " + vardec_degen(stmt[1]);
      break;

    case "functionStmt":
      break;
    case "emptyStmt":
      // do nothing
      break;

    case "exprStmt":
      res = exprs_degen(stmt[1]);
      break;

    case "ifStmt":
      res = if_degen(stmt[1]);
      break;

    case "iterStmt":
      res = iter_degen(stmt[1]);
      break;

    case "continueStmt":
      res += "continue;";
      break;

    case "breakStmt":
      res = "break;";
      break;

    case "returnStmt":
      res = "return ";
      if (stmt[1]) res += expr_degen(stmt[1]);
      break;

    default:
      break;
  }
  return res;
}

function vardec_degen(arr) {
  let res = "";

  for (let i = 0; i < arr.length; i++) {
    res += arr[i].identifier;

    if (arr[i].value) res = res + "=" + arr[i].value;

    if (i < arr.length - 1) res += ", ";
  }
  return res;
}
function exprs_degen(exprs) {
  let res = '';
  for(let i = 0;i < exprs.length; i++)
  {
    res += expr_degen(exprs[i]);

    if(i < exprs.length - 1) res += ', ';
  }
}
function expr_degen(expr) {
  let res = "";
  switch (expr.type) {
    case "relational_exp":
      res = expr_degen(expr.left) + expr.operator + expr_degen(expr.right);
      break;

    case "assign_exp":
      res = expr_degen(expr.left) + expr.operator + expr_degen(expr.right);
      break;

    case "logical_exp":
      res = expr_degen(expr.left) + expr.operator + expr_degen(expr.right);
      break;

    case 'ternary_exp':
      res = expr_degen(expr.exp1) + '?' + expr_degen(expr.exp2) + ':' + expr_degen(expr.exp3);
      break;
    
    case 'bitwise_exp':
      res = expr_degen(expr.left) + expr.operator + expr_degen(expr.right);
      break;
    
    case 'relational_exp':
      res = expr_degen(expr.left) + expr.operator + expr_degen(expr.right);
      break;

    case 'shift_exp':
      res = expr_degen(expr.left) + expr.operator + expr_degen(expr.right);
      break;
    
    case 'post_fix_exp':
      res = expr_degen()
    default:
      break;
  }
}

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

    case "for_var":
      res =
        "for" +
        "(" +
        "var" +
        vardec_degen(node.init) +
        "; " +
        expr_degen(node.test) +
        "; " +
        expr_degen(node.update) +
        ")" +
        stmt_degen(node.body);
      break;

    case "rangeloop":
      res =
        "for" +
        "(" +
        expr_degen(node.lhs) +
        ":" +
        expr_degen(node.rhs) +
        ")" +
        stmt_degen(node.body);
      break;

    default:
      break;
  }
}
