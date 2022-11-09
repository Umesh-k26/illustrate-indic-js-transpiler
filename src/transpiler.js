const moo = require("moo");
const Languages = require("./languages");
const JisonLex = require('jison-lex');
const execSync = require('child_process').execSync;
const parser = require('./examples/jscore.js');
// const Parser = require("jison").Parser;
const Tinytim = require('tinytim');

const transpiler = (language, data) => {
  const languageObj = Languages[language];
  const grammar = Tinytim.renderFile("./languages/template.l", languageObj.keywords_rev);
  console.log("********* " + grammar + " *********");
  
  let jisonlex = new JisonLex(grammar);
  jisonlex.setInput(data);

  // TODO creating a jscore file

  // jison jscore.jison hindi_js.l -o jscore.js
  // let parser = new Parser(grammar);
  // exec('jison jscore.jison hindi_js.l -o ./examples/jscore.js', { encoding: 'utf-8' }); 

  // execSync('echo '+ grammar + ' > ./examples/output-grammar.l', { encoding: 'utf-8' });
  // let out = console.log(execSync('echo ' + '"' + grammar + '"' + ' > ./examples/output-grammar.l', { encoding: 'utf-8' }))
  // execSync('jison ./examples/jscore.jison ./examples/output-grammar.l -o ./examples/jscore.js', { encoding: 'utf-8' });

  parser.lexer = jisonlex;
  ast = parser.parse(data);
  console.log("AST:\n"+ JSON.stringify(ast));

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
