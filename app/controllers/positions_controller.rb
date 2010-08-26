class PositionsController < ApplicationController

  # GET /positions/current
  # GET /positions/current.xml
  def current
   #Cache for a second or two, incase someone is refresh happy
   expires_in 2.seconds, :public => true

    case params[:active]
      when "Online" then
        shuttles = Shuttle.where({:enabled => true, :active => true})
      when "Offline" then
        shuttles = Shuttle.where({:enabled => true, :active => false})
      when "All" then
        shuttles = Shuttle.where({:enabled => true})
      else
        shuttles = Shuttle.where({:enabled => true})
    end
    
    @positions = shuttles.collect{|s| s.current_position}
    @positions.each {|p| p.build_icon unless p.nil? }
    @positions.compact!
    respond_to do |format|
      format.html # current.html.erb
      format.xml # current.xml.erb
      format.js # current.js.erb
      format.kml #current.kml.erb
    end
  end
  
  # GET /positions
  # GET /positions.xml
  def index
    @positions = Position.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @positions }
    end
  end

  # GET /positions/1
  # GET /positions/1.xml
  def show
    @position = Position.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @position }
    end
  end

  # GET /positions/new
  # GET /positions/new.xml
  def new
    @position = Position.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @position }
    end
  end

  # GET /positions/1/edit
  def edit
    @position = Position.find(params[:id])
  end

  # POST /positions
  # POST /positions.xml
  def create
    @position = Position.new(params[:position])

    respond_to do |format|
      if @position.save
        format.html { redirect_to(@position, :notice => 'Position was successfully created.') }
        format.xml  { render :xml => @position, :status => :created, :location => @position }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @position.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /positions/1
  # PUT /positions/1.xml
  def update
    @position = Position.find(params[:id])

    respond_to do |format|
      if @position.update_attributes(params[:position])
        format.html { redirect_to(@position, :notice => 'Position was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @position.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /positions/1
  # DELETE /positions/1.xml
  def destroy
    @position = Position.find(params[:id])
    @position.destroy

    respond_to do |format|
      format.html { redirect_to(positions_url) }
      format.xml  { head :ok }
    end
  end
end