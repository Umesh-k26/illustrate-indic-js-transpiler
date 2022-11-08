const Languages = require("./languages");

const lexRules = (language) => {
  const keywords = Languages[language].keywords;
  const operators = Languages.operators;

  let ret = {
    macros: {},
    rules: [],
  };
  return ret;
};

module.exports = lexRules;
