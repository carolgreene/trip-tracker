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

  post '/trips' do
    if !params[:trip_name].empty? && !params[:description].empty?
      @trip = Trip.create(trip_name: params["trip_name"], description: params["description"])
      @trip.user_id = session[:user_id]
      @trip.save
      erb :'trips/trips'
    else
      redirect '/trips/new'
    end
  end

  get '/trips/:id' do
    if logged_in?
      @trip = Trip.find_by_id(params[:id])
      erb :'/trips/show_trip'
    else
      redirect '/login'
    end
  end

end
