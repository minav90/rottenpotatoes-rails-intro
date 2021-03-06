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
    
    setRatings

   if params[:ratings].present? then
   session[:ratings] = params[:ratings].keys
   end 

   if params[:item].present? then
    session[:item] = params[:item]
   end
   
   if(session[:item] == "Title") then
      @sort = "Title"
      if session[:ratings].present? then
        @movies = Movie.where(:rating => session[:ratings]).order("title")
      else
        @movies = Movie.order("title").all
      end
   elsif(session[:item] == "Date") then
      @sort = "Date"
      if session[:ratings].present? then
        @movies = Movie.where(:rating => session[:ratings]).order("release_date")
      else
        @movies = Movie.order("release_date").all
      end
   else
      if session[:ratings].present? then
        @movies = Movie.where(:rating => session[:ratings]).all
      else
        @movies = Movie.all
      end
   end


  end

  def setRatings
    @all_ratings = Movie.all_ratings
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
  #dummy Merge

end
