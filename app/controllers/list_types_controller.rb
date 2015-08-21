class ListTypesController < ApplicationController
  # GET /list_types
  # GET /list_types.json
  def index
    @list_types = ListType.where(can_be_root: true)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @list_types }
    end
  end

  # GET /list_types/
  # GET /list_types/1.json
  def show
    @list_type = ListType.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @list_type }
    end
  end

  # GET /list_types/new
  # GET /list_types/new.json
  def new
    @list_type = ListType.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @list_type }
    end
  end

  # GET /list_types/1/edit
  def edit
    @list_type = ListType.find(params[:id])
    authorize @list_type
  end

  # POST /list_types
  # POST /list_types.json
  def create
   #@list_type_creator = ListTypeCreator.new(params)
   @list_type = ListType.new(list_type_params)
   authorize @list_type

   success = @list_type.save

    respond_to do |format|
      if success
        format.html { redirect_to @list_type, notice: 'List type was successfully created.' }
        format.json { render json: @list_type, status: :created, location: @list_type }
      else
        format.html { render action: "new" }
        format.json { render json: @list_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /list_types/1
  # PUT /list_types/1.json
  def update
    @list_type = ListType.find(params[:id])

    respond_to do |format|
      if @list_type.update_attributes(list_type_params)
        format.html { redirect_to @list_type, notice: 'List type was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @list_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /list_types/1
  # DELETE /list_types/1.json
  def destroy
    @list_type = ListType.find(params[:id])
    @list_type.destroy

    respond_to do |format|
      format.html { redirect_to list_types_url }
      format.json { head :no_content }
    end
  end

  private

  def list_type_params
    params.require(:list_type).permit(:name, :user_id)
  end
end
