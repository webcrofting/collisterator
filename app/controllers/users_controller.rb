class UsersController < ApplicationController
#  before_filter :get_user, :only => [:index,:new,:edit]
#  before_filter :accessible_roles, :only => [:new, :edit, :show, :update, :create]
#  load_and_authorize_resource :only => [:show,:new,:destroy,:edit,:update]
  #skip_load_and_authorize_resource :only => [:show]
 
 # GET /users
  # GET /users.xml                                                
  # GET /users.json                                       HTML and AJAX
  #-----------------------------------------------------------------------
  #def index
   # @users = User.accessible_by(current_ability, :index).limit(20)
    #respond_to do |format|
     # format.json { render :json => @users }
      #format.xml  { render :xml => @users }
      #format.html
    #end
  #end
 
  # GET /users/new
  # GET /users/new.xml                                            
  # GET /users/new.json                                    HTML AND AJAX
  #-------------------------------------------------------------------
  def new
    @item_share = ItemShare.new
    respond_to do |format|
      format.json { render :json => @user }   
      format.xml  { render :xml => @user }
      format.html
    end
  end
 
  # GET /users/1
  # GET /users/1.xml                                                       
  # GET /users/1.json                                     HTML AND AJAX
  #-------------------------------------------------------------------
  def show
    @user = User.find(current_user.id)
    @profile = UserProfilePresenter.new(@user)

    render 'users/show'
    #respond_to do |format|
      #format.html { render 'users/show' }     
      #format.json { render :json => @user }
   # end
  
  #rescue ActiveRecord::RecordNotFound
   # respond_to_not_found(:json, :xml, :html)
   
  end
  
  # PUT /users/1
  #--------------------------------------------------------------------
  def update
		@user = User.find(current_user.id)
    console.log "something"
		if params[:user][:password].blank?
			console.log "something else"
		end
		respond_to do |format|
			format.html { render 'users/show'}
			format.json { render :json => @user }
		end
  end

  # GET /users/1/edit                                                      
  # GET /users/1/edit.xml                                                      
  # GET /users/1/edit.json                                HTML AND AJAX
  #-------------------------------------------------------------------
  def edit
    respond_to do |format|
      format.json { render :json => @user }   
      format.xml  { render :xml => @user }
      format.html
    end
 
  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:json, :xml, :html)
  end
 
  # DELETE /users/1     
  # DELETE /users/1.xml
  # DELETE /users/1.json                                  HTML AND AJAX
  #-------------------------------------------------------------------
  def destroy
    @user.destroy!
 
    respond_to do |format|
      format.json { respond_to_destroy(:ajax) }
      format.xml  { head :ok }
      format.html { respond_to_destroy(:html) }      
    end
 
  rescue ActiveRecord::RecordNotFound
    respond_to_not_found(:json, :xml, :html)
  end
 
  # POST /users
  # POST /users.xml         
  # POST /users.json                                      HTML AND AJAX
  #-----------------------------------------------------------------
  def create
    @user = User.new(params[:user])

    if @user.save
      UserMailer.test(@user).deliver
      respond_to do |format|
        format.json { render :json => @user.to_json, :status => 200 }
        format.xml  { head :ok }
        format.html { redirect_to :action => :index }
      end
    else
      respond_to do |format|
        format.json { render :text => "Could not create user", :status => :unprocessable_entity } # placeholder
        format.xml  { head :ok }
        format.html { render :action => :new, :status => :unprocessable_entity }
      end
    end
  end
end
