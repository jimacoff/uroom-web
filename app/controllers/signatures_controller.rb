class SignaturesController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:callbacks]

  def show
  end

  def create
    embedded_request = create_embedded_request(name: current_user.full_name, email: current_user.email)
    @sign_url = get_sign_url(embedded_request)
    render :embedded_signature
  end

  def callbacks
    render json: 'Hello API Event Received', status: 200
  end

  private
    def create_embedded_request(opts = {})
      HelloSign.create_embedded_signature_request(
        test_mode: 1,
        client_id: 'a4bf79b42c8f1212b39dfac989ee5a18',
        subject: 'First signature request',
        message: 'This would be cool',
        signers: [
          {
            email_address: opts[:email],
            name: opts[:name]
          }
        ],
        files: ['Google.pdf']
      )
    end

    def get_sign_url(embedded_request)
      sign_id = get_first_signature_id(embedded_request)
      HelloSign.get_embedded_sign_url(signature_id: sign_id).sign_url
    end

    def get_first_signature_id(embedded_request)
      embedded_request.signatures[0].signature_id
    end
end
