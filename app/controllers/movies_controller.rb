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
    @all_ratings = Movie.pluck(:rating).uniq
    redirect = false
    if(params.has_key?(:ratings))
      session[:ratings] = params[:ratings]
    else if session.has_key?(:ratings)
          params[:ratings] = session[:ratings]
          redirect = true
        else
          params[:ratings] = Hash[@all_ratings.map {|v| [v,true]}]
        end
    end
    if(params.has_key?(:sort))
      session[:sort] = params[:sort]
    else
      params[:sort] = session[:sort]
      redirect = true
    end
    if(redirect)
      flash[:notice]="You will be redirected"
      redirect_to movies_path(params) and return  
    end
    
    ratings = params[:ratings]
    @sort = params[:sort]
    @ratings =  ratings.nil? ? @all_ratings : ratings.keys
    @movies = Movie.where(rating: @ratings).order(@sort)
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
