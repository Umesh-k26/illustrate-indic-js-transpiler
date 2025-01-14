const moo = require("moo");
const Tinytim = require("tinytim");
const fs = require("fs");
const JisonLex = require("jison-lex");
const execSync = require("child_process").execSync;

const operators = require("./languages/operators");
const appDir = require("./appDir");

const transpiler = (language, data) => {
  let languageObj = null;
  try {
    languageObj = require(`./languages/${language}`)
  } catch (error) {
    throw "Unable to find the specified language";
  }
  const grammar = Tinytim.renderFile(
    appDir + "/src/languages/template.l",
    {
      regexStart: languageObj.regexStart,
      regexEnd: languageObj.regexEnd,
      ...languageObj.keywords_rev

    }
  );

  let jisonlex = new JisonLex(grammar);
  jisonlex.setInput(data);

  let jisonFilePath = `${appDir}/src/jscore.jison`;

  const buildDir = "build";
  let lexFilePath = `${appDir}/${buildDir}/${language}_lexer.l`;
  let parserPath = `${appDir}/${buildDir}/${language}_parser.js`;

  if (!fs.existsSync(buildDir)) {
    fs.mkdirSync(buildDir);
  }

  fs.writeFileSync(lexFilePath, grammar);
  execSync(`jison "${jisonFilePath}" "${lexFilePath}" -o "${parserPath}"`);

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
    operators: operators,
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
