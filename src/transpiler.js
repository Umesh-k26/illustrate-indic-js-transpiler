const moo = require("moo");
const fs = require("fs");
const Languages = require("./languages");

const transpiler = (language, data) => {
  const languageObj = Languages[language].keywords;

  let lexer = moo.compile({
    WS: /[ \t]+/,
    comment: /\/\/.*?$/,
    number: /0|[1-9][0-9]*/,
    IDEN: {
      match: /[a-zA-Z\u0900-\u097F]+/,
      type: moo.keywords({
        KW: Object.keys(languageObj),
      }),
    },
    SPACE: { match: /\s+/, lineBreaks: true },
    operators: Languages.operators,
  });

  let output = "";

  lexer.reset(data);
  while ((token = lexer.next())) {
    // console.log(token)
    output += token.type == "KW" ? languageObj[token.value] : token.value;
  }
  return output;
};

module.exports = transpiler;
