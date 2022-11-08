const moo = require("moo");
const Languages = require("./languages");

const transpiler = (language, data) => {
  const languageObj = Languages[language];

  let lexer = moo.compile({
    WS: /[ \t]+/,
    comment: /\/\/.*?$/,
    number: /0|[1-9][0-9]*/,
    IDEN: {
      match: new RegExp(
        `[a-zA-Z${languageObj.regexStart}-${languageObj.regexEnd}]+`
      ),
      type: moo.keywords({
        KW: Object.keys(languageObj.keywords),
      }),
    },
    SPACE: { match: /\s+/, lineBreaks: true },
    operators: Languages.operators,
  });

  let output = "";
  lexer.reset(data);
  while ((token = lexer.next())) {
    output +=
      token.type == "KW" ? languageObj.keywords[token.value] : token.value;
  }
  return output;
};

module.exports = transpiler;
