child_process = require('child_process')

module.exports = (robot) ->
  tail_log = (n) ->
    return child_process.execSync "tail -n #{n} #{process.env.LOGFILE_PATH}"

  robot.respond /tail$/i, (res) ->
    res.send "```\n#{tail_log(50).replace(/```/i, '\`\`\`')}\n```"

  robot.respond /tail ([0-9]+)/i, (res) ->
    res.send "```\n#{tail_log(res.match[1]).replace(/```/i, '\`\`\`')}\n```"
