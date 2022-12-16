const { dirname } = require('path');
const appDir = dirname(require.main.filename);

module.exports = appDir;