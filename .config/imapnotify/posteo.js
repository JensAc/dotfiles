var child_process = require('child_process');

function getStdout(cmd) {
  var stdout = child_process.execSync(cmd);
  return stdout.toString().trim();
}

exports.host = "posteo.de";
exports.port = 993;
exports.tls = true;
exports.tlsOptions = { "rejectUnauthorized": false };
exports.username = "jens.schneider.ac@posteo.de";
exports.password = getStdout("pass mail/posteo.de | head -n 1");
exports.onNotify = "mbsync -a";
exports.onNotifyPost = "notify-send 'New mail on posteo'";
exports.executeOnStartup = true;
exports.boxes = [ "Inbox" ];
