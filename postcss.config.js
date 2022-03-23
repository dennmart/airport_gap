var tailwindcss = require("tailwindcss");

module.exports = {
  plugins: [
    require("postcss-import"),
    require('postcss-nested'),
    tailwindcss('./tailwind.config.js'),
  ]
};
