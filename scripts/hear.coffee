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
  robot.hear /ち！/i, (res) ->
    res.send "ち:exclamation::hamster:"
  robot.hear /ち？/i, (res) ->
    res.send ":flushed::ghost:"
  robot.hear /ちゅ/i, (res) ->
    res.send "ちゅ:kiss:"
  robot.hear /たん/i, (res) ->
    res.send "た:question::eyes:"
  robot.hear /さとち/i, (res) ->
    res.send "さとちゅん:heartpulse:"
  robot.hear /ちか/i, (res) ->
    res.send ":eyes:"
  robot.hear /帰る/i, (res) ->
    res.send ":frog:"
  gohan = [':rice:', ':stew:', ':ramen:', ':curry:', ':rice_ball:', ':oden:']
  robot.hear /ご飯/i, (res) ->
    res.send res.random gohan
  robot.hear /ごはん/i, (res) ->
    res.send res.random gohan
