class UsersController < ApplicationController

  get '/signup' do
    if !logged_in?
      erb :'users/create_user'
    else
      redirect '/trips'
    end
  end

  post '/signup' do
    @user = User.new(username: params["username"], email: params["email"], password: params["password"])
    if @user.save
      session[:user_id] = @user.id
      redirect '/trips'
    else
      flash[:message] = @user.errors.full_messages.join("<br>")
      erb :'/users/create_user'
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
    if @user && @user.authenticate(params["password"])
      session[:user_id] = @user.id
      redirect '/trips'
    else
      flash[:message] = "Username or Password does not match our files. Please try again"
      erb :'/users/login'
    end
  end

  get '/logout' do
    if logged_in?
      session.clear
      redirect '/login'
    else
      redirect '/'
    end
  end

  get '/users/:slug' do
    if !logged_in?
      redirect '/login'
    end
    @user = User.find_by_slug(params[:slug])
    if !@user.nil? && @user == current_user
      erb :'/users/show'
    else
      flash[:message] = "You can only see a list of your own trips"
      redirect '/trips'
    end
  end

end
