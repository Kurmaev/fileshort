class UploadController < ApplicationController
  def index
    @uploads = Upload.all()
  end

  def create
    original_filename = params[:upload][:original_name].original_filename
    @upload = Upload.new(:original_name => original_filename)
    @upload.save

    id = @upload.id.to_s(16)
    extension = params[:upload][:original_name].original_filename.split('.').last

    name      =  id+'.'+extension
    directory = "public/data"
    path = File.join(directory, name)
    File.open(path, "wb") { |f| f.write(params[:upload][:original_name].read) }

    @upload.update_attributes(:slug => id, :extension => extension, :filepath => name)

    redirect_to :action => :view, :id => @upload.id
  end

  def view
    @upload = Upload.find(params[:id])
    if @upload.extension == 'jpeg' || @upload.extension == 'png'
      render 'view_image'
    end
  end

  def download
    @upload = Upload.find(params[:id])
    send_file('public/data/'+@upload.filepath, {:filename => @upload.original_name})
  end

  def delete
    @upload = Upload.find(params[:id])
    File.delete("public/data/"+@upload.filepath) 
    @upload.destroy
   
    redirect_to :action => :index
  end
end