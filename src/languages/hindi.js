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

const regexStart = '\u0900'
const regexEnd = '\u097F'

module.exports = {
  keywords: keywords,
  regexStart: regexStart,
  regexEnd: regexEnd
};
