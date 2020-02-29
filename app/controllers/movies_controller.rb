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
    @all_ratings = Movie.uniq.pluck(:rating);
    sort = params[:sort]
    if params[:commit] == "Refresh"
        sort = session[:sort]
    elsif @date_class
        sort = session[:sort]
    end
    session[:sort] = params[:sort]
    @ratings = {}
    if params[:ratings]
        session[:ratings] = params[:ratings]
        params[:ratings].each_key do |key|
            @ratings[key] = true
        end
    elsif session[:ratings]
        session[:ratings].each_key do |key|
            @ratings[key] = true
        end
    else
        @all_ratings.each do |key|
            @ratings[key] = true
        end
    end
    if sort == "title"
        @title_class = "hilite"
        @movies = Movie.where(rating: @ratings.keys).order("title asc")
        session[:sort] = "title"
    elsif sort == "date"
        @date_class = "hilite"
        @movies = Movie.where(rating: @ratings.keys).order("release_date asc")
        session[:sort] = "date"
    else
        @movies = Movie.where(rating: @ratings.keys)
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
