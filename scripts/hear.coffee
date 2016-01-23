module.exports = (robot) ->
  robot.hear /ちゅん/i, (res) ->
    res.send ":heartbeat:"
  robot.hear /ちゅ(ー+)ん/i, (res) ->
    text = ""
    for i in [0..res.match[1].length]
      text += ":heartbeat:"
    res.send text
  robot.hear /に！/i, (res) ->
    res.send "た:exclamation::heart_eyes_cat:"
  robot.hear /た！/i, (res) ->
    res.send "に:exclamation::heart_eyes:"
  robot.hear /ち？/i, (res) ->
    res.send ":flushed::ghost:"
  robot.hear /ちゅ/i, (res) ->
    res.send "ちゅ:kiss:"
  robot.hear /たん/i, (res) ->
    res.send "た:question::eyes:"
