const moo = require("moo");
const Tinytim = require("tinytim");
const fs = require("fs");
const JisonLex = require("jison-lex");
const execSync = require("child_process").execSync;

const Languages = require("./languages");
const appDir = require("./appDir");

const transpiler = (language, data) => {
  const languageObj = Languages[language];
  const grammar = Tinytim.renderFile(
    appDir + "/src/languages/template.l",
    languageObj.keywords_rev
  );

  let jisonlex = new JisonLex(grammar);
  jisonlex.setInput(data);

  let jisonFilePath = `${appDir}/src/jscore.jison`;

  const buildDir = "build";
  let lexFilePath = `${appDir}/${buildDir}/lexer.l`;
  let parserPath = `${appDir}/${buildDir}/parser.js`;

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
