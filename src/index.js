const fs = require('fs')
const parser = require('./examples/jscore.js')
const degen = require('./ast_degen.js')


fs.readFile('test.js', (err, data) => {
  data = data.toString('utf-8')
  // console.log(data);
  ast = parser.parse(data);

  // console.log(res);
  console.log(JSON.stringify(ast));

  console.log(degen(ast))
})