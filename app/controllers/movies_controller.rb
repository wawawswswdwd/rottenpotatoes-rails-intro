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
    @all_ratings = Movie.all_ratings
    sort = params[:sort]
    @ratings = {}
    if params[:commit] == "Refresh"
        sort = flash[:sort]
        if params[:ratings]
            flash[:ratings] = params[:ratings]
            params[:ratings].each_key do |key|
                @ratings[key] = true
            end
        end
    elsif sort
        if flash[:ratings]
            flash[:ratings].each_key do |key|
                @ratings[key] = true
            end
        end
        flash[:ratings] = flash[:ratings]
    else
        @all_ratings.each do |key|
            @ratings[key] = true
        end
    end

    if sort == "title"
        @title_class = "hilite"
        @movies = Movie.where(rating: @ratings.keys).order("title asc")
        flash[:sort] = "title"
    elsif sort == "date"
        @date_class = "hilite"
        @movies = Movie.where(rating: @ratings.keys).order("release_date asc")
        flash[:sort] = "date"
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
