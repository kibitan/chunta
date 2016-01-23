module.exports = (robot) ->
  robot.hear /ちゅん/i, (res) ->
    res.send ":heartbeat:"
  robot.hear /ちゅ(ー+)ん/i, (res) ->
    text = ""
    for i in [0..res.match[1].length]
      text += ":heartbeat:"
    res.send text
  robot.hear /に！/i, (res) ->
    res.send "た！:heart_eyes_cat:"
  robot.hear /た！/i, (res) ->
    res.send "に！:heart_eyes:"
