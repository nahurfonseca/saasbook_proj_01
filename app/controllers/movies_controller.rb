class MoviesController < ApplicationController
  @@statefull_params = [:ratings, :sort_by]
  attr_accessor :statefull_params

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # remember session, if no params
    @need_redirect = false
    @@statefull_params.each { |p|
        if session[p] and !params[p]
          params[p] = session[p]
          @need_redirect = true
        end }
    if @need_redirect
      redirect_to movies_path(params)
    end
    # load Model from DB
    case
      when (params[:ratings] and params[:sort_by])
        @movies = Movie.where('rating in (?)', params[:ratings].keys).order(params[:sort_by]).all
      when params[:ratings]
        @movies = Movie.where('rating in (?)', params[:ratings].keys).all
      when params[:sort_by]
        @movies = Movie.order(params[:sort_by]).all
      else
        @movies = Movie.all
    end
    # prepare instance variables used in view
    @all_ratings = Movie.all_ratings
    @sorted = params[:sort_by]
    @checked_ratings = {}
    if (params[:ratings])
      params['ratings'].each { |k,v| @checked_ratings[k]=true }
    end
    # save session
    @@statefull_params.each { |p|
        if params[p]
          session[p] = params[p] 
        end }
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
