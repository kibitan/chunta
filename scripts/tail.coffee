child_process = require('child_process')

module.exports = (robot) ->
  tail_log = (n) ->
    return child_process.execSync "tail -n #{n} #{process.env.LOGFILE_PATH}"

  robot.respond /tail$/i, (res) ->
    log = tail_log(30).toString()
    res.send "```\n#{log.replace(/```/i, '\\\`\\\`\\\`')}\n```"

  robot.respond /tail ([0-9]+)/i, (res) ->
    log = tail_log(res.match[1]).toString()
    res.send "```\n#{log.replace(/```/i, '\\\`\\\`\\\`')}\n```"
