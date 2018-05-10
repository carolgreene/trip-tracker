require 'rack-flash'

class TripsController < ApplicationController
  use Rack::Flash


  get '/trips' do
    if !logged_in?
      flash[:message] = "You have to sign in to do that"
      redirect '/login'
    else
      @user = User.find(session[:user_id])
      erb :'/trips/trips'
    end
  end

  get '/trips/new' do
    if !logged_in?
      flash[:message] = "You have to sign in to do that"
      redirect '/login'
    else
      erb :'/trips/create_trip'
    end
  end


  post '/trips' do
    #binding.pry
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
    @trip = Trip.find_by_id(params[:id])
      if !logged_in?
        flash[:message] = "You have to sign in to do that"
        redirect '/login'
      elsif session[:user_id] == @trip.user_id

        erb :'/trips/show_trip'
      else
        flash[:message] = "You can only go to your own trips"
        redirect '/trips'
      end
    end

  get '/trips/:id/edit' do
    @trip = Trip.find_by_id(params[:id])
    if !logged_in?
      flash[:message] = "You have to sign in to do that"
      redirect '/login'
    elsif session[:user_id] == @trip.user_id
      erb :'trips/edit_trip'
    else
      flash[:message] = "You can only edit your own trips"
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
      flash[:message] = "You have to sign in to do that"
      redirect '/login'
    elsif session[:user_id] == @trip.user_id
      @trip.delete
      redirect '/trips'
    else
      flash[:message] = "You can only delete your own trips"
      redirect '/trips'
    end
  end


end
