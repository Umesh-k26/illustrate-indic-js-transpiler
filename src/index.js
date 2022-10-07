const fs = require('fs')
const parser = require('./examples/jscore')


fs.readFile('test.js', (err, data) => {
  data = data.toString('utf-8')
  // console.log(data);
  res = parser.parse(data);

  // end = res[res.length-1]
  // console.log(end[1])
  // console.log(res[0][1]);
  console.log(res);

})