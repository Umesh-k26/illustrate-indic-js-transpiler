const exec = require("child_process").exec;

const Parser = require("jison").Parser;
const { stderr } = require("process");
const lexRules = require("./lex_rules");

const astGenerator = async (language, data) => {
  // let grammar = {
  //   lex: lexRules(),
  // };
  // const parser = new Parser(grammar);

  // exec for lexer
  // lexRules(language);
  // exec for jison

  // exec("jison parser.jison lexer.l -o parser.js", (error, stdout, stderr) => {
  //   if (error) return error;

  //   const parser = require("./parser");
  //   let output = parser.parse(data);
  //   console.log(output);
  // });
  console.log('AST Yet to be implemented...')
};

module.exports = astGenerator;
