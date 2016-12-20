//= require node-fs-extra/lib/copy/copy.js

fs.copy('/Users/ivan/Desktop/pum.wav', '/Users/ivan/Desktop/den.wav', function (err) {
  if (err) return console.error(err)
  console.log("success!")
});

