class UsersController < ApplicationController

  get '/signup' do
    if !logged_in?
      erb :'users/new'
    else
      redirect '/trips'
    end
  end

  post '/signup' do
    if params["username"] == "" || params["email"] == "" ||  params["password"] == ""
      redirect '/signup'
    else
      @user = User.new(username: params["username"], email: params["email"], password: params["password"])
      @user.save
      session[:user_id] = @user.id
      redirect '/trips'
    end
  end




end
