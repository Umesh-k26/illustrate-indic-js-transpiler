const argv = require("minimist")(process.argv.slice(2));

const fs = require("fs");
const execSync = require("child_process").execSync;


const transpiler = require("./src/transpiler");
const appDir = require("./src/appDir");

const usage =
  "Usage:\n-f : input file name\n-o : output file name\n-l : language\n-a : to print ast or not\n";

async function main() {
  if (!argv["f"]) {
    console.log(usage);
    throw new Error("No input file provided");
  }

  if (!argv["l"]) {
    console.log(usage);
    throw new Error("Language not specified");
  }
  let inputFile = appDir + "/tests/" + argv["f"];
  let outputFile = argv["o"] ? argv["o"] : "output_" + argv["f"];
  outputFile = appDir + "/build/" + outputFile;
  let language = argv["l"];

  fs.readFile(inputFile, "utf8", (err, data) => {
    if (err) throw err;
    let output = transpiler(language, data);
    fs.writeFile(outputFile, output, (err) => {
      if (err) throw err;
      console.log(`Output writtten into ${outputFile}`);
    });

    // Ast function call
    if (argv["a"]) {
      let parserPath = appDir + "/build/parser.js";
      execSync(`node "${parserPath}" ${inputFile}`, { stdio: "inherit" });
    }
  });
}

main();

/* 
Usage:
-f : input file name
-o : output file name
-l : language
-a : to print ast or not
*/
