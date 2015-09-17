class MessagesController < ApplicationController

  def create
    text = params[:message][:text]
    chat = Chat.find(params[:chat])
    @chat = Chat.find(params[:chat])
    @message = Message.create!(chat: @chat, sender: current_user, text: text)

    # redirect_to Listing.find(params[:listing])
    # check if user is part of crew
    Pusher.trigger("#{@chat.id}", 'new_message', {
      sender: @message.sender.first_name,
      text: @message.text
    }, {
    socket_id: params[:socket_id]
    })

    respond_to :js
  end
end
