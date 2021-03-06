class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    
    #Part 1 Stuff
    @movies = Movie.order(params[:sort_by])
    @sort = params[:sort_by]
    
    #Part 2 and 3 Stuff
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    update = false
    if params[:ratings].present?
      @selected_rating = params[:ratings].keys
      @movies = @movies.where(rating: @selected_rating)
      session[:ratings] = params[:ratings]
    elsif !session[:ratings].nil?
      params[:ratings] = session[:ratings]
      update = true
    elsif params[:sort_by].present?
      @sort = params[:sort_by]
      @movies = @movies.order(@sort)
      session[:sort_by] = params[:sort_by]
    elsif !session[:sort_by].nil?
      params[:sort_by] = session[:sort_by]
      update = true
    end
    
    if update
     redirect_to movies_path(params.slice(:ratings, :sort_by))
    end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
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
