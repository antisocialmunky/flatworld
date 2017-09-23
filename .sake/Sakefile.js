'use strict';

use('sake-bundle');

use('sake-outdated');

use('sake-publish');

use('sake-version');

option('-b', '--browser [browser]', 'browser to use for tests');

option('-g', '--grep [filter]', 'test filter');

option('-t', '--test [test]', 'specify test to run');

option('-v', '--verbose', 'enable verbose test logging');

task('clean', 'clean project', function () {
  return exec('rm -rf lib');
});

task('build', 'build js', ['build:static'], function () {
  if (running('build')) {
    return;
  }
  return bundle.write({
    entry: 'src/index.coffee',
    compilers: {
      coffee: {
        version: 1
      }
    },
    quiet: false,
    details: true,
    external: false,
    commonjs: true
  })["catch"](function (err) {
    return console.error(err);
  });
});

task('build:web', 'build js', function () {
  return bundle.write({
    entry: 'src/index.coffee',
    external: false,
    browser: false,
    details: true,
    quiet: false,
    commonjs: true,
    format: 'web',
    sourceMap: false,
    compilers: {
      coffee: {
        version: 1
      }
    }
  });
});

task('build:min', 'build js for production', ['build', 'build:web'], function* () {
  yield exec('uglifyjs flatworld.js -o flatworld.min.js');
  return yield exec('cp lib/theme.css theme.css');
});

task('build:static', 'build static assets', function () {
  return exec('bebop compile');
});

task('build:static', 'build static assets', function () {
  return exec('mkdir -p public/css\nmkdir -p public/js\nbebop compile\'');
});

task('watch', 'watch for changes and rebuild project', ['watch:js', 'watch:static']);

task('watch:js', 'watch js for changes and rebuild', function () {
  var build;
  build = function (filename) {
    if (running('build')) {
      return;
    }
    console.log(filename, 'modified');
    return invoke('build:js');
  };
  watch('src/*', build);
  return watch('node_modules/*', build);
});

task('watch:static', 'watch static files and rebuild', ['build:static'], function () {
  return exec('bebop');
});