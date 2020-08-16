const postcssPresetEnv = require('postcss-preset-env');
const postcssImport = require('postcss-import');
const postcssNormalize = require('postcss-normalize');
const postcssExtend = require('postcss-extend');
const postcssColorMod = require('postcss-color-mod-function');
const cssNano = require('cssnano');

module.exports = () => ({
  plugins: [
    postcssImport(),
    postcssNormalize(),
    postcssPresetEnv({
      stage: 0,
      insertAfter: {
        'nesting-rules': postcssExtend,
      },
    }),
    postcssColorMod(),
  ],
});
