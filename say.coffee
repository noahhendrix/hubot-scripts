# Assign allowed replies to certain messages
#
# when we say <msg> you can say <reply> - assign a new reply to message

# hubot when we say shut up you can say Sorry, I'll keep it down!
# hubot when we say shut up you can say Yes, sir!
#
# you: hubot I say shut up
# hubot: "Yes, sir!" or "Sorry, I'll keep it down!"

class Replies
  constructor: (@robot) ->
    @cache = {}
    @robot.brain.on 'loaded', =>
      if @robot.brain.data.replies
        @cache = @robot.brain.data.replies
  add: (message, reply) ->
    if @cache[message] == undefined
       @cache[message] = []
    
    @cache[message].push reply if reply not in @cache[message]
    @robot.brain.data.replies = @cache
    
    reply
  all: -> @cache
  lookup: (message) ->
    if @cache[message] != undefined
      random_index = (Math.ceil Math.random() * @cache[message].length) - 1
      @cache[message][random_index]
  
module.exports = (robot) ->
  replies = new Replies robot
  
  robot.respond /when (we|I) say (.*) you can say (.*)/i, (msg) ->
    msg_txt   = msg.match[2]
    reply_txt = msg.match[3].trim()
    
    reply = replies.add msg_txt, reply_txt
    msg.send "Response added: #{msg_txt} -> #{reply_txt}"
    
  robot.respond /I say (.*)/i, (msg) ->
    message = msg.match[1].trim()
    reply   = replies.lookup(message)
    if reply
      msg.send reply
    else
      msg.send "I don't know what to say to #{message}"