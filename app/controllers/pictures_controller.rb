class PicturesController < ApplicationController

  def destroy
    @picture = Picture.find(params[:id])
    @id = @picture.id
    @picture.destroy

    respond_to do |format|
      format.html { redirect_to picture_url }
      format.json { head :no_content }
      format.js   { render :layout => false }
    end
  end

end
