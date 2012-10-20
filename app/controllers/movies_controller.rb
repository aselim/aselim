class MoviesController < ApplicationController
  
  def initialize
    super
    @all_ratings = Movie.all_ratings
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
	    @sort_by = params[:sort_by] ||  session[:sort_by]
	    @all_ratings = Movie.all_ratings
	    @ratings = params[:ratings] || session[:ratings] || {}
	    @ratings_ary = @ratings.keys
            session[:sort_by] = @sort_by
            session[:ratings] = @ratings
#            redirect_to :sort_by => @sort_by and return #, :ratings => @ratings and return
	    @movies = Movie.where(:rating => @ratings_ary).order(@sort_by) 
#           @movies = Movie.order(@sort_by) 
#	    session[:sort_by] = @sort_by
#	    session[:ratings] = @ratings
#	    redirect_to movies_path(session[:sort_by])
#	    redirect_to :sort_by => @sort_by and return
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
