const moo = require("moo");
const fs = require("fs");
const lang = require("./languages");

const hindiMap = lang.hindi.keywords;

let lexer = moo.compile({
  WS: /[ \t]+/,
  comment: /\/\/.*?$/,
  number: /0|[1-9][0-9]*/,
  IDEN: {
    match: /[a-zA-Z\u0900-\u097F]+/,
    type: moo.keywords({
      KW: Object.keys(hindiMap),
    }),
  },
  SPACE: { match: /\s+/, lineBreaks: true },
  operators: lang.operators,
});


fs.readFile("test.js", (err, data) => {
  data = data.toString("utf-8");
  lexer.reset(data)
  let token;
  let output = '';
  while ((token = lexer.next())) {
    // console.log(token)
    if(token.type == 'KW')
    {
      output += hindiMap[token.value]
    }
    else output += token.value;
  }
  console.log(output)
});
