# frozen_string_literal: true

class OrganisersController < CMSBaseController
  def index
    @organisers = Organiser.includes(:socials, :classes)
  end

  def show
    @organiser = Organiser.find(params[:id])
    @editor = Editor.build(@organiser.audits.last)
  end

  def new
    @organiser = Organiser.new
  end

  def edit
    @organiser = Organiser.find(params[:id])
  end

  def create
    @organiser = Organiser.new(organiser_params)

    if @organiser.save
      flash[:notice] = 'Organiser was successfully created.'
      redirect_to(@organiser)
    else
      render action: 'new'
    end
  end

  def update
    @organiser = Organiser.find(params[:id])

    if @organiser.update(organiser_params)
      flash[:notice] = 'Organiser was successfully updated.'
      redirect_to(@organiser)
    else
      render action: 'edit'
    end
  end

  def destroy
    @organiser = Organiser.find(params[:id])
    @organiser.destroy

    redirect_to(organisers_url)
  end

  private

  def organiser_params
    params.require(:organiser).permit(:name, :shortname, :website, :description)
  end
end
