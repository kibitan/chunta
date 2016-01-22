module.exports = (robot) ->
  robot.hear /ちゅん/i, (res) ->
    res.send ":heartbeat:"
