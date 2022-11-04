const fs = require('fs')
const parser = require('./examples/jscore.js')


fs.readFile('test.js', (err, data) => {
  data = data.toString('utf-8')
  console.log(data);
  res = parser.parse(data);

  console.log(res);
  console.log(JSON.stringify(res));

})