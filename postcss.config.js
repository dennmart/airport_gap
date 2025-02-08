var tailwindcss = require("tailwindcss");

module.exports = {
  plugins: [
    require("@tailwindcss/postcss"),
    require("@tailwindcss/nesting"),
    tailwindcss("./tailwind.config.js"),
  ],
};
