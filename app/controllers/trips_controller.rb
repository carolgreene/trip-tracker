class TripsController < ApplicationController



  get '/trips' do
    if !logged_in?
      redirect '/login'
    else
      @user = User.find(session[:user_id])
      erb :'/trips/trips'
    end
  end

  get '/trips/new' do
    if !logged_in?
      redirect '/login'
    else
      erb :'/trips/create_trip'
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

  get '/trips/:id/edit' do
    @trip = Trip.find_by_id(params[:id])
    if !logged_in?
      redirect '/login'
    elsif session[:user_id] == @trip.user_id
      erb :'trips/edit_trip'
    else
      redirect '/trips'
    end
  end

  patch '/trips/:id' do
    @trip = Trip.find_by_id(params[:id])
    if params[:trip_name].empty? || params[:description].empty?
      redirect "/trips/#{@trip.id}/edit"
    else
      @trip.trip_name = params[:trip_name]
      @trip.description = params[:description]
      @trip.save
      redirect "/trips/#{@trip.id}"
    end
  end

  delete '/trips/:id/delete' do
    @trip = Trip.find_by_id(params[:id])

    if !logged_in?
      redirect '/login'
    elsif session[:user_id] == @trip.user_id
      @trip.delete
      redirect '/trips'
    else
      redirect '/'
    end
  end


end
