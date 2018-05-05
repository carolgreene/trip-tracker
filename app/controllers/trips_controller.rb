class TripsController < ApplicationController

  get 'trips/new' do
    if !logged_in?
      redirect '/login'
    else
      erb :'/trips/create_trip'
    end
  end

  get '/trips' do
    if !logged_in?
      redirect '/login'
    else
      @user = User.find(session[:user_id])
      erb :'/trips/trips'
    end
  end

end
