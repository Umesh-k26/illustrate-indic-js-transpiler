const keywords = {
  शून्य: "null",
  నిజం: "true",
  తప్పుడు: "false",
  यह: "this",
  रिक्त: "void",
  मिटाना: "delete",
  प्रकार: "typeof",
  नया: "new",
  విలువ: "var",
  होने: "let",
  लगातार: "const",
  करना: "do",
  చక్రం: "for",
  పర్యంతం: "while",
  साथ: "with",
  ఉంటే: "if",
  లేకపోతే: "else",
  మారండి: "switch",
  కేసు: "case",
  ఈలోగా: "default",
  फेंकना: "throw",
  प्रयत्न: "try",
  पकड़: "catch",
  आखिरकार: "finally",
  जारी_रखें: "continue",
  విరామం: "break",
  ఫలితం: "return",
  ఫార్ములా: "function",
  डिबगर: "debugger",

  /* INBUILT FUNCTIONS */
  ముద్రణ: "console.log",
};

const regexStart = "\u0C00";
const regexEnd = "\u0C7F";

/* ***************************
 * 
 * 
 * DO NOT EDIT THE BELOW CODE
 * 
 * 
 * ***************************
 */


const keywords_rev = {};
for (const [k, v] of Object.entries(keywords)) {
  keywords_rev[v] = k;
}

module.exports = {
  keywords: keywords,
  regexStart: regexStart,
  regexEnd: regexEnd,
  keywords_rev: keywords_rev,
};
