class PlacesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @places = Place.all
  end
#adds a new page called "new" which you can see in "places"
  def new
    @place = Place.new
  end
##All the ruby code between the def create and the end will get executed after the button is pressed.
##The following "def create" and "def place_params" will suck in the values from the form the user submits.
##This is similar to how we previously hardcoded the following in the rails console before:
##Place.create(name: 'Place', address: '123 Fake Street', description: 'Awesome!')
  def create
    @place = current_user.places.create(place_params)
    #Check if validations are passed and the record actually got saved to our database
    if @place.valid?
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @place = Place.find(params[:id])
  end

  def edit
    @place = Place.find(params[:id])

    if @place.user != current_user
      return render text: 'Not Allowed', status: :forbidden
    end
  end

  def update
    @place = Place.find(params[:id])
    if @place.user != current_user
      return render text: 'Not Allowed', status: :forbidden
    end

    @place.update_attributes(place_params)
    if @place.valid?
      redirect_to root_path
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @place = Place.find(params[:id])
    if @place.user != current_user
      return render text: 'Not Allowed', status: :forbidden
    end
    @place.destroy
    redirect_to root_path
  end

  private
##The place_params part is what pulls the values of name, description and address from the place form.
##Then the Place.create is what actually sends the item to the database.
  def place_params
    params.require(:place).permit(:name, :description, :address)
  end

end
