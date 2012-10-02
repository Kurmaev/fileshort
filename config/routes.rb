Fileshort::Application.routes.draw do
  get "upload/index"
  get "upload/files"
  post "upload/create"
  get "upload/view/:id" => "upload#view"
  get "upload/download/:id" => "upload#download"
  get "upload/delete/:id" => "upload#delete"
  get ":id" => "upload#view"

  root :to => 'upload#index'
end
