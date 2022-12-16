const keywords = {
  शून्य: "null",
  सत्य: "true",
  असत्य: "false",
  यह: "this",
  रिक्त: "void",
  मिटाना: "delete",
  प्रकार: "typeof",
  नया: "new",
  मान: "var",
  होने: "let",
  लगातार: "const",
  करना: "do",
  चक्रम्: "for",
  पर्यन्तम्: "while",
  साथ: "with",
  यदि: "if",
  अथ: "else",
  निर्देश: "switch",
  यद: "case",
  यदभावे: "default",
  फेंकना: "throw",
  प्रयत्न: "try",
  पकड़: "catch",
  आखिरकार: "finally",
  जारी_रखें: "continue",
  विराम्: "break",
  फल: "return",
  सूत्र: "function",
  डिबगर: "debugger",

  /* INBUILT FUNCTIONS */
  वद्: "console.log",
};

const keywords_rev = {
  null: "शून्य",
  true: "सत्य",
  false: "असत्य",
  this: "यह",
  void: "रिक्त",
  delete: "मिटाना",
  typeof: "प्रकार",
  new: "नया",
  var: "मान",
  let: "होने",
  const: "लगातार",
  do: "करना",
  for: "चक्रम्",
  while: "पर्यन्तम्",
  with: "साथ",
  if: "यदि",
  else: "अथ",
  switch: "निर्देश",
  case: "यद",
  default: "यदभावे",
  throw: "फेंकना",
  try: "प्रयत्न",
  catch: "पकड़",
  finally: "आखिरकार",
  continue: "जारी_रखें",
  break: "विराम्",
  return: "फल",
  function: "सूत्र",
  debugger: "डिबगर",

  /* INBUILT FUNCTIONS */
  "console.log": "वद्",
};

const regexStart = '\u0900'
const regexEnd = '\u097F'

module.exports = {
  keywords: keywords,
  regexStart: regexStart,
  regexEnd: regexEnd,
  keywords_rev: keywords_rev
};
