class OrganisersController < ApplicationController
  layout 'cms'
  before_filter :authenticate

  # GET /organisers
  # GET /organisers.xml
  def index
    @organisers = Organiser.includes(:socials, :classes)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @organisers }
    end
  end

  # GET /organisers/1
  # GET /organisers/1.xml
  def show
    @organiser = Organiser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @organiser }
    end
  end

  # GET /organisers/new
  # GET /organisers/new.xml
  def new
    @organiser = Organiser.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @organiser }
    end
  end

  # GET /organisers/1/edit
  def edit
    @organiser = Organiser.find(params[:id])
  end

  # POST /organisers
  # POST /organisers.xml
  def create
    @organiser = Organiser.new(organiser_params)

    respond_to do |format|
      if @organiser.save
        flash[:notice] = 'Organiser was successfully created.'
        format.html { redirect_to(@organiser) }
        format.xml  { render :xml => @organiser, :status => :created, :location => @organiser }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @organiser.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /organisers/1
  # PUT /organisers/1.xml
  def update
    @organiser = Organiser.find(params[:id])

    respond_to do |format|
      if @organiser.update_attributes(organiser_params)
        flash[:notice] = 'Organiser was successfully updated.'
        format.html { redirect_to(@organiser) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @organiser.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /organisers/1
  # DELETE /organisers/1.xml
  def destroy
    @organiser = Organiser.find(params[:id])
    @organiser.destroy

    respond_to do |format|
      format.html { redirect_to(organisers_url) }
      format.xml  { head :ok }
    end
  end

  private

  def organiser_params
    params.require(:organiser).permit(:name, :shortname, :website, :description)
  end
end
