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
    
    @ratings = params[:ratings] if params.has_key?(:ratings)
    @sort = params[:sort] if params.has_key?(:sort)
    
    if params.has_key?('commit')
      session.delete(:ratings)
      session.delete(:sort)
    end
    
    #update session if need 
    session[:ratings] = @ratings if !@ratings.nil?
    session[:sort] = @sort if @sort
    
    #do we need to redirect?
    if !@ratings && session[:ratings]
      @ratings = session[:ratings] unless @ratings
      @sort = session[:sort] unless @sort
      flash.keep
      redirect_to movies_path({sort: @sort, ratings: @ratings})
    end
    
    # redirect = false
    # if(params.has_key?(:ratings))
    #   session[:ratings] = params[:ratings]
    # else 
    #     redirect = true
    #     if session.has_key?(:ratings)
    #       params[:ratings] = session[:ratings]
    #       redirect = true
    #     else
    #       local_ratings = Hash[@all_ratings.map {|v| [v,true]}] #No rating selected
    #       logger.debug local_ratings
    #     end
    # end
    # #if(params.has_key?(:sort))
    # #  session[:sort] = params[:sort]
    # #else
    # #  params[:sort] = session[:sort]
    # #  redirect = true
    # #end
    # if(redirect)
    #   flash[:notice]="You did not select any rating"
    #   redirect_to movies_path(sort: params[:sort], ratings: {"G"=>true}) and return  
    # end
    #ratings = params[:ratings]
    #@sort = params[:sort]
    logger.debug @ratings
    local_ratings =  @ratings.nil? ? @all_ratings : @ratings.keys
    @movies = Movie.where(rating: local_ratings).order(@sort)
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
