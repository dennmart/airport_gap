var tailwindcss = require("tailwindcss");

module.exports = {
  plugins: [
    require("postcss-import"),
    require('postcss-nested'),
    tailwindcss('./tailwind.config.js'),
    // require("postcss-flexbugs-fixes"),
    // require("postcss-preset-env")({
    //   autoprefixer: {
    //     flexbox: "no-2009"
    //   },
    //   stage: 3
    // })
  ]
};
