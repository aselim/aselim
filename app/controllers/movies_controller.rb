class MoviesController < ApplicationController
  
  def initialize
    super
    @all_ratings = Movie.all_ratings
    #reset_session
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
	    @sort_by = params[:sort_by]  ||  session[:sort_by]
	    @ratings = params[:ratings]  || session[:ratings]
            @all_ratings = Movie.all_ratings
            @ratings_ary = @ratings ? @ratings.keys : @all_ratings
	    if (not params[:ratings] and not params[:sort_by] and not params[:commit]) and (session[:ratings] or session[:sort_by])
	    redirect_to movies_path(:ratings => session[:ratings], :sort_by => session[:sort_by])
	    end
            @movies = Movie.where(:rating => @ratings_ary).order(@sort_by)
	    session[:sort_by] = @sort_by
            session[:ratings] = @ratings
#	    @movies = Movie.where(:rating => @ratings_ary).order(@sort_by) 
#	    redirect_to movies_path(:sort_by => @sort_by)
  end

  def new
	# default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path(:sort_by => @sort_by, :rating => @ratings_ary)  and return
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
#    redirect_to movies_path
    redirect_to movies_path(:sort_by => @sort_by, :rating => @ratings_ary) and return
  end

end
