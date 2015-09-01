class MessagesController < ApplicationController

  def create
    @message = Message.new
    @chat = Chat.find(params[:chat])
    @message.text = params[:message][:text]
    @message.chat = Chat.find(params[:chat])
    @message.sender = current_user
    @message.save
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
