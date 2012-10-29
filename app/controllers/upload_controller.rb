class UploadController < ApplicationController
  def index
  end

  def create
    if params[:upload].present?
      original_filename = params[:upload][:original_name].original_filename
      extension = params[:upload][:original_name].original_filename.split('.').last
      to_write = params[:upload][:original_name].read
    elsif params[:base64].present?
      original_filename = Time.now.strftime("%Y%m%d%H%M%S%L")
      extension = "png"
      to_write = Base64.decode64(params[:base64].split(',').last)
    else
      if request.xhr?
        render :json => { "status" => "error" }
      else
        redirect_to :action => :index
      end
      return
    end

      @upload = Upload.new(:original_name => original_filename)
      @upload.save
      id = @upload.id.to_s(16)
      name      =  id+'.'+extension

      directory = "public/data"
      path = File.join(directory, name)

      File.open(path, "wb") { |f| f.write(to_write) }
      @upload.update_attributes(:slug => id, :extension => extension, :filepath => name)

      render :text => id
  end

  def view
    @upload = Upload.find_by_slug(params[:id])
    if @upload.extension == 'jpeg' || @upload.extension == 'png' || @upload.extension == 'jpg' || @upload.extension == 'gif'
      @image = true
      render 'view_image'
    end
  end

  def download
    @upload = Upload.find_by_slug(params[:id])
    send_file('public/data/'+@upload.filepath, {:filename => @upload.original_name})
  end

  def delete
    @upload = Upload.find(params[:id])
    File.delete("public/data/"+@upload.filepath) 
    @upload.destroy
   
    redirect_to :action => :files
  end

  def files
    @uploads = Upload.all()
  end
end