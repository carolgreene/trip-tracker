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
    if !params[:trip_name].empty? && !params[:description].empty?
      @trip = Trip.create(trip_name: params["trip_name"], description: params["description"])
      @trip.user_id = session[:user_id]
      @trip.save
      flash[:message] = "New trip created"
      erb :'/trips/trips'
    else
      flash[:message] = "All fields must be filled out"
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
      flash[:message] = "All fields need to be filled out"
      redirect "/trips/#{@trip.id}/edit"
    else
      @trip.trip_name = params[:trip_name]
      @trip.description = params[:description]
      @trip.save
      flash[:message] = "Edit complete"
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
      flash[:message] = "Trip has been deleted"
      redirect '/trips'
    else
      flash[:message] = "You can only delete your own trips"
      redirect '/trips'
    end
  end

end
