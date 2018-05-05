class UsersController < ApplicationController

  get '/signup' do
    if !logged_in?
      erb :'users/create_user'
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

  get '/login' do
    if !logged_in?
      erb :'/users/login'
    else
      redirect '/trips'
    end
  end

  post '/login' do
    @user = User.find_by(username: params["username"])
    if @user && user.authenticate(params["password"])
      session[:user_id] = @user.id
      redirect '/trips'
    else
      redirect '/login'
    end
  end





end
